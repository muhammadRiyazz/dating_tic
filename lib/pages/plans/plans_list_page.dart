// import 'dart:ui';

// import 'package:dating/pages/plans/plan_details.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dating/main.dart';

// class SubscriptionCardPage extends StatefulWidget {
//   const SubscriptionCardPage({super.key});

//   @override
//   State<SubscriptionCardPage> createState() => _SubscriptionCardPageState();
// }

// class _SubscriptionCardPageState extends State<SubscriptionCardPage> {
//   int _currentIndex = 0;
//   final PageController _pageController = PageController(viewportFraction: 0.85);
  
//   final List<SubscriptionPlan> _plans = [
//     SubscriptionPlan(
//       title: "Explorer",
//       subtitle: "Perfect for beginners",
//       price: 9.99,
//       period: "/month",
//       features: [
//         "50 Daily Profile Views",
//         "5 Super Likes per week",
//         "Basic Matching Algorithm",
//         "Standard Filters",
//       ],
//       icon: Iconsax.radar1,
//       gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
//       badge: null,
//       imageUrl: "https://images.pexels.com/photos/3171204/pexels-photo-3171204.jpeg",
//     ),
//     SubscriptionPlan(
//       title: "Voyager",
//       subtitle: "Most popular choice",
//       price: 24.99,
//       period: "/3 months",
//       features: [
//         "Unlimited Profile Views",
//         "15 Super Likes per week",
//         "Advanced Matching",
//         "All Premium Filters",
//         "Priority Support",
//         "5 Rewinds per day",
//       ],
//       icon: Iconsax.crown,
//       gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
//       badge: "MOST POPULAR",
//       imageUrl: "https://images.pexels.com/photos/4873585/pexels-photo-4873585.jpeg",
//     ),
//     SubscriptionPlan(
//       title: "Cosmonaut",
//       subtitle: "Ultimate experience",
//       price: 79.99,
//       period: "/year",
//       features: [
//         "Unlimited Everything",
//         "AI-Powered Matching",
//         "VIP Priority Support",
//         "Advanced Insights",
//         "Unlimited Rewinds",
//         "Profile Highlight",
//         "Incognito Mode",
//       ],
//       icon: Iconsax.star,
//       gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
//       badge: "BEST VALUE",
//       imageUrl: "https://images.pexels.com/photos/6579000/pexels-photo-6579000.jpeg",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: Stack(
//         children: [
//           // Blurred background image
//           Positioned.fill(
//             child: CachedNetworkImage(
//               imageUrl: "https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w-800&auto=format&fit=crop",
//               fit: BoxFit.cover,
//               color: Colors.black.withOpacity(0.1),
//               colorBlendMode: BlendMode.darken,
//             ),
//           ),
          
//           // Blur overlay
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),
//           ),
          
//           // Content
//           SafeArea(
//             child: Column(
//               children: [
//                 // Header with back button
//                 // Padding(
//                 //   padding: const EdgeInsets.all(16),
//                 //   child: Row(
//                 //     children: [
   
//                 //         Text(
//                 //         "   Upgrade Plan",
//                 //         style: TextStyle(
//                 //           fontSize: 24,
//                 //           fontWeight: FontWeight.w900,
//                 //           color: Colors.white,
//                 //           height: 1.2,
//                 //         ),
//                 //         textAlign: TextAlign.center,
//                 //       ), 

//                 //       //  const Spacer(),
//                 //       // _buildGlassyChip("Upgrade Now"),
                  
                    
//                 //     ],
//                 //   ),
//                 // ),
//                 Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start, 
//             children: [
//               Text("Plans & Pricing", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900,letterSpacing: -1.5,)), 
//               Text("Manage your digital presence", style: TextStyle(color: Colors.white38, fontSize: 13))
//             ]
//           ),
//           _buildGlassyButton( icon:  Iconsax.arrow_left_2,onTap:  () => Navigator.pop(context)),
//         ],
//       ),
//     ),
          
           
//                 // Cards with PageView
//                 Expanded(
//                   child: PageView.builder(
//                     controller: _pageController,
//                     onPageChanged: (index) {
//                       setState(() => _currentIndex = index);
//                     },
//                     itemCount: _plans.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: index == _currentIndex ? 0 : 10,
//                           vertical: 20,
//                         ),
//                         child: _buildPlanCard(_plans[index], index),
//                       );
//                     },
//                   ),
//                 ),
                
//                 // Plan Indicator
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     _plans.length,
//                     (index) => AnimatedContainer(
//                       duration: 300.ms,
//                       width: index == _currentIndex ? 20 : 8,
//                       height: 8,
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4),
//                         color: index == _currentIndex
//                             ? _plans[index].gradient[0]
//                             : Colors.white.withOpacity(0.2),
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 // Description and Button Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 5),
                      
