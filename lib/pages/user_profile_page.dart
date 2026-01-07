// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dating/Theme/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';

// // First, update the Match class to include more profile details
// class Match {
//   final String id;
//   final String name;
//   final int age;
//   final String imageUrl;
//   final String location;
//   final String matchedTime;
//   final List<String> commonInterests;
//   final bool isOnline;
//   final bool hasUnreadMessage;
//   final int unreadCount;
//   final String lastMessage;
//   final String lastMessageTime;
//   final String bio;
//   final List<String> photos;
//   final String occupation;
//   final String education;
//   final String height;
//   final String relationshipType;
//   final bool isVerified;
//   final int distance;
//   final List<String> lifestyle;
//   final List<String> values;

//   Match({
//     required this.id,
//     required this.name,
//     required this.age,
//     required this.imageUrl,
//     required this.location,
//     required this.matchedTime,
//     required this.commonInterests,
//     required this.isOnline,
//     required this.hasUnreadMessage,
//     required this.unreadCount,
//     required this.lastMessage,
//     required this.lastMessageTime,
//     required this.bio,
//     required this.photos,
//     required this.occupation,
//     required this.education,
//     required this.height,
//     required this.relationshipType,
//     required this.isVerified,
//     required this.distance,
//     required this.lifestyle,
//     required this.values,
//   });
// }

// // Update your matches list with more details
// final List<Match> _matchesList = [
//   Match(
//     id: "1",
//     name: "Sophia",
//     age: 26,
//     imageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
//     location: "2 km away",
//     matchedTime: "2 hours ago",
//     commonInterests: ["Yoga", "Travel", "Coffee", "Photography"],
//     isOnline: true,
//     hasUnreadMessage: true,
//     unreadCount: 3,
//     lastMessage: "Hey! Want to grab coffee this weekend? ☕",
//     lastMessageTime: "10:24 AM",
//     bio: "Digital marketer who loves sunrise yoga and capturing beautiful moments. Coffee dates are my favorite! Looking for someone who appreciates the little things in life.",
//     photos: [
//       "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
//       "https://images.unsplash.com/photo-1517841905240-472988babdf9?fit=crop&w=800&q=80",
//       "https://images.unsplash.com/photo-1494790108755-2616b786d4d1?fit=crop&w=800&q=80",
//       "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=800&q=80",
//       "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
//     ],
//     occupation: "Digital Marketer",
//     education: "MBA, Stanford University",
//     height: "5'7\"",
//     relationshipType: "Looking for Long-term",
//     isVerified: true,
//     distance: 2,
//     lifestyle: ["Non-smoker", "Social drinker", "Vegetarian", "Fitness Enthusiast"],
//     values: ["Family-oriented", "Spiritual", "Ambitious", "Adventurous"],
//   ),
//   // ... update other matches similarly
// ];

// // User Profile Page
// class UserProfilePage extends StatefulWidget {
  
//   const UserProfilePage({super.key, });

//   @override
//   State<UserProfilePage> createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   int _selectedPhotoIndex = 0;
//   bool _isLiked = false;
//   bool _showFullBio = false;

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;
//     final primaryRed = const Color(0xFFFF3B30);
    
//     // Theme colors
//     final backgroundColor = isDarkMode ? const Color(0xFF0A0505) : const Color(0xFFFFF5F5);
//     final cardColor = isDarkMode ? Colors.white.withOpacity(0.03) : Colors.white;
//     final textColor = isDarkMode ? Colors.white : const Color(0xFF2A0707);
//     final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
//     final dividerColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             CustomScrollView(
//               slivers: [
//                 // Profile Header with Photos
//                 SliverAppBar(
//                   expandedHeight: 500,
//                   floating: false,
//                   pinned: true,
//                   backgroundColor: Colors.transparent,
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: _buildProfilePhotos(primaryRed),
//                   ),
//                   leading: _buildBackButton(primaryRed, cardColor),
//                   actions: [
//                     _buildActionButton(
//                       icon: Iconsax.more,
//                       onPressed: _showProfileOptions,
//                       color: primaryRed,
//                       bgColor: cardColor,
//                     ),
//                     const SizedBox(width: 8),
//                     _buildActionButton(
//                       icon: _isLiked ? Iconsax.heart5 : Iconsax.heart,
//                       onPressed: _toggleLike,
//                       color: _isLiked ? Colors.red : primaryRed,
//                       bgColor: cardColor,
//                     ),
//                     const SizedBox(width: 12),
//                   ],
//                 ),
                
