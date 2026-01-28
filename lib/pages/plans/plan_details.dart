import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PremiumSubscriptionPage extends StatefulWidget {
  final String image;
  const PremiumSubscriptionPage({super.key, required this.image});

  @override
  State<PremiumSubscriptionPage> createState() => _PremiumSubscriptionPageState();
}

class _PremiumSubscriptionPageState extends State<PremiumSubscriptionPage> {
  // Define the Neon Gold Color
  static const Color neonGold = Color(0xFFFFD700);

  // Track which plan is selected
  int _selectedPlanIndex = 1; // Default to Yearly (Best Value)

  final List<Map<String, dynamic>> _pricingOptions = [
    {
      "title": "Monthly",
      "price": "\$10.99",
      "period": "/ month",
      "badge": null,
    },
    {
      "title": "Yearly",
      "price": "\$100.99",
      "period": "/ year",
      "badge": "BEST VALUE",
    },
    {
      "title": "Weekly",
      "price": "\$4.99",
      "period": "/ week",
      "badge": null,
    },
  ];

  final List<String> _features = [
    "Decryption of a personal bodygraph",
    "The movement of the planets",
    "Calculating compatibility with others",
    "Get Personal Bodygraph readings",
    "Unlimited profile rewinds",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Starry/Cosmos Background
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.image,
              fit: BoxFit.cover,
            ),
          ),
          
          // 2. Dark Gradient Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // 3. Content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildMainHeader(),
                        const SizedBox(height: 35),
                        
                        // Pricing List
                        Column(
                          children: List.generate(_pricingOptions.length, (index) {
                            return _buildPricingCard(index);
                          }),
                        ),

                        const SizedBox(height: 32),
                        _buildFeaturesSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                _buildBottomActionSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40), 
          const Text(
            "Pricing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return Column(
      children: [
        const Text(
          'Voyager',
          style: TextStyle(
            color: neonGold, // Applied Neon Gold here
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
        const SizedBox(height: 4),
        Text(
          'Most popular choice',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildPricingCard(int index) {
    final option = _pricingOptions[index];
    bool isSelected = _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? neonGold : Colors.white.withOpacity(0.1), // Gold border when selected
            width:  1,
          ),
          color: isSelected ? neonGold.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          // boxShadow: isSelected ? [
          //   BoxShadow(
          //     color: neonGold.withOpacity(0.15),
          //     blurRadius: 15,
          //     spreadRadius: 1,
          //   )
          // ] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Custom Radio Button
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? neonGold : Colors.white30,
                        width: 2,
                      ),
                      color: isSelected ? neonGold : Colors.transparent,
                    ),
                    child: isSelected 
                      ? const Icon(Icons.check, size: 16, color: Colors.black) 
                      : null,
                  ),
                  const SizedBox(width: 16),
                  
                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option['title'],
                          style: TextStyle(
                            color: isSelected ? neonGold : Colors.white, // Text gold when selected
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${option['price']} ${option['period']}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge
                  if (option['badge'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: neonGold, // Badge Gold
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: neonGold.withOpacity(0.3),
                            blurRadius: 8,
                          )
                        ]
                      ),
                      child: Text(
                        option['badge'],
                        style: const TextStyle(
                          color: Colors.black, // Contrast color
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's included",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(_features.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                const Icon(Iconsax.tick_circle, color: neonGold, size: 20), // Gold Tick Icons
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _features[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildBottomActionSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
        )
      ),
      child: Column(
        children: [
          // Subscribe Button in Neon Gold
          ElevatedButton(
            onPressed: () {
              // Action logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: neonGold, // Button Solid Gold
              foregroundColor: Colors.black, // Text Black for contrast
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
              // shadowColor: neonGold.withOpacity(0.4),
            ),
            child: const Text(
              "Subscribe Now",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
          
          const SizedBox(height: 10),
          
          // // Terms & Privacy
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildFooterLink("Terms of Use"),
          //     _buildDot(),
          //     _buildFooterLink("Privacy Policy"),
          //     _buildDot(),
          //     _buildFooterLink("Restore"),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text("•", style: TextStyle(color: Colors.white.withOpacity(0.4))),
    );
  }
}