//                       // // Additional Promotional Text
//                       // Container(
//                       //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       //   decoration: BoxDecoration(
//                       //     color: Colors.white.withOpacity(0.05),
//                       //     borderRadius: BorderRadius.circular(12),
//                       //     border: Border.all(color: Colors.white.withOpacity(0.1)),
//                       //   ),
//                       //   child: Row(
//                       //     children: [
//                       //       Icon(
//                       //         Iconsax.flash,
//                       //         color: _plans[_currentIndex].gradient[1],
//                       //         size: 20,
//                       //       ),
//                       //       const SizedBox(width: 12),
//                       //       // Expanded(
//                       //       //   child: Text(
//                       //       //     _getPromotionalText(_currentIndex),
//                       //       //     style: TextStyle(
//                       //       //       color: Colors.white.withOpacity(0.9),
//                       //       //       fontSize: 13,
//                       //       //       fontWeight: FontWeight.w500,
//                       //       //     ),
//                       //       //   ),
//                       //       // ),
//                       //     ],
//                       //   ),
//                       // ),
                      
//                       // const SizedBox(height: 20),
                      
//                       // Plan Description
//                       Text(
//                         _getPlanDescription(_currentIndex),
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.7),
//                           fontSize: 14,
//                           height: 1.5,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
                      
//                       const SizedBox(height: 15),
                      
//                       // Subscribe Button
                      
//                             ElevatedButton(
//             onPressed: () {
//               // Action logic
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.neonGold, // Button Solid Gold
//               foregroundColor: Colors.black, // Text Black for contrast
//               minimumSize: const Size(double.infinity, 55),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               elevation: 10,
//               // shadowColor: neonGold.withOpacity(0.4),
//             ),
//             child: const Text(
//               "Subscribe Now",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 // letterSpacing: 01,
//               ),
//             ),
//           )
//                       // // Terms Text
//                       // Text(
//                       //   "Cancel anytime. No commitments.",
//                       //   style: TextStyle(
//                       //     color: Colors.white.withOpacity(0.5),
//                       //     fontSize: 12,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getPromotionalText(int index) {
//     switch (index) {
//       case 0:
//         return "Special offer: First month 50% off for new subscribers!";
//       case 1:
//         return "🔥 Best deal: Get 3 months for the price of 2!";
//       case 2:
//         return "🚀 Ultimate savings: 75% OFF compared to monthly plan!";
//       default:
//         return "Limited time offer!";
//     }
//   }

//   String _getPlanDescription(int index) {
//     switch (index) {
//       case 0:
//         return "Start your journey with essential features to explore potential matches. Perfect for those who want to test the waters.";
//       case 1:
//         return "Our most popular plan offers the perfect balance of features and value. Experience dating with enhanced capabilities.";
//       case 2:
//         return "Go all-in with our premium plan. Unlock every feature for the ultimate dating experience with maximum savings.";
//       default:
//         return "Choose the plan that fits your needs.";
//     }
//   }

 
//   Widget _buildPlanCard(SubscriptionPlan plan, int index) {
//     final isCurrent = index == _currentIndex;
    
//     return GestureDetector(
//       onTap: () {
//         _pageController.animateToPage(
//           index,
//           duration: 300.ms,
//           curve: Curves.easeInOut,
//         );
//       },
//       child: AnimatedContainer(
//         duration: 300.ms,
//         curve: Curves.easeInOut,
//         margin: EdgeInsets.symmetric(
//           vertical: isCurrent ? 0 : 30,
//         ),
//         transform: Matrix4.identity()..scale(isCurrent ? 1.0 : 0.9),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(24),
//           child: Stack(
//             children: [
//               // Background image with gradient overlay
//               Positioned.fill(
//                 child: CachedNetworkImage(
//                   imageUrl: plan.imageUrl,
//                   fit: BoxFit.cover,
//                   color: Colors.black.withOpacity(0.5),
//                   colorBlendMode: BlendMode.darken,
//                 ),
//               ),
              
//               // Glassy overlay
              // Positioned.fill(
              //   child: ClipRRect(
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              //       child: Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             begin: Alignment.topCenter,
              //             end: Alignment.bottomCenter,
              //             colors: [
              //               Colors.transparent,
              //               Colors.black.withOpacity(0.9),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
        
