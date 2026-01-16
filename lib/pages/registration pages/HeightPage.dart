import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/LifestylePage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HeightPage extends StatefulWidget {
  const HeightPage({
      super.key,
    required this.userdata,
  });

  final UserRegistrationModel userdata;

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
    final currentDisplayHeight = _useFeetInches 
        ? _convertToFeetInches(_selectedHeight)
        : '${_selectedHeight.round()} cm';

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
        decoration: BoxDecoration(

             gradient: LinearGradient(
                    colors: [
                      AppColors.neonGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
      ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
               
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button with glow effect
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.neonGold.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Iconsax.arrow_left_2,
                                  color: AppColors.neonGold,
                                  size: 24,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
        
                      // Title with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              Colors.white,
                              AppColors.neonGold,
                            ],
                            stops: const [0.7, 1.0],
                          ).createShader(bounds);
                        },
                        child: Text(
                          'Your Height',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            // fontStyle: FontStyle.italic,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
        
                      // Description
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select your height for better match compatibility',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade300,
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
        
                      // Height display with glow
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.neonGold.withOpacity(0.1),
                                AppColors.neonGold.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            // border: Border.all(
                            //   color: AppColors.neonGold.withOpacity(0.2),
                            //   width: .5,
                            // ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: AppColors.neonGold.withOpacity(0.1),
                            //     blurRadius: 20,
                            //     spreadRadius: 5,
                            //   ),
                            // ],
                          ),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Colors.white,
                                      AppColors.neonGold,
                                      AppColors.neonGold,
                                    ],
                                    stops: const [0.3, 0.7, 1.0],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  currentDisplayHeight,
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Unit toggle
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBlack.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
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
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        decoration: BoxDecoration(
                                          gradient: !_useFeetInches
                                              ? LinearGradient(
                                                  colors: [
                                                    AppColors.neonGold,
                                                    AppColors.neonGold.withOpacity(0.8),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )
                                              : null,
                                          color: _useFeetInches ? Colors.transparent : null,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'CM',
                                          style: TextStyle(
                                            color: !_useFeetInches 
                                                ? Colors.black 
                                                : Colors.grey.shade400,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        if (!_useFeetInches) {
                                          setState(() => _useFeetInches = true);
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        decoration: BoxDecoration(
                                          gradient: _useFeetInches
                                              ? LinearGradient(
                                                  colors: [
                                                    AppColors.neonGold,
                                                    AppColors.neonGold.withOpacity(0.8),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )
                                              : null,
                                          color: !_useFeetInches ? Colors.transparent : null,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'FT/IN',
                                          style: TextStyle(
                                            color: _useFeetInches 
                                                ? Colors.black 
                                                : Colors.grey.shade400,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
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
                      ),
        
                      const SizedBox(height: 0),
        
                      // Height picker wheel
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification) {
                              _snapToNearestValue();
                            }
                            return false;
                          },
                          child: Stack(
                            children: [
                              // Center indicator line
                              Center(
                                child: Container(
                                  height: 1,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.neonGold,
                                        Colors.transparent,
                                      ],
                                      stops: const [0, 0.5, 1],
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Selection indicator circles
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.neonGold,
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.neonGold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Wheel picker
                              ListWheelScrollView.useDelegate(
                                diameterRatio: 2.5,
                                perspective: 0.005,
                                offAxisFraction: 0.0,
                                useMagnifier: true,
                                magnification: 1.3,
                                itemExtent: 70,
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
                                            child: AnimatedScale(
                                              duration: const Duration(milliseconds: 200),
                                              scale: isSelected ? 1.2 : 1.0,
                                              child: Text(
                                                '${height.round()}',
                                                style: TextStyle(
                                                  fontSize: isSelected ? 25 : 20,
                                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                                  color: isSelected 
                                                      ? AppColors.neonGold 
                                                      : Colors.grey.shade500,
                                                  shadows: isSelected
                                                      ? [
                                                          Shadow(
                                                            color: AppColors.neonGold.withOpacity(0.5),
                                                            blurRadius: 10,
                                                          ),
                                                        ]
                                                      : null,
                                                ),
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
                                            child: AnimatedScale(
                                              duration: const Duration(milliseconds: 200),
                                              scale: isSelected ? 1.2 : 1.0,
                                              child: Text(
                                                heightStr,
                                                style: TextStyle(
                                                  fontSize: isSelected ? 25 : 20,
                                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                                  color: isSelected 
                                                      ? AppColors.neonGold 
                                                      : Colors.grey.shade500,
                                                  shadows: isSelected
                                                      ? [
                                                          Shadow(
                                                            color: AppColors.neonGold.withOpacity(0.5),
                                                            blurRadius: 10,
                                                          ),
                                                        ]
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
        
                      // Info card
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.neonGold.withOpacity(0.08),
                              AppColors.neonGold.withOpacity(0.02),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.neonGold.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.neonGold.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.rulerpen,
                                color: AppColors.neonGold,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Average Height Range',
                                    style: TextStyle(
                                      color: AppColors.neonGold,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Most people on Weekend are between 160-180 cm. Your height helps show you compatible matches.',
                                    style: TextStyle(
                                      color: AppColors.neonGold.withOpacity(0.8),
                                      fontSize: 8,
                                      height: 1.4,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        
                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return AppColors.neonGold.withOpacity(0.5);
                          }
                          return AppColors.neonGold;
                        },
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Iconsax.arrow_right_3,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
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
   


  final UserRegistrationModel data = widget.userdata.copyWith(
    height:_selectedHeight,
  );



    // Navigate to next page (Lifestyle or Bio)
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LifestylePage( userdata: data,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}