import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class SocialConnectionScreen extends StatefulWidget {
  @override
  _SocialConnectionScreenState createState() => _SocialConnectionScreenState();
}

class _SocialConnectionScreenState extends State<SocialConnectionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];

  bool _inCall = false;

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection1;
  RTCPeerConnection? _peerConnection2;

  @override
  void initState() {
    super.initState();
    _initRenderers();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add(_messageController.text);
        _messageController.clear();
      });
    }
  }

  Future<void> _startCall() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    _peerConnection1 = await createPeerConnection(config);
    _peerConnection2 = await createPeerConnection(config);

    _localStream!.getTracks().forEach((track) {
      _peerConnection1!.addTrack(track, _localStream!);
    });

    _peerConnection1!.onIceCandidate = (candidate) {
      if (candidate != null) _peerConnection2!.addCandidate(candidate);
    };
    _peerConnection2!.onIceCandidate = (candidate) {
      if (candidate != null) _peerConnection1!.addCandidate(candidate);
    };

    _peerConnection2!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    RTCSessionDescription offer = await _peerConnection1!.createOffer();
    await _peerConnection1!.setLocalDescription(offer);
    await _peerConnection2!.setRemoteDescription(offer);

    RTCSessionDescription answer = await _peerConnection2!.createAnswer();
    await _peerConnection2!.setLocalDescription(answer);
    await _peerConnection1!.setRemoteDescription(answer);

    setState(() {
      _localRenderer.srcObject = _localStream;
      _inCall = true;
    });
  }

  Future<void> _stopCall() async {
    await _localStream?.dispose();
    await _peerConnection1?.close();
    await _peerConnection2?.close();
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;

    setState(() {
      _inCall = false;
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    _peerConnection1?.dispose();
    _peerConnection2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          if (_inCall)
            Expanded(
              child: Row(
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          Expanded(
            flex: _inCall ? 1 : 3,
            child: ListView(
              children: messages.map((msg) => ListTile(title: Text(msg))).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter your message...'),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
                IconButton(
                  icon: Icon(_inCall ? Icons.call_end : Icons.video_call),
                  color: _inCall ? Colors.red : Colors.green,
                  onPressed: _inCall ? _stopCall : _startCall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
