// import 'dart:ui';
// import 'package:dating/main.dart';
// import 'package:dating/models/profile_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class ProfileDetailsPage extends StatefulWidget {
//   final Profile profiledata;

//   const ProfileDetailsPage({super.key, required this.profiledata});

//   @override
//   State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
// }

// class _ProfileDetailsPageState extends State<ProfileDetailsPage> with TickerProviderStateMixin {
//   final ScrollController _mainScrollController = ScrollController();
//   final CarouselSliderController _carouselController = CarouselSliderController();
//   int _currentImageIndex = 0;

//   // Helper to calculate age from DOB string
//   String _calculateAge(String? dob) {
//     if (dob == null || dob.isEmpty) return "24"; // Default
//     try {
//       DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
//       DateTime today = DateTime.now();
//       int age = today.year - birthDate.year;
//       if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
//         age--;
//       }
//       return age.toString();
//     } catch (e) {
//       return "24";
//     }
//   }

//   @override
//   void dispose() {
//     _mainScrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.deepBlack,
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           CustomScrollView(
//             controller: _mainScrollController,
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildModernHeader(),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 25),
//                       _buildMainBioSection(),
//                       const SizedBox(height: 30),
//                       _buildQuickInfoGrid(),
//                       const SizedBox(height: 30),
//                       _buildLifestylesSection(),
//                       const SizedBox(height: 30),
//                       _buildInterestsSection(),
//                       const SizedBox(height: 30),
//                       _buildGallerySection(),
//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Floating action buttons overlay
//         ],
//       ),
//     );
//   }

//   // ========== UPDATED GALLERY SECTION WITH HORIZONTAL CAROUSEL ==========
//   Widget _buildGallerySection() {
//     if (widget.profiledata.photos.isEmpty) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("MY MOMENTS", 
//               style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
//             Row(
//               children: [
//                 Text("${_currentImageIndex + 1}", 
//                   style: const TextStyle(color: AppColors.neonGold, fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text("/${widget.profiledata.photos.length}", 
//                   style: const TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w500)),
//                 const SizedBox(width: 8),
//                 const Icon(Iconsax.gallery, color: AppColors.neonGold, size: 16),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
        
//         // Horizontal Carousel
//         CarouselSlider.builder(
//           carouselController: _carouselController,
//           options: CarouselOptions(
//             height: 400,
//             viewportFraction: 0.88,
//             enlargeCenterPage: true,
//             enlargeFactor: 0.2,
//             autoPlay: false,
//             enableInfiniteScroll: false,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _currentImageIndex = index;
//               });
//             },
//             scrollPhysics: const BouncingScrollPhysics(),
//           ),
//           itemCount: widget.profiledata.photos.length,
//           itemBuilder: (context, index, realIndex) {
//             return _buildPhotoCard(widget.profiledata.photos[index], index);
//           },
//         ),
        
//         // Dots indicator
//         const SizedBox(height: 20),
//         Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: widget.profiledata.photos.asMap().entries.map((entry) {
//               return GestureDetector(
//                 onTap: () => _carouselController.animateToPage(entry.key),
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _currentImageIndex == entry.key 
//                       ? AppColors.neonGold 
//                       : Colors.white.withOpacity(0.3),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
        
//         // Social tags
//       ],
//     );
//   }

//   Widget _buildPhotoCard(String imageUrl, int index) {
//     // Dynamic tags for each photo
//     final List<List<String>> tagsList = [
//       ["#WeekendVibe", "#Explore"],
//       ["#Sunset", "#Mood"],
//       ["#Adventure", "#Nature"],
//       ["#CityLife", "#Style"],
//       ["#BeachDay", "#Relax"],
//     ];
    
//     final List<String> captions = [
//       "Golden hour adventures ✨",
//       "Chasing sunsets & dreams",
//       "Exploring new horizons",
//       "Urban vibes only",
//       "Beach days are the best days",
//     ];

