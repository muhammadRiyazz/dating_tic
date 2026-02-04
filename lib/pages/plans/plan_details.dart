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

  void _showConfirmationBottomSheet() {
    final selectedPrice = widget.plan.prices.firstWhere((p) => p.priceId == _selectedPriceId);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 30),
              
              // Crown Icon with Glow
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.neonGold.withOpacity(0.1),
                  boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.1), blurRadius: 20)],
                  border: Border.all(color: AppColors.neonGold.withOpacity(0.2))
                ),
                child: const Icon(Iconsax.crown5, color: AppColors.neonGold, size: 40),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 25),
              const Text("CONFIRM UPGRADE", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 10),
              Text(
                "You are activating the ${widget.plan.name} features.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
              ),
              
              const SizedBox(height: 35),
              
              // Glassy Card Inside Bottom Sheet
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedPrice.cycle.toUpperCase(), style: const TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.w900, fontSize: 18)),
                        const Text("Billing Cycle", style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                    const Spacer(),
                    Text("₹${selectedPrice.offerPrice ?? selectedPrice.price}", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("NOT NOW", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleUpgrade();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("PAY & UPGRADE", style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleUpgrade() async {
    if (_selectedPriceId == null) return;
    final userId = await AuthService().getUserId();
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    final selectedPrice = widget.plan.prices.firstWhere((p) => p.priceId == _selectedPriceId);

    HapticFeedback.heavyImpact();
    final success = await provider.upgradeUserPlan(userId.toString(), _selectedPriceId.toString());

    if (mounted) {
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UpgradeSuccessPage(
            planName: widget.plan.name,
            duration: 'Month',
            price: '599',
            bgImage: widget.image,
          ))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: CachedNetworkImage(imageUrl: widget.image, fit: BoxFit.cover)),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.9)],
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
                        _buildSectionLabel("CHOOSE YOUR EXPERIENCE"),
                        const SizedBox(height: 16),
                        ...widget.plan.prices.map((price) => _buildPricingCard(price)),
                        const SizedBox(height: 40),
                        _buildSectionLabel("MEMBERSHIP PERKS"),
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
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle), child: const Icon(Iconsax.arrow_left_2, color: Colors.white, size: 20)),
          ),
          const Text("UPGRADE STUDIO", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 3)),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.plan.name.toUpperCase(), style: const TextStyle(color: AppColors.neonGold, fontSize: 45, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
        const SizedBox(height: 5),
        Text(widget.plan.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16)),
      ],
    ).animate().fadeIn().slideX();
  }

  Widget _buildSectionLabel(String text) {
    return Text(text, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2));
  }

  Widget _buildPricingCard(PriceModel price) {
    bool isSelected = _selectedPriceId == price.priceId;
    bool isActivePrice = widget.plan.isActive && widget.plan.activePriceId == price.priceId;

    return GestureDetector(
      onTap: () { if (!isActivePrice) setState(() => _selectedPriceId = price.priceId); },
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.neonGold : Colors.white10, width: isSelected ? 2 : 1),
          color: isSelected ? AppColors.neonGold.withOpacity(0.1) : Colors.white.withOpacity(0.03),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Iconsax.tick_circle5 : Iconsax.record, color: isSelected ? AppColors.neonGold : Colors.white24),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(price.cycle.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Text("₹${price.offerPrice ?? price.price}", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                ],
              ),
            ),
            if (isActivePrice) _buildBadge("ACTIVE", Colors.green)
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.2))),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        children: widget.plan.features.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Row(children: [const Icon(Iconsax.verify5, color: AppColors.neonGold, size: 20), const SizedBox(width: 16), Expanded(child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 15)))]),
        )).toList(),
      ),
    );
  }

  Widget _buildBottomActionSection() {
    final provider = context.watch<SubscriptionProvider>();
    if (widget.plan.isActive && _selectedPriceId == widget.plan.activePriceId) return const SizedBox();
    return Positioned(
      bottom: 40, left: 24, right: 24,
      child: ElevatedButton(
        onPressed: provider.isUpgrading ? null : _showConfirmationBottomSheet,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGold,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: provider.isUpgrading 
          ? const CircularProgressIndicator(color: Colors.black)
          : const Text("Activate Membership", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
    );
  }
}