//               // Content
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top section with gradient overlay
//                   Container(
//                     height: 150,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           plan.gradient[0].withOpacity(0.7),
//                           plan.gradient[1].withOpacity(0.3),
//                         ],
//                       ),
//                     ),
//                     child: Stack(
//                       children: [
//                         // Pattern overlay
                        // Positioned.fill(
                        //   child: Opacity(
                        //     opacity: 0.1,
                        //     child: Container(
                        //       decoration: const BoxDecoration(
                        //         image: DecorationImage(
                        //           image: NetworkImage(
                        //             'https://www.transparenttextures.com/patterns/carbon-fibre.png',
                        //           ),
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        
//                         // Content
//                         Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   _buildGlassyIcon(
//                                     icon: plan.icon,
//                                     gradient: plan.gradient,
//                                   ),
//                                   const Spacer(),
//                                   if (plan.badge != null)
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(20),
//                                       child: BackdropFilter(
//                                         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 14,
//                                             vertical: 8,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white.withOpacity(0.15),
//                                             borderRadius: BorderRadius.circular(20),
//                                             border: Border.all(
//                                               color: Colors.white.withOpacity(0.2),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             plan.badge!,
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w900,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               const Spacer(),
//                               Text(
//                                 plan.title,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 plan.subtitle,
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.9),
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Content section
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(                      
                        
//                         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
//                          color: Colors.black.withOpacity(0.6),
// ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Price
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.baseline,
//                               textBaseline: TextBaseline.alphabetic,
//                               children: [
//                                 Text(
//                                   '\$${plan.price}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 36,
//                                     fontWeight: FontWeight.w900,
//                                     shadows: [
//                                       Shadow(
//                                         blurRadius: 10,
//                                         color: Colors.black,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   plan.period,
//                                   style: TextStyle(
//                                     color: Colors.white.withOpacity(0.8),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),

//                             // Glassy Divider
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(1),
//                               child: BackdropFilter(
//                                 filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                                 child: Container(
//                                   height: 1,
//                                   color: Colors.white.withOpacity(0.15),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),

//                             // Features
//                             Expanded(
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: plan.features.length,
//                                 itemBuilder: (context, featureIndex) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(bottom: 12),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.all(4),
//                                           decoration: BoxDecoration(
//                                             color: plan.gradient[1].withOpacity(0.2),
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Icon(
//                                             Iconsax.tick_circle,
//                                             color: plan.gradient[1],
//                                             size: 16,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Text(
//                                             plan.features[featureIndex],
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),

//                             // View Details Glassy Button
//                             const SizedBox(height: 16),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //       return PremiumSubscriptionPage( image:   plan.imageUrl ,);
                            //     },));
                            //   },
                            //   child: ClipRRect(
                            //     borderRadius: BorderRadius.circular(16),
                            //     child: BackdropFilter(
                            //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            //       child: Container(
                            //         width: double.infinity,
                            //         padding: const EdgeInsets.symmetric(vertical: 16),
                            //         decoration: BoxDecoration(
                            //           color: Colors.white.withOpacity(0.08),
                            //           borderRadius: BorderRadius.circular(16),
                            //           // border: Border.all(
                            //           //   color: Colors.white.withOpacity(0.15),
                            //           // ),
                            //         ),
                            //         child: Center(
                            //           child: Text(
                            //             'View all details',
                            //             style: const TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w600,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassyButton({
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white.withOpacity(0.2)),
//             ),
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassyChip(String text) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 6,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.2)),
//           ),
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.8),
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassyIcon({
//     required IconData icon,
//     required List<Color> gradient,
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 gradient[0].withOpacity(0.3),
//                 gradient[1].withOpacity(0.1),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: gradient[0].withOpacity(0.3)),
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }

//   void _subscribeToPlan(int index) {
//     // Handle subscription logic
//     print('Subscribed to ${_plans[index].title}');
    
//     // Show confirmation dialog or navigate to payment screen
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.black.withOpacity(0.9),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(color: _plans[index].gradient[0].withOpacity(0.3)),
//         ),
//         title: Text(
//           "Confirm Subscription",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Text(
//           "You are about to subscribe to ${_plans[index].title} plan for \$${_plans[index].price}${_plans[index].period}",
//           style: TextStyle(color: Colors.white.withOpacity(0.8)),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.white.withOpacity(0.6)),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: _plans[index].gradient,
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Process subscription
//               },
//               child: const Text(
//                 "Subscribe",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SubscriptionPlan {
//   final String title;
//   final String subtitle;
//   final double price;
//   final String period;
//   final List<String> features;
//   final IconData icon;
//   final List<Color> gradient;
//   final String? badge;
//   final String imageUrl;

//   SubscriptionPlan({
//     required this.title,
//     required this.subtitle,
//     required this.price,
//     required this.period,
//     required this.features,
//     required this.icon,
//     required this.gradient,
//     this.badge,
//     required this.imageUrl,
//   });
// }
import 'dart:developer';
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/plan_model.dart';
import 'package:dating/pages/plans/plan_details.dart';
import 'package:dating/providers/subscription_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class SubscriptionCardPage extends StatefulWidget {
  const SubscriptionCardPage({super.key});

  @override
  State<SubscriptionCardPage> createState() => _SubscriptionCardPageState();
}

