import 'package:nb_utils/nb_utils.dart';

class DownloadModel {
  String? id;
  String? name;
  String? file;

  //Local Variable
  String get filename => file.validate().substring(file.validate().lastIndexOf("/") + 1);

  DownloadModel({this.id, this.name, this.file});

  DownloadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['file'] = this.file;
    return data;
  }
}
