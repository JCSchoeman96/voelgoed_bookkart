class ImageModel {
  String? alt;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  int? id;
  String? name;
  String? src;

  ImageModel({this.alt, this.dateCreated, this.dateCreatedGmt, this.dateModified, this.dateModifiedGmt, this.id, this.name, this.src});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      alt: json['alt'],
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      id: json['id'],
      name: json['name'],
      src: json['src'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alt'] = this.alt;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['src'] = this.src;
    return data;
  }
}