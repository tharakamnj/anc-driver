import 'dart:convert';

import 'package:anc_bus_service_driver/models/DriverModel.dart';
import 'package:anc_bus_service_driver/routes/app_pages.dart';
import 'package:anc_bus_service_driver/utils/common_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  String username = "Test user";
  CommonNetwork api = CommonNetwork();
  final usernametextfield = TextEditingController();
  final passwordtextfield = TextEditingController();
  List loginUserDetails = [];

  checkUserLogin(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get.offAndToNamed(Routes.LAYOUT);
  }

  onLogin(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var req = jsonEncode(<String, String>{
      "username": usernametextfield.value.text,
      "password": passwordtextfield.value.text
    });
    print(req);
    var response = await api.getAuthApi(context, '/authenticate', req);
    if (response != null) {
      // print(response.data['payload']);
      prefs.setInt("driverId", response.data['payload'][0]['user']['driverId']);
      prefs.setString(
          "firstName", response.data['payload'][0]['user']['firstName']);
      prefs.setString(
          "lastName", response.data['payload'][0]['user']['lastName']);
      prefs.setString(
          "username", response.data['payload'][0]['user']['username']);
      prefs.setString(
          "licenceNo", response.data['payload'][0]['user']['licenceNo']);
      prefs.setString(
          "deviceId", response.data['payload'][0]['user']['deviceId']);
      prefs.setString("token", response.data['payload'][0]['token']);

      Get.offAndToNamed(Routes.HOME);
    }
    // if (response.data != null) {
    // if (response.data['payload'] != null) {
    //   List jsonResponseClient = response.data['payload'];
    //   loginUserDetails =
    //       jsonResponseClient.map((job) => Driver.fromJson(job)).toList();
    // }
    // }
    // print(loginUserDetails);
  }

  navigateToRegisterScreen() {
    Get.offAndToNamed(Routes.REGISTER);
  }
}
