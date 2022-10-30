import 'package:anc_bus_service_driver/models/ClientModel.dart';
import 'package:anc_bus_service_driver/screens/home/students_list/students_list_controller.dart';
import 'package:anc_bus_service_driver/utils/app_utils.dart';
import 'package:anc_bus_service_driver/utils/common_network.dart';
import 'package:anc_bus_service_driver/widgets/custom_app_bar.dart';
import 'package:anc_bus_service_driver/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({Key? key}) : super(key: key);
  @override
  _StudentsListScreenState createState() => _StudentsListScreenState();
}

@immutable
class _StudentsListScreenState extends State<StudentsListScreen> {
  final StudentsListController studentsListController =
      StudentsListController();
  late List<Client> clientList = [];
  final CommonNetwork api = CommonNetwork();
  bool loading = true;

  loadStudents(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await api.getApi(
        context, '/driverClient/' + prefs.getInt('driverId').toString());
    print(response);
    print(response.data['payload'].toString());
    if (response.data['payload'] != null) {
      List jsonResponseClient = response.data['payload'][0];
      clientList =
          jsonResponseClient.map((job) => Client.fromJson(job)).toList();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    loadStudents(context);
    studentsListController.loadDriverLocation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom("Students List"),
      drawer: CustomDrawer('students'),
      body: Column(
        children: <Widget>[
          loading
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: CircularProgressIndicator(),
                ))
              : Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: clientList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return clientCard(clientList[index]);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget clientCard(data) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(data.firstName + ' ' + data.lastName),
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              ElevatedButton(
                onPressed: () {
                  studentsListController.onPickup(context, data.clientId,
                      data.firstName + ' ' + data.lastName);
                },
                child: Text('Pickup'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    studentsListController.onDropOff(context, data.clientId,
                        data.firstName + ' ' + data.lastName);
                  },
                  child: Text('Drop off'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 220, 138, 15),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
