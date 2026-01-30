import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/main.dart';
import 'package:dating/models/plan_model.dart';
import 'package:dating/pages/plans/plan_details.dart';
import 'package:dating/providers/subscription_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class PremiumUpgradeSheet extends StatefulWidget {
  const PremiumUpgradeSheet({super.key});

  @override
  State<PremiumUpgradeSheet> createState() => _PremiumUpgradeSheetState();
}

class _PremiumUpgradeSheetState extends State<PremiumUpgradeSheet> {
  late PageController _pageController;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = await AuthService().getUserId();
      final provider = Provider.of<SubscriptionProvider>(context, listen: false);
      await provider.fetchPlans(userId ?? '');
      
      if (mounted && provider.plans.isNotEmpty) {
        // Find next upgrade index
        int upgradeIndex = provider.plans.indexWhere((p) => !p.isActive);
        if (upgradeIndex == -1) upgradeIndex = 0;

        provider.setCurrentPlanIndex(upgradeIndex);
        setState(() => _isInit = true);
        _pageController.jumpToPage(upgradeIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Color(0xFF0A0A0A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            child: Stack(
              children: [
                // 1. Blurred Background Image (Matches the first card)
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: "https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=800",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                ),

                if (provider.isLoading || !_isInit)
                  _buildShimmerLoading()
                else
                  _buildSheetContent(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetContent(BuildContext context, SubscriptionProvider provider) {
    final currentPlan = provider.plans[provider.currentPlanIndex];

    return Column(
      children: [
        // Handle Bar
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Plans & Pricing",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                  Text("Upgrade your experience", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13))
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Iconsax.close_circle5, color: Colors.white38, size: 32),
              ),
            ],
          ),
        ),

        // Exact Swiping Cards
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              HapticFeedback.selectionClick();
              provider.setCurrentPlanIndex(index);
            },
            itemCount: provider.plans.length,
            itemBuilder: (context, index) {
              return _buildExactPlanCard(provider.plans[index], index, provider);
            },
          ),
        ),

        // Indicator Dots
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              provider.plans.length,
              (index) => AnimatedContainer(
                duration: 300.ms,
                width: index == provider.currentPlanIndex ? 24 : 8,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: index == provider.currentPlanIndex ? AppColors.neonGold : Colors.white24,
                ),
              ),
            ),
          ),
        ),

        // Description and Action
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Column(
            children: [
              Text(
                _getPlanDescription(provider.currentPlanIndex),
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, height: 1.4),
                textAlign: TextAlign.center,
              ).animate(key: ValueKey(provider.currentPlanIndex)).fadeIn().slideY(begin: 0.1),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: currentPlan.isActive ? null : () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => 
                    PremiumSubscriptionPage(
                      image: SubscriptionService.getRandomBackgroundImage(provider.currentPlanIndex),
                      plan: currentPlan,
                    )
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentPlan.isActive ? Colors.white10 : AppColors.neonGold,
                  disabledBackgroundColor: Colors.white10,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Text(
                  currentPlan.isActive ? "CURRENT ACTIVE PLAN" : "SUBSCRIBE NOW", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: currentPlan.isActive ? Colors.white38 : Colors.black)
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds, color: Colors.white30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExactPlanCard(SubscriptionPlanModel plan, int index, SubscriptionProvider provider) {
    final isCurrent = index == provider.currentPlanIndex;
    final currentPrice = plan.prices.isNotEmpty ? plan.prices[0] : null;
    final bool isFree = currentPrice == null || (currentPrice.offerPrice ?? currentPrice.price) == 0;

    return AnimatedScale(
      scale: isCurrent ? 1.0 : 0.9,
      duration: 300.ms,
      curve: Curves.easeOutBack,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: SubscriptionService.getRandomBackgroundImage(index),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPlanIcon(plan.name),
                        if (plan.isActive)
                          _buildSmallBadge("CURRENT", Colors.green)
                        else if (plan.badge != null)
                          _buildSmallBadge(plan.badge!, AppColors.neonGold),
                      ],
                    ),
                    const Spacer(),
                    Text(plan.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                    Text(plan.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          isFree ? 'Free' : '₹${currentPrice.offerPrice ?? currentPrice.price}',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)
                        ),
                        if (!isFree)
                          Text(' /${currentPrice!.cycle}', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 32),
                    ...plan.features.take(3).map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Iconsax.tick_circle, color: AppColors.neonGold, size: 16),
                          const SizedBox(width: 10),
                          Expanded(child: Text(feature, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildPlanIcon(String planName) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Text(SubscriptionService.getIconForPlan(planName), style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: [
        const SizedBox(height: 100),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(32)),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: Colors.white10),
        ),
        const SizedBox(height: 150),
      ],
    );
  }

  String _getPlanDescription(int index) {
    switch (index) {
      case 0: return "Essential features to get you started.";
      case 1: return "Our most popular plan for active seekers.";
      case 2: return "The ultimate experience with full access.";
      default: return "Choose your perfect plan.";
    }
  }
}