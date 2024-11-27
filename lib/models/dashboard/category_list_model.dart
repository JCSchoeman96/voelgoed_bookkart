import 'package:bookkart_flutter/models/common_models/image_model.dart';

class CategoriesListResponse {
  int? count;
  String? description;
  String? display;
  int? id;
  ImageModel? image;
  int? menuOrder;
  String? name;
  int? parent;
  String? slug;

  CategoriesListResponse({this.count, this.description, this.display, this.id, this.image, this.menuOrder, this.name, this.parent, this.slug});

  factory CategoriesListResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesListResponse(
      count: json['count'],
      description: json['description'],
      display: json['display'],
      id: json['id'],
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
      menuOrder: json['menu_order'],
      name: json['name'],
      parent: json['parent'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['description'] = this.description;
    data['display'] = this.display;
    data['id'] = this.id;
    data['menu_order'] = this.menuOrder;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['slug'] = this.slug;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}
