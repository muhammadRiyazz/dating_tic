import 'dart:convert';
import 'dart:developer';
import 'package:dating/core/url.dart';
import 'package:http/http.dart' as http;
import '../models/permission_model.dart';
import 'storage_service.dart';

class PermissionService {
  static final StorageService _storage = StorageService();
  
  static const String _permissionCacheKey = 'user_permissions';
  
  // Fetch permissions from API
  static Future<PermissionResponse> fetchPermissions(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/all-permission'),
  
        body: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseModel = PermissionResponse.fromJson(data);
        
        // Cache successful response
        if (responseModel.isSuccess && responseModel.permissions != null) {
          await _cachePermissions(responseModel.permissions!);
        }
        
        return responseModel;
      } else {
        return PermissionResponse(
          status: 'FAILED',
          statusDesc: 'HTTP Error ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('Permission fetch error: $e');
      return PermissionResponse(
        status: 'FAILED',
        statusDesc: 'Network error: $e',
        statusCode: -1,
      );
    }
  }
  
  // Get cached permissions
  static Future<UserPermissions?> getCachedPermissions() async {
    try {
      final cached = await _storage.read(_permissionCacheKey);
      if (cached != null) {
        final Map<String, dynamic> data = json.decode(cached);
        return UserPermissions.fromJson(data);
      }
      return null;
    } catch (e) {
      log('Cache read error: $e');
      return null;
    }
  }
  
  // Cache permissions locally
  static Future<void> _cachePermissions(UserPermissions permissions) async {
    try {
      await _storage.write(
        _permissionCacheKey,
        json.encode(permissions.toJson()),
      );
    } catch (e) {
      print('Cache write error: $e');
    }
  }
  
  // Clear cache
  static Future<void> clearCache() async {
    await _storage.delete(_permissionCacheKey);
  }
  
  // Update cache optimistically after action
  static Future<void> updateCacheOptimistically({
    required UserPermissions current,
    required String action,
  }) async {
    UserPermissions updated;
    
    switch (action) {
      case 'like':
        updated = current.copyWithLikeUsed();
        break;
      case 'view_profile':
        updated = current.copyWithViewUsed();
        break;
      default:
        updated = current;
    }
    
    await _cachePermissions(updated);
  }
  
  // Check if user can perform action
  static bool canPerformAction({
    required UserPermissions? permissions,
    required String action,
  }) {
    if (permissions == null) return false;
    
    switch (action) {
      case 'like':
        return permissions.canLike;
      case 'view_profile':
        return permissions.canViewProfiles;
      case 'chat':
        return permissions.unlimitedChat;
      case 'see_liked_me':
        return permissions.seeLikedMe;
      case 'boost_profile':
        return permissions.boostProfile;
      case 'hide_online':
        return permissions.hideOnline;
      default:
        return false;
    }
  }
  
  // Get action display text
  static String getActionStatus({
    required UserPermissions? permissions,
    required String action,
  }) {
    if (permissions == null) return 'Loading...';
    
    switch (action) {
      case 'like':
        return permissions.dailyLikes.displayText;
      case 'view_profile':
        return permissions.viewProfilesPerDay.displayText;
      case 'chat':
        return permissions.unlimitedChat ? 'Unlimited chat' : 'Chat limited';
      case 'see_liked_me':
        return permissions.seeLikedMe ? 'See who liked you' : 'Upgrade to see likes';
      case 'boost_profile':
        return permissions.boostProfile ? 'Profile boost available' : 'Upgrade for boost';
      case 'hide_online':
        return permissions.hideOnline ? 'Hide online status' : 'Visible online';
      default:
        return '';
    }
  }
}