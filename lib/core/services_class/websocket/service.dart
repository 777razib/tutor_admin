/* import 'dart:async';
import 'dart:convert';
import 'package:admin_tutor_app/core/network_caller/endpoints.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../core/services_class/local_service/shared_preferences_helper.dart';

class WebSocketService {
  late WebSocketChannel channel;
  late Stream broadcastStream;

  String myUserid = "";
  String otherUserId = "";

  Timer? _timer;

  // ✅ connect to websocket
  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse(Urls.webSocketUrl),
    );
    broadcastStream = channel.stream.asBroadcastStream();

    // listen for messages
    broadcastStream.listen((message) {
      print("📩 Received: $message");

      final data = jsonDecode(message);
      if (data["event"] == "userStatus" && data["data"]["userId"] != null) {
        if (myUserid.isEmpty) {
          myUserid = data["data"]["userId"];
        } else {
          otherUserId = data["data"]["userId"];
        }
        sendSubscribe(data["data"]["userId"]);
      }
    });

    // send location update every 10s
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      sendLocationUpdate();
    });

    // authenticate immediately
    sendAuth();
  }

  // ✅ authenticate
  Future<void> sendAuth() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) {
      print("❌ No access token found.");
      return;
    }
    final msg = {
      "event": "authenticate",
      "token": token,
    };
    channel.sink.add(jsonEncode(msg));
    print("✅ Auth message sent $msg");
  }

  // ✅ send location update
  Future<void> sendLocationUpdate() async {
    var position = await _determinePosition();
    final msg = {
      "event": "locationUpdate",
      "lat": position.latitude,
      "lng": position.longitude,
    };
    channel.sink.add(jsonEncode(msg));
    print("✅ Location update sent: $msg");
  }

  // ✅ subscribe to another user
  void sendSubscribe(String targetUserId) {
    final msg = {
      "event": "subscribeToLocation",
      "targetUserId": targetUserId,
    };
    channel.sink.add(jsonEncode(msg));
    print("✅ Subscribed to $targetUserId");
  }

  // ✅ location permission
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // ✅ close connection
  void dispose() {
    channel.sink.close();
    _timer?.cancel();
  }
}
 */