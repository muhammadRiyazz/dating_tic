import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

// class AgoraService {
//   static const String appId = "6d9c58b1baba408d83be44b0e7467815";
//   late RtcEngine engine;

//   // Initialize the engine
//   Future<void> initAgora({required RtcEngineEventHandler handler}) async {
//     // 1. Request Permissions
//     await [Permission.microphone, Permission.camera].request();

//     // 2. Create Engine
//     engine = createAgoraRtcEngine();
//     await engine.initialize(
//       const RtcEngineContext(
//         appId: appId,
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ),
//     );

//     // 3. Register Event Handlers (passed from the UI)
//     engine.registerEventHandler(handler);
//   }

//   // Join a channel for Video Call
//   Future<void> joinVideoCall(String channelName, String token) async {
//     await engine.enableVideo();
//     await engine.startPreview();
//     await engine.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: 0, // Agora assigns a random ID if set to 0
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         publishCameraTrack: true,
//         publishMicrophoneTrack: true,
//       ),
//     );
//   }

//   // Join a channel for Voice Call
//   Future<void> joinVoiceCall(String channelName, String token) async {
//     await engine.enableAudio();
//     await engine.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         publishCameraTrack: false, // Voice only
//         publishMicrophoneTrack: true,
//       ),
//     );
//   }

//   Future<void> leaveCall() async {
//     await engine.leaveChannel();
//     await engine.release();
//   }
// }


class AgoraService {
  static const String appId = "6d9c58b1baba408d83be44b0e7467815";
  late RtcEngine engine;

  Future<void> initAgora(RtcEngineEventHandler handler) async {
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    engine.registerEventHandler(handler);
  }

  Future<void> joinCall(String channel, String? token, bool isVideo) async {
    if (isVideo) {
      await engine.enableVideo();
      await engine.startPreview();
    } else {
      await engine.enableAudio();
    }

    await engine.joinChannel(
      token: token ?? "", // Ideally fetch from backend
      channelId: channel,
      uid: 0,
      options: ChannelMediaOptions(
        publishCameraTrack: isVideo,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }
}