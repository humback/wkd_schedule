// To parse this JSON data, do
//
//     final wkdDelay = wkdDelayFromJson(jsonString);

import 'dart:convert';

WkdDelay wkdDelayFromJson(String str) => WkdDelay.fromJson(json.decode(str));

String wkdDelayToJson(WkdDelay data) => json.encode(data.toJson());

class WkdDelay {
    WkdDelay({
        required this.trains,
        required this.update,
        required this.direction,
        required this.station,
    });

    List<Train> trains;
    String update;
    String direction;
    String station;

    factory WkdDelay.fromJson(Map<String, dynamic> json) => WkdDelay(
        trains: List<Train>.from(json["trains"].map((x) => Train.fromJson(x))),
        update: json["update"],
        direction: json["direction"],
        station: json["station"],
    );

    Map<String, dynamic> toJson() => {
        "trains": List<dynamic>.from(trains.map((x) => x.toJson())),
        "update": update,
        "direction": direction,
        "station": station,
    };
}

class Train {
    Train({
        required this.id,
        required this.delay,
        required this.scheduleDepartureTime,
        required this.realDepartureTime,
    });

    String id;
    double delay;
    String scheduleDepartureTime;
    String realDepartureTime;

    factory Train.fromJson(Map<String, dynamic> json) => Train(
        id: json["id"],
        delay: json["delay"],
        scheduleDepartureTime: json["scheduleDepartureTime"],
        realDepartureTime: json["realDepartureTime"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "delay": delay,
        "scheduleDepartureTime": scheduleDepartureTime,
        "realDepartureTime": realDepartureTime,
    };
}
