import 'package:dating/main.dart';
import 'package:dating/pages/registration%20pages/gender_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DateOfBirthPage extends StatefulWidget {
  @override
  _DateOfBirthPageState createState() => _DateOfBirthPageState();
}

class _DateOfBirthPageState extends State<DateOfBirthPage> {
  DateTime? _selectedDate;
  bool _isLoading = false;
  int _age = 0;

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
            padding: const EdgeInsets.all(26),
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
                  'When\'s your birthday?',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                const SizedBox(height: 8),
        
                // Description
                Text(
                  'Your age will be shown on your profile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
        
                // Date Picker Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedDate != null 
                          ? AppColors.neonGold.withOpacity(0.3)
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color:  Colors.black.withOpacity(0.3),
                  ),
                  child: TextButton(
                    onPressed: _pickDate,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.calendar_1,
                          color: AppColors.neonGold,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Select your date of birth',
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedDate != null ? Colors.white : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
        
                // Age Display
                if (_selectedDate != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.neonGold.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.neonGold.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.cake,
                          color: AppColors.neonGold,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'You are $_age years old',
                          style: TextStyle(
                            color: AppColors.neonGold,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
        
                // Note
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.3) ,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Iconsax.info_circle,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You must be at least 18 years old to use Weekend',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                const Spacer(),
        
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedDate != null && _age >= 18 ? _continue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(mainAxisAlignment: MainAxisAlignment.center,
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
Future<void> _pickDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)), // Default to 20 years ago
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    selectableDayPredicate: (DateTime date) {
      // Allow all days to be selectable
      return true;
    },
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: AppColors.neonGold,
            onPrimary: Colors.black,
            surface: AppColors.deepBlack,
            onSurface: Colors.white,
            background: AppColors.cardBlack,
            surfaceVariant: Colors.grey.shade800,
            secondary: AppColors.neonGold.withOpacity(0.3),
            outline: Colors.grey.shade700,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.deepBlack,
            surfaceTintColor: Colors.transparent,
            elevation: 24,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: AppColors.neonGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            shadowColor: AppColors.neonGold.withOpacity(0.2),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            bodyLarge: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16,
            ),
            labelLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.neonGold,
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              elevation: 3,
              shadowColor: AppColors.neonGold.withOpacity(0.5),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.neonGold.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.neonGold,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade900.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          dividerTheme: DividerThemeData(
            color: Colors.grey.shade700,
            thickness: 0.5,
            space: 0,
          ),
          cardTheme: CardThemeData(
            color: AppColors.cardBlack,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Colors.grey.shade700,
                width: 0.5,
              ),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: AppColors.neonGold.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child:  child!,
        ),
      );
    },
  );
  
  if (picked != null) {
    final now = DateTime.now();
    final age = now.year - picked.year;
    
    // Check if birthday has occurred this year
    final hasBirthdayOccurred = now.month > picked.month || 
        (now.month == picked.month && now.day >= picked.day);
    
    final actualAge = hasBirthdayOccurred ? age : age - 1;
    
    setState(() {
      _selectedDate = picked;
      _age = actualAge;
    });
    
    // Show age confirmation snackbar
    if (actualAge < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Icon(Iconsax.warning_2, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You must be 18+ years old to use this app',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
     
    }
  }
}
  void _continue() {
    if (_selectedDate == null || _age < 18) return;
    
    // Navigate to Gender page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenderPage(),
      ),
    );
  }
}