//                 // Profile Details
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Name and Basic Info
//                         _buildBasicInfo(textColor, secondaryTextColor, primaryRed),
                        
//                         const SizedBox(height: 20),
                        
//                         // About Me Section
//                         _buildAboutSection(textColor, secondaryTextColor),
                        
//                         const SizedBox(height: 20),
                        
//                         // Photos Gallery
//                         _buildPhotosGallery(textColor),
                        
//                         const SizedBox(height: 20),
                        
//                         // Interests Section
//                         _buildInterestsSection(primaryRed, textColor),
                        
//                         const SizedBox(height: 20),
                        
//                         // Details Section
//                         _buildDetailsSection(textColor, secondaryTextColor),
                        
//                         const SizedBox(height: 20),
                        
//                         // Lifestyle & Values
//                         _buildLifestyleSection(primaryRed, textColor),
                        
//                         const SizedBox(height: 40),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
            
//             // Floating Action Buttons at Bottom
//             // Positioned(
//             //   bottom: 20,
//             //   left: 20,
//             //   right: 20,
//             //   child: _buildActionButtons(primaryRed, isDarkMode),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfilePhotos(Color primaryRed) {
//     return Stack(
//       children: [
//         // Main Photo
//         PageView.builder(
//           itemCount:_matchesList[0].photos.length,
//           onPageChanged: (index) {
//             setState(() {
//               _selectedPhotoIndex = index;
//             });
//           },
//           itemBuilder: (context, index) {
//             return CachedNetworkImage(
//               imageUrl: _matchesList[0].photos[index],
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 color: Colors.grey.shade300,
//               ),
//               errorWidget: (context, url, error) => Container(
//                 color: Colors.grey.shade300,
//                 child: const Icon(Iconsax.gallery, size: 50),
//               ),
//             );
//           },
//         ),
        
//         // Gradient Overlay at bottom
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 200,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 colors: [
//                   Colors.black.withOpacity(0.8),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//         ),
        
//         // Photo Indicator
//         Positioned(
//           bottom: 20,
//           left: 0,
//           right: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               _matchesList[0].photos.length,
//               (index) => Container(
//                 width: 8,
//                 height: 8,
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _selectedPhotoIndex == index 
//                       ? primaryRed 
//                       : Colors.white.withOpacity(0.5),
//                 ),
//               ),
//             ),
//           ),
//         ),
        
//         // Photo Count
//         Positioned(
//           bottom: 20,
//           right: 20,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.6),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 Icon(Iconsax.gallery5, size: 14, color: Colors.white),
//                 const SizedBox(width: 6),
//                 Text(
//                   '${_selectedPhotoIndex + 1}/${_matchesList[0].photos.length}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBackButton(Color primaryRed, Color bgColor) {
//     return Container(
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: bgColor,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(Iconsax.arrow_left_2, color: primaryRed),
//         onPressed: () => Navigator.pop(context),
//         padding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//     required Color color,
//     required Color bgColor,
//   }) {
//     return Container(
//       width: 44,
//       height: 44,
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: bgColor,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: color),
//         onPressed: onPressed,
//         padding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildBasicInfo(Color textColor, Color secondaryTextColor, Color primaryRed) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               '${_matchesList[0].name}, ${_matchesList[0].age}',
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: 32,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const SizedBox(width: 8),
//             if (_matchesList[0].isVerified)
//               Icon(Iconsax.verify5, color: Colors.blue, size: 24),
//           ],
//         ),
        
//         const SizedBox(height: 8),
        
