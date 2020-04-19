class Coordinates {
  double lon;
  double lat;

  Coordinates({this.lon, this.lat});

  Coordinates.fromJson(Map<String, dynamic> json) {
    lon = double.parse(json['lon'].toString());
    lat = double.parse(json['lat'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}