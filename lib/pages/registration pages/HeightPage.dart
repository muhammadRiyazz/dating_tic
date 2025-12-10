import 'package:dating/pages/registration%20pages/LifestylePage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HeightPage extends StatefulWidget {
  @override
  _HeightPageState createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  double _selectedHeight = 170.0; // Default 170cm
  bool _isLoading = false;
  bool _useFeetInches = false; // false = cm, true = ft'in
  
  // Height ranges
  final double _minHeightCM = 120.0;
  final double _maxHeightCM = 220.0;
  
  List<double> _cmOptions = [];
  List<String> _ftOptions = [];

  @override
  void initState() {
    super.initState();
    // Generate CM options
    for (double i = _minHeightCM; i <= _maxHeightCM; i += 1.0) {
      _cmOptions.add(i);
    }
    
    // Generate FT options (4'0" to 7'4")
    for (int feet = 4; feet <= 7; feet++) {
      for (int inches = 0; inches < 12; inches++) {
        if (feet == 7 && inches > 4) break; // Stop at 7'4"
        _ftOptions.add("$feet'$inches\"");
      }
    }
  }

  String _convertToFeetInches(double cm) {
    double totalInches = cm / 2.54;
    int feet = (totalInches / 12).floor();
    int inches = (totalInches % 12).round();
    return "$feet'$inches\"";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    final backgroundColor = isDark ? const Color(0xFF0A0505) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    final currentDisplayHeight = _useFeetInches 
        ? _convertToFeetInches(_selectedHeight)
        : '${_selectedHeight.round()} cm';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
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
                'What\'s your height?',
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
                'Select your height',
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Height Display
              Center(
                child: Column(
                  children: [
                    // Text(
                    //   currentDisplayHeight,
                    //   style: TextStyle(
                    //     fontSize: 64,
                    //     color: primaryRed,
                    //     fontWeight: FontWeight.w800,
                    //     height: 1,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    
                    // Unit Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_useFeetInches) {
                                setState(() => _useFeetInches = false);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: !_useFeetInches 
                                    ? primaryRed 
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'CM',
                                style: TextStyle(
                                  color: !_useFeetInches 
                                      ? Colors.white 
                                      : primaryRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!_useFeetInches) {
                                setState(() => _useFeetInches = true);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: _useFeetInches 
                                    ? primaryRed 
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'FT/IN',
                                style: TextStyle(
                                  color: _useFeetInches 
                                      ? Colors.white 
                                      : primaryRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Height Picker
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      _snapToNearestValue();
                    }
                    return false;
                  },
                  child: ListWheelScrollView.useDelegate(
                    diameterRatio: 2.0,
                    perspective: 0.005,
                    offAxisFraction: 0.0,
                    useMagnifier: true,
                    magnification: 1.2,
                    itemExtent: 60,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        if (!_useFeetInches) {
                          _selectedHeight = _cmOptions[index];
                        } else {
                          // Convert ft'in string to cm
                          String ftIn = _ftOptions[index];
                          List<String> parts = ftIn.split("'");
                          int feet = int.parse(parts[0]);
                          int inches = int.parse(parts[1].replaceAll('"', ''));
                          int totalInches = (feet * 12) + inches;
                          _selectedHeight = totalInches * 2.54;
                        }
                      });
                    },
                    childDelegate: !_useFeetInches
                        ? ListWheelChildBuilderDelegate(
                            childCount: _cmOptions.length,
                            builder: (context, index) {
                              final height = _cmOptions[index];
                              final isSelected = height == _selectedHeight;
                              
                              return Center(
                                child: Text(
                                  '${height.round()}',
                                  style: TextStyle(
                                    fontSize: isSelected ? 32 : 24,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? primaryRed : hintColor,
                                  ),
                                ),
                              );
                            },
                          )
                        : ListWheelChildBuilderDelegate(
                            childCount: _ftOptions.length,
                            builder: (context, index) {
                              final heightStr = _ftOptions[index];
                              // Calculate if this is selected
                              String currentFtIn = _convertToFeetInches(_selectedHeight);
                              final isSelected = heightStr == currentFtIn;
                              
                              return Center(
                                child: Text(
                                  heightStr,
                                  style: TextStyle(
                                    fontSize: isSelected ? 32 : 24,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? primaryRed : hintColor,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),

              // Height Indicator
          
              const SizedBox(height: 20),

              // Average Height Info
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
                  children: [
                    Icon(
                      Iconsax.rulerpen,
                      color: primaryRed,
                      size: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Most people on Weekend are between 160-180 cm',
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 10,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
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
                      : Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _snapToNearestValue() {
    if (!_useFeetInches) {
      // Snap to nearest cm
      setState(() {
        _selectedHeight = _selectedHeight.roundToDouble();
      });
    }
  }

  void _continue() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    // Navigate to next page (Lifestyle or Bio)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LifestylePage(), // Or BioPage
      ),
    );
  }
}