// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:dating/Theme/theme_provider.dart';
// // import 'package:dating/pages/user_profile_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:provider/provider.dart';

// // class Match {
// //   final String id;
// //   final String name;
// //   final int age;
// //   final String imageUrl;
// //   final String location;
// //   final String matchedTime; // "2 days ago", "1 hour ago", etc.
// //   final List<String> commonInterests;
// //   final bool isOnline;
// //   final bool hasUnreadMessage;
// //   final int unreadCount;
// //   final String lastMessage;
// //   final String lastMessageTime;

// //   Match({
// //     required this.id,
// //     required this.name,
// //     required this.age,
// //     required this.imageUrl,
// //     required this.location,
// //     required this.matchedTime,
// //     required this.commonInterests,
// //     required this.isOnline,
// //     required this.hasUnreadMessage,
// //     required this.unreadCount,
// //     required this.lastMessage,
// //     required this.lastMessageTime,
// //   });
// // }

// // final List<Match> _matchesList = [
// //   Match(
// //     id: "1",
// //     name: "Sophia",
// //     age: 26,
// //     imageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
// //     location: "2 km away",
// //     matchedTime: "2 hours ago",
// //     commonInterests: ["Yoga", "Travel", "Coffee"],
// //     isOnline: true,
// //     hasUnreadMessage: true,
// //     unreadCount: 3,
// //     lastMessage: "Hey! Want to grab coffee this weekend? ☕",
// //     lastMessageTime: "10:24 AM",
// //   ),
// //   Match(
// //     id: "2",
// //     name: "Emma",
// //     age: 24,
// //     imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?fit=crop&w=800&q=80",
// //     location: "4 km away",
// //     matchedTime: "1 day ago",
// //     commonInterests: ["Art", "Hiking", "Music"],
// //     isOnline: false,
// //     hasUnreadMessage: false,
// //     unreadCount: 0,
// //     lastMessage: "That museum exhibit sounds amazing!",
// //     lastMessageTime: "Yesterday",
// //   ),
// //   Match(
// //     id: "3",
// //     name: "Mia",
// //     age: 25,
// //     imageUrl: "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
// //     location: "3 km away",
// //     matchedTime: "3 days ago",
// //     commonInterests: ["Wine", "Writing", "Music"],
// //     isOnline: true,
// //     hasUnreadMessage: true,
// //     unreadCount: 1,
// //     lastMessage: "What's your favorite playlist?",
// //     lastMessageTime: "9:15 AM",
// //   ),
// //   Match(
// //     id: "4",
// //     name: "Amelia",
// //     age: 26,
// //     imageUrl: "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?fit=crop&w=800&q=80",
// //     location: "4 km away",
// //     matchedTime: "1 week ago",
// //     commonInterests: ["Travel", "Photography", "Food"],
// //     isOnline: false,
// //     hasUnreadMessage: false,
// //     unreadCount: 0,
// //     lastMessage: "The sunset photos were incredible!",
// //     lastMessageTime: "3 days ago",
// //   ),
// //   Match(
// //     id: "5",
// //     name: "Harper",
// //     age: 27,
// //     imageUrl: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?fit=crop&w=800&q=80",
// //     location: "3 km away",
// //     matchedTime: "2 weeks ago",
// //     commonInterests: ["Fitness", "Reading", "Wine"],
// //     isOnline: true,
// //     hasUnreadMessage: true,
// //     unreadCount: 5,
// //     lastMessage: "Ready for our hike this Saturday? 🏔️",
// //     lastMessageTime: "11:30 AM",
// //   ),
// //   Match(
// //     id: "6",
// //     name: "Evelyn",
// //     age: 25,
// //     imageUrl: "https://images.unsplash.com/photo-1542740348-39501cd6e2b4?fit=crop&w=800&q=80",
// //     location: "1 km away",
// //     matchedTime: "3 weeks ago",
// //     commonInterests: ["Dancing", "Cooking", "Movies"],
// //     isOnline: false,
// //     hasUnreadMessage: false,
// //     unreadCount: 0,
// //     lastMessage: "The recipe worked perfectly!",
// //     lastMessageTime: "1 week ago",
// //   ),
// // ];

// // class MatchesPage extends StatefulWidget {
// //   const MatchesPage({super.key});

// //   @override
// //   State<MatchesPage> createState() => _MatchesPageState();
// // }

// // class _MatchesPageState extends State<MatchesPage> with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   final TextEditingController _searchController = TextEditingController();
// //   String _searchQuery = '';
// //   int _selectedFilterIndex = 0;
  
// //   final List<String> _filterOptions = ['All', 'Online', 'Recent', 'Unread'];
// //   final List<String> _tabOptions = ['Matches', 'Messages'];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: _tabOptions.length, vsync: this);
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   List<Match> get filteredMatches {
// //     List<Match> matches = _matchesList.where((match) {
// //       final nameMatch = match.name.toLowerCase().contains(_searchQuery.toLowerCase());
// //       final interestMatch = match.commonInterests.any(
// //         (interest) => interest.toLowerCase().contains(_searchQuery.toLowerCase()),
// //       );
// //       return nameMatch || interestMatch;
// //     }).toList();

// //     // Apply additional filters
// //     if (_selectedFilterIndex == 1) { // Online
// //       matches = matches.where((match) => match.isOnline).toList();
// //     } else if (_selectedFilterIndex == 2) { // Recent
// //       // Sort by recent (simplified - in real app use actual timestamps)
// //       matches.sort((a, b) => b.matchedTime.compareTo(a.matchedTime));
// //     } else if (_selectedFilterIndex == 3) { // Unread
// //       matches = matches.where((match) => match.hasUnreadMessage).toList();
// //     }

// //     return matches;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final themeProvider = Provider.of<ThemeProvider>(context);
// //     final isDarkMode = themeProvider.isDarkMode;
// //     final theme = Theme.of(context);
// //     final primaryRed = const Color(0xFFFF3B30);
    
// //     // Theme colors
// //     final backgroundColor = isDarkMode ? const Color(0xFF0A0505) : const Color(0xFFFFF5F5);
// //   final cardColor = isDarkMode ?Colors.white.withOpacity(0.03)
   
// //     //  const Color(0xFF1A0A0A)
     
// //       : Colors.white;
// //     final textColor = isDarkMode ? Colors.white : const Color(0xFF2A0707);
// //     final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
// //     final dividerColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
// //     final searchBgColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;

// //     return Scaffold(
// //       backgroundColor: backgroundColor,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // App Bar
// //             _buildAppBar(primaryRed, textColor),
            
// //             // Search Bar
// //             _buildSearchBar(searchBgColor, textColor, secondaryTextColor),
            
// //             // Filter Chips
// //             // _buildFilterChips(primaryRed, cardColor, textColor),
            
// //             // Tab Bar
// //             // _buildTabBar(primaryRed, textColor, secondaryTextColor),
            
// //             // Tab Content
// //                             Expanded(child: _buildMatchesTab(cardColor, textColor, secondaryTextColor, dividerColor, primaryRed)),

// //           ],
// //         ),
// //       ),
      
// //       // New Matches Floating Action Button
// //       // floatingActionButton: _buildNewMatchesButton(primaryRed, isDarkMode),
// //     );
// //   }

// //   Widget _buildAppBar(Color primaryRed, Color textColor) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(Iconsax.heart5, color: primaryRed, size: 28),
// //               const SizedBox(width: 12),
// //               Text(
// //                 'Matches',
// //                 style: TextStyle(
// //                   color: textColor,
// //                   fontSize: 28,
// //                   fontWeight: FontWeight.w800,
// //                   letterSpacing: -0.5,
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                 decoration: BoxDecoration(
// //                   color: primaryRed.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Text(
// //                   '${_matchesList.length}',
// //                   style: TextStyle(
// //                     color: primaryRed,
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w700,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Row(
// //             children: [
// //               // Sort Button
// //               Container(
// //                 width: 44,
// //                 height: 44,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: primaryRed.withOpacity(0.1),
// //                 ),
// //                 child: IconButton(
// //                   icon: Icon(Iconsax.sort, size: 20, color: primaryRed),
// //                   onPressed: _showSortOptions,
// //                   padding: EdgeInsets.zero,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSearchBar(Color bgColor, Color textColor, Color hintColor) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //       child: Container(
// //         height: 50,
// //         decoration: BoxDecoration(
// //           color: bgColor,
// //           borderRadius: BorderRadius.circular(15),
// //           border: Border.all(
// //             color: Colors.transparent,
// //             width: 1,
// //           ),
// //         ),
// //         child: Row(
// //           children: [
// //             const SizedBox(width: 16),
// //             Icon(Iconsax.search_normal, color: hintColor, size: 20),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: TextField(
// //                 controller: _searchController,
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _searchQuery = value;
// //                   });
// //                 },
// //                 style: TextStyle(color: textColor, fontSize: 16),
// //                 decoration: InputDecoration(
// //                   hintText: 'Search matches...',
// //                   hintStyle: TextStyle(color: hintColor),
// //                   border: InputBorder.none,
// //                   contentPadding: EdgeInsets.zero,
// //                 ),
// //               ),
// //             ),
// //             if (_searchQuery.isNotEmpty)
// //               IconButton(
// //                 icon: Icon(Iconsax.close_circle, color: hintColor, size: 20),
// //                 onPressed: () {
// //                   _searchController.clear();
// //                   setState(() {
// //                     _searchQuery = '';
// //                   });
// //                 },
// //               ),
// //             const SizedBox(width: 8),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFilterChips(Color primaryRed, Color cardColor, Color textColor) {
// //     return SizedBox(
// //       height: 50,
// //       child: ListView.builder(
// //         scrollDirection: Axis.horizontal,
// //         padding: const EdgeInsets.symmetric(horizontal: 20),
// //         itemCount: _filterOptions.length,
// //         itemBuilder: (context, index) {
// //           final isSelected = _selectedFilterIndex == index;
// //           return Padding(
// //             padding: const EdgeInsets.only(right: 8),
// //             child: ChoiceChip(
// //               label: Text(
// //                 _filterOptions[index],
// //                 style: TextStyle(
// //                   color: isSelected ? Colors.white : textColor,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               selected: isSelected,
// //               onSelected: (selected) {
// //                 setState(() {
// //                   _selectedFilterIndex = selected ? index : 0;
// //                 });
// //               },
// //               backgroundColor: cardColor,
// //               selectedColor: primaryRed,
// //               side: BorderSide(
// //                 color: isSelected ? primaryRed : Colors.transparent,
// //                 width: 1,
// //               ),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildTabBar(Color primaryRed, Color textColor, Color secondaryTextColor) {
// //     return Padding(
// //       padding: const EdgeInsets.only(top: 8),
// //       child: TabBar(
// //         controller: _tabController,
// //         labelColor: primaryRed,
// //         unselectedLabelColor: secondaryTextColor,
// //         indicatorColor: primaryRed,
// //         indicatorSize: TabBarIndicatorSize.tab,
// //         indicatorWeight: 3,
// //         labelStyle: const TextStyle(
// //           fontSize: 16,
// //           fontWeight: FontWeight.w700,
// //         ),
// //         unselectedLabelStyle: const TextStyle(
// //           fontSize: 16,
// //           fontWeight: FontWeight.w500,
// //         ),
// //         tabs: _tabOptions
// //             .map((tab) => Tab(
// //                   child: Text(tab),
// //                 ))
// //             .toList(),
// //       ),
// //     );
// //   }

// //   Widget _buildMatchesTab(Color cardColor, Color textColor, Color secondaryTextColor, Color dividerColor, Color primaryRed) {
// //     final matches = filteredMatches;
    
// //     if (matches.isEmpty) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Iconsax.heart_search,
// //               size: 80,
// //               color: secondaryTextColor.withOpacity(0.5),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               'No matches found',
// //               style: TextStyle(
// //                 color: secondaryTextColor,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Try adjusting your filters or start swiping!',
// //               style: TextStyle(
// //                 color: secondaryTextColor.withOpacity(0.7),
// //                 fontSize: 14,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 20),
// //             if (_searchQuery.isNotEmpty)
// //               ElevatedButton(
// //                 onPressed: () {
// //                   _searchController.clear();
// //                   setState(() {
// //                     _searchQuery = '';
// //                   });
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: primaryRed,
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(15),
// //                   ),
// //                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
// //                 ),
// //                 child: const Text('Clear Search'),
// //               ),
// //           ],
// //         ),
// //       );
// //     }

// //     return RefreshIndicator(
// //       color: primaryRed,
// //       backgroundColor: cardColor,
// //       onRefresh: () async {
// //         // Simulate refresh
// //         await Future.delayed(const Duration(seconds: 1));
// //         setState(() {});
// //       },
// //       child: ListView.builder(
// //         padding: const EdgeInsets.all(20),
// //         itemCount: matches.length,
// //         itemBuilder: (context, index) {
// //           final match = matches[index];
// //           return _buildMatchCard(match, cardColor, textColor, secondaryTextColor, primaryRed);
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildMatchCard(Match match, Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: cardColor,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             spreadRadius: 2,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Material(
// //         color: Colors.transparent,
// //         borderRadius: BorderRadius.circular(20),
// //         child: InkWell(
// //           borderRadius: BorderRadius.circular(20),
// //           onTap: () => _openMatchProfile(match),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Profile Image with Online Indicator
// //                 Stack(
// //                   children: [
// //                     Container(
// //                       width: 70,
// //                       height: 70,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         border: Border.all(
// //                           color: primaryRed.withOpacity(0.3),
// //                           width: 2,
// //                         ),
// //                       ),
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(35),
// //                         child: CachedNetworkImage(
// //                           imageUrl: match.imageUrl,
// //                           fit: BoxFit.cover,
// //                           placeholder: (context, url) => Container(
// //                             color: secondaryTextColor.withOpacity(0.1),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     if (match.isOnline)
// //                       Positioned(
// //                         bottom: 0,
// //                         right: 0,
// //                         child: Container(
// //                           width: 16,
// //                           height: 16,
// //                           decoration: BoxDecoration(
// //                             color: Colors.green,
// //                             shape: BoxShape.circle,
// //                             border: Border.all(
// //                               color: cardColor,
// //                               width: 2,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
                
// //                 const SizedBox(width: 16),
                
// //                 // Match Info
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Name and Age
// //                       Row(
// //                         children: [
// //                           Text(
// //                             match.name,
// //                             style: TextStyle(
// //                               color: textColor,
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.w700,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             '${match.age}',
// //                             style: TextStyle(
// //                               color: secondaryTextColor,
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.w400,
// //                             ),
// //                           ),
// //                           const Spacer(),
// //                           Text(
// //                             match.matchedTime,
// //                             style: TextStyle(
// //                               color: secondaryTextColor.withOpacity(0.7),
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
                      
// //                       const SizedBox(height: 4),
                      
// //                       // Location
// //                       Row(
// //                         children: [
// //                           Icon(Iconsax.location5, size: 14, color: secondaryTextColor),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             match.location,
// //                             style: TextStyle(
// //                               color: secondaryTextColor,
// //                               fontSize: 14,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
                      
// //                       const SizedBox(height: 8),
                      
// //                       // Common Interests
// //                       Wrap(
// //                         spacing: 6,
// //                         runSpacing: 6,
// //                         children: match.commonInterests.take(3).map((interest) {
// //                           return Container(
// //                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                             decoration: BoxDecoration(
// //                               color: primaryRed.withOpacity(0.1),
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             child: Text(
// //                               interest,
// //                               style: TextStyle(
// //                                 color: primaryRed,
// //                                 fontSize: 12,
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                             ),
// //                           );
// //                         }).toList(),
// //                       ),
                      
// //                       const SizedBox(height: 8),
                      
// //                       // Action Buttons
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: ElevatedButton(
// //                               onPressed: () => _sendMessage(match),
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: primaryRed,
// //                                 foregroundColor: Colors.white,
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                                 padding: const EdgeInsets.symmetric(vertical: 10),
// //                               ),
// //                               child: const Row(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 children: [
// //                                   Icon(Iconsax.message, size: 16),
// //                                   SizedBox(width: 6),
// //                                   Text('Message'),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Container(
// //                             width: 44,
// //                             height: 44,
// //                             decoration: BoxDecoration(
// //                               color: cardColor,
// //                               shape: BoxShape.circle,
// //                               border: Border.all(
// //                                 // color: dividerColor,
// //                                 width: 1,
// //                               ),
// //                             ),
// //                             child: IconButton(
// //                               icon: Icon(
// //                                 Iconsax.more,
// //                                 size: 20,
// //                                 color: secondaryTextColor,
// //                               ),
// //                               onPressed: () => _showMatchOptions(match),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMessagesTab(Color cardColor, Color textColor, Color secondaryTextColor, Color dividerColor, Color primaryRed) {
// //     final matchesWithMessages = _matchesList.where((match) => match.lastMessage.isNotEmpty).toList();
    
// //     if (matchesWithMessages.isEmpty) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Iconsax.message_text,
// //               size: 80,
// //               color: secondaryTextColor.withOpacity(0.5),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               'No messages yet',
// //               style: TextStyle(
// //                 color: secondaryTextColor,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Start a conversation with your matches!',
// //               style: TextStyle(
// //                 color: secondaryTextColor.withOpacity(0.7),
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       padding: const EdgeInsets.all(20),
// //       itemCount: matchesWithMessages.length,
// //       itemBuilder: (context, index) {
// //         final match = matchesWithMessages[index];
// //         return _buildMessageCard(match, cardColor, textColor, secondaryTextColor, primaryRed);
// //       },
// //     );
// //   }

// //   Widget _buildMessageCard(Match match, Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: cardColor,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.03),
// //             blurRadius: 8,
// //             spreadRadius: 1,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Material(
// //         color: Colors.transparent,
// //         borderRadius: BorderRadius.circular(20),
// //         child: InkWell(
// //           borderRadius: BorderRadius.circular(20),
// //           onTap: () => _openChat(match),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Row(
// //               children: [
// //                 // Profile Image
// //                 Stack(
// //                   children: [
// //                     Container(
// //                       width: 60,
// //                       height: 60,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         border: Border.all(
// //                           color: match.hasUnreadMessage ? primaryRed : Colors.transparent,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(30),
// //                         child: CachedNetworkImage(
// //                           imageUrl: match.imageUrl,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                     ),
// //                     if (match.isOnline)
// //                       Positioned(
// //                         bottom: 0,
// //                         right: 0,
// //                         child: Container(
// //                           width: 14,
// //                           height: 14,
// //                           decoration: BoxDecoration(
// //                             color: Colors.green,
// //                             shape: BoxShape.circle,
// //                             border: Border.all(
// //                               color: cardColor,
// //                               width: 2,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
                
// //                 const SizedBox(width: 16),
                
// //                 // Message Info
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Text(
// //                             match.name,
// //                             style: TextStyle(
// //                               color: textColor,
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.w700,
// //                             ),
// //                           ),
// //                           if (match.hasUnreadMessage)
// //                             Container(
// //                               margin: const EdgeInsets.only(left: 6),
// //                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// //                               decoration: BoxDecoration(
// //                                 color: primaryRed,
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                               child: Text(
// //                                 '${match.unreadCount}',
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.w700,
// //                                 ),
// //                               ),
// //                             ),
// //                           const Spacer(),
// //                           Text(
// //                             match.lastMessageTime,
// //                             style: TextStyle(
// //                               color: secondaryTextColor.withOpacity(0.7),
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
                      
// //                       const SizedBox(height: 4),
                      
// //                       // Last Message Preview
// //                       Text(
// //                         match.lastMessage,
// //                         style: TextStyle(
// //                           color: match.hasUnreadMessage ? textColor : secondaryTextColor,
// //                           fontSize: 14,
// //                           fontWeight: match.hasUnreadMessage ? FontWeight.w600 : FontWeight.w400,
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildNewMatchesButton(Color primaryRed, bool isDarkMode) {
// //     return FloatingActionButton.extended(
// //       onPressed: _showNewMatches,
// //       backgroundColor: primaryRed,
// //       foregroundColor: Colors.white,
// //       elevation: 8,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //       icon: const Icon(Iconsax.heart_add, size: 20),
// //       label: const Text('New Matches'),
// //     );
// //   }

// //   void _showSortOptions() {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final primaryRed = const Color(0xFFFF3B30);
    
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => Container(
// //         decoration: BoxDecoration(
// //           color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
// //           borderRadius: const BorderRadius.only(
// //             topLeft: Radius.circular(24),
// //             topRight: Radius.circular(24),
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const SizedBox(height: 12),
// //             Container(
// //               width: 40,
// //               height: 4,
// //               decoration: BoxDecoration(
// //                 color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
// //                 borderRadius: BorderRadius.circular(2),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 24),
// //               child: Text(
// //                 'Sort By',
// //                 style: TextStyle(
// //                   color: isDark ? Colors.white : Colors.black87,
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             _buildSortOption('Most Recent', Iconsax.calendar_1, true),
// //             _buildSortOption('Closest Distance', Iconsax.location),
// //             _buildSortOption('Highest Match %', Iconsax.heart),
// //             _buildSortOption('Alphabetical', Iconsax.sort),
// //             const SizedBox(height: 30),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   ListTile _buildSortOption(String title, IconData icon, [bool selected = false]) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final primaryRed = const Color(0xFFFF3B30);
    
// //     return ListTile(
// //       leading: Icon(icon, color: selected ? primaryRed : (isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
// //       title: Text(
// //         title,
// //         style: TextStyle(
// //           color: isDark ? Colors.white : Colors.black87,
// //           fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
// //         ),
// //       ),
// //       trailing: selected
// //           ? Icon(Iconsax.tick_circle, color: primaryRed, size: 22)
// //           : null,
// //       onTap: () {
// //         Navigator.pop(context);
// //         // Apply sort logic here
// //       },
// //       contentPadding: const EdgeInsets.symmetric(horizontal: 24),
// //     );
// //   }

// //   void _openMatchProfile(Match match) {
// //     // TODO: Navigate to match profile

// // Navigator.push(context, MaterialPageRoute(builder:(context) {
// //   return ProfileDetailPage( );
// // }, ));
// //     // showDialog(
// //     //   context: context,
// //     //   builder: (context) => AlertDialog(
// //     //     title: Text('${match.name}\'s Profile'),
// //     //     content: Text('This would show ${match.name}\'s detailed profile'),
// //     //     actions: [
// //     //       TextButton(
// //     //         onPressed: () => Navigator.pop(context),
// //     //         child: const Text('Close'),
// //     //       ),
// //     //     ],
// //     //   ),
// //     // );
// //   }

// //   void _sendMessage(Match match) {
// //     // TODO: Open chat with match
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Message ${match.name}'),
// //         content: const Text('This would open the chat screen'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Close'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showMatchOptions(Match match) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final primaryRed = const Color(0xFFFF3B30);
    
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => Container(
// //         decoration: BoxDecoration(
// //           color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
// //           borderRadius: const BorderRadius.only(
// //             topLeft: Radius.circular(24),
// //             topRight: Radius.circular(24),
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const SizedBox(height: 12),
// //             Container(
// //               width: 40,
// //               height: 4,
// //               decoration: BoxDecoration(
// //                 color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
// //                 borderRadius: BorderRadius.circular(2),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             _buildMatchOption('View Full Profile', Iconsax.user),
// //             _buildMatchOption('Share Profile', Iconsax.share),
// //             _buildMatchOption('Unmatch', Iconsax.close_circle, color: Colors.red),
// //             const SizedBox(height: 20),
// //             Container(
// //               height: 1,
// //               color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
// //             ),
// //             const SizedBox(height: 20),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 24),
// //               child: SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: () => Navigator.pop(context),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: primaryRed,
// //                     foregroundColor: Colors.white,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(15),
// //                     ),
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                   ),
// //                   child: const Text('Close'),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 30),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   ListTile _buildMatchOption(String title, IconData icon, {Color? color}) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final primaryRed = const Color(0xFFFF3B30);
    
// //     return ListTile(
// //       leading: Icon(icon, color: color ?? primaryRed),
// //       title: Text(
// //         title,
// //         style: TextStyle(
// //           color: isDark ? Colors.white : Colors.black87,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //       trailing: Icon(Iconsax.arrow_right_3, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
// //       onTap: () {
// //         Navigator.pop(context);
// //         // Handle option selection
// //       },
// //       contentPadding: const EdgeInsets.symmetric(horizontal: 24),
// //     );
// //   }

// //   void _openChat(Match match) {
// //     // TODO: Open chat screen
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Chat with ${match.name}'),
// //         content: const Text('This would open the chat interface'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Close'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showNewMatches() {
// //     // TODO: Show new matches or navigate to discover
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('New Matches'),
// //         content: const Text('Check out who swiped right on you!'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Later'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('View Now'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dating/pages/dummy.dart'; // Ensure this points to your data model
// import 'package:dating/pages/intro_page.dart' hide profileData;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';
// import 'dart:ui'; // For ImageFilter

// // --- THEME COLORS ---
// const Color kEliteGold = Color(0xFFFFD166);
// const Color kCardDark = Color(0xFF1E1E1E);
// const Color kBgDark = Color(0xFF0F0F0F);
// const Color kAccentRed = Color(0xFFFF4B4B);

// class MatchesPage extends StatefulWidget {
//   const MatchesPage({super.key});

//   @override
//   State<MatchesPage> createState() => _MatchesPageState();
// }

// class _MatchesPageState extends State<MatchesPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();

//   // Mocking Chat Data linked to your Profile model
//   // In a real app, this comes from a backend
//   late List<Map<String, dynamic>> _chats;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
    
//     // Creating dummy chat data using your profileData
//     _chats = [
//       {
//         'profile': profileData[0],
//         'lastMessage': "Can't wait to see you tonight! ✨",
//         'time': '10:42 AM',
//         'unread': 2,
//         'isTyping': false,
//       },
//       {
//         'profile': profileData[1],
//         'lastMessage': "Sent a photo",
//         'time': 'Yesterday',
//         'unread': 0,
//         'isTyping': true, // Simulating typing
//       },
//       {
//         'profile': profileData[2],
//         'lastMessage': "Haha that's crazy 😂",
//         'time': 'Mon',
//         'unread': 0,
//         'isTyping': false,
//       },
//        {
//         'profile': profileData[3],
//         'lastMessage': "Are you free this weekend?",
//         'time': 'Sun',
//         'unread': 1,
//         'isTyping': false,
//       },
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     // Force dark mode for the "Elite" feel or adapt
//     final bgColor = isDark ? kBgDark : const Color(0xFFFAFAFA);

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: SafeArea(
//         child: NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) {
//             return [
//               _buildSliverAppBar(isDark),
//             ];
//           },
//           body: Column(
//             children: [
//               _buildSearchBar(isDark),
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.only(top: 10, bottom: 80),
//                   physics: const BouncingScrollPhysics(),
//                   children: [
//                     // 1. Who Liked You (Premium Feature)
//                     _buildLikesSection(isDark),
                    
//                     const SizedBox(height: 25),
                    
//                     // 2. New Matches (Horizontal)
//                     _buildSectionTitle("New Matches", "4"),
//                     _buildNewMatchesList(isDark),

//                     const SizedBox(height: 25),

//                     // 3. Messages Title
//                     _buildSectionTitle("Messages", ""),
                    
//                     // 4. Chat List
//                     _buildChatList(isDark),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- WIDGETS ---

//   Widget _buildSliverAppBar(bool isDark) {
//     return SliverAppBar(
//       backgroundColor: isDark ? kBgDark : Colors.white,
//       expandedHeight: 60,
//       floating: true,
//       pinned: false,
//       elevation: 0,
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: false,
//         titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             RichText(
//               text: const TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "MY", 
//                     style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1)
//                   ),
//                   TextSpan(
//                     text: " MATCHES", 
//                     style: TextStyle(color: kEliteGold, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1)
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white10),
//               ),
//               child: const Icon(Iconsax.setting_2, color: Colors.grey, size: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar(bool isDark) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
//           boxShadow: [
//              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
//           ]
//         ),
//         child: TextField(
//           controller: _searchController,
//           style: TextStyle(color: isDark ? Colors.white : Colors.black),
//           decoration: InputDecoration(
//             hintText: "Search matches...",
//             hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//             prefixIcon: const Icon(Iconsax.search_normal, color: Colors.grey, size: 20),
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(vertical: 15),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, String count) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 0.5,
//             ),
//           ),
//           if (count.isNotEmpty) ...[
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: kEliteGold,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 count,
//                 style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // --- 1. LIKES SECTION (Upsell) ---
//   Widget _buildLikesSection(bool isDark) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       height: 70,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         gradient: LinearGradient(
//           colors: [kEliteGold.withOpacity(0.2), kEliteGold.withOpacity(0.05)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border.all(color: kEliteGold.withOpacity(0.3)),
//       ),
//       child: InkWell(
//         onTap: () {
//           // Trigger Premium Purchase Sheet
//           HapticFeedback.mediumImpact();
//         },
//         child: Row(
//           children: [
//             const SizedBox(width: 15),
//             // Stacked blurred avatars
//             SizedBox(
//               width: 60,
//               height: 40,
//               child: Stack(
//                 children: [
//                   _buildBlurredAvatar(0),
//                   Positioned(left: 15, child: _buildBlurredAvatar(1)),
//                   Positioned(left: 30, child: _buildBlurredAvatar(2)),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "18 People like you",
//                     style: TextStyle(color: kEliteGold, fontWeight: FontWeight.bold, fontSize: 14),
//                   ),
//                   Text(
//                     "See who likes you now",
//                     style: TextStyle(color: Colors.grey[400], fontSize: 11),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(right: 15),
//               padding: const EdgeInsets.all(8),
//               decoration: const BoxDecoration(
//                 color: kEliteGold,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Iconsax.arrow_right_3, color: Colors.black, size: 16),
//             )
//           ],
//         ),
//       ),
//     ).animate().shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.1));
//   }

//   Widget _buildBlurredAvatar(int index) {
//     // Just using dummy images but blurring them
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: kBgDark, width: 2),
//         image: DecorationImage(
//           image: CachedNetworkImageProvider("https://i.pravatar.cc/150?img=${20 + index}"),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(50),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//           child: Container(color: Colors.black.withOpacity(0.2)),
//         ),
//       ),
//     );
//   }

//   // --- 2. NEW MATCHES (Horizontal) ---
//   Widget _buildNewMatchesList(bool isDark) {
//     // Reverse list to show "newest" first or just take the first few
//     final matches = profileData.take(6).toList();
    
//     return SizedBox(
//       height: 110,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         itemCount: matches.length,
//         itemBuilder: (ctx, i) {
//           final profile = matches[i];
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Stack(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         // Gradient border for Elite/New feel
//                         gradient: LinearGradient(
//                           colors: i == 0 
//                             ? [kEliteGold, Colors.orange] // First one is super new
//                             : [Colors.purple, Colors.blue], 
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: isDark ? kBgDark : Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                         child: CircleAvatar(
//                           radius: 30,
//                           backgroundImage: CachedNetworkImageProvider(profile.imageUrl),
//                         ),
//                       ),
//                     ),
//                     if (profile.isOnline)
//                       Positioned(
//                         bottom: 2,
//                         right: 2,
//                         child: Container(
//                           width: 14, height: 14,
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: kBgDark, width: 2),
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   profile.name,
//                   style: TextStyle(
//                     color: isDark ? Colors.white : Colors.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//               ],
//             ),
//           ).animate().scale(delay: (i * 100).ms);
//         },
//       ),
//     );
//   }

//   // --- 3. CHAT LIST (Vertical) ---
//   Widget _buildChatList(bool isDark) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: _chats.length,
//       itemBuilder: (context, index) {
//         final chat = _chats[index];
//         final Profile profile = chat['profile'];
//         final bool isTyping = chat['isTyping'] ?? false;
//         final int unread = chat['unread'] ?? 0;

//         return Dismissible(
//           key: Key(profile.name),
//           background: Container(
//             color: kAccentRed,
//             alignment: Alignment.centerRight,
//             padding: const EdgeInsets.only(right: 20),
//             child: const Icon(Iconsax.trash, color: Colors.white),
//           ),
//           direction: DismissDirection.endToStart,
//           onDismissed: (direction) {
//             // Handle delete
//           },
//           child: InkWell(
//             onTap: () {
//                // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen()));
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               child: Row(
//                 children: [
//                   // Avatar
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 28,
//                         backgroundImage: CachedNetworkImageProvider(profile.imageUrl),
//                       ),
//                       if (profile.isOnline)
//                         Positioned(
//                           right: 0, bottom: 0,
//                           child: Container(
//                             width: 12, height: 12,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF00C853),
//                               shape: BoxShape.circle,
//                               border: Border.all(color: kBgDark, width: 2),
//                             ),
//                           ),
//                         )
//                     ],
//                   ),
//                   const SizedBox(width: 15),
                  
//                   // Message Content
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               profile.name,
//                               style: TextStyle(
//                                 color: isDark ? Colors.white : Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               chat['time'],
//                               style: TextStyle(
//                                 color: unread > 0 ? kEliteGold : Colors.grey,
//                                 fontSize: 11,
//                                 fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             if (isTyping)
//                               _buildTypingIndicator()
//                             else
//                               Expanded(
//                                 child: Text(
//                                   chat['lastMessage'],
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     color: unread > 0 ? Colors.white : Colors.grey,
//                                     fontSize: 13,
//                                     fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
//                                   ),
//                                 ),
//                               ),
//                             if (unread > 0)
//                               Container(
//                                 margin: const EdgeInsets.only(left: 10),
//                                 width: 20, height: 20,
//                                 decoration: const BoxDecoration(
//                                   color: kEliteGold,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   unread.toString(),
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
//       },
//     );
//   }

//   Widget _buildTypingIndicator() {
//     return Text(
//       "Typing...",
//       style: TextStyle(
//         color: kEliteGold,
//         fontSize: 12,
//         fontStyle: FontStyle.italic,
//       ),
//     ).animate(onPlay: (c) => c.repeat()).fade(duration: 600.ms);
//   }
// }