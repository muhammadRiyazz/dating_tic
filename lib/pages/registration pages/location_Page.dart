import 'package:dating/main.dart';
import 'package:dating/pages/registration%20pages/bio_Page.dart';
import 'package:dating/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // --- Controllers & Focus ---
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  
  // --- States ---
  bool _isLoading = false;
  bool _isFetchingLocation = false;
  bool _isSearching = false;
  bool _showSuggestions = false;
  bool _mapInitialized = false;

  // --- API & Map Data ---
  final String _apiKey = 'AIzaSyAGmdSqGPgz_-Qoc669E8U7pHNTAJWGGSU'; 
  List<dynamic> _placeSuggestions = [];
  GoogleMapController? _mapController;
  
  // Default fallback (e.g., India center) if location isn't detected yet
  LatLng _currentLocation = const LatLng(20.5937, 78.9629); 
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  Timer? _debounceTimer;

  String? selectedCity;
  double? selectedLat;
  double? selectedLng;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    final cachedLocation = LocationManager().cachedLocation;
    if (cachedLocation != null && cachedLocation.hasLocation) {
      _initializeWithCachedLocation(cachedLocation);
    } else {
      // Try to get current position automatically
      await _getCurrentPosition(silent: true);
    }
    setState(() => _mapInitialized = true);
  }

  void _initializeWithCachedLocation(LocationData location) {
    setState(() {
      _currentLocation = LatLng(location.latitude!, location.longitude!);
      _selectedLocation = _currentLocation;
      selectedCity = location.city;
      selectedLat = location.latitude;
      selectedLng = location.longitude;
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // --- Map & API Logic ---

  void _updateMarkers() {
    if (_selectedLocation == null) return;
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: _selectedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
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
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
        selectedCity = place.locality ?? place.subAdministrativeArea;
        _locationController.text = selectedCity ?? "Current Location";
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
          selectedCity = data['result']['name'];
          _locationController.text = selectedCity!;
          _showSuggestions = false;
          _updateMarkers();
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_selectedLocation!, 15));
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.neonGold.withOpacity(0.1), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // 1. MAP LAYER
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 14),
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (_selectedLocation != null) {
                    _updateMarkers();
                    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_selectedLocation!, 14));
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
                      colors: [AppColors.deepBlack .withOpacity(0.9), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),

            // 3. ANIMATED HEADER
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              top: isKeyboardVisible ? -200 : 65,
              left: 24, right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, AppColors.neonGold],
                      stops: const [0.7, 1.0],
                    ).createShader(bounds),
                    child: const Text(
                      'Set Your Location',
                      style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic, height: 1.1, letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find matches near you for better connections',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade300, height: 1.5, fontWeight: FontWeight.w400),
                  )
                ],
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
                        colors: [AppColors.neonGold.withOpacity(0.1), AppColors.neonGold.withOpacity(0.05)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [AppColors.neonGold.withOpacity(0.3), AppColors.neonGold.withOpacity(0.1)]),
                          ),
                          child: const Icon(Iconsax.location, color: AppColors.neonGold, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedCity != null ? 'Selected Location' : 'Set Your Location',
                                style: const TextStyle(color: AppColors.neonGold, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                selectedCity ?? 'Search or use current location',
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _getCurrentPosition(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.neonGold.withOpacity(0.9), AppColors.neonGold]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Iconsax.location, color: Colors.black, size: 14),
                                SizedBox(width: 6),
                                Text('Current', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  // Continue Button
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: ElevatedButton(
                      onPressed: (selectedCity == null || _isLoading) ? null : _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonGold, foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ).copyWith(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.disabled)) return AppColors.neonGold.withOpacity(0.5);
                          return AppColors.neonGold;
                        }),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Continue', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.2)),
                                SizedBox(width: 10),
                                Icon(Iconsax.arrow_right_3, size: 20, color: Colors.black),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 45, width: 45,
        decoration: BoxDecoration(
          color: AppColors.cardBlack.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Icon(Iconsax.arrow_left_2, color: AppColors.neonGold, size: 20),
      ),
    );
  }

  Widget _buildSearchAndSuggestions(bool isSearching) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      top: isSearching ? 50 : 225,
      left: 20, right: 20,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBlack.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _locationController,
                  focusNode: _locationFocusNode,
                  onChanged: _debounceSearch,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Search city or area...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: InputBorder.none,
                    prefixIcon: _isSearching 
                      ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.neonGold))
                      : const Icon(Iconsax.search_normal, color: AppColors.neonGold, size: 22),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        onPressed: () => _getCurrentPosition(),
                        icon: _isFetchingLocation 
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.neonGold))
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
                color: AppColors.cardBlack.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _placeSuggestions.length,
                separatorBuilder: (c, i) => Divider(color: Colors.white.withOpacity(0.05)),
                itemBuilder: (context, index) {
                  final item = _placeSuggestions[index];
                  return ListTile(
                    leading: const Icon(Iconsax.location, color: Colors.grey, size: 18),
                    title: Text(item['description'], style: const TextStyle(color: Colors.white, fontSize: 14)),
                    onTap: () => _getPlaceDetails(item['place_id']),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _continue() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
       Navigator.push(context, MaterialPageRoute(builder: (context) =>  BioPage()));
       setState(() => _isLoading = false);
    });
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