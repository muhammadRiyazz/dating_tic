import 'dart:developer';

import 'package:dating/main.dart'; // For AppColors
import 'package:dating/providers/profile_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// Method to show Height Bottom Sheet
void showHeightBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0A0A0A),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return _HeightBottomSheet();
    },
  );
}

class _HeightBottomSheet extends StatefulWidget {
  @override
  State<_HeightBottomSheet> createState() => _HeightBottomSheetState();
}

class _HeightBottomSheetState extends State<_HeightBottomSheet> {
  int? _selectedHeight;
  late List<int> _heightOptions;
  FixedExtentScrollController? _scrollController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize height options (120cm to 220cm)
    _heightOptions = List.generate(101, (index) => 120 + index);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

 void _initializeHeight() {
    if (_initialized) return;
    
    final updateProvider = context.read<UpdateProfileProvider>();
    final currentHeightStr = updateProvider.userProfile.height;
    log('Current height string: $currentHeightStr');
    
    try {
      // Parse as double first, then convert to int
      final currentHeightDouble = double.tryParse(currentHeightStr ?? '170');
      final currentHeight = currentHeightDouble?.round() ?? 170;
      log('Parsed height: $currentHeight');
      
      _selectedHeight = currentHeight;
      
      // Find index of current height
      final index = _heightOptions.indexWhere((h) => h == currentHeight);
      final initialIndex = index != -1 ? index : 50; // 170cm default
      log('Initial index: $initialIndex');
      
      _scrollController = FixedExtentScrollController(initialItem: initialIndex);
      _initialized = true;
      
      if (mounted) setState(() {});
    } catch (e) {
      log('Error initializing height: $e');
      _selectedHeight = 170;
      _scrollController = FixedExtentScrollController(initialItem: 50);
      _initialized = true;
      if (mounted) setState(() {});
    }
  }

  void _updateHeight(int height) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedHeight = height;
    });
  }

  Future<void> _saveHeight(BuildContext context) async {
    if (_selectedHeight == null) return;
    
    final updateProvider = context.read<UpdateProfileProvider>();
    HapticFeedback.mediumImpact();
    
    try {
      // Update height in provider
      updateProvider.updateHeight(_selectedHeight!.toString());
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      log('Height update error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize height on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initializeHeight();
      }
    });

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1A1A1A),
            const Color(0xFF0A0A0A),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Your Height",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Iconsax.close_circle,
                      color: Colors.white38, size: 24),
                ),
              ],
            ),
          ),

          // Current Height Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.neonGold.withOpacity(0.1),
                  AppColors.neonGold.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
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
                    _selectedHeight != null ? '$_selectedHeight cm' : 'Loading...',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Centimeters',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Height Picker Wheel (show only when initialized)
          if (_scrollController != null && _selectedHeight != null)
            Expanded(
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
                    controller: _scrollController!,
                    onSelectedItemChanged: (index) {
                      _updateHeight(_heightOptions[index]);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _heightOptions.length,
                      builder: (context, index) {
                        final height = _heightOptions[index];
                        final isSelected = height == _selectedHeight;
                        
                        return Center(
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            scale: isSelected ? 1.2 : 1.0,
                            child: Text(
                              '$height',
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
            )
          else
            // Loading state for picker
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.neonGold,
                ),
              ),
            ),

          // Height Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.rulerpen,
                    color: AppColors.neonGold,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Height Range',
                        style: TextStyle(
                          color: AppColors.neonGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Most people prefer partners with compatible heights. Average range is 160-180 cm.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Update Button (only show when initialized)
          if (_selectedHeight != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: InkWell(
                onTap: () => _saveHeight(context),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonGold,
                        AppColors.neonGold.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                 
                  ),
                  child: const Center(
                    child: Text(
                      "Update Height",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            // Loading state for button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.neonGold,
                    strokeWidth: 1,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// Helper method to get display text for height
String getHeightDisplay(BuildContext context) {
  final updateProvider = context.read<UpdateProfileProvider>();
  final height = updateProvider.userProfile.height;
  
  if (height == null || height.isEmpty) return "Add Height";
  
  return '$height cm';
}

// Example usage in your profile page:
Widget _buildHeightField(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showHeightBottomSheet(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Iconsax.rulerpen, 
                  color: AppColors.neonGold, 
                  size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Height",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<UpdateProfileProvider>(
                      builder: (context, provider, child) {
                        final height = provider.userProfile.height;
                        return Text(
                          height != null && height.isNotEmpty ? '$height cm' : "Add Height",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Icon(Iconsax.arrow_right_3, 
                color: Colors.white38, 
                size: 20),
            ],
          ),
        ),
      ),
    ),
  );
}