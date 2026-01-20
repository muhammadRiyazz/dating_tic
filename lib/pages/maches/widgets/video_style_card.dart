import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/maches/Match_Success_Screen.dart';
import 'package:dating/providers/interaction_provider.dart';
import 'package:dating/providers/likers_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class VideoStyleCard extends StatefulWidget {
  final Profile profile;
  const VideoStyleCard({super.key, required this.profile});

  @override
  State<VideoStyleCard> createState() => _VideoStyleCardState();
}

class _VideoStyleCardState extends State<VideoStyleCard> {
  double _yOffset = 0;
  bool _isTriggered = false;
  String _dragMode = ""; // "like" or "pass"

  int _calculateAge(String? dob) {
    if (dob == null) return 0;
    try {
      DateTime birth = DateTime.parse(dob);
      DateTime now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) age--;
      return age;
    } catch (e) { return 0; }
  }

  void _executeAction(String status) async {
    final interactionProv = context.read<InteractionProvider>();
    final likersProv = context.read<LikersProvider>();
    final myId = await AuthService().getUserId();

    if (status == 'like') {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.mediumImpact();
    }

    await interactionProv.handleAction(
      context: context,
      fromUser: myId.toString(),
      toUser: widget.profile.userId.toString(),
      status: status,
      onComplete: () {
        if (status == 'like') {
          Navigator.push(context, PageRouteBuilder(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, _, __) => MatchSuccessScreen(userImg: widget.profile.photo),
          ));
        }
        likersProv.removeLikerLocally(widget.profile.userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int age = _calculateAge(widget.profile.dateOfBirth);

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (_isTriggered) return;
        setState(() {
          _yOffset += details.delta.dy * 0.7;
          if (_yOffset > 20) _dragMode = "like";
          else if (_yOffset < -20) _dragMode = "pass";
          else _dragMode = "";

          if (_yOffset > 180) {
            _isTriggered = true;
            _executeAction('like');
          } else if (_yOffset < -180) {
            _isTriggered = true;
            _executeAction('pass');
          }
        });
      },
      onVerticalDragEnd: (_) {
        setState(() {
          _yOffset = 0;
          _dragMode = "";
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _yOffset, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(38),
          boxShadow: [
            if (_dragMode == "like")
              BoxShadow(color: Colors.pinkAccent.withOpacity(0.4), blurRadius: 40, spreadRadius: 5),
            if (_dragMode == "pass")
              BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 40, spreadRadius: 5),
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 15))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: Stack(
            children: [
              // 1. Profile Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: widget.profile.photo,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),

              // 2. Dark Premium Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 0.7, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Location Badge (Top Left)
              Positioned(
                top: 20,
                left: 20,
                child: _glassCapsule(
                  child: Row(
                    children: [
                      const Icon(Iconsax.location5, color: Colors.amber, size: 14),
                      const SizedBox(width: 5),
                      Text(widget.profile.city ?? "Nearby", 
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              // NEW: PASS Button Hint (Top Right)
              Positioned(
                top: 20,
                right: 20,
                child: _glassCapsule(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Iconsax.close_circle, color: Colors.white.withOpacity(0.6), size: 20),
                ),
              ),

              // 4. Content Area
              Positioned(
                bottom: 25, left: 20, right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${widget.profile.userName}, $age",
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                        const SizedBox(width: 8),
                        const Icon(Iconsax.verify5, color: Colors.blueAccent, size: 22),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(widget.profile.job ?? "Elite Member",
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    if (widget.profile.interests.isNotEmpty)
                      Wrap(
                        spacing: 6, runSpacing: 6,
                        children: widget.profile.interests.take(3).map((interest) {
                          return _glassCapsule(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Text("${interest.emoji} ${interest.name}", 
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 12),
                    Text(widget.profile.bio ?? "Let's connect and see where it goes...",
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, height: 1.4)),
                  ],
                ),
              ),

              // 5. Drag Overlay Feedback (The "Big Icons" on Drag)
              if (_yOffset.abs() > 30)
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    color: _dragMode == "like" 
                        ? Colors.pink.withOpacity((_yOffset / 500).clamp(0, 0.5))
                        : Colors.black.withOpacity((_yOffset.abs() / 500).clamp(0, 0.7)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                            ),
                            child: Icon(
                              _dragMode == "like" ? Iconsax.heart5 : Iconsax.close_circle5,
                              color: Colors.white,
                              size: 60 + (_yOffset.abs() / 4),
                            ),
                          ).animate().scale(curve: Curves.elasticOut),
                          const SizedBox(height: 15),
                          Text(
                            _dragMode == "like" ? "MATCH" : "PASS",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 5),
                          ).animate().fadeIn()
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassCapsule({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}