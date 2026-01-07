import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationData {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? state;
  final String? country;
  final String? address;
  final bool hasPermission;
  final bool isLocationEnabled;
  final DateTime? fetchedAt;

  LocationData({
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.country,
    this.address,
    required this.hasPermission,
    required this.isLocationEnabled,
    this.fetchedAt,
  });

  bool get hasLocation => latitude != null && longitude != null;
  bool get isRecent => fetchedAt != null && 
      DateTime.now().difference(fetchedAt!).inMinutes < 5;
}
class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  factory LocationManager() => _instance;
  LocationManager._internal();

  LocationData? _cachedLocation;

  // Get cached location (if exists and recent)
  LocationData? get cachedLocation {
    if (_cachedLocation != null && _cachedLocation!.isRecent) {
      return _cachedLocation;
    }
    return null;
  }

  // Manually cache a location (used when user selects from map/search)
  void cacheLocation(LocationData location) {
    _cachedLocation = location;
  }

  // Fetch and cache location automatically
  Future<LocationData> fetchAndCacheLocation() async {
    try {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (!isLocationEnabled) {
        _cachedLocation = LocationData(
          hasPermission: false,
          isLocationEnabled: false,
          fetchedAt: DateTime.now(),
        );
        return _cachedLocation!;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        _cachedLocation = LocationData(
          hasPermission: false,
          isLocationEnabled: true,
          fetchedAt: DateTime.now(),
        );
        return _cachedLocation!;
      }

      bool hasPermission = permission == LocationPermission.always || 
                          permission == LocationPermission.whileInUse;

      if (!hasPermission) {
        _cachedLocation = LocationData(
          hasPermission: false,
          isLocationEnabled: true,
          fetchedAt: DateTime.now(),
        );
        return _cachedLocation!;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.isNotEmpty ? placemarks.first : Placemark();
      
      _cachedLocation = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        city: place.locality,
        state: place.administrativeArea,
        country: place.country,
        address: place.locality ?? place.subLocality ?? '',
        hasPermission: true,
        isLocationEnabled: true,
        fetchedAt: DateTime.now(),
      );
      
      return _cachedLocation!;
      
    } catch (e) {
      _cachedLocation = LocationData(
        hasPermission: false,
        isLocationEnabled: true,
        fetchedAt: DateTime.now(),
      );
      return _cachedLocation!;
    }
  }

  // Clear cached location
  void clearCache() {
    _cachedLocation = null;
  }

  // Get current cached location or fetch new one
  Future<LocationData> getCurrentLocation({bool forceRefresh = false}) async {
    if (!forceRefresh && cachedLocation != null) {
      return cachedLocation!;
    }
    return await fetchAndCacheLocation();
  }
}