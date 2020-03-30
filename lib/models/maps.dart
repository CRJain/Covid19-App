class Address {
  String status;
  List<Results> resultsList;
  Address({this.status, this.resultsList});
  Address.fromJson(Map<String,  dynamic> json) {
    status = json['status'][0];
    var list = json['results'] as List;
    resultsList = list.map((i) => Results.fromJson(i)).toList();
  }
}

class Results {
  Geometry geometry;
  String id;
  String name;
  String placeid;

  Results({
    this.id,
    this.name,
    this.placeid,
  });

  Results.fromJson(Map<String, dynamic> json)  {
    geometry = Geometry.fromJson(json['geometry']);
    id = json['id'];
    name = json['name'];
    placeid =  json['place_id'];
  }
}

class Geometry {
  Location location;
  Geometry({this.location});
  Geometry.fromJson(Map<String, dynamic> json) {
    location = Location.fromJson(json['location']);
  }
}


class Location {
  double lat;
  double lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }
}