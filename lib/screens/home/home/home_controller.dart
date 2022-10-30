import 'dart:convert';

import 'package:anc_bus_service_driver/routes/app_pages.dart';
import 'package:anc_bus_service_driver/screens/home/home/home_view.dart';
import 'package:anc_bus_service_driver/utils/common_network.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final test = "Hi";
  String formattedDate = DateFormat('EEE d MMM').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm a').format(DateTime.now());
  CommonNetwork api = CommonNetwork();
  double currentLat = 6.878939;
  double currentLong = 79.921858;

  loadDriverLocation(context) async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457
    currentLat = position.latitude;
    currentLong = position.longitude;
  }

  onStartJourney(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var req = {
      "tripType": "UP",
      "startLat": currentLat,
      "startLon": currentLong
    };
    print(req);
    var response = await api.postApi(context,
        '/dtrip/start/' + prefs.getInt('driverId').toString(), jsonEncode(req));
    print(response);
    if (response != null) {
      print(response.data);
      prefs.setInt("driverTripId", response.data['payload'][0]['driverTripId']);
      prefs.setString("journeyStatus", "Started");
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Journey Started",
            text: "\nTime: " + formattedTime + "\nDate: " + formattedDate),
      );
      Get.offAndToNamed(Routes.HOME);
      // if (response.data['payload'] != null) {
      //   Get.offAndToNamed(Routes.MAP);
      // }
    }
  }

  onEndJourney(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var req = {
      "driverTripId": prefs.getInt('driverTripId'),
      "endLat": currentLat,
      "endLon": currentLong
    };
    print(req);
    var response = await api.putApi(context, '/dtrip/end', jsonEncode(req));
    print(response);
    if (response != null) {
      print(response.data);
      prefs.setString("journeyStatus", "Ended");
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Journey Ended",
            text: "\nTime: " + formattedTime + "\nDate: " + formattedDate),
      );
      // if (response.data['payload'] != null) {
      //   Get.offAndToNamed(Routes.MAP);
      // }
    }
  }

  navigateToStudentList() async {
    Get.offAndToNamed(Routes.STUDENTLIST);
  }
}
