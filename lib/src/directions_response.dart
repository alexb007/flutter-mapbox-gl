// To parse this JSON data, do
//
//     final directionsResponse = directionsResponseFromJson(jsonString);

import 'dart:convert';

DirectionsResponse directionsResponseFromJson(String str) => DirectionsResponse.fromJson(json.decode(str));

String directionsResponseToJson(DirectionsResponse data) => json.encode(data.toJson());

class DirectionsResponse {
  List<Route> routes;
  List<Waypoint> waypoints;
  String code;
  String uuid;

  DirectionsResponse({
    this.routes,
    this.waypoints,
    this.code,
    this.uuid,
  });

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) => DirectionsResponse(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    waypoints: List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromJson(x))),
    code: json["code"],
    uuid: json["uuid"],
  );

  Map<String, dynamic> toJson() => {
    "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
    "waypoints": List<dynamic>.from(waypoints.map((x) => x.toJson())),
    "code": code,
    "uuid": uuid,
  };
}

class Route {
  String weightName;
  List<Leg> legs;
  String geometry;
  double distance;
  int duration;
  int weight;

  Route({
    this.weightName,
    this.legs,
    this.geometry,
    this.distance,
    this.duration,
    this.weight,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    weightName: json["weight_name"],
    legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
    geometry: json["geometry"],
    distance: json["distance"].toDouble(),
    duration: json["duration"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "weight_name": weightName,
    "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
    "geometry": geometry,
    "distance": distance,
    "duration": duration,
    "weight": weight,
  };
}

class Leg {
  String summary;
  List<dynamic> steps;
  double distance;
  int duration;
  int weight;

  Leg({
    this.summary,
    this.steps,
    this.distance,
    this.duration,
    this.weight,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    summary: json["summary"],
    steps: List<dynamic>.from(json["steps"].map((x) => x)),
    distance: json["distance"].toDouble(),
    duration: json["duration"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "summary": summary,
    "steps": List<dynamic>.from(steps.map((x) => x)),
    "distance": distance,
    "duration": duration,
    "weight": weight,
  };
}

class Waypoint {
  double distance;
  String name;
  List<double> location;

  Waypoint({
    this.distance,
    this.name,
    this.location,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    distance: json["distance"].toDouble(),
    name: json["name"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance,
    "name": name,
    "location": List<dynamic>.from(location.map((x) => x)),
  };
}
