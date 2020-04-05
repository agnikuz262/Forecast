class MainData {
  double temp;
  int pressure;
  int humidity;
  double tempMin;
  double tempMax;

  MainData({this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax});

  MainData.fromJson(Map<String, dynamic> json) {
    temp = json['temp'].toDouble();
    pressure = json['pressure'];
    humidity = json['humidity'];
    tempMin = json['temp_min'].toDouble();
    tempMax = json['temp_max'].toDouble();
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
