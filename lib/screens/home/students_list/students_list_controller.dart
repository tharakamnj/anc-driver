import 'dart:convert';

import 'package:anc_bus_service_driver/models/ClientModel.dart';
import 'package:anc_bus_service_driver/utils/common_network.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentsListController extends GetxController {
  final CommonNetwork api = CommonNetwork();
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

  onPickup(context, clientId, clientName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var req = {
      "tripType": "UP",
      "pickLat": currentLat,
      "pickLon": currentLong,
      "clientId": clientId,
      "driverTripId": prefs.getInt('driverTripId')
    };
    var response = await api.postApi(context, '/pickup', jsonEncode(req));
    if (response != null) {
      print(response);
      print(response.data['payload'][0]);
      prefs.setInt("clientTripId", response.data['payload'][0]);
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Journey Started",
            text: clientName + "'s journey started"),
      );
    }
  }

  onDropOff(context, clientId, clientName) async {
    var req = {"dropLat": currentLat, "dropLon": currentLong, "clientId": clientId};
    var response = await api.postApi(context, '/dropOut', req);
    print(response);
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "Journey Ended",
          text: clientName + "'s journey ended"),
    );
  }
}
