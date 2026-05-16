import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class LocationService {
  Position? currentLocation;
  double? latitude;
  double? longitude;
  final Logger log = Logger();

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.defaultDialog(
        title: 'GPS is Disabled',
        middleText: 'Please turn on your GPS Location',
        textConfirm: 'TURN ON',
        onConfirm: () async {
          await Geolocator.openLocationSettings();
          Get.back();
        },
        textCancel: 'Skip',
        onCancel: () {},
      );
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log.e('Location permission denied');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log.e('Location permission permanently denied, opening settings');
      await Geolocator.openAppSettings();
      return null;
    }
    try {
      currentLocation = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
        // ignore: deprecated_member_use
        timeLimit: Duration(seconds: 10),
      );
      log.d(
        'Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}',
      );
      return currentLocation;
    } catch (e) {
      log.e('Error getting location: $e');
      return null;
    }
  }

  Future<String> getAddressFromLatLng(LatLng? location) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        location!.latitude,
        location.longitude,
      );

      Placemark place = placeMarks[0];
      log.d(
        "the location is  ${place.thoroughfare} "
        " ${place.subLocality}"
        " ${place.locality}"
        " ${place.country}",
      );
      return "${place.thoroughfare} ${place.subLocality} ${place.locality} ${place.country}";
    } catch (e) {
      log.d("the exception is $e");
      return '';
    }
  }
}
