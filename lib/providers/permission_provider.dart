import 'dart:async';

import 'package:flutter/material.dart';
import '../models/permission_model.dart';
import '../services/permission_service.dart';

class PermissionProvider with ChangeNotifier {
  // State
  UserPermissions? _permissions;
  bool _isLoading = false;
  String _error = '';
  bool _isRefreshing = false;
  DateTime? _lastFetchTime;
  Timer? _syncTimer;

  // Getters
  UserPermissions? get permissions => _permissions;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  bool get hasPermissions => _permissions != null;

  // Permission checkers
  bool get canLike => PermissionService.canPerformAction(
    permissions: _permissions,
    action: 'like',
  );

  bool get canViewProfiles => PermissionService.canPerformAction(
    permissions: _permissions,
    action: 'view_profile',
  );

  bool get canChat => PermissionService.canPerformAction(
    permissions: _permissions,
    action: 'chat',
  );

  bool get canSeeLikedMe => PermissionService.canPerformAction(
    permissions: _permissions,
    action: 'see_liked_me',
  );

  bool get canBoostProfile => PermissionService.canPerformAction(
    permissions: _permissions,
    action: 'boost_profile',
  );

  bool get canHideOnline => PermissionService.canPerformAction(
    permissions: _permissions,
    action: 'hide_online',
  );

  // Display texts
  String get likesStatus => PermissionService.getActionStatus(
    permissions: _permissions,
    action: 'like',
  );

  String get viewsStatus => PermissionService.getActionStatus(
    permissions: _permissions,
    action: 'view_profile',
  );

  // Check if data is stale
  bool get isStale {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!) > const Duration(minutes: 5);
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  // Load permissions (with cache first)
  Future<void> loadPermissions(String userId, {bool forceRefresh = false}) async {
    if (_isLoading && !forceRefresh) return;

    // Try cache first if not forcing refresh
    if (!forceRefresh && _permissions == null) {
      final cached = await PermissionService.getCachedPermissions();
      if (cached != null) {
        _permissions = cached;
        notifyListeners();
      }
    }

    // Fetch from API
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await PermissionService.fetchPermissions(userId);

      if (response.isSuccess && response.permissions != null) {
        _permissions = response.permissions;
        _lastFetchTime = DateTime.now();
        _error = '';
        
        // Start periodic sync (every 5 minutes)
        _startPeriodicSync(userId);
      } else {
        _error = response.statusDesc ?? 'Failed to load permissions';
        
        // If we have cached data, keep it even if API fails
        if (_permissions == null) {
          _permissions = null;
        }
      }
    } catch (e) {
      _error = 'Network error: $e';
      
      // Keep cached data if API fails
      if (_permissions == null) {
        final cached = await PermissionService.getCachedPermissions();
        _permissions = cached;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Start periodic background sync
  void _startPeriodicSync(String userId) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      refreshSilently(userId);
    });
  }

  // Refresh permissions silently (for background updates)
  Future<void> refreshSilently(String userId) async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      final response = await PermissionService.fetchPermissions(userId);

      if (response.isSuccess && response.permissions != null) {
        _permissions = response.permissions;
        _lastFetchTime = DateTime.now();
        _error = '';
        notifyListeners();
      }
    } catch (e) {
      print('Silent refresh failed: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  // Optimistic update (for instant UI feedback)
  bool updateOptimistically(String action) {
    if (_permissions == null) return false;

    bool updated = false;
    
    switch (action) {
      case 'like':
        if (canLike) {
          _permissions = _permissions!.copyWithLikeUsed();
          PermissionService.updateCacheOptimistically(
            current: _permissions!,
            action: action,
          );
          updated = true;
        }
        break;

      case 'view_profile':
        if (canViewProfiles) {
          _permissions = _permissions!.copyWithViewUsed();
          PermissionService.updateCacheOptimistically(
            current: _permissions!,
            action: action,
          );
          updated = true;
        }
        break;
    }

    if (updated) {
      notifyListeners();
    }
    
    return updated;
  }

  // Revert optimistic update (if API call fails)
  void revertUpdate(String action) {
    // Load fresh data from cache/API
    // This is simplified - in production you'd track changes more precisely
    _error = 'Action failed. Please try again.';
    notifyListeners();
  }

  // Check permission for specific action
  bool checkPermission(String action) {
    return PermissionService.canPerformAction(
      permissions: _permissions,
      action: action,
    );
  }

  // Get status text for action
  String getPermissionStatus(String action) {
    return PermissionService.getActionStatus(
      permissions: _permissions,
      action: action,
    );
  }

  // Clear all data
  void clear() {
    _permissions = null;
    _error = '';
    _lastFetchTime = null;
    _syncTimer?.cancel();
    PermissionService.clearCache();
    notifyListeners();
  }

  // Error handling
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Update from external source (e.g., after purchase)
  void updatePermissions(UserPermissions newPermissions) {
    _permissions = newPermissions;
    _lastFetchTime = DateTime.now();
    PermissionService.updateCacheOptimistically(
      current: _permissions!,
      action: 'update',
    );
    notifyListeners();
  }

  // Get remaining likes count
  int get remainingLikes {
    if (_permissions == null) return 0;
    final likes = _permissions!.dailyLikes;
    if (likes.isUnlimited) return 999;
    return likes.left;
  }

  // Get remaining views count
  int get remainingViews {
    if (_permissions == null) return 0;
    final views = _permissions!.viewProfilesPerDay;
    if (views.isUnlimited) return 999;
    return views.left;
  }
}