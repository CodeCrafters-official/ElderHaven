import 'package:geolocator/geolocator.dart';

class GeofencingService {
  static Future<String> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
    } catch (e) {
      return 'Location not available';
    }
  }
}
