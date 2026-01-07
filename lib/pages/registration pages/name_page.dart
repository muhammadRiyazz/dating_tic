import 'package:dating/main.dart';
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

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
          decoration: BoxDecoration(  gradient: LinearGradient(
                    colors: [
                      AppColors.neonGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
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
                        color: AppColors.neonGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Iconsax.arrow_left_2,
                          color: AppColors.neonGold,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
           ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              Colors.white,
                              AppColors.neonGold,
                            ],
                            stops: const [0.7, 1.0],
                          ).createShader(bounds);
                        },
                        child: Text(
                  'What\'s your name?',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                // Title
             
                const SizedBox(height: 8),
        
                // Description
                Text(
                  'This is how you\'ll appear on Weekend',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
        
                // Name Input Field
           Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(
        color: 
             AppColors.neonGold.withOpacity(0.3)
           ,
        width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            color:  Colors.black.withOpacity(0.3) 
          ),
          child: TextField(
            controller: _nameController,
            autofocus: true,
            style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
        hintText: 'Enter your full name',
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
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
          color: AppColors.neonGold,
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
                    color: Colors.grey.shade400,
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
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        :  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Iconsax.arrow_right_3,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
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