import 'dart:developer';
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/plans/plan_upgrade_sheet.dart'; 
import 'package:dating/providers/interaction_provider.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/permission_provider.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/suppoting_data_service.dart/age_calculater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class ProfileDetailsPage extends StatefulWidget {
  final Profile profiledata;
  final String goalName;
  final bool match; 

  const ProfileDetailsPage({
    super.key, 
    required this.profiledata, 
    required this.goalName, 
    required this.match,
  });

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> with TickerProviderStateMixin {
  final ScrollController _mainScrollController = ScrollController();
  final PageController _galleryPageController = PageController();
  int _currentImageIndex = 0;

  // Interaction Feedback Logic
  late AnimationController _overlayController;
  late Animation<double> _scaleAnimation;
  String? _interactionStatus;
  bool _isProcessing = false;

  // Audio Logic
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
    _overlayController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.elasticOut),
    );
  }

  void _initAudio() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((s) => setState(() => _isPlaying = s == PlayerState.playing));
    _audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    _audioPlayer.onPlayerComplete.listen((e) => setState(() => _position = Duration.zero));
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _galleryPageController.dispose();
    _audioPlayer.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  // --- LOGIC HELPERS ---

  bool _isActiveStatus() {
    try {
      if (widget.profiledata.lastSeen == null) return false;
      DateTime lastSeenTime = DateTime.parse(widget.profiledata.lastSeen!);
      return DateTime.now().difference(lastSeenTime).inMinutes < 5;
    } catch (e) {
      return false;
    }
  }

  void _onInteraction(String status) async {
    if (_isProcessing) return;
    
    final permissionProv = Provider.of<PermissionProvider>(context, listen: false);
    
    if (status == 'like' && !permissionProv.canLike) {
      _showPremiumUpgrade();
      return;
    }

    setState(() {
      _isProcessing = true;
      _interactionStatus = status;
    });

    final interactionProv = Provider.of<InteractionProvider>(context, listen: false);
    final homeProv = Provider.of<HomeProvider>(context, listen: false);
    final auth = AuthService();
    final userId = await auth.getUserId();
    final myPhoto = await auth.getUserPhoto();

    _overlayController.forward();
    status == 'like' ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();

    try {
      await interactionProv.handleAction(
        matchedfromUserImg: myPhoto ?? '',
        context: context,
        fromUser: userId.toString(),
        toUser: widget.profiledata.userId.toString(),
        status: status,
        matchedUserImg: widget.profiledata.photo,
        onComplete: () async {
          if (mounted) {
            context.read<MatchesProvider>().fetchMatches(userId.toString());
            homeProv.removeProfileLocally(widget.profiledata.userId);
            
            // Pop the page after a short delay so user sees the visual feedback
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted) Navigator.pop(context);
            });
          }
        },
      );
      permissionProv.refreshSilently(userId.toString());
    } catch (e) {
      log("Error interaction details: $e");
      setState(() {
        _isProcessing = false;
        _interactionStatus = null;
      });
      _overlayController.reset();
    }
  }

  void _showPremiumUpgrade() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumUpgradeSheet(),
    );
  }

  void _openGallery(List<Photo> photos, int index) {
    Navigator.push(context, PageRouteBuilder(opaque: false, pageBuilder: (context, _, __) => FullScreenGallery(photos: photos, initialIndex: index)));
  }

  void _toggleVoice() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (widget.profiledata.voiceUrl != null) {
        await _audioPlayer.play(UrlSource(widget.profiledata.voiceUrl!));
        HapticFeedback.lightImpact();
      }
    }
  }

  String _formatDuration(Duration d) {
    return "${d.inMinutes.remainder(60)}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  // --- UI COMPONENTS ---

  @override
  Widget build(BuildContext context) {
    final age = calculateAge(widget.profiledata.dateOfBirth);
    final active = _isActiveStatus();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Hero Image Background
          Positioned.fill(
            child: Hero(
              tag: 'profile_image_${widget.profiledata.userId}',
              child: Image.network(widget.profiledata.photo, fit: BoxFit.cover),
            ),
          ),

          // 2. Cinematic Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.7, 1.0],
                  colors: [Colors.black45, Colors.transparent, Colors.black87, Colors.black],
                ),
              ),
            ),
          ),

          // 3. Main Scrollable Content
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverHeader(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 280),
                        _buildFloatingBadges(active).animate().fadeIn().slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 20),
                        _buildNameSection(age.toString(), active),
                        
                        if (widget.profiledata.voiceUrl != null && widget.profiledata.voiceUrl!.isNotEmpty)
                          _buildVisualizerVoicePlayer().animate().fadeIn(delay: 200.ms),

                        const SizedBox(height: 30),
                        _buildAboutSection(),
                        const SizedBox(height: 35),
                        _buildPremiumDetailsGrid(),
                        const SizedBox(height: 35),
                        _buildLifestyleSection(),
                        const SizedBox(height: 35),
                        _buildInterestsSection(),
                        const SizedBox(height: 35),
                        if (widget.profiledata.photos.isNotEmpty) _buildGallerySection(),
                        const SizedBox(height: 35),
                        _buildPrivateVaultSection(),
                        const SizedBox(height: 150), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Central Visual Feedback Icon (Heart/Pass)
          if (_interactionStatus != null)
            IgnorePointer(
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    _interactionStatus == 'like' ? Iconsax.heart5 : Iconsax.close_circle5,
                    color: _interactionStatus == 'like' ? AppColors.neonGold : Colors.red,
                    size: 150,
                  ),
                ),
              ),
            ),

          _buildFloatingActionDock(),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          _glassIcon(Iconsax.arrow_left_2, () => Navigator.pop(context)), 
          _glassIcon(Iconsax.more, () {})
        ]
      ),
    ),
  );

  Widget _buildNameSection(String age, bool active) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: Text("${widget.profiledata.userName}, $age", style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold))),
          if (active)
            Container(
              width: 12, height: 12,
              decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.greenAccent, blurRadius: 10, spreadRadius: 2)]),
            ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 1.seconds, curve: Curves.easeInOut),
        ],
      ),
      Row(children: [const Icon(Iconsax.location, color: AppColors.neonGold, size: 16), const SizedBox(width: 6), Text(widget.profiledata.city ?? "Nearby", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16))]),
    ],
  );

  Widget _buildFloatingBadges(bool active) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: active ? Colors.greenAccent : AppColors.neonGold)),
        child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(widget.profiledata.photo)),
      ),
      const SizedBox(width: 12),
      _glassBadge(widget.goalName, icon: Iconsax.heart5, color: AppColors.neonGold),
      if (active) ...[
        const SizedBox(width: 8),
        _glassBadge("LIVE", icon: Icons.circle, color: Colors.greenAccent),
      ]
    ],
  );

  Widget _buildVisualizerVoicePlayer() {
    double progress = _duration.inSeconds > 0 ? _position.inSeconds / _duration.inSeconds : 0.0;
    return Container(
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.05)]),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _toggleVoice,
                child: Container(
                  height: 55, width: 55,
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppColors.neonGold, Color(0xFFFFB300)])),
                  child: Icon(_isPlaying ? Iconsax.pause5 : Iconsax.play5, color: Colors.black, size: 28),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Voice Intro", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(_isPlaying ? "Listening..." : "Hear my story", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              Text(_formatDuration(_position), style: const TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(30, (i) => Container(width: 3, height: (i % 3 == 0) ? 20 : (i % 2 == 0) ? 12 : 8, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))))),
              ClipRect(
                clipper: _ProgressClipper(progress),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(30, (i) => Container(width: 3, height: (i % 3 == 0) ? 20 : (i % 2 == 0) ? 12 : 8, decoration: BoxDecoration(color: AppColors.neonGold, borderRadius: BorderRadius.circular(2))))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start, 
    children: [
      const Text("About", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), 
      const SizedBox(height: 10), 
      Text(widget.profiledata.bio ?? "Elite member", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15, height: 1.6))
    ]
  );

  Widget _buildPremiumDetailsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Elite Profile", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10, crossAxisSpacing: 10,
          childAspectRatio: 2.4,
          children: [
            _gridItem(Iconsax.user, "Gender", widget.profiledata.gender.name),
            if(widget.profiledata.interestedGender != null) _gridItem(Iconsax.heart_search, "Seeking", widget.profiledata.interestedGender!),
            if(widget.profiledata.education.name.isNotEmpty) _gridItem(Iconsax.teacher, "Education", widget.profiledata.education.name),
            if(widget.profiledata.job != null) _gridItem(Iconsax.briefcase, "Work", widget.profiledata.job!),
            _gridItem(Iconsax.ruler, "Height", "${widget.profiledata.height ?? '170'} cm"),
            _gridItem(Iconsax.home, "Lives in", widget.profiledata.city ?? "Nearby"),
          ],
        ),
      ],
    );
  }

  Widget _gridItem(IconData icon, String label, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.05))),
    child: Row(children: [Icon(icon, color: AppColors.neonGold, size: 18), const SizedBox(width: 10), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)), Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis))]))]),
  );

  Widget _buildLifestyleSection() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Lifestyle", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 16), Wrap(spacing: 12, runSpacing: 12, children: [if (widget.profiledata.smokingHabit != null) _lifeChip("🚬", widget.profiledata.smokingHabit!), if (widget.profiledata.drinkingHabit != null) _lifeChip("🍻", widget.profiledata.drinkingHabit!)])]);

  Widget _lifeChip(String e, String v) => Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(e, style: const TextStyle(fontSize: 18)), const SizedBox(width: 10), Text(v, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))]));

  Widget _buildInterestsSection() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Interests", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 16), Wrap(spacing: 10, runSpacing: 10, children: widget.profiledata.interests.map((i) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(15)), child: Text("${i.emoji} ${i.name}", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)))).toList())]);

  Widget _buildGallerySection() {
    final photos = widget.profiledata.photos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gallery", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 450,
          child: PageView.builder(
            itemCount: photos.length,
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _openGallery(photos, index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28), 
                  image: DecorationImage(image: NetworkImage(photos[index].photoUrl), fit: BoxFit.cover)
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: List.generate(photos.length, (index) => AnimatedContainer(
            duration: 300.ms, 
            margin: const EdgeInsets.symmetric(horizontal: 3), 
            height: 4, 
            width: _currentImageIndex == index ? 24 : 8, 
            decoration: BoxDecoration(color: _currentImageIndex == index ? AppColors.neonGold : Colors.white24, borderRadius: BorderRadius.circular(10))
          ))
        ),
      ],
    );
  }

  Widget _buildPrivateVaultSection() {
    final privatePhotos = widget.profiledata.privatePhotos;
    if (privatePhotos.isEmpty && widget.profiledata.privatePhotoCount == 0) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Private Vault", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Icon(Iconsax.lock, color: AppColors.neonGold, size: 18),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: privatePhotos.isNotEmpty ? privatePhotos.length : widget.profiledata.privatePhotoCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            bool isLocked = !widget.match;
            return GestureDetector(
              onTap: () {
                if (!isLocked) {
                  _openGallery(privatePhotos, index);
                } else {
                  _showPremiumUpgrade();
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (privatePhotos.isNotEmpty) 
                      Image.network(privatePhotos[index].photoUrl, fit: BoxFit.cover)
                    else 
                      Container(color: Colors.white10),
                    if (isLocked)
                      Positioned.fill(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.4),
                              child: const Icon(Iconsax.lock, color: Colors.white, size: 24),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionDock() {
    return Consumer<PermissionProvider>(
      builder: (context, perm, _) {
        final bool isPremium = perm.permissions?.isPremium ?? false;
        final bool canLike = perm.canLike;
        return Positioned(
          bottom: 30, left: 20, right: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.white.withOpacity(0.1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionBtn(Iconsax.close_circle, Colors.white, () => _onInteraction('pass')),
                    _actionBtn(Iconsax.message_text5, (widget.match || isPremium) ? AppColors.neonGold : Colors.white24, () { if (!widget.match && !isPremium) _showPremiumUpgrade(); }),
                    _actionBtn(Iconsax.video5, isPremium ? Colors.white : Colors.white24, () { if (!isPremium) _showPremiumUpgrade(); }),
                    if (!widget.match)
                      GestureDetector(
                        onTap: () => _onInteraction('like'),
                        child: Container(
                          height: 60, width: 60,
                          decoration: BoxDecoration(
                            gradient: canLike 
                              ? const LinearGradient(colors: [AppColors.neonGold, Color(0xFFFFB300)])
                              : LinearGradient(colors: [Colors.grey.shade700, Colors.grey.shade900]), 
                            shape: BoxShape.circle, 
                            boxShadow: [BoxShadow(color: canLike ? AppColors.neonGold.withOpacity(0.3) : Colors.black, blurRadius: 15)]
                          ),
                          child: Icon(canLike ? Iconsax.heart5 : Iconsax.lock, color: canLike ? Colors.black : Colors.white54, size: 30),
                        ),
                      ),
                    if (widget.match) _actionBtn(Iconsax.user_remove, Colors.redAccent, () {}),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap, 
    child: Container(height: 52, width: 52, decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle), child: Icon(icon, color: color, size: 24))
  );

  Widget _glassBadge(String t, {IconData? icon, Color? color}) => ClipRRect(
    borderRadius: BorderRadius.circular(20), 
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), 
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)), 
        child: Row(mainAxisSize: MainAxisSize.min, children: [if (icon != null) ...[Icon(icon, color: color ?? Colors.white, size: 10), const SizedBox(width: 6)], Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10))])
      )
    )
  );

  Widget _glassIcon(IconData i, VoidCallback o) => GestureDetector(
    onTap: o, 
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15), 
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
        child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)), child: Icon(i, color: Colors.white, size: 20))
      )
    )
  );
}

// --- SUPPORTING WIDGETS ---

class FullScreenGallery extends StatefulWidget {
  final List<Photo> photos;
  final int initialIndex;
  const FullScreenGallery({super.key, required this.photos, required this.initialIndex});

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            itemBuilder: (context, index) => InteractiveViewer(
              child: Center(child: Image.network(widget.photos[index].photoUrl, fit: BoxFit.contain))
            ),
          ),
          Positioned(
            top: 50, left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: const Icon(Iconsax.close_circle5, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;
  _ProgressClipper(this.progress);
  @override Rect getClip(Size size) => Rect.fromLTRB(0, 0, size.width * progress, size.height);
  @override bool shouldReclip(_ProgressClipper oldClipper) => oldClipper.progress != progress;
}