//     final tags = tagsList[index % tagsList.length];
    
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 20,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Main Image
//             Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Container(
//                   color: AppColors.cardBlack,
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                           : null,
//                       color: AppColors.neonGold,
//                     ),
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) => Container(
//                 color: AppColors.cardBlack,
//                 child: const Icon(Iconsax.gallery_slash, color: Colors.white38, size: 50),
//               ),
//             ),
            
//             // Gradient overlay
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                   stops: const [0.6, 1],
//                 ),
//               ),
//             ),
            
//             // Content overlay
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Tags
//                     Wrap(
//                       spacing: 8,
//                       children: tags.map((tag) => Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: AppColors.neonGold.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
//                         ),
//                         child: Text(
//                           tag,
//                           style: const TextStyle(
//                             color: AppColors.neonGold,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       )).toList(),
//                     ),
                    
//                     const SizedBox(height: 12),
                    
//                     // Caption
//                     Text(
//                       captions[index % captions.length],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         height: 1.4,
//                       ),
//                     ),
                    
//                     // Photo counter
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         const Icon(Iconsax.camera, color: Colors.white38, size: 12),
//                         const SizedBox(width: 6),
//                         Text(
//                           "Photo ${index + 1} of ${widget.profiledata.photos.length}",
//                           style: const TextStyle(
//                             color: Colors.white38,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             // Like button on top right
//             Positioned(
//               top: 15,
//               right: 15,
//               child: GestureDetector(
//                 onTap: () {
//                   // Add like functionality
//                 },
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                   ),
//                   child: const Icon(
//                     Iconsax.heart,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

 




//   // ========== INTERESTS SECTION ==========
//   Widget _buildInterestsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("INTERESTS & VIBES", 
//           style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
//         const SizedBox(height: 15),
//         Wrap(
//           spacing: 8,
//           runSpacing: 10,
//           children: widget.profiledata.interests.map((interest) => Container(
//             padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
//             decoration: BoxDecoration(
//               color: AppColors.cardBlack,
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Emoji Circle
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: AppColors.neonGold.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(interest.emoji, style: const TextStyle(fontSize: 14)),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   interest.name, 
//                   style: const TextStyle(
//                     color: Colors.white, 
//                     fontSize: 13, 
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: -0.2
//                   )
//                 ),
//               ],
//             ),
//           )).toList(),
//         ),
//       ],
//     );
//   }

//   // ========== LIFESTYLE SECTION ==========
//   Widget _buildLifestylesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("LIFESTYLE HABITS", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
//         const SizedBox(height: 15),
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: [
//             _lifestyleChip("🚬", "Smoking", widget.profiledata.smokingHabit ?? "Non-smoker"),
//             _lifestyleChip("🍻", "Drinking", widget.profiledata.drinkingHabit ?? "Social Drinker"),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _lifestyleChip(String emoji, String category, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: AppColors.cardBlack,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 18)),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(category, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ========== QUICK INFO GRID ==========
//   Widget _buildQuickInfoGrid() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("PERSONAL STATS", 
//           style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
//         const SizedBox(height: 15),
//         Container(
//           padding: const EdgeInsets.all(2), // Space for gradient border effect
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             gradient: LinearGradient(
//               colors: [AppColors.neonGold.withOpacity(0.2), Colors.transparent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: AppColors.cardBlack,
//               borderRadius: BorderRadius.circular(22),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(child: _infoTile(Iconsax.briefcase, widget.profiledata.job ?? "Professional", "Job")),
//                     Container(height: 40, width: 1, color: Colors.white10), // Vertical Divider
//                     Expanded(child: _infoTile(Iconsax.teacher, widget.profiledata.education.name, "Education")),
//                   ],
//                 ),
//                 const Divider(color: Colors.white10, height: 40),
//                 Row(
//                   children: [
//                     Expanded(child: _infoTile(Iconsax.ruler, "${widget.profiledata.height ?? '175'} cm", "Height")),
//                     Container(height: 40, width: 1, color: Colors.white10), // Vertical Divider
//                     Expanded(child: _infoTile(Iconsax.location, widget.profiledata.city ?? "Unknown", "City")),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _infoTile(IconData icon, String title, String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Icon(icon, color: AppColors.neonGold.withOpacity(0.8), size: 22),
//         const SizedBox(height: 8),
//         Text(title, 
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//         Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w600)),
//       ],
//     );
//   }

//   // ========== MODERN HEADER ==========
//   Widget _buildModernHeader() {
//     return SliverAppBar(
//       expandedHeight: MediaQuery.of(context).size.height * 0.55,
//       automaticallyImplyLeading: false,
//       pinned: true,
//       stretch: true,
//       backgroundColor: AppColors.deepBlack,
//       flexibleSpace: FlexibleSpaceBar(
//         stretchModes: const [StretchMode.zoomBackground],
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.network(
//               widget.profiledata.photo,
//               fit: BoxFit.cover,
//             ),
//             // High-end Gradient
//               Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.yellow.withOpacity(0.3),
//                     Colors.transparent,
//                                         Colors.transparent,

//                     // Colors.yellow.withOpacity(0.4),
//                     // Colors.yellow.withOpacity(0.4),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.4),
//                     Colors.transparent,
//                     AppColors.deepBlack.withOpacity(0.8),
//                     AppColors.deepBlack,
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       leadingWidth: 70,
//       leading: _buildCircleAction(Iconsax.arrow_left_2, () => Navigator.pop(context)),
//       actions: [
//         _buildCircleAction(Iconsax.share, () {}),
//         const SizedBox(width: 10),
//         _buildCircleAction(Iconsax.more, () {}),
//         const SizedBox(width: 20),
//       ],
//     );
//   }

//   // ========== STATUS BADGE ==========
//   Widget _buildStatusBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.greenAccent.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.greenAccent.withOpacity(0.4), width: 0.5),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 6,
//             height: 6,
//             decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 6),
//           const Text(
//             "ACTIVE NOW",
//             style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
//           ),
//         ],
//       ),
//     );
//   }

//   // ========== MAIN BIO SECTION ==========
//   Widget _buildMainBioSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildStatusBadge(),
//         const SizedBox(height: 12),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               widget.profiledata.userName,
//               style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               _calculateAge(widget.profiledata.dateOfBirth),
//               style: TextStyle(color: AppColors.neonGold.withOpacity(0.8), fontSize: 28, fontWeight: FontWeight.w300),
//             ),
//             const SizedBox(width: 10),
//             const Icon(Iconsax.verify5, color: AppColors.neonGold, size: 26),
//           ],
//         ),
//         const SizedBox(height: 15),
//         Text(
//           widget.profiledata.bio ?? "No bio provided yet.",
//           style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15, height: 1.6, fontWeight: FontWeight.w400),
//         ),
//       ],
//     );
//   }

//   // ========== CIRCLE ACTION BUTTONS ==========
//   Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         width: 45,
//         height: 45,
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.4),
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.white.withOpacity(0.1)),
//         ),
//         child: Icon(icon, color: Colors.white, size: 20),
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:dating/main.dart'; // Ensure AppColors are defined here
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProfileDetailsPage extends StatefulWidget {
  final Profile profiledata;

  const ProfileDetailsPage({super.key, required this.profiledata});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> with TickerProviderStateMixin {
  final ScrollController _mainScrollController = ScrollController();
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentImageIndex = 0;

  // Helper to calculate age
  String _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return "24";
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return "24";
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. FIXED BACKGROUND IMAGE
          Positioned.fill(
            child: Image.network(
              widget.profiledata.photo,
              fit: BoxFit.cover,
            ),
          ),

          // 2. BLUR LAYER (The Glass Feeling)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                color: Colors.black.withOpacity(0.55), // Darken the blur
              ),
            ),
          ),

          // 3. SCROLLABLE CONTENT
          CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildModernHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      _buildMainBioSection(),
                      const SizedBox(height: 30),
                      _buildQuickInfoGrid(),
                      const SizedBox(height: 30),
                      _buildLifestylesSection(),
                      const SizedBox(height: 30),
                      _buildInterestsSection(),
                      const SizedBox(height: 30),
                      _buildGallerySection(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Floating Action Bar could be added here
        ],
      ),
    );
  }

  // ========== MODERN HEADER (TOP IMAGE) ==========
  Widget _buildModernHeader() {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.55,
      automaticallyImplyLeading: false,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent, // Keeps it glassy
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // The main sharp image at top
            Image.network(
              widget.profiledata.photo,
              fit: BoxFit.cover,
            ),
            // Gradient to blend sharp image into blurred background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8), // Blends into the body blur
                  ],
                  stops: const [0, 0.4, 0.7, 1],
                ),
              ),
            ),
          ],
        ),
      ),
      leadingWidth: 75,
      leading: _buildCircleAction(Iconsax.arrow_left_2, () => Navigator.pop(context)),
      actions: [
        _buildCircleAction(Iconsax.share, () {}),
        const SizedBox(width: 10),
        _buildCircleAction(Iconsax.more, () {}),
        const SizedBox(width: 20),
      ],
    );
  }

  // ========== MAIN BIO SECTION ==========
  Widget _buildMainBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBadge(),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.profiledata.userName,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
            ),
            const SizedBox(width: 10),
            Text(
              _calculateAge(widget.profiledata.dateOfBirth),
              style: TextStyle(color: AppColors.neonGold.withOpacity(0.9), fontSize: 28, fontWeight: FontWeight.w300),
            ),
            const SizedBox(width: 10),
            const Icon(Iconsax.verify5, color: AppColors.neonGold, size: 26),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          widget.profiledata.bio ?? "No bio provided yet.",
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, height: 1.6, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  // ========== QUICK INFO GRID (GLASS STYLE) ==========
  Widget _buildQuickInfoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PERSONAL STATS", 
          style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07), // Translucent white
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)), // Glass border
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _infoTile(Iconsax.briefcase, widget.profiledata.job ?? "Professional", "Job")),
                  Container(height: 40, width: 1, color: Colors.white10),
                  Expanded(child: _infoTile(Iconsax.teacher, widget.profiledata.education.name, "Education")),
                ],
              ),
              const Divider(color: Colors.white10, height: 40),
              Row(
                children: [
                  Expanded(child: _infoTile(Iconsax.ruler, "${widget.profiledata.height ?? '175'} cm", "Height")),
                  Container(height: 40, width: 1, color: Colors.white10),
                  Expanded(child: _infoTile(Iconsax.location, widget.profiledata.city ?? "Unknown", "City")),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.neonGold.withOpacity(0.9), size: 22),
        const SizedBox(height: 8),
        Text(title, 
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ========== LIFESTYLE SECTION (GLASS STYLE) ==========
  Widget _buildLifestylesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("LIFESTYLE HABITS", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _lifestyleChip("🚬", "Smoking", widget.profiledata.smokingHabit ?? "Non-smoker"),
            _lifestyleChip("🍻", "Drinking", widget.profiledata.drinkingHabit ?? "Social Drinker"),
          ],
        ),
      ],
    );
  }

  Widget _lifestyleChip(String emoji, String category, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.w700)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // ========== INTERESTS SECTION (GLASS STYLE) ==========
  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("INTERESTS & VIBES", 
          style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: widget.profiledata.interests.map((interest) => Container(
            padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(interest.emoji, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 10),
                Text(
                  interest.name, 
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  // ========== GALLERY SECTION ==========
  Widget _buildGallerySection() {
    if (widget.profiledata.photos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("MY MOMENTS", 
              style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
            Row(
              children: [
                Text("${_currentImageIndex + 1}", 
                  style: const TextStyle(color: AppColors.neonGold, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("/${widget.profiledata.photos.length}", 
                  style: const TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        CarouselSlider.builder(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 420,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) => setState(() => _currentImageIndex = index),
          ),
          itemCount: widget.profiledata.photos.length,
          itemBuilder: (context, index, realIndex) => _buildPhotoCard(widget.profiledata.photos[index], index),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(String imageUrl, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  stops: const [0.6, 1],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Moment ${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Iconsax.camera, color: AppColors.neonGold, size: 14),
                      SizedBox(width: 6),
                      Text("Shot on iPhone", style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== HELPERS ==========
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
          SizedBox(width: 6),
          Text("ACTIVE NOW", style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}