import 'package:dating/main.dart';
import 'package:dating/providers/profile_update.dart' show UpdateProfileProvider;
import 'package:dating/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:provider/provider.dart';

class LocationEditPage extends StatefulWidget {
  const LocationEditPage({super.key});

  @override
  State<LocationEditPage> createState() => _LocationEditPageState();
}

class _LocationEditPageState extends State<LocationEditPage> {
  // --- Controllers & Focus ---
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  
  // --- States ---
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isFetchingLocation = false;
  bool _isSearching = false;
  bool _showSuggestions = false;
  bool _mapInitialized = false;
  bool _hasChanges = false;

  // --- API & Map Data ---
  final String _apiKey = 'AIzaSyAGmdSqGPgz_-Qoc669E8U7pHNTAJWGGSU'; 
  List<dynamic> _placeSuggestions = [];
  GoogleMapController? _mapController;
  
  // Location data
  LatLng _currentLocation = const LatLng(20.5937, 78.9629); 
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  Timer? _debounceTimer;

  String? _selectedCity;
  String? _initialCity;
  double? _selectedLat;
  double? _selectedLng;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    // Get current location from profile
    final profileProvider = context.read<UpdateProfileProvider>();
    final profile = profileProvider.userProfile;
    
    if (profile.latitude != null && profile.longitude != null) {
      // Initialize with saved location
      setState(() {
        _selectedLat = double.tryParse( profile.latitude??'');
        _selectedLng = double.tryParse( profile.longitude??'') ;
        _selectedCity = profile.city ?? profile.country;
        _initialCity = _selectedCity;
        
        if (_selectedLat != null && _selectedLng != null) {
          _currentLocation = LatLng(_selectedLat!, _selectedLng!);
          _selectedLocation = _currentLocation;
        }
        
        _locationController.text = _selectedCity ?? '';
      });
      
      _updateMarkers();
    } else {
      // Try to get current position if no saved location
      final cachedLocation = LocationManager().cachedLocation;
      if (cachedLocation != null && cachedLocation.hasLocation) {
        _initializeWithCachedLocation(cachedLocation);
      } else {
        await _getCurrentPosition(silent: true);
      }
    }
    
