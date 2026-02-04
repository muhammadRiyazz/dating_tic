import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/location_Page.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class WorkEducationPage extends StatefulWidget {
  const WorkEducationPage({
    super.key,
    required this.userdata,
  });

  final UserRegistrationModel userdata;

  @override
  _WorkEducationPageState createState() => _WorkEducationPageState();
}

class _WorkEducationPageState extends State<WorkEducationPage> {
  final TextEditingController _jobController = TextEditingController();
  final FocusNode _jobFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _jobFocusNode.addListener(() => setState(() {}));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RegistrationDataProvider>();
      if (provider.educationStatus == DataLoadStatus.initial) {
        provider.loadEducationLevels();
      }
      if (provider.jobTitle != null) {
        _jobController.text = provider.jobTitle!;
      }
    });
  }

  @override
  void dispose() {
    _jobController.dispose();
    _jobFocusNode.dispose();
    super.dispose();
  }

  // VALIDATION & NAVIGATION
  void _continue() async {
    final provider = context.read<RegistrationDataProvider>();
    
    // Check if fields are empty
    final bool isJobEmpty = _jobController.text.trim().isEmpty;
    final bool isEduEmpty = provider.selectedEducationId == null;

    if (isJobEmpty || isEduEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isJobEmpty && isEduEmpty 
                ? 'Please fill in all required fields' 
                : (isJobEmpty ? 'Please enter your job title' : 'Please select your education'),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.neonGold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(20),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);
    
    final UserRegistrationModel data = widget.userdata.copyWith(
      job: _jobController.text.trim(),
      education: provider.selectedEducationId,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LocationRegistrationPage(userdata: data),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationDataProvider>();

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.neonGold.withOpacity(0.1), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                // HEADER (UNCHANGED)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.neonGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Iconsax.arrow_left_2, color: AppColors.neonGold, size: 24),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, AppColors.neonGold],
                    stops: const [0.4, 1.0],
                  ).createShader(bounds),
                  child: const Text(
                    'Work & Education',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Build your professional profile',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400, height: 1.5),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // JOB TITLE INPUT
                        _buildLabel("Job Title"),
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: AppColors.cardBlack.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _jobFocusNode.hasFocus ? AppColors.neonGold : Colors.white.withOpacity(0.1),
                              width: 1.5,
                            ),
                            boxShadow: _jobFocusNode.hasFocus 
                              ? [BoxShadow(color: AppColors.neonGold.withOpacity(0.1), blurRadius: 10)]
                              : [],
                          ),
                          child: TextField(
                            controller: _jobController,
                            // focusNode: _jobFocusNode,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "e.g. Creative Designer",
                              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              border: InputBorder.none,
                              prefixIcon: Icon(Iconsax.briefcase, color: _jobFocusNode.hasFocus ? AppColors.neonGold : Colors.grey, size: 20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // EDUCATION SELECTION
                        _buildLabel("Highest Education"),
                        const SizedBox(height: 12),
                        provider.educationLoading 
                        ? const Center(child: CircularProgressIndicator(color: AppColors.neonGold))
                        : Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBlack.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: provider.selectedEducationId,
                                isExpanded: true,
                                dropdownColor: AppColors.cardBlack,
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Icon(Iconsax.arrow_down_1, color: AppColors.neonGold, size: 20),
                                ),
                                hint: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Select your level", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                ),
                                items: provider.educationLevels.map((edu) {
                                  return DropdownMenuItem<String>(
                                    value: edu['eduId'].toString(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(edu['eduTitle'], style: const TextStyle(color: Colors.white, fontSize: 15)),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) => provider.selectEducation(val!),
                              ),
                            ),
                          ),

                        const SizedBox(height: 40),

                        // INFO BOX
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.neonGold.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.neonGold.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.verify, color: AppColors.neonGold, size: 20),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Verifying your career helps build trust within the community.',
                                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // CONTINUE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Continue', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                              SizedBox(width: 10),
                              Icon(Iconsax.arrow_right_3, size: 20),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Text("*", style: TextStyle(color: AppColors.neonGold, fontSize: 18)),
      ],
    );
  }
}