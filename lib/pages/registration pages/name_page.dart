import 'package:dating/pages/registration%20pages/date_of_birth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

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
                'What\'s your name?',
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
                'This is how you\'ll appear on Weekend',
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Name Input Field
         Container(
  height: 56,
  decoration: BoxDecoration(
    border: Border.all(
      color: _nameController.text.isNotEmpty 
          ? primaryRed.withOpacity(0.3)
          : borderColor,
      width: 1.5,
    ),
    borderRadius: BorderRadius.circular(12),
    color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
  ),
  child: TextField(
    controller: _nameController,
    autofocus: true,
    style: TextStyle(
      fontSize: 18,
      color: textColor,
      fontWeight: FontWeight.w500,
    ),
    decoration: InputDecoration(
      hintText: 'Enter your full name',
      hintStyle: TextStyle(
        color: hintColor,
        fontSize: 16,
      ),
      border: InputBorder.none,
      // Adjust vertical padding to center
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18, // Adjust this value as needed
      ),
      prefixIcon: Icon(
        Iconsax.user,
        color: primaryRed,
        size: 20,
      ),
    ),
    onChanged: (value) {
      setState(() {});
    },
  ),
),
              const SizedBox(height: 16),

              // Note
              Text(
                'Use your real name for better matches',
                style: TextStyle(
                  fontSize: 13,
                  color: hintColor,
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().length >= 2 ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
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
                      : Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _continue() async {
    if (_nameController.text.trim().length < 2) return;
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    // Navigate to Date of Birth page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateOfBirthPage(),
      ),
    );
  }
}