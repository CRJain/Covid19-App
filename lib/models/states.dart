class Data {
  List<States> states;

  Data({this.states});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['States'] != null) {
      states = new List<States>();
      json['States'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
  }
}

class States {
  int active;
  int confirmed;
  int deceased;
  List<Districts> districts;
  String name;
  int recovered;
  int rise;

  States(
      {this.active,
        this.confirmed,
        this.deceased,
        this.districts,
        this.name,
        this.recovered,
        this.rise});

  States.fromJson(Map<String, dynamic> json) {
    active = json['Active'];
    confirmed = json['Confirmed'];
    deceased = json['Deceased'];
    if (json['Districts'] != null) {
      districts = new List<Districts>();
      json['Districts'].forEach((v) {
        districts.add(new Districts.fromJson(v));
      });
    }
    name = json['Name'];
    recovered = json['Recovered'];
    rise = json['Rise'];
  }
}

class Districts {
  int confirmed;
  String name;

  Districts({this.confirmed, this.name});

  Districts.fromJson(Map<String, dynamic> json) {
    confirmed = json['Confirmed'];
    name = json['Name'];
  }
}