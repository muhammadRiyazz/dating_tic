import 'dart:developer';
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PremiumSubscriptionPage extends StatefulWidget {
  final String image;
  final SubscriptionPlanModel plan;

  const PremiumSubscriptionPage({super.key, required this.image, required this.plan});

  @override
  State<PremiumSubscriptionPage> createState() => _PremiumSubscriptionPageState();
}

class _PremiumSubscriptionPageState extends State<PremiumSubscriptionPage> {
  int? _selectedPriceId;

  @override
  void initState() {
    super.initState();
    _selectedPriceId = widget.plan.activePriceId ?? 
                      (widget.plan.prices.isNotEmpty ? widget.plan.prices[0].priceId : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(imageUrl: widget.image, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 0.9],
                    colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildMainHeader(),
                        const SizedBox(height: 40),
                        _buildSectionLabel("SELECT A DURATION"),
                        const SizedBox(height: 16),
                        
                        // Handle Empty/Zero price list cases
                        if (widget.plan.prices.isEmpty)
                           _buildEmptyPricePlaceholder()
                        else
                          ...widget.plan.prices.map((price) => _buildPricingCard(price)),
                        
                        const SizedBox(height: 40),
                        _buildSectionLabel("MEMBERSHIP BENEFITS"),
                        const SizedBox(height: 16),
                        _buildFeaturesSection(),
                        const SizedBox(height: 120), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomActionSection(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircularGlassButton(
            icon: Iconsax.arrow_left_2,
            onTap: () => Navigator.pop(context),
          ),
          const Text("PLAN DETAILS", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.plan.name.toUpperCase(),
          style: TextStyle(color: AppColors.neonGold, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1),
        ),
        const SizedBox(height: 8),
        Text(widget.plan.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1);
  }

  Widget _buildSectionLabel(String text) {
    return Text(text, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2));
  }

  // UPDATED: Fixed empty/complimentary management
  Widget _buildPricingCard(PriceModel price) {
    bool isSelected = _selectedPriceId == price.priceId;
    bool isActivePrice = widget.plan.isActive && widget.plan.activePriceId == price.priceId;
    bool isFree = (price.offerPrice ?? price.price) == 0;

    return GestureDetector(
      onTap: () => setState(() => _selectedPriceId = price.priceId),
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected 
                ? (isActivePrice ? Colors.green.withOpacity(0.6) : AppColors.neonGold.withOpacity(0.6))
                : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          color: isSelected 
              ? (isActivePrice ? Colors.green.withOpacity(0.05) : AppColors.neonGold.withOpacity(0.05))
              : Colors.white.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Iconsax.tick_circle5 : Iconsax.record,
              color: isSelected ? (isActivePrice ? Colors.green : AppColors.neonGold) : Colors.white24,
              size: 24,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show the cycle name even if it is free
                  Text(
                    price.cycle.isEmpty ? "Standard Access" : price.cycle.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  // Better labels for zero cost
                  Text(
                    isFree ? "Complimentary • No Cost" : "₹${price.offerPrice ?? price.price} total",
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
            if (isActivePrice)
              _buildBadge("ACTIVE", Colors.green)
            else if (price.discount != null && price.discount! > 0)
              _buildBadge("SAVE ${price.discount}%", AppColors.neonGold),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPricePlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
           Icon(Iconsax.info_circle, color: AppColors.neonGold, size: 24),
           const SizedBox(width: 16),
           const Expanded(
             child: Text(
               "This basic tier includes permanent complimentary access.",
               style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.4))),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: widget.plan.features.isEmpty 
          ? [const Text("Standard basic features included.", style: TextStyle(color: Colors.white54))]
          : widget.plan.features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Iconsax.verify5, color: AppColors.neonGold, size: 20),
                const SizedBox(width: 16),
                Expanded(child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4))),
              ],
            ),
          )).toList(),
      ),
    );
  }

  Widget _buildBottomActionSection() {
    bool isCurrentSelectionActive = widget.plan.isActive && _selectedPriceId == widget.plan.activePriceId;

    return 
      isCurrentSelectionActive ? SizedBox():
    
    Positioned(
      bottom: 45, left: 25, right: 25,
      child:   ElevatedButton(
                  onPressed: () {
                    // Logic to open details
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => 
                    //   PremiumSubscriptionPage(
                    //     image: SubscriptionService.getRandomBackgroundImage(provider.currentPlanIndex),
                    //     plan: currentPlan,
                    //   )
                    // ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.neonGold,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                   "Subscribe Now", 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(
                  // enabled: !currentPlan.isActive,
                  duration: 2.seconds, 
                  color: Colors.white30
                ));
  }

  Widget _buildCircularGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.2))),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}