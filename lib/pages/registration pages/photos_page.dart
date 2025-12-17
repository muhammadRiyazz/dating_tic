import 'package:dating/main.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  bool _isLoading = false;
  bool _isUploading = false;
  
  final int _minPhotos = 2;
  final int _maxPhotos = 4;

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= _maxPhotos) return;
    
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Iconsax.camera, color: const Color(0xFFFF3B30)),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Iconsax.gallery, color: const Color(0xFFFF3B30)),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
                        'Add Photos',
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
                        'Add at least $_minPhotos photos to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: hintColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                
                      // Fixed 4 Photo Boxes (2x2 Grid)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          if (index < _selectedImages.length) {
                            // Filled photo box
                            final isFirstPhoto = index == 0;
                            
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: FileImage(_selectedImages[index]),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark 
                                        ? Colors.black.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // First Photo Badge
                                  if (isFirstPhoto)
                                    Positioned(
                                      top: 12,
                                      left: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryRed,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Main',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  
                                  // Remove Button
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Iconsax.close_circle,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Empty photo box (Add button)
                            return GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? Colors.black.withOpacity(0.3) 
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: primaryRed.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Iconsax.add,
                                        color: primaryRed,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: primaryRed,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                
                      const SizedBox(height: 24),
                
                      // Photo Counter & Warning
                      Column(
                        children: [
                          Text(
                            '${_selectedImages.length}/$_maxPhotos photos added',
                            style: TextStyle(
                              fontSize: 14,
                              color: hintColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          if (_selectedImages.length < _minPhotos)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.info_circle,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Add at least $_minPhotos photos to continue',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                
                      const SizedBox(height: 24),
                
                      // Photo Tips
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryRed.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryRed.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.like_shapes,
                                  color: primaryRed,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Photo Tips',
                                  style: TextStyle(
                                    color: primaryRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• Add clear, recent photos\n• Include photos showing your face\n• Smiling photos get 40% more likes\n• Add variety to show your personality',
                              style: TextStyle(
                                color: hintColor,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                
                      const SizedBox(height: 40),
                
                      // Upload & Continue Button
                    
                    ],
                  ),
                ),
              ),  SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                          
                          //  _selectedImages.length >= _minPhotos && !_isUploading
                          //     ? 
                              _uploadAndContinue,
                              // : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading || _isUploading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              :
                               Text(

                                  // _selectedImages.length < _minPhotos
                                  //     ? 'Add $_minPhotos Photos'
                                     // :
                                       'Complete Registration',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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

  void _uploadAndContinue() async {
    // if (_selectedImages.length < _minPhotos) return;
    
    setState(() {
      _isUploading = true;
    });
    
    // Simulate image upload
    for (int i = 0; i < _selectedImages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    
    setState(() {
      _isUploading = false;
      _isLoading = true;
    });
    
    // Complete registration
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isLoading = false);
    
    // Navigate to Home/Main screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DatingHomePage(),
      ),
    );
  }
}