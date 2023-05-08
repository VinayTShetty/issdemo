class Data {
  final int buildingID;
  final String buildingName;
  final int floorID;
  final String floorName;
  final int floorLevel;
  final Location userLocation;
  final Floorplan floorplan;

  Data({
    required this.buildingID,
    required this.buildingName,
    required this.floorID,
    required this.floorName,
    required this.floorLevel,
    required this.userLocation,
    required this.floorplan,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      buildingID: json['buildingID'],
      buildingName: json['buildingName'],
      floorID: json['floorID'],
      floorName: json['floorName'],
      floorLevel: json['floorLevel'],
      userLocation: Location.fromJson(json['userLocation']),
      floorplan: Floorplan.fromJson(json['floorplan']),
    );
  }
}

class Location {
  final double lat;
  final double long;

  Location({
    required this.lat,
    required this.long,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      long: json['long'],
    );
  }
}

class Floorplan {
  final String imageURL;
  final Boundaries boundaries;

  Floorplan({
    required this.imageURL,
    required this.boundaries,
  });

  factory Floorplan.fromJson(Map<String, dynamic> json) {
    return Floorplan(
      imageURL: json['imageURL'],
      boundaries: Boundaries.fromJson(json['boundaries']),
    );
  }
}

class Boundaries {
  final Location topLeft;
  final Location bottomLeft;
  final Location topRight;

  Boundaries({
    required this.topLeft,
    required this.bottomLeft,
    required this.topRight,
  });

  factory Boundaries.fromJson(Map<String, dynamic> json) {
    return Boundaries(
      topLeft: Location.fromJson(json['topLeft']),
      bottomLeft: Location.fromJson(json['bottomLeft']),
      topRight: Location.fromJson(json['topRight']),
    );
  }
}
