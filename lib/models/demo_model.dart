class DemoModel {
  String? name;
  String? mail;

  DemoModel({this.name, this.mail});

  DemoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mail = json['mail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mail'] = this.mail;
    return data;
  }
}
