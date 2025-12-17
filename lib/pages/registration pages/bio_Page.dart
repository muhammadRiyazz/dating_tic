import 'package:dating/pages/registration%20pages/photos_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BioPage extends StatefulWidget {
  @override
  _BioPageState createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  int _charCount = 0;
  final int _maxChars = 500;

  @override
  void initState() {
    super.initState();
    _bioController.addListener(() {
      setState(() {
        _charCount = _bioController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    final backgroundColor = isDark ? const Color(0xFF0A0505) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
                padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Iconsax.arrow_left_2,
                                color: primaryRed,
                                size: 24,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),
                
                      // Title
                      Text(
                        'About You',
                        style: TextStyle(
                          fontSize: 28,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                
                      // Description
                      Text(
                        'Tell others about yourself (optional)',
                        style: TextStyle(
                          fontSize: 16,
                          color: hintColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                
                      // Bio Input Container
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _bioController.text.isNotEmpty
                                ? primaryRed.withOpacity(0.3)
                                : borderColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Character Count
                            Padding(
                              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bio',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hintColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$_charCount/$_maxChars',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _charCount > _maxChars 
                                          ? Colors.red 
                                          : hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                
                            // Text Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: _bioController,
                                maxLines: 8,
                                maxLength: _maxChars,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                  height: 1.4,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Write about yourself, interests, what you\'re looking for...',
                                  hintStyle: TextStyle(
                                    color: hintColor,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                
                            // Suggestions
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? Colors.black.withOpacity(0.5) 
                                    : Colors.grey.shade100,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '💡 Suggestions:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: hintColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '• What are your passions?\n• What do you enjoy doing?\n• What are you looking for?',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: hintColor,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                
                      const SizedBox(height: 24),
                
                      // Optional Note
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryRed.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primaryRed.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              color: primaryRed,
                              size: 14,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'A good bio increases your matches by 40%',
                                style: TextStyle(
                                  color: hintColor,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                
                      const SizedBox(height: 40),
                
                   
                    ],
                  ),
                ),
              ),
                 // Continue Button (can skip)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _bioController.text.isEmpty
                                    ? 'Skip'
                                    : 'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
  }

  void _continue() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    // Navigate to Photos page (final step)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotosPage(),
      ),
    );
  }
}