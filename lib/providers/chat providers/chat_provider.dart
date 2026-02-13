import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dating/models/media_model.dart.dart';
import 'package:dating/models/message_models.dart';
import 'package:dating/services/chat_media_service.dart';
import 'package:dating/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final MediaService _mediaService = MediaService();
  
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isPaused = false;
  

  bool get isPaused => _isPaused;


  // Typing indicator
  bool _isTyping = false;
  Timer? _typingTimer;
  
  // Media selection
  List<MediaModel> _selectedMedia = [];
  bool _isRecording = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  
  // Reply functionality
  MessageModel? _replyToMessage;
  
  // View once
  bool _isViewOnce = false;
  
  // Upload progress
  Map<String, double> _uploadProgress = {};
  
  // Message actions
  MessageModel? _selectedMessage;
  
  // Getters
  bool get isTyping => _isTyping;
  List<MediaModel> get selectedMedia => _selectedMedia;
  bool get isRecording => _isRecording;
  Duration get recordingDuration => _recordingDuration;
  MessageModel? get replyToMessage => _replyToMessage;
  bool get isViewOnce => _isViewOnce;
  Map<String, double> get uploadProgress => _uploadProgress;
  MessageModel? get selectedMessage => _selectedMessage;

  // Typing indicator
  void onTextChanged(String chatId, String userId, String text) {
    if (text.isNotEmpty && !_isTyping) {
      _startTyping(chatId, userId);
    }
    
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _stopTyping(chatId, userId);
    });
  }

  void _startTyping(String chatId, String userId) {
    _isTyping = true;
    _chatService.setTypingStatus(chatId, userId, true);
    notifyListeners();
  }

  void _stopTyping(String chatId, String userId) {
    _isTyping = false;
    _chatService.setTypingStatus(chatId, userId, false);
    notifyListeners();
  }

  // Media selection
  Future<void> pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    
    for (var image in images) {
      final file = File(image.path);
      _selectedMedia.add(MediaModel.fromFile(file, MediaType.image));
    }
    notifyListeners();
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    
    if (photo != null) {
      _selectedMedia.add(MediaModel.fromFile(File(photo.path), MediaType.image));
      notifyListeners();
    }
  }

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    
    if (video != null) {
      _selectedMedia.add(MediaModel.fromFile(File(video.path), MediaType.video));
      notifyListeners();
    }
  }

  Future<void> recordVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.camera);
    
    if (video != null) {
      _selectedMedia.add(MediaModel.fromFile(File(video.path), MediaType.video));
      notifyListeners();
    }
  }

  void removeMedia(String id) {
    _selectedMedia.removeWhere((media) => media.id == id);
    notifyListeners();
  }

  void clearMedia() {
    _selectedMedia.clear();
    notifyListeners();
  }
  // Pause recording
  Future<void> pauseRecording() async {
    try {
      await _audioRecorder.pause();
      _isPaused = true;
      _recordingTimer?.cancel();
      notifyListeners();
    } catch (e) {
      log('Error pausing recording: $e');
    }
  }
 Future<void> resumeRecording() async {
    try {
      await _audioRecorder.resume();
      _isPaused = false;
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordingDuration = Duration(seconds: _recordingDuration.inSeconds + 1);
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      log('Error resuming recording: $e');
    }
  }



    Future<void> stopRecording({
    required String chatId,
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      
      if (path != null && path.isNotEmpty) {
        _recordingPath = path;
        
        // Send the voice message
        await _sendVoiceMessage(chatId, senderId, receiverId);
      }
      
      _resetRecording();
      notifyListeners();
    } catch (e) {
      log('Error stopping recording: $e');
      _resetRecording();
    }
  }


  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.stop();
      // Delete the recording file if it exists
      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      log('Error canceling recording: $e');
    } finally {
      _resetRecording();
    }
  }
 void _resetRecording() {
    _isRecording = false;
    _isPaused = false;
    _recordingDuration = Duration.zero;
    _recordingPath = null;
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  // Voice recording
 Future<void> startRecording() async {
    try {
      // Check and request permission
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        // Handle permission denied
        return;
      }

      // Get temporary directory for recording
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      
      // Start recording
      await _audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
      
      _recordingPath = path;
      _isRecording = true;
      _isPaused = false;
      _recordingDuration = Duration.zero;
      
      // Start timer
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordingDuration = Duration(seconds: _recordingDuration.inSeconds + 1);
        notifyListeners();
      });
      
      notifyListeners();
    } catch (e) {
      log('Error starting recording: $e');
    }
  }

  // Update _sendVoiceMessage method
  Future<void> _sendVoiceMessage(String chatId, String senderId, String receiverId) async {
    if (_recordingPath == null) return;
    
    try {
      final file = File(_recordingPath!);
      if (!await file.exists()) return;
      
      final messageId = _chatService.generateMessageId();
      _uploadProgress[messageId] = 0.0;
      notifyListeners();

      final message = MessageModel(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
        text: '🎤 Voice message',
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
        type: MessageType.audio,
        mediaUrls: [],
        metadata: {
          'duration': _recordingDuration.inSeconds,
          'waveform': _generateWaveform(), // You can implement this
        },
        replyToId: _replyToMessage?.messageId,
        uploadProgress: 0.0,
      );

      // Upload with progress
      await _chatService.sendMediaMessage(
        chatId: chatId,
        message: message,
        file: file,
        onProgress: (progress) {
          _uploadProgress[messageId] = progress;
          notifyListeners();
        },
      );

      _uploadProgress.remove(messageId);
      
      // Clean up the recording file after successful upload
      await file.delete();
      
    } catch (e) {
      log('Error sending voice message: $e');
    } finally {
      _recordingPath = null;
      _recordingDuration = Duration.zero;
    }
  }

  // Helper to generate waveform data (simplified)
  List<int> _generateWaveform() {
    // This would normally analyze the audio file
    // For now, return dummy waveform
    return [10, 20, 30, 25, 40, 35, 45, 30, 25, 35];
  }

  // Reply functionality
  void setReplyTo(MessageModel message) {
    _replyToMessage = message;
    notifyListeners();
  }

  void clearReply() {
    _replyToMessage = null;
    notifyListeners();
  }

  // View once
  void toggleViewOnce() {
    _isViewOnce = !_isViewOnce;
    notifyListeners();
  }

  // Send message with media
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    String text = '',
  }) async {
    if (text.isEmpty && _selectedMedia.isEmpty && _recordingPath == null) return;

    // Handle view once media
    if (_isViewOnce && _selectedMedia.isNotEmpty) {
      await _sendViewOnceMedia(chatId, senderId, receiverId);
    } 
    // Handle normal media
    else if (_selectedMedia.isNotEmpty) {
      await _sendMediaMessages(chatId, senderId, receiverId, text);
    }
    // Handle voice message
    else if (_recordingPath != null) {
      await _sendVoiceMessage(chatId, senderId, receiverId);
    }
    // Handle text message
    else {
      await _sendTextMessage(chatId, senderId, receiverId, text);
    }

    clearMedia();
    clearReply();
    _isViewOnce = false;
  }

  Future<void> _sendTextMessage(String chatId, String senderId, String receiverId, String text) async {
    final message = MessageModel(
      messageId: '',
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      type: MessageType.text,
      replyToId: _replyToMessage?.messageId,
    );

    await _chatService.sendMessage(chatId, message);
  }

  Future<void> _sendMediaMessages(String chatId, String senderId, String receiverId, String text) async {
    for (var media in _selectedMedia) {
      final messageId = _chatService.generateMessageId();
      _uploadProgress[messageId] = 0.0;
      notifyListeners();

      final message = MessageModel(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
        text: text,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
        type: media.type == MediaType.image ? MessageType.image : MessageType.video,
        mediaUrls: [],
        replyToId: _replyToMessage?.messageId,
        uploadProgress: 0.0,
      );

      // Upload with progress
      await _chatService.sendMediaMessage(
        chatId: chatId,
        message: message,
        file: media.file,
        onProgress: (progress) {
          _uploadProgress[messageId] = progress;
          notifyListeners();
        },
      );

      _uploadProgress.remove(messageId);
      notifyListeners();
    }
  }


  Future<void> _sendViewOnceMedia(String chatId, String senderId, String receiverId) async {
    for (var media in _selectedMedia) {
      final message = MessageModel(
        messageId: '',
        senderId: senderId,
        receiverId: receiverId,
        text: '📷 View once media',
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
        type: MessageType.viewOnce,
        mediaUrls: [],
        viewOnceData: {
          'viewed': false,
          'viewedAt': null,
          'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
        },
      );

      await _chatService.sendMediaMessage(
        chatId: chatId,
        message: message,
        file: media.file,
      );
    }
  }

  // Message actions
  void selectMessage(MessageModel message) {
    _selectedMessage = message;
    notifyListeners();
  }

  void clearSelectedMessage() {
    _selectedMessage = null;
    notifyListeners();
  }

  Future<void> deleteMessage(String chatId, MessageModel message) async {
    await _chatService.deleteMessage(chatId, message.messageId);
  }

  Future<void> addReaction(String chatId, String messageId, String reaction) async {
    await _chatService.addReaction(chatId, messageId, reaction);
  }

  Future<void> forwardMessage(String chatId, MessageModel message, String targetChatId) async {
    await _chatService.forwardMessage(chatId, message, targetChatId);
  }

  @override
  @override
  void dispose() {
    _typingTimer?.cancel();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }
}
