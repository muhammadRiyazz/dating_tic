import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dating/services/agora_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


// --- NEW FULL SCREEN CALL WIDGET ---
class CallScreen extends StatefulWidget {
  final String channelName;
  final bool isVideo;
  final String remoteUserName;

  const CallScreen({
    super.key,
    required this.channelName,
    required this.isVideo,
    required this.remoteUserName,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraService _agoraService = AgoraService();
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    initCall();
  }

  Future<void> initCall() async {
    await _agoraService.initAgora(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() => _remoteUid = null);
          Navigator.pop(context);
        },
      ),
    );
    // Use your token logic here. Passing null defaults to AppID only (Testing mode)
    await _agoraService.joinCall(widget.channelName, null, widget.isVideo);
  }

  @override
  void dispose() {
    _agoraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _viewRows(),
          _toolbar(),
        ],
      ),
    );
  }

  Widget _viewRows() {
    if (widget.isVideo) {
      return Stack(
        children: [
          _remoteVideo(),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 120, height: 180,
              child: _localUserJoined
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _agoraService.engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Iconsax.user, size: 50)),
            const SizedBox(height: 20),
            Text(widget.remoteUserName, style: const TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 10),
            Text(_remoteUid == null ? "Calling..." : "On Call", style: const TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _agoraService.engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return Center(child: Text("Calling ${widget.remoteUserName}...", style: const TextStyle(color: Colors.white)));
    }
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {
              setState(() => _muted = !_muted);
              _agoraService.engine.muteLocalAudioStream(_muted);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: _muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(_muted ? Icons.mic_off : Icons.mic, color: _muted ? Colors.white : Colors.blueAccent, size: 20.0),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(Icons.call_end, color: Colors.white, size: 35.0),
          ),
          if (widget.isVideo)
            RawMaterialButton(
              onPressed: () => _agoraService.engine.switchCamera(),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(Icons.switch_camera, color: Colors.blueAccent, size: 20.0),
            ),
        ],
      ),
    );
  }
}