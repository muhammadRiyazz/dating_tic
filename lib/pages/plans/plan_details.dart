import 'dart:developer';
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/plan_model.dart';
import 'package:dating/pages/plans/upgrade_success_page.dart';
import 'package:dating/providers/subscription_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

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

  void _handleUpgrade() async {
    if (_selectedPriceId == null) return;

    final userId = await AuthService().getUserId();
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);

    HapticFeedback.mediumImpact();
    
    final success = await provider.upgradeUserPlan(userId.toString(), _selectedPriceId.toString());

    if (mounted) {
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UpgradeSuccessPage(planName: widget.plan.name))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
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
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 0.9],
                    colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.9)],
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
                        
                        if (widget.plan.prices.isEmpty)
                        SizedBox()
                          //  _buildEmptyPricePlaceholder()
                        else
                          ...widget.plan.prices.map((price) => _buildPricingCard(price)),
                        
                        const SizedBox(height: 40),
                        _buildSectionLabel("MEMBERSHIP BENEFITS"),
                        const SizedBox(height: 16),
                        _buildFeaturesSection(),
                        const SizedBox(height: 140), 
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
          const Text("PLAN DETAILS", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 3)),
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
          style: const TextStyle(color: AppColors.neonGold, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1.5),
        ),
        const SizedBox(height: 8),
        Text(widget.plan.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1);
  }

  Widget _buildSectionLabel(String text) {
    return Text(text, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2));
  }

  Widget _buildPricingCard(PriceModel price) {
    bool isSelected = _selectedPriceId == price.priceId;
    bool isActivePrice = widget.plan.isActive && widget.plan.activePriceId == price.priceId;
    bool isFree = (price.offerPrice ?? price.price) == 0;

    return GestureDetector(
      onTap: () {
        if (!isActivePrice) setState(() => _selectedPriceId = price.priceId);
      },
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected 
                ? (isActivePrice ? Colors.green.withOpacity(0.6) : AppColors.neonGold)
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? (isActivePrice ? Colors.green.withOpacity(0.05) : AppColors.neonGold.withOpacity(0.05))
              : Colors.white.withOpacity(0.04),
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
                  Text(
                    price.cycle.isEmpty ? "ACCESS" : price.cycle.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isFree ? "Complimentary" : "₹${price.offerPrice ?? price.price} total",
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
            if (isActivePrice)
              _buildBadge("ACTIVE", Colors.green)
            else if (price.discount != null && price.discount! > 0)
              _buildBadge("-${price.discount}%", AppColors.neonGold),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
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
          ? [const Text("Standard features included.", style: TextStyle(color: Colors.white54))]
          : widget.plan.features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.verify5, color: AppColors.neonGold, size: 20),
                const SizedBox(width: 16),
                Expanded(child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4))),
              ],
            ),
          )).toList(),
      ),
    );
  }

  Widget _buildBottomActionSection() {
    final provider = context.watch<SubscriptionProvider>();
    bool isCurrentSelectionActive = widget.plan.isActive && _selectedPriceId == widget.plan.activePriceId;

    if (isCurrentSelectionActive) return const SizedBox();
    
    return Positioned(
      bottom: 40, left: 24, right: 24,
      child: ElevatedButton(
        onPressed: provider.isUpgrading ? null : _handleUpgrade,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGold,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: provider.isUpgrading 
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5))
          : const Text("Activate Membership", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds, color: Colors.white24),
    );
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