    setState(() => _mapInitialized = true);
  }

  void _initializeWithCachedLocation(LocationData location) {
    setState(() {
      _currentLocation = LatLng(location.latitude!, location.longitude!);
      _selectedLocation = _currentLocation;
      _selectedCity = location.city;
      _initialCity = _selectedCity;
      _selectedLat = location.latitude;
      _selectedLng = location.longitude;
      _locationController.text = location.address ?? '';
      _updateMarkers();
    });
  }

  // --- Permission & Service Check ---
  Future<bool> _checkPermissionsAndService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog(
        "Location Disabled", 
        "GPS is turned off. Please turn it on to find your location automatically.",
        onPressed: () => Geolocator.openLocationSettings()
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar("Location permissions are denied.");
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog(
        "Permissions Denied", 
        "Location permissions are permanently denied. Please enable them in app settings.",
        onPressed: () => Geolocator.openAppSettings()
      );
      return false;
    }

    return true;
  }

  void _showErrorDialog(String title, String msg, {required VoidCallback onPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: AppColors.neonGold)),
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel", style: TextStyle(color: Colors.white70))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGold),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            }, 
            child: const Text("Settings", style: TextStyle(color: Colors.black))
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.neonGold,
      )
    );
  }

  // --- Map & API Logic ---

  void _updateMarkers() {
    if (_selectedLocation == null) return;
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: _selectedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        )
      };
    });
  }

  Future<void> _getCurrentPosition({bool silent = false}) async {
    if (!silent) {
      bool hasPermission = await _checkPermissionsAndService();
      if (!hasPermission) return;
    }

    setState(() => _isFetchingLocation = true);
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );
      Placemark place = placemarks.first;

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
        _selectedCity = place.locality ?? place.subAdministrativeArea;
        _selectedLat = position.latitude;
        _selectedLng = position.longitude;
        _hasChanges = _selectedCity != _initialCity;
        _locationController.text = _selectedCity ?? "Current Location";
        _updateMarkers();
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 15));
      });
    } catch (e) {
      if (!silent) _showSnackBar("Error fetching location");
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  void _debounceSearch(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (query.length >= 2) {
        _searchPlaces(query);
      } else {
        setState(() => _showSuggestions = false);
      }
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() => _isSearching = true);
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_apiKey&components=country:in&language=en');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _placeSuggestions = data['predictions'] ?? [];
          _showSuggestions = _placeSuggestions.isNotEmpty;
          _isSearching = false;
        });
      }
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    setState(() => _isLoading = true);
    _locationFocusNode.unfocus();
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey&fields=name,geometry');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loc = data['result']['geometry']['location'];
        final lat = loc['lat'];
        final lng = loc['lng'];

        setState(() {
          _selectedLocation = LatLng(lat, lng);
          _selectedCity = data['result']['name'];
          _selectedLat = lat;
          _selectedLng = lng;
          _hasChanges = _selectedCity != _initialCity;
          _locationController.text = _selectedCity!;
          _showSuggestions = false;
          _updateMarkers();
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_selectedLocation!, 15));
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveLocation() async {
    if (_selectedCity == null || _selectedLat == null || _selectedLng == null) {
      _showSnackBar("Please select a location");
      return;
    }

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final profileProvider = context.read<UpdateProfileProvider>();
       profileProvider.updateLocation(
        city: _selectedCity!,
        latitude:  _selectedLat!.toString(),
        longitude: _selectedLng!.toString(),
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Location updated successfully!'),
            backgroundColor: AppColors.neonGold,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. MAP LAYER
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation, 
                zoom: 14
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                if (_selectedLocation != null) {
                  _updateMarkers();
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_selectedLocation!, 14)
                  );
                }
              },
              style: _darkMapStyle,
              markers: _markers,
              myLocationEnabled: true,
              compassEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              indoorViewEnabled: true,
              myLocationButtonEnabled: false,
              onTap: (_) {
                _locationFocusNode.unfocus();
                setState(() => _showSuggestions = false);
              },
            ),
          ),

          // 2. TOP GRADIENT
          Positioned(
            top: 0, left: 0, right: 0, height: 250,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0A0A0A).withOpacity(0.9), 
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. APPBAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Iconsax.arrow_left_2, 
                          color: Colors.white, size: 20),
                      ),
                    ),
                    Text(
                      "Update Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 45), // For balance
                  ],
                ),
              ),
            ),
          ),

          // 4. FLOATING SEARCH SECTION
          _buildSearchAndSuggestions(isKeyboardVisible),

          // 5. BOTTOM ACTION CARD
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            bottom: isKeyboardVisible ? -300 : 25,
            left: 20, right: 20,
            child: Column(
              children: [
                // Selected Location Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonGold.withOpacity(0.1),
                        AppColors.neonGold.withOpacity(0.05)
                      ],
                      begin: Alignment.topLeft, 
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.neonGold.withOpacity(0.3),
                              AppColors.neonGold.withOpacity(0.1)
                            ]
                          ),
                        ),
                        child: const Icon(Iconsax.location, 
                          color: AppColors.neonGold, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedCity != null 
                                ? 'Selected Location' 
                                : 'Set Your Location',
                              style: const TextStyle(
                                color: AppColors.neonGold, 
                                fontSize: 13, 
                                fontWeight: FontWeight.w700, 
                                letterSpacing: 0.5
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedCity ?? 'Search or use current location',
                              style: const TextStyle(
                                color: Colors.white, 
                                fontSize: 15, 
                                fontWeight: FontWeight.w600, 
                                letterSpacing: -0.2
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _getCurrentPosition(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.neonGold.withOpacity(0.9), 
                                AppColors.neonGold
                              ]
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Iconsax.location, color: Colors.black, size: 14),
                              SizedBox(width: 6),
                              Text('Current', 
                                style: TextStyle(
                                  color: Colors.black, 
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w700
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Save Button
                InkWell(
                  onTap: (_hasChanges && !_isSaving) ? _saveLocation : null,
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: _hasChanges && !_isSaving
                          ? LinearGradient(
                              colors: [
                                AppColors.neonGold,
                                AppColors.neonGold.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: !_hasChanges || _isSaving
                          ? Colors.white.withOpacity(0.05)
                          : null,
                      borderRadius: BorderRadius.circular(18),
                      // boxShadow: _hasChanges && !_isSaving
                      //     ? [
                      //         BoxShadow(
                      //           color: AppColors.neonGold.withOpacity(0.3),
                      //           blurRadius: 12,
                      //           offset: const Offset(0, 6),
                      //         ),
                      //       ]
                      //     : [],
                    ),
                    child: Center(
                      child: _isSaving
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _hasChanges 
                                ? "Update Location" 
                                : "No Changes",
                              style: TextStyle(
                                color: _hasChanges ? Colors.black : Colors.white24,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchAndSuggestions(bool isKeyboardVisible) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      top: isKeyboardVisible ? 50 : 150,
      left: 20, right: 20,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _locationController,
                  focusNode: _locationFocusNode,
                  onChanged: (value) {
                    _debounceSearch(value);
                    setState(() {
                      _hasChanges = value != _initialCity;
                    });
                  },
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Search city or area...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18
                    ),
                    border: InputBorder.none,
                    prefixIcon: _isSearching 
                      ?  Padding(
                          padding: EdgeInsets.all(12), 
                          child: Container(height: 13,width: 13,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, 
                              
                              color: AppColors.neonGold
                            ),
                          )
                        )
                      : const Icon(Iconsax.search_normal, 
                          color: AppColors.neonGold, size: 22),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        onPressed: () => _getCurrentPosition(),
                        icon: _isFetchingLocation 
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2, 
                                color: AppColors.neonGold
                              )
                            )
                          : const Icon(Iconsax.location, color: AppColors.neonGold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_showSuggestions)
            Container(
              margin: const EdgeInsets.only(top: 10),
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _placeSuggestions.length,
                separatorBuilder: (c, i) => Divider(
                  color: Colors.white.withOpacity(0.05)
                ),
                itemBuilder: (context, index) {
                  final item = _placeSuggestions[index];
                  return ListTile(
                    leading: const Icon(Iconsax.location, 
                      color: Colors.grey, size: 18),
                    title: Text(item['description'], 
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                    onTap: () => _getPlaceDetails(item['place_id']),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// PREMIUM DARK MODE FOR GOOGLE MAPS
const String _darkMapStyle = '''[
  { "elementType": "geometry", "stylers": [ { "color": "#212121" } ] },
  { "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] },
  { "elementType": "labels.text.stroke", "stylers": [ { "color": "#212121" } ] },
  { "featureType": "administrative", "elementType": "geometry", "stylers": [ { "color": "#757575" } ] },
  { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#121212" } ] },
  { "featureType": "road", "elementType": "geometry.fill", "stylers": [ { "color": "#2c2c2c" } ] },
  { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#000000" } ] }
]''';