//         Row(
//           children: [
//             Icon(Iconsax.location5, size: 18, color: secondaryTextColor),
//             const SizedBox(width: 6),
//             Text(
//               '${_matchesList[0].distance} km away',
//               style: TextStyle(
//                 color: secondaryTextColor,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: _matchesList[0].isOnline 
//                     ? Colors.green.withOpacity(0.2)
//                     : Colors.grey.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 8,
//                     height: 8,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _matchesList[0].isOnline ? Colors.green : Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     _matchesList[0].isOnline ? 'Online Now' : 'Offline',
//                     style: TextStyle(
//                       color: _matchesList[0].isOnline ? Colors.green : secondaryTextColor,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
        
//         const SizedBox(height: 12),
        
//         Row(
//           children: [
//             _buildInfoChip(
//               icon: Iconsax.briefcase,
//               text: _matchesList[0].occupation,
//               color: primaryRed,
//             ),
//             const SizedBox(width: 12),
//             _buildInfoChip(
//               icon: Iconsax.book,
//               text: _matchesList[0].education,
//               color: primaryRed,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoChip({required IconData icon, required String text, required Color color}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               color: color,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAboutSection(Color textColor, Color secondaryTextColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'About Me',
//           style: TextStyle(
//             color: textColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           _matchesList[0].bio,
//           style: TextStyle(
//             color: secondaryTextColor,
//             fontSize: 15,
//             height: 1.5,
//           ),
//           maxLines: _showFullBio ? null : 4,
//           overflow: _showFullBio ? null : TextOverflow.ellipsis,
//         ),
//         if (!_showFullBio)
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _showFullBio = true;
//               });
//             },
//             style: TextButton.styleFrom(
//               padding: EdgeInsets.zero,
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             ),
//             child: Text(
//               'Read more',
//               style: TextStyle(
//                 color: const Color(0xFFFF3B30),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildPhotosGallery(Color textColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Photos',
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             Text(
//               '${_matchesList[0].photos.length}',
//               style: TextStyle(
//                 color: textColor.withOpacity(0.7),
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 100,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _matchesList[0].photos.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedPhotoIndex = index;
//                   });
//                   // Scroll to photo section
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   margin: EdgeInsets.only(right: index == _matchesList[0].photos.length - 1 ? 0 : 12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     image: DecorationImage(
//                       image: CachedNetworkImageProvider(_matchesList[0].photos[index]),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: _selectedPhotoIndex == index 
//                           ? const Color(0xFFFF3B30) 
//                           : Colors.transparent,
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInterestsSection(Color primaryRed, Color textColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Interests',
//           style: TextStyle(
//             color: textColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: _matchesList[0].commonInterests.map((interest) {
//             return Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 color: primaryRed.withOpacity(0.01),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: primaryRed.withOpacity(0.1),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     _getInterestIcon(interest),
//                     size: 16,
//                     color: primaryRed,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     interest,
//                     style: TextStyle(
//                       color: primaryRed,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   IconData _getInterestIcon(String interest) {
//     final Map<String, IconData> iconMap = {
//       'Yoga': Iconsax.activity,
//       'Travel': Iconsax.airplane,
//       'Coffee': Iconsax.coffee,
//       'Photography': Iconsax.camera,
//       'Art': Iconsax.paintbucket,
//       'Music': Iconsax.music,
//       'Reading': Iconsax.book_1,
//       'Hiking': Iconsax.hashtag_up,
//       // Add more mappings as needed
//     };
//     return iconMap[interest] ?? Iconsax.heart;
//   }

//   Widget _buildDetailsSection(Color textColor, Color secondaryTextColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Details',
//           style: TextStyle(
//             color: textColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildDetailRow('Height', _matchesList[0].height, Iconsax.rulerpen, textColor, secondaryTextColor),
//         _buildDetailRow('Relationship', _matchesList[0].relationshipType, Iconsax.heart, textColor, secondaryTextColor),
//         _buildDetailRow('Education', _matchesList[0].education, Iconsax.book, textColor, secondaryTextColor),
//         _buildDetailRow('Occupation', _matchesList[0].occupation, Iconsax.briefcase, textColor, secondaryTextColor),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String label, String value, IconData icon, Color textColor, Color secondaryTextColor) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: secondaryTextColor),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: secondaryTextColor,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: textColor,
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLifestyleSection(Color primaryRed, Color textColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Lifestyle & Values',
//           style: TextStyle(
//             color: textColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 12),
        
//         // Lifestyle
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Lifestyle',
//               style: TextStyle(
//                 color: textColor.withOpacity(0.8),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: _matchesList[0].lifestyle.map((item) {
//                 return Chip(
//                   label: Text(
//                     item,
//                     style: TextStyle(
//                       color: primaryRed,
//                       fontSize: 13,
//                     ),
//                   ), 
              
//                   backgroundColor:primaryRed.withOpacity(0.00),
//                   side: BorderSide(
//  color: primaryRed.withOpacity(0.1),                    width: 1,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
        
//         const SizedBox(height: 16),
        
//         // // Values
//         // Column(
//         //   crossAxisAlignment: CrossAxisAlignment.start,
//         //   children: [
//         //     Text(
//         //       'Values',
//         //       style: TextStyle(
//         //         color: textColor.withOpacity(0.8),
//         //         fontSize: 16,
//         //         fontWeight: FontWeight.w600,
//         //       ),
//         //     ),
//         //     const SizedBox(height: 8),
//         //     Wrap(
//         //       spacing: 8,
//         //       runSpacing: 8,
//         //       children: _matchesList[0].values.map((value) {
//         //         return Chip(
//         //           label: Text(
//         //             value,
//         //             style: TextStyle(
//         //               color: Colors.purple.shade700,
//         //               fontSize: 13,
//         //             ),
//         //           ),
//         //           backgroundColor: Colors.purple.shade50,
//         //           side: BorderSide(
//         //             color: Colors.purple.shade100,
//         //             width: 1,
//         //           ),
//         //           shape: RoundedRectangleBorder(
//         //             borderRadius: BorderRadius.circular(20),
//         //           ),
//         //         );
//         //       }).toList(),
//         //     ),
//         //   ],
//         // ),
//       ],
//     );
//   }

//   // Widget _buildActionButtons(Color primaryRed, bool isDarkMode) {
//   //   return Container(
//   //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//   //     decoration: BoxDecoration(
//   //       color: isDarkMode ? const Color(0xFF1A0A0A) : Colors.white,
//   //       borderRadius: BorderRadius.circular(25),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black.withOpacity(0.1),
//   //           blurRadius: 20,
//   //           spreadRadius: 5,
//   //         ),
//   //       ],
//   //     ),
//   //     child: Row(
//   //       children: [
//   //         Expanded(
//   //           child: _buildProfileActionButton(
//   //             icon: Iconsax.close_circle,
//   //             label: 'Pass',
//   //             color: Colors.red.shade700,
//   //             onPressed: _passProfile,
//   //           ),
//   //         ),
//   //         const SizedBox(width: 20),
//   //         Expanded(
//   //           child: _buildProfileActionButton(
//   //             icon: Iconsax.heart5,
//   //             label: 'Like',
//   //             color: Colors.green.shade700,
//   //             onPressed: _likeProfile,
//   //             isGradient: true,
//   //           ),
//   //         ),
//   //         const SizedBox(width: 20),
//   //         Expanded(
//   //           child: _buildProfileActionButton(
//   //             icon: Iconsax.message,
//   //             label: 'Chat',
//   //             color: primaryRed,
//   //             onPressed: _startChat,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildProfileActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//     bool isGradient = false,
//   }) {
//     return Column(
//       children: [
//         Container(
//           width: 56,
//           height: 56,
//           decoration: BoxDecoration(
//             color: isGradient ? null : color.withOpacity(0.1),
//             gradient: isGradient
//                 ? LinearGradient(
//                     colors: [color, Colors.green.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   )
//                 : null,
//             shape: BoxShape.circle,
//             boxShadow: isGradient
//                 ? [
//                     BoxShadow(
//                       color: color.withOpacity(0.3),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Material(
//             color: Colors.transparent,
//             shape: const CircleBorder(),
//             child: InkWell(
//               customBorder: const CircleBorder(),
//               onTap: onPressed,
//               splashColor: color.withOpacity(0.2),
//               child: Icon(
//                 icon,
//                 color: isGradient ? Colors.white : color,
//                 size: 24,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: TextStyle(
//             color: color,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   void _toggleLike() {
//     setState(() {
//       _isLiked = !_isLiked;
//     });
    
//     // Show animation or snackbar
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           _isLiked 
//               ? '❤️ Added ${_matchesList[0].name} to your favorites'
//               : 'Removed ${_matchesList[0].name} from favorites',
//         ),
//         backgroundColor: _isLiked ? Colors.green : Colors.grey,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _showProfileOptions() {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primaryRed = const Color(0xFFFF3B30);
    
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 12),
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildProfileOption('Report Profile', Iconsax.warning_2, Colors.red),
//             _buildProfileOption('Block User', Iconsax.profile_remove, Colors.orange),
//             _buildProfileOption('Share Profile', Iconsax.share),
//             // _buildProfileOption('View All Photos', Iconsax.gallery),
//             const SizedBox(height: 20),
//             Container(
//               height: 1,
//               color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryRed,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: const Text('Close'),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   ListTile _buildProfileOption(String title, IconData icon, [Color? color]) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primaryRed = const Color(0xFFFF3B30);
    
//     return ListTile(
//       leading: Icon(icon, color: color ?? primaryRed),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isDark ? Colors.white : Colors.black87,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       trailing: Icon(Iconsax.arrow_right_3, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
//       onTap: () {
//         Navigator.pop(context);
//         // Handle option selection
//       },
//       contentPadding: const EdgeInsets.symmetric(horizontal: 24),
//     );
//   }

//   void _passProfile() {
//     Navigator.pop(context);
//     // Add logic to pass on this profile
//   }

//   void _likeProfile() {
//     setState(() {
//       _isLiked = true;
//     });
    
//     // Show success animation
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.green.withOpacity(0.3),
//                     blurRadius: 20,
//                     spreadRadius: 5,
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Iconsax.heart5,
//                 color: Colors.white,
//                 size: 50,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'You liked ${_matchesList[0].name}!',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
    
//     Future.delayed(const Duration(seconds: 1), () {
//       Navigator.pop(context);
//       Navigator.pop(context); // Go back to matches page
//     });
//   }

//   void _startChat() {
//     // Navigate to chat page or show chat interface
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Start chat with ${_matchesList[0].name}'),
//         content: const Text('This would open the chat interface'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Navigate to actual chat page
//             },
//             child: const Text('Start Chat'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Update the _openMatchProfile function in MatchesPage to navigate to UserProfilePage
// void _openMatchProfile(BuildContext context, Match match) {
//   // Navigator.push(
//   //   context,
//   //   MaterialPageRoute(
//   //     builder: (context) => UserProfilePage(match: match),
//   //   ),
//   // );
// }

// // Update the _buildMatchCard function in MatchesPage
// Widget _buildMatchCard(Match match, Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed ,BuildContext context) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 16),
//     decoration: BoxDecoration(
//       color: cardColor,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10,
//           spreadRadius: 2,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Material(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(20),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () => _openMatchProfile(context, match), // Updated this line
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile Image with Online Indicator
//               Stack(
//                 children: [
//                   Container(
//                     width: 70,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: primaryRed.withOpacity(0.3),
//                         width: 2,
//                       ),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(35),
//                       child: CachedNetworkImage(
//                         imageUrl: match.imageUrl,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => Container(
//                           color: secondaryTextColor.withOpacity(0.1),
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (match.isOnline)
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: cardColor,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
              
//               const SizedBox(width: 16),
              
//               // Match Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Name and Age with verified badge
//                     Row(
//                       children: [
//                         Text(
//                           match.name,
//                           style: TextStyle(
//                             color: textColor,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${match.age}',
//                           style: TextStyle(
//                             color: secondaryTextColor,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         if (match.isVerified)
//                           const SizedBox(width: 4),
//                         if (match.isVerified)
//                           Icon(Iconsax.verify5, color: Colors.blue, size: 16),
//                         const Spacer(),
//                         Text(
//                           match.matchedTime,
//                           style: TextStyle(
//                             color: secondaryTextColor.withOpacity(0.7),
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
                    
//                     const SizedBox(height: 4),
                    
//                     // Location
//                     Row(
//                       children: [
//                         Icon(Iconsax.location5, size: 14, color: secondaryTextColor),
//                         const SizedBox(width: 4),
//                         Text(
//                           match.location,
//                           style: TextStyle(
//                             color: secondaryTextColor,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
                    
//                     const SizedBox(height: 8),
                    
//                     // Common Interests
//                     Wrap(
//                       spacing: 6,
//                       runSpacing: 6,
//                       children: match.commonInterests.take(3).map((interest) {
//                         return Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: primaryRed.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             interest,
//                             style: TextStyle(
//                               color: primaryRed,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
                    
//                     const SizedBox(height: 8),
                    
//                     // Action Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () => 
                            
//                             _openMatchProfile(context, match),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryRed,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Iconsax.eye, size: 16),
//                                 SizedBox(width: 6),
//                                 Text('View Profile'),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Container(
//                           width: 44,
//                           height: 44,
//                           decoration: BoxDecoration(
//                             color: cardColor,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               width: 1,
//                               color: secondaryTextColor.withOpacity(0.3),
//                             ),
//                           ),
//                           child: IconButton(
//                             icon: Icon(
//                               Iconsax.message,
//                               size: 20,
//                               color: primaryRed,
//                             ),
//                             onPressed: () => null,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

// --- THEME CONSTANTS (Reused) ---
const Color kEliteGold = Color(0xFFFFD166);
const Color kCardDark = Color(0xFF1E1E1E);
const Color kBgDark = Color(0xFF0F0F0F);

// --- DUMMY DATA FOR THIS PAGE ---
// We create a static dummy profile here so you don't need navigation arguments to test it.
final Map<String, dynamic> dummyProfileData = {
  'name': 'Isabella',
  'age': 24,
  'location': 'New York, USA',
  'bio':
      'Art lover, coffee enthusiast, and spontaneous traveler. Looking for someone who appreciates the finer things in life. Let\'s make memories that last forever.',
  'mainImage':
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
  'isVerified': true,
  'isOnline': true,
  'rate': '150',
  'interests': ['Travel', 'Fine Dining', 'Art', 'Fashion', 'Music'],
  'publicPhotos': [
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
  ],
  // These will be blurred
  'privatePhotos': [
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?auto=format&fit=crop&w=800&q=80',
  ]
};

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  // Simulating User Status (Change to true to see unblurred images)
  bool isPremiumUser = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? kBgDark : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. SLIVER APP BAR (Main Image)
          _buildSliverAppBar(context),

          // 2. CONTENT BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  _buildHeaderInfo(textColor),

                  const SizedBox(height: 20),

                  // Action Buttons (Chat, Call, Video)
                  _buildActionButtons(isDark),

                  const SizedBox(height: 25),

                  // Bio Section
                  Text(
                    "About Me",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dummyProfileData['bio'],
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey[700],
                        height: 1.5,
                        fontSize: 14),
                  ),

                  const SizedBox(height: 25),

                  // Interests
                  Text(
                    "Interests",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (dummyProfileData['interests'] as List<String>)
                        .map((tag) => _buildInterestChip(tag, isDark))
                        .toList(),
                  ),

                  const SizedBox(height: 30),

                  // --- PUBLIC GALLERY ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Gallery",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text("See all",
                          style: TextStyle(color: kEliteGold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildPublicGallery(),

                  const SizedBox(height: 30),

                  // --- PRIVATE GALLERY (BLURRED) ---
                  Row(
                    children: [
                      const Icon(Iconsax.lock5, color: kEliteGold, size: 20),
                      const SizedBox(width: 8),
                      Text("Private Album",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      if (!isPremiumUser)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: kEliteGold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text("PREMIUM",
                              style: TextStyle(
                                  color: kEliteGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildPrivateGallery(),
                  
                  // Bottom Spacer
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Floating Booking Button
      bottomSheet: Container(
        color: isDark ? kBgDark : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kEliteGold,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              shadowColor: kEliteGold.withOpacity(0.4),
            ),
            child: const Text("Book Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      backgroundColor: kBgDark,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
             padding: const EdgeInsets.all(8),
             decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
            child: const Icon(Iconsax.more, color: Colors.white)),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: dummyProfileData['mainImage'],
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    kBgDark.withOpacity(0.2),
                    kBgDark,
                  ],
                  stops: const [0.6, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Name and Age
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${dummyProfileData['name']}, ${dummyProfileData['age']}",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 8),
                    if (dummyProfileData['isVerified'])
                      const Icon(Iconsax.verify5, color: Colors.blue, size: 22),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Iconsax.location,
                        color: textColor.withOpacity(0.6), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      dummyProfileData['location'],
                      style: TextStyle(
                          color: textColor.withOpacity(0.6), fontSize: 14),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          color: dummyProfileData['isOnline']
                              ? Colors.green
                              : Colors.grey,
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      dummyProfileData['isOnline'] ? "Online" : "Offline",
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            // Rate Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kCardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kEliteGold.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text("\$${dummyProfileData['rate']}",
                      style: const TextStyle(
                          color: kEliteGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const Text("/hr",
                      style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButtonIcon(Iconsax.message, "Chat", Colors.white, Colors.blue),
        _buildActionButtonIcon(Iconsax.call, "Call", Colors.black, kEliteGold), // Prominent
        _buildActionButtonIcon(Iconsax.video, "Video", Colors.white, Colors.purple),
      ],
    );
  }

  Widget _buildActionButtonIcon(
      IconData icon, String label, Color iconColor, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: bgColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack);
  }

  Widget _buildInterestChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87, fontSize: 12),
      ),
    );
  }

  Widget _buildPublicGallery() {
    final photos = dummyProfileData['publicPhotos'] as List<String>;
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: CachedNetworkImageProvider(photos[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrivateGallery() {
    final photos = dummyProfileData['privatePhotos'] as List<String>;
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (!isPremiumUser) {
                _showPremiumBottomSheet(context);
              } else {
                // Open Full Screen Viewer
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // Only load image if premium, otherwise minimal or placeholder to save bandwidth (optional)
                // For effect, we load and blur
                color: kCardDark,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // The Image
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: isPremiumUser ? 0 : 15, // BLUR LOGIC
                        sigmaY: isPremiumUser ? 0 : 15,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: photos[index],
                        fit: BoxFit.cover,
                      ),
                    ),

                    // The Lock Overlay (if not premium)
                    if (!isPremiumUser)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: kEliteGold.withOpacity(0.5))),
                                child: const Icon(Iconsax.lock5,
                                    color: kEliteGold, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- PREMIUM BOTTOM SHEET ---
  void _showPremiumBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Color(0xFF151515),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  color: kEliteGold,
                  blurRadius: 20,
                  offset: Offset(0, -5),
                  spreadRadius: -15)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 25),
              
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kEliteGold.withOpacity(0.1),
                ),
                child: const Icon(Iconsax.crown_1, color: kEliteGold, size: 50),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1000.ms),

              const SizedBox(height: 20),
              
              const Text(
                "Unlock Private Photos",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Get Elite Membership to view private albums, unlimited messages, and access contact details.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              
              const SizedBox(height: 30),

              // Feature List
              _buildFeatureRow("View Hidden Galleries"),
              _buildFeatureRow("Direct Contact Access"),
              _buildFeatureRow("Video Call Enabled"),

              const SizedBox(height: 30),

              // Subscribe Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Add your payment logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kEliteGold,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    "Get Premium - ${9.99}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Maybe Later", style: TextStyle(color: Colors.grey))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: kEliteGold, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}