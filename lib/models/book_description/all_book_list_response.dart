import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';

class AllBookListResponse {
  int? numOfPages;
  List<BookDataModel>? data;

  AllBookListResponse({this.numOfPages, this.data});

  AllBookListResponse.fromJson(Map<String, dynamic> json) {
    numOfPages = json['num_of_pages'];

    if (json['data'] != null) {
      data = <BookDataModel>[];
      json['data'].forEach((v) {
        data!.add(new BookDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['num_of_pages'] = this.numOfPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
