import 'dart:developer';
import 'dart:ui';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DiscoverySearchPage extends StatefulWidget {
  const DiscoverySearchPage({super.key});

  @override
  State<DiscoverySearchPage> createState() => _DiscoverySearchPageState();
}

class _DiscoverySearchPageState extends State<DiscoverySearchPage> {
  String searchQuery = "";
  int selectedGoalId = -1;

  // Filter values
  double distanceValue = 500;
  RangeValues ageRange = const RangeValues(18, 80);
  List<String> selectedGenderIds = [];
  List<String> selectedEducationIds = [];
  List<String> selectedInterestIds = [];
  List<String> selectedRelationshipGoalIds = [];
  bool verifiedOnly = false;
  bool onlineOnly = false;

  final TextEditingController _searchController = TextEditingController();

  int _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return 22;
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 22;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = context.read<RegistrationDataProvider>();
      if (!dataProvider.gendersLoaded) dataProvider.loadGenders();
      if (!dataProvider.educationLoaded) dataProvider.loadEducationLevels();
      if (!dataProvider.interestsLoaded) dataProvider.loadInterests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Consumer2<HomeProvider, RegistrationDataProvider>(
        builder: (context, homeProvider, dataProvider, child) {
          List<Profile> displayProfiles = _getFilteredProfiles(homeProvider);

          return Stack(
            children: [
              // 1. TOP RED GRADIENT (As requested)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFFFF4D67).withOpacity(0.2), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Ambient Glow (Gold)
              // Positioned(
              //   top: -100, right: -50,
              //   child: Container(
              //     width: 300, height: 300,
              //     decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFD700).withOpacity(0.05)),
              //     child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container()),
              //   ),
              // ),

              SafeArea(
                child: Column(
                  children: [
                    _buildEliteHeader(displayProfiles.length),
                    _buildSearchBar(),
                    SizedBox(height: 4,),
                    _buildCategoryScroller(homeProvider.categories),
                    _buildActiveFiltersCounter(displayProfiles.length),
                    Expanded(
                      child: homeProvider.isLoading 
                        ? _buildShimmerGrid() 
                        : displayProfiles.isEmpty 
                            ? _buildEnhancedEmptyState() 
                            : _buildProfileGrid(displayProfiles),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildAdvancedFilterButton(),
    );
  }

  // --- FILTER LOGIC ---
  List<Profile> _getFilteredProfiles(HomeProvider provider) {
    List<Profile> baseList = (selectedGoalId == -1) 
        ? provider.forYouProfiles 
        : provider.categories.firstWhere(
            (e) => e.goalId == selectedGoalId, 
            orElse: () => GoalProfile(goalId: -1, goalTitle: "", profiles: [], goalEmoji: '')
          ).profiles;

    return baseList.where((profile) {
      if (searchQuery.isNotEmpty) {
        if (!profile.userName.toLowerCase().contains(searchQuery.toLowerCase())) return false;
      }
      if ((profile.distance ?? 0) > distanceValue) return false;
      int age = _calculateAge(profile.dateOfBirth);
      if (age < ageRange.start || age > ageRange.end) return false;
      if (selectedGenderIds.isNotEmpty && !selectedGenderIds.contains(profile.gender.id.toString())) return false;
      if (selectedEducationIds.isNotEmpty && !selectedEducationIds.contains(profile.education.id.toString())) return false;
      if (onlineOnly && !profile.isLive) return false;
      if (selectedInterestIds.isNotEmpty) {
        bool hasMatch = profile.interests.any((i) => selectedInterestIds.contains(i.id.toString()));
        if (!hasMatch) return false;
      }
      return true;
    }).toList();
  }

  // --- UI COMPONENTS ---

  Widget _buildEliteHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Discovery",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              Text(
                "$count elite matches found",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          _buildGlassCircleIcon(Iconsax.search_favorite, () {}),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => searchQuery = v),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search name or vibe...",
            hintStyle: const TextStyle(color: Colors.white24),
            prefixIcon: const Icon(Iconsax.search_normal_1, color: Color(0xFFFFD700), size: 18),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryScroller(List<GoalProfile> categories) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          bool isAll = index == 0;
          bool isSelected = isAll ? selectedGoalId == -1 : selectedGoalId == categories[index - 1].goalId;
          String label = isAll ? "For You" : categories[index - 1].goalTitle;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => selectedGoalId = isAll ? -1 : categories[index - 1].goalId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveFiltersCounter(int count) {
    if (!_hasActiveFilters()) return const SizedBox(height: 10);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        children: [
          const Icon(Iconsax.filter5, color: Color(0xFFFFD700), size: 12),
          const SizedBox(width: 8),
          const Text("Active Filters", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
          const Spacer(),
          GestureDetector(
            onTap: _clearAllFilters,
            child: const Text("Reset", style: TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileGrid(List<Profile> profiles) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.7,
      ),
      itemCount: profiles.length,
      itemBuilder: (context, index) => _buildProfileCard(profiles[index]),
    );
  }

  Widget _buildProfileCard(Profile profile) {
    int age = _calculateAge(profile.dateOfBirth);
    int match = ((profile.interestMatch ?? 0) * 20).clamp(0, 100);

    return InkWell(

      onTap: () {
        


  HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProfileDetailsPage(
                  profiledata: profile,
                  goalName: profile.relationshipGoal?.name??'',
                  match: false,
                );
              },
            ),
          );

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(image: CachedNetworkImageProvider(profile.photo), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.9)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
            // Positioned(
            //   top: 10, right: 10,
            //   child: _buildMatchBadge("$match%"),
            // ),
            Positioned(
              bottom: 15, left: 15, right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${profile.userName}, $age", 
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(profile.job ?? "Elite Member", 
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Iconsax.location, color: Color(0xFFFFD700), size: 10),
                      const SizedBox(width: 4),
                      Text(profile.distance != null && profile.distance! < 50 ? "Near you" : "${profile.distance?.toStringAsFixed(0)} km",
                        style: const TextStyle(color: Colors.white70, fontSize: 9)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildMatchBadge(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFFD700).withOpacity(0.2), border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3))),
          child: Text(text, style: const TextStyle(color: Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildAdvancedFilterButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showFilterBottomSheet(),
      backgroundColor: const Color(0xFFFFD700),
      label: const Row(
        children: [
          Icon(Iconsax.filter_search, color: Colors.black, size: 20),
          SizedBox(width: 8),
          Text("FILTERS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12)),
        ],
      ),
    );
  }

  // --- FILTER BOTTOM SHEET ---
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final dataProvider = context.read<RegistrationDataProvider>();

          // FLATTENING THE NESTED INTERESTS DATA
          List<Map<String, dynamic>> flatInterests = [];
          for (var group in dataProvider.interests) {
            if (group['interests'] != null) {
              for (var interest in group['interests']) {
                flatInterests.add({
                  'name': interest['name']?.toString() ?? "N/A",
                  'id': interest['id']?.toString() ?? "",
                  'emoji': interest['emoji']?.toString() ?? "",
                });
              }
            }
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
            ),
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("FILTERS", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Iconsax.close_circle, color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _filterHeader("DISTANCE", "${distanceValue.toInt()} km"),
                        Slider(
                          value: distanceValue, min: 1, max: 500,
                          activeColor: const Color(0xFFFFD700),
                          inactiveColor: Colors.white12,
                          onChanged: (v) => setModalState(() => distanceValue = v),
                        ),
                        const SizedBox(height: 20),
                        _filterHeader("AGE RANGE", "${ageRange.start.toInt()} - ${ageRange.end.toInt()}"),
                        RangeSlider(
                          values: ageRange, min: 18, max: 80,
                          activeColor: const Color(0xFFFFD700),
                          inactiveColor: Colors.white12,
                          onChanged: (v) => setModalState(() => ageRange = v),
                        ),
                        const SizedBox(height: 30),

                        _filterLabel("GENDER"),
                        _buildChoiceChips(
                          dataProvider.genders.map((e) => e['genderTitle']?.toString() ?? "N/A").toList(),
                          dataProvider.genders.map((e) => e['genderId']?.toString() ?? "").toList(),
                          selectedGenderIds,
                          (id) => setModalState(() => selectedGenderIds.contains(id) ? selectedGenderIds.remove(id) : selectedGenderIds.add(id)),
                        ),
                        const SizedBox(height: 30),

                        _filterLabel("EDUCATION"),
                        _buildChoiceChips(
                          dataProvider.educationLevels.map((e) => e['eduTitle']?.toString() ?? "N/A").toList(),
                          dataProvider.educationLevels.map((e) => e['eduId']?.toString() ?? "").toList(),
                          selectedEducationIds,
                          (id) => setModalState(() => selectedEducationIds.contains(id) ? selectedEducationIds.remove(id) : selectedEducationIds.add(id)),
                        ),
                        const SizedBox(height: 30),

                        _filterLabel("INTERESTS"),
                        _buildChoiceChips(
                          flatInterests.map((e) => "${e['emoji']} ${e['name']}").toList(),
                          flatInterests.map((e) => e['id'].toString()).toList(),
                          selectedInterestIds,
                          (id) => setModalState(() => selectedInterestIds.contains(id) ? selectedInterestIds.remove(id) : selectedInterestIds.add(id)),
                        ),
                        const SizedBox(height: 30),

                        _buildToggleRow("Currently Online", onlineOnly, (v) => setModalState(() => onlineOnly = v)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("APPLY FILTERS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // --- HELPERS ---
  Widget _filterHeader(String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _filterLabel(title),
        Text(val, style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _filterLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(text, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
  );

  Widget _buildChoiceChips(List<String> labels, List<String> ids, List<String> selected, Function(String) onToggle) {
    if (labels.isEmpty) return const Text("Loading...", style: TextStyle(color: Colors.white24, fontSize: 10));
    
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: List.generate(labels.length, (i) {
        if (labels[i].contains("N/A") || ids[i] == "") return const SizedBox.shrink();

        bool isSel = selected.contains(ids[i]);
        return GestureDetector(
          onTap: () => onToggle(ids[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSel ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSel ? Colors.transparent : Colors.white12),
            ),
            child: Text(labels[i], style: TextStyle(color: isSel ? Colors.black : Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        );
      }),
    );
  }

  Widget _buildToggleRow(String title, bool val, Function(bool) onToggle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          Switch(value: val, onChanged: onToggle, activeColor: const Color(0xFFFFD700)),
        ],
      ),
    );
  }

  Widget _buildGlassCircleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)));
  }

  Widget _buildEnhancedEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.search_status, size: 60, color: Colors.white12),
          const SizedBox(height: 15),
          const Text("No Vibe Found", style: TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Try adjusting your filters", style: TextStyle(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }

  bool _hasActiveFilters() => distanceValue < 500 || ageRange.start > 18 || ageRange.end < 80 || selectedGenderIds.isNotEmpty || selectedInterestIds.isNotEmpty || onlineOnly;

  void _clearAllFilters() {
    setState(() {
      distanceValue = 500; 
      ageRange = const RangeValues(18, 80);
      selectedGenderIds.clear(); 
      selectedEducationIds.clear(); 
      selectedInterestIds.clear();
      onlineOnly = false; 
      verifiedOnly = false;
    });
  }
}