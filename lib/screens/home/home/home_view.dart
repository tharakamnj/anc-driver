import 'dart:async';

import 'package:anc_bus_service_driver/screens/home/home/home_controller.dart';
import 'package:anc_bus_service_driver/widgets/custom_app_bar.dart';
import 'package:anc_bus_service_driver/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

@immutable
class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  String journeyStatus = "";
  final Geolocator geolocator = Geolocator();
  Position? _currentPosition;
  Timer? timer;

  loadjourneyStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("journeyStatus", "Not Started");
    setState(() {
      journeyStatus = prefs.getString("journeyStatus").toString();
    });
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      // setState(() {
      _currentPosition = position;
      // });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    loadjourneyStatus();
    getCurrentLocation();
    homeController.loadDriverLocation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom("Home"),
      drawer: CustomDrawer('home'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Trip status: '),
                        Text(
                          journeyStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            onPressed: () {
                              homeController.onStartJourney(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: StadiumBorder(),
                            ),
                            child: Text('Start Journey'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            onPressed: () {
                              homeController.onEndJourney(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 220, 138, 15),
                              shape: StadiumBorder(),
                            ),
                            child: Text('End Journey'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () {
                    homeController.navigateToStudentList();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 36, 83, 106),
                  ),
                  child: Text('Open Student List'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
