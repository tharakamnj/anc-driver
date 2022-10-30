import 'dart:convert';

Driver clientFromJson(String str) => Driver.fromJson(json.decode(str));

class Driver {
  Driver({
    required this.clientId,
    required this.clientName,
    required this.password,
    required this.lat,
    required this.lon,
    required this.mobileNo,
    required this.deviceId,
    required this.status,
    // required this.trips,
  });

  int clientId;
  String clientName;
  String password;
  double lat;
  double lon;
  String mobileNo;
  String deviceId;
  String status;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        clientId: json["clientId"],
        clientName: json["clientName"],
        password: json["password"] ?? "",
        lat: json["lat"],
        lon: json["lon"],
        mobileNo: json["mobileNo"],
        deviceId: json["deviceId"] ?? "",
        status: json["status"],
      );

  // static List<ClientTrip> parseTrip(jsonObj) {
  //   List<ClientTrip> tripList;
  //   tripList =
  //       (jsonObj as List).map((job) => ClientTrip.fromJson(job)).toList();
  //   return tripList;
  // }
}