class _SubscriptionCardPageState extends State<SubscriptionCardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = await AuthService().getUserId();
      final provider = Provider.of<SubscriptionProvider>(context, listen: false);
      provider.fetchPlans(userId ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: "https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=800&auto=format&fit=crop",
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.4),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),
              if (provider.isLoading)
                _buildShimmerLoading()
              else if (provider.hasError)
                _buildErrorWidget(context, provider)
              else if (provider.plans.isNotEmpty)
                _buildContent(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, SubscriptionProvider provider) {
    final currentPlan = provider.plans[provider.currentPlanIndex];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
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
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                _buildGlassyButton(
                  icon: Iconsax.arrow_left_2,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => provider.setCurrentPlanIndex(index),
              itemCount: provider.plans.length,
              itemBuilder: (context, index) {
                return _buildPlanCard(provider.plans[index], index, provider);
              },
            ),
          ),
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
                    color: index == provider.currentPlanIndex ? AppColors.neonGold : Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                Text(
                  _getPlanDescription(provider.currentPlanIndex),
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, height: 1.4),
                  textAlign: TextAlign.center,
                ).animate(key: ValueKey(provider.currentPlanIndex)).fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 20),
                
                // Subscription Button Logic
                ElevatedButton(
                  onPressed: currentPlan.isActive ? null : () {
                    // Logic to open details
                    Navigator.push(context, MaterialPageRoute(builder: (context) => 
                      PremiumSubscriptionPage(
                        image: SubscriptionService.getRandomBackgroundImage(provider.currentPlanIndex),
                        plan: currentPlan,
                      )
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPlan.isActive ? Colors.grey.shade900 : AppColors.neonGold,
                    foregroundColor: currentPlan.isActive ? Colors.white54 : Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    currentPlan.isActive ? "Current Active Plan" : "Subscribe Now", 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(
                  // enabled: !currentPlan.isActive,
                  duration: 2.seconds, 
                  color: Colors.white30
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan, int index, SubscriptionProvider provider) {
    final isCurrent = index == provider.currentPlanIndex;
    final currentPrice = plan.prices.isNotEmpty ? plan.prices[0] : null;
    
    // Logic for displaying price or Free
    final bool isFree = currentPrice == null || (currentPrice.offerPrice ?? currentPrice.price) == 0;

    return AnimatedScale(
      scale: isCurrent ? 1.0 : 0.9,
      duration: 300.ms,
      curve: Curves.easeOutBack,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          // border: Border.all(
          //   color: plan.isActive ? AppColors.neonGold.withOpacity(0.8) : Colors.transparent,
          //   width: 2,
          // ),
        ),
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
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPlanIcon(plan.name),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (plan.isActive)
                               _buildSmallBadge("CURRENT", Colors.green),
                            if (plan.badge != null && !plan.isActive)
                              _buildSmallBadge(plan.badge!, AppColors.neonGold),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(plan.name, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                    Text(plan.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          isFree ? 'Free' : '₹${currentPrice.offerPrice ?? currentPrice.price}',
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)
                        ),
                        if (!isFree && currentPrice != null)
                          Text(' /${currentPrice.cycle}',
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 32),
                    ...plan.features.take(3).map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Icon(Iconsax.tick_circle, color: AppColors.neonGold, size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(feature,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
                    _buildDetailsButton(context, plan, index),
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
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildDetailsButton(BuildContext context, SubscriptionPlanModel plan, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => 
          PremiumSubscriptionPage(
            image: SubscriptionService.getRandomBackgroundImage(index),
            plan: plan,
          )
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('View all details',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanIcon(String planName) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(SubscriptionService.getIconForPlan(planName), style: const TextStyle(fontSize: 24)),
    );
  }

  Widget _buildGlassyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 150, height: 28),
                    const SizedBox(height: 8),
                    _shimmerBox(width: 100, height: 14),
                  ],
                ),
                _shimmerBox(width: 45, height: 45, isCircle: true),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(32),
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: Colors.white10),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _shimmerBox(width: double.infinity, height: 56, radius: 16),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox({required double width, required double height, double radius = 8, bool isCircle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, SubscriptionProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.danger, color: Colors.redAccent, size: 64),
          const SizedBox(height: 16),
          Text(provider.error, style: const TextStyle(color: Colors.white70)),
          TextButton(
            onPressed: () => provider.retryFetch('user123'),
            child: Text("Try Again", style: TextStyle(color: AppColors.neonGold)),
          )
        ],
      ),
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