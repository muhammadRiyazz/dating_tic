// import 'package:dating/pages/intro_page.dart';
// import 'package:flutter/material.dart';

// class DatingIntroScreen extends StatelessWidget {
//   const DatingIntroScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF2A0707), // exact deep wine-red bottom
//                             Color(0xFF0A0505), // exact dark black-red top

//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 40),

//               /// APP NAME
//               const Text(
//                 "Connexa",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 26,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),

//               const SizedBox(height: 50),

//               /// CARDS
//               Expanded(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     /// LEFT CARD
//                     Positioned(
//                       left: 40,
//                       top: 40,
//                       child: Transform.rotate(
//                         angle: -0.15,
//                         child: ProfileCard(
//                           name: "Jason",
//                           age: "24",
//                           location: "New York",
//                           imageUrl:
//                           "https://images.unsplash.com/photo-1500648767791-00dcc994a43e"    

//                         ),
//                       ),
//                     ),

//                     /// RIGHT CARD
//                     Positioned(
//                       right: 40,
//                       bottom: 40,
//                       child: Transform.rotate(
//                         angle: 0.12,
//                         child: ProfileCard(
//                           name: "Julia",
//                           age: "27",
//                           location: "Los Angeles",
//                           imageUrl:
// "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e"
//                     ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 10),

//               /// TITLE
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: const TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "Find Your\n",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 32,
//                         height: 1.2,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "Perfect Match",
//                       style: TextStyle(
//                         color: Color(0xFFFF3B30), // exact red
//                         fontSize: 32,
//                         height: 1.2,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 12),

//               /// SUBTEXT
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 32),
//                 child: Text(
//                   "Meet New People, Spark Real Connections, And See Where It Goes.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xFFD7D7D7),
//                     fontSize: 16,
//                     height: 1.3,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 32),

//               /// BUTTON
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: SizedBox(
//                   height: 55,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF3B30),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: () {

//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return IntroPage();
//                       },));
//                     },
//                     child: const Text(
//                       "Get Started",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// PROFILE CARD --------------------------------------------
// class ProfileCard extends StatelessWidget {
//   final String name;
//   final String age;
//   final String location;
//   final String imageUrl;

//   const ProfileCard({
//     required this.name,
//     required this.age,
//     required this.location,
//     required this.imageUrl,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 190,
//       height: 260,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(22),
//         color: const Color(0xFF4A1A1A), // dark card red tint
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.55),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           )
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(22),
//         child: Stack(
//           children: [
//             /// IMAGE
//             Positioned.fill(
//               child: Image.network(imageUrl, fit: BoxFit.cover),
//             ),

//             /// GRADIENT BOTTOM
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.black.withOpacity(0.75),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             /// NAME & LOCATION
//             Positioned(
//               left: 12,
//               bottom: 14,
//               child: Text(
//                 "$name, $age\n$location",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 17,
//                   height: 1.2,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),

//             /// HEART ICON
//             Positioned(
//               bottom: 12,
//               right: 12,
//               child: CircleAvatar(
//                 radius: 18,
//                 backgroundColor: const Color(0xFFFF3B30),
//                 child: const Icon(Icons.favorite, color: Colors.white, size: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:dating/Theme/theme_provider.dart';
import 'package:dating/main.dart';
import 'package:dating/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatingIntroScreen extends StatefulWidget {
  const DatingIntroScreen({super.key});

  @override
  State<DatingIntroScreen> createState() => _DatingIntroScreenState();
}

class _DatingIntroScreenState extends State<DatingIntroScreen> {
  double _rotationAngle = 0.0;
  final List<double> _cardOffsets = [0.0, 0.0];
  final List<Alignment> _cardAlignments = [
    Alignment.centerLeft,
    Alignment.centerRight
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _rotationAngle = 0.1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2A0707), // deep wine-red bottom
                                        Color(0xFF0A0505), // dark black-red top

                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFF0F0), // light pink top
                    Color(0xFFFFE6E6), // light red bottom
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// APP NAME
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
                 
              //     Text(
              //       "MatchFindr",
              //       style: TextStyle(
              //         color: isDarkMode ? Colors.white : const Color(0xFF2A0707),
              //         fontSize: 23,
              //         fontWeight: FontWeight.w800,
              //         letterSpacing: 1.5,
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 40),

              /// ANIMATED CARDS
            
              /// CARDS
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// LEFT CARD
                    Positioned(
                      left: 40,
                      top: 40,
                      child: Transform.rotate(
                        angle: -0.15,
                        child: ProfileCard(
                          name: "Jason",
                          age: "24",
                          location: "New York",
                          imageUrl:
                          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e"    ,
isDarkMode: isDarkMode,
                        ),
                      ),
                    ),

                    /// RIGHT CARD
                    Positioned(
                      right: 40,
                      bottom: 40,
                      child: Transform.rotate(
                        angle: 0.12,
                        child: ProfileCard(
                          isDarkMode: isDarkMode,
                          name: "Julia",
                          age: "27",
                          location: "Los Angeles",
                          imageUrl:
"https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                    ),
                      ),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 20),

              /// TITLE
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Find Your\n",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF2A0707),
                        fontSize: 36,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: "Perfect Match",
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFFFF3B30)
                            : Colors.red.shade700,
                        fontSize: 36,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// SUBTEXT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Swipe, Match, and Connect with Amazing People Nearby",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFFD7D7D7)
                        : Colors.grey.shade700,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    /// GET STARTED BUTTON
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B30),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.red.withOpacity(0.5),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => 
                              // DatingHomePage
                               DatingHomePage(),
                            ),
                          );
                        },
                        child: const Text(
  "Get Started",                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // / THEME TOGGLE
                    // Container(
                    //   width: 200,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: isDarkMode
                    //         ? Colors.black.withOpacity(0.3)
                    //         : Colors.white.withOpacity(0.5),
                    //     borderRadius: BorderRadius.circular(15),
                    //     border: Border.all(
                    //       color: isDarkMode
                    //           ? Colors.white24
                    //           : Colors.red.shade100,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Icon(
                    //         Icons.light_mode,
                    //         color: !isDarkMode
                    //             ? Colors.orange.shade700
                    //             : Colors.grey.shade400,
                    //       ),
                    //       Switch(
                    //         value: isDarkMode,
                    //         onChanged: (value) {
                    //           themeProvider.toggleTheme();
                    //         },
                    //         activeColor: Colors.red,
                    //         inactiveTrackColor: Colors.grey.shade300,
                    //       ),
                    //       Icon(
                    //         Icons.dark_mode,
                    //         color: isDarkMode
                    //             ? Colors.indigo.shade300
                    //             : Colors.grey.shade400,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// PROFILE CARD --------------------------------------------
class ProfileCard extends StatelessWidget {
  final String name;
  final String age;
  final String location;
  final String imageUrl;
  final bool isDarkMode;

  const ProfileCard({
    required this.name,
    required this.age,
    required this.location,
    required this.imageUrl,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isDarkMode
              ? const Color(0xFF4A1A1A)
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.6)
                  : Colors.red.shade100,
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: -5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              /// IMAGE
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      // color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                      // child: Center(
                      //   child: CircularProgressIndicator(
                      //     color: Colors.red,
                      //   ),
                      // ),
                    );
                  },
                ),
              ),

              /// GRADIENT OVERLAY
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        isDarkMode
                            ? Colors.black.withOpacity(0.8)
                            : Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),

              /// MATCH PERCENTAGE BADGE
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      const Text(
                        "86%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// PROFILE INFO
              Positioned(
                left: 15,
                bottom: 15,
                right: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name, $age",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withOpacity(0.8),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// LIKE BUTTON
              Positioned(
                bottom: 15,
                right: 15,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}