import 'dart:async';
import 'dart:io';
import 'dart:convert'; // Required for Base64 encoding
import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/LifestylePage.dart';
import 'package:dating/pages/registration%20pages/photos_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoicePromptPage extends StatefulWidget {
  const VoicePromptPage({super.key, required this.userdata});
  final UserRegistrationModel userdata;

  @override
  _VoicePromptPageState createState() => _VoicePromptPageState();
}

class _VoicePromptPageState extends State<VoicePromptPage> {
  late AudioRecorder _audioRecorder;
  late AudioPlayer _audioPlayer;
  
  String? _audioPath;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isProcessing = false; // To show loading while encoding
  int _recordDuration = 0;
  Timer? _timer;

  final List<String> _prompts = [
    "My go-to karaoke song is...",
    "A random fact I love is...",
    "The way to my heart is...",
    "My simple pleasures are...",
    "We'll get along if..."
  ];
  int _selectedPromptIndex = 0;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
    
    _audioPlayer.onPlayerComplete.listen((event) {
      debugPrint("🔊 Audio Playback: Completed");
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- Core Logic: Permissions ---
  Future<bool> _checkPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      status = await Permission.microphone.request();
      return status.isGranted;
    }
    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
      return false;
    }
    return status.isGranted;
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBlack,
        title: const Text("Microphone Access", style: TextStyle(color: Colors.white)),
        content: const Text("Microphone access is permanently denied. Please enable it in settings.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () { openAppSettings(); Navigator.pop(context); }, child: const Text("Settings")),
        ],
      ),
    );
  }

  // --- Core Logic: Recording ---
  Future<void> _startRecording() async {
    try {
      if (await _checkPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/voice_bio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        const config = RecordConfig(encoder: AudioEncoder.aacLc);
        await _audioRecorder.start(config, path: path);
        setState(() { _isRecording = true; _recordDuration = 0; _audioPath = null; });
        _startTimer();
      }
    } catch (e) { debugPrint("🚨 Error: $e"); }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();
    setState(() { _isRecording = false; _audioPath = path; });
  }

  Future<void> _togglePlayback() async {
    if (_audioPath == null) return;
    if (_isPlaying) { await _audioPlayer.pause(); } 
    else { await _audioPlayer.play(DeviceFileSource(_audioPath!)); }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _reRecord() async {
    if (_isPlaying) await _audioPlayer.stop();
    setState(() { _audioPath = null; _isPlaying = false; _recordDuration = 0; });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordDuration++);
      if (_recordDuration >= 30) _stopRecording();
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.neonGold.withOpacity(0.1), Colors.transparent],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildPromptCard(),
                const SizedBox(height: 20),
                Expanded(child: _buildMainRecorderUI()),
                _buildFooterInfo(),
                _buildContinueButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // (Header, PromptCard, MainRecorderUI, FooterInfo widgets remain the same...)
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Iconsax.arrow_left_2, color: AppColors.neonGold, size: 24),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Voice Intro', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
        const SizedBox(height: 5),
        Text('Profiles with voice notes get 40% more matches.', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      ],
    );
  }

  Widget _buildPromptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("PROMPT", style: TextStyle(color: AppColors.neonGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              if (!_isRecording && _audioPath == null)
                GestureDetector(
                  onTap: () => setState(() => _selectedPromptIndex = (_selectedPromptIndex + 1) % _prompts.length),
                  child: const Text("CHANGE", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(_prompts[_selectedPromptIndex], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMainRecorderUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(15, (index) => _buildWaveBar(index))),
        const SizedBox(height: 20),
        Text(_isRecording ? "Recording... ${_formatDuration(_recordDuration)}" : (_audioPath != null ? "Recording Ready" : "Tap microphone to speak"),
          style: const TextStyle(color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () { if (_isRecording) _stopRecording(); else if (_audioPath != null) _togglePlayback(); else _startRecording(); },
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _isRecording ? Colors.red : AppColors.neonGold, boxShadow: [BoxShadow(color: (_isRecording ? Colors.red : AppColors.neonGold).withOpacity(0.4), blurRadius: 25, spreadRadius: 5)]),
            child: Icon(_isRecording ? Iconsax.stop5 : (_audioPath != null ? (_isPlaying ? Iconsax.pause5 : Iconsax.play5) : Iconsax.microphone_2), size: 35, color: _isRecording ? Colors.white : Colors.black),
          ),
        ),
        if (_audioPath != null && !_isRecording) ...[
          const SizedBox(height: 30),
          TextButton.icon(onPressed: _reRecord, icon: const Icon(Iconsax.refresh, color: Colors.white54, size: 18), label: const Text("Delete & Re-record", style: TextStyle(color: Colors.white54)))
        ]
      ],
    );
  }

  Widget _buildWaveBar(int index) {
    return AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 2), width: 3, height: _isRecording ? (10.0 + (index % 5 * 10)) : 15, decoration: BoxDecoration(color: _isRecording ? Colors.red : (_audioPath != null ? AppColors.neonGold : Colors.white10), borderRadius: BorderRadius.circular(10)));
  }

  Widget _buildFooterInfo() {
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Iconsax.info_circle, color: AppColors.neonGold, size: 18), SizedBox(width: 12), Expanded(child: Text('Keep it under 30 seconds for best results.', style: TextStyle(color: Colors.white38, fontSize: 11)))]));
  }

  // --- ENCRYPTION LOGIC HERE ---
  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_audioPath != null && !_isProcessing) ? () async {
          setState(() => _isProcessing = true);

          try {
            // 1. Get File
            File audioFile = File(_audioPath!);
            
            // 2. Get Extension (e.g., "m4a")
            String extension = _audioPath!.split('.').last;

            // 3. Convert to Base64 (Encryption)
            List<int> audioBytes = await audioFile.readAsBytes();
            String base64Audio = base64Encode(audioBytes);

            debugPrint("🔒 Encryption Complete. Extension: $extension");

            // 4. Update Model
            final updatedData = widget.userdata.copyWith(
              voiceEncryption: base64Audio,
              voiceEncryptionExtension: extension,
            );

            // 5. Navigate
            if (mounted) {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PhotosPage(userdata: updatedData))
              );
            }
          } catch (e) {
            debugPrint("🚨 Error encoding audio: $e");
          } finally {
            if (mounted) setState(() => _isProcessing = false);
          }
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGold,
          disabledBackgroundColor: AppColors.neonGold.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _isProcessing 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
          : const Text('Continue', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black)),
      ),
    );
  }
}