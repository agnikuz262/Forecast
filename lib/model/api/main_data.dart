class MainData {
  double temp;
  int pressure;
  int humidity;
  double tempMin;
  double tempMax;

  MainData({this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax});

  MainData.fromJson(Map<String, dynamic> json) {
    temp = double.parse(json['temp'].toString());
    pressure = json['pressure'];
    humidity = json['humidity'];
    tempMin = double.parse(json['temp_min'].toString());
    tempMax = double.parse(json['temp_max'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['temp_min'] = this.tempMin;
    data['temp_max'] = this.tempMax;
    return data;
  }
}
