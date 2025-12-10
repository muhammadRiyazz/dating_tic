import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;
  bool _useCurrentLocation = false;
  int _selectedDistance = 50; // km

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    final backgroundColor = isDark ? const Color(0xFF0A0505) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all( 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Iconsax.arrow_left_2,
                        color: primaryRed,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Your Location',
                style: TextStyle(
                  fontSize: 28,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                'Set your location to find matches nearby',
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Current Location Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _useCurrentLocation = true;
                    _locationController.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _useCurrentLocation
                        ? primaryRed.withOpacity(0.1)
                        : isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _useCurrentLocation
                          ? primaryRed.withOpacity(0.3)
                          : borderColor,
                      width: _useCurrentLocation ? 2 : 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: primaryRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Iconsax.location,
                          color: primaryRed,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Use current location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _useCurrentLocation ? primaryRed : textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Automatically detect your city',
                              style: TextStyle(
                                fontSize: 13,
                                color: hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_useCurrentLocation)
                        Icon(
                          Iconsax.tick_circle,
                          color: primaryRed,
                          size: 22,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: hintColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Manual Location Input
              Text(
                'Enter city manually',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _locationController.text.isNotEmpty && !_useCurrentLocation
                        ? primaryRed.withOpacity(0.3)
                        : borderColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
                ),
                child: TextField(
                  controller: _locationController,
                  enabled: !_useCurrentLocation,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g., Mumbai, Delhi, Bangalore',
                    hintStyle: TextStyle(color: hintColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    prefixIcon: Icon(
                      Iconsax.search_normal,
                      color: primaryRed,
                      size: 20,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _useCurrentLocation = false;
                      });
                    }
                    setState(() {});
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Distance Preference
              Text(
                'Distance Preference',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Show me matches within',
                style: TextStyle(
                  fontSize: 14,
                  color: hintColor,
                ),
              ),
              const SizedBox(height: 12),
              
              // Distance Slider
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Slider(
                      value: _selectedDistance.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      onChanged: (value) {
                        setState(() {
                          _selectedDistance = value.round();
                        });
                      },
                      activeColor: primaryRed,
                      inactiveColor: borderColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1 km',
                          style: TextStyle(
                            fontSize: 12,
                            color: hintColor,
                          ),
                        ),
                        Text(
                          '$_selectedDistance km',
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '100 km',
                          style: TextStyle(
                            fontSize: 12,
                            color: hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Privacy Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: primaryRed.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Iconsax.shield_tick,
                      color: primaryRed,
                      size: 14,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your exact location is never shared. Only your city and approximate distance are shown.',
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_useCurrentLocation || _locationController.text.isNotEmpty) 
                      ? _continue 
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Iconsax.arrow_right_3, size: 20),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continue() async {
    if (!_useCurrentLocation && _locationController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    // Navigate to Bio or Photos page (final step)
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => BioPage(), // or PhotosPage()
    //   ),
    // );
  }
}