import 'package:bookkart_flutter/models/common_models/social_links_model.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthorListResponse {
  int? id;
  String? storeName;
  String? firstName;
  String? lastName;
  Social? social;
  String? phone;
  bool? showEmail;
  Address? address;
  String? location;
  String? banner;
  int? bannerId;
  String? gravatar;
  int? gravatarId;
  String? shopUrl;
  int? productsPerPage;
  bool? showMoreProductTab;
  bool? tocEnabled;
  String? storeToc;
  bool? featured;
  Rating? rating;
  bool? enabled;
  String? registered;
  String? payment;
  bool? trusted;
  String? description;
  String? name;
  String? image;

  //Local
  String get fullName => firstName.validate() + " " + lastName.validate();

  double get getRating => rating!.rating.validate().toDouble();

  AuthorListResponse({
    this.id,
    this.storeName,
    this.firstName,
    this.lastName,
    this.social,
    this.phone,
    this.showEmail,
    this.address,
    this.location,
    this.banner,
    this.bannerId,
    this.gravatar,
    this.gravatarId,
    this.shopUrl,
    this.productsPerPage,
    this.showMoreProductTab,
    this.tocEnabled,
    this.storeToc,
    this.featured,
    this.rating,
    this.enabled,
    this.registered,
    this.payment,
    this.trusted,
    this.description,
    this.name,
    this.image,
  });

  factory AuthorListResponse.fromJson(dynamic json) {
    return AuthorListResponse(
      id: json['id'],
      storeName: json['store_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      social: json['social'] != null
          ? (json['social'].runtimeType == List)
              ? Social()
              : Social.fromJson(json['social'])
          : null,
      phone: json['phone'],
      showEmail: json['show_email'],
      address: json['address'] != null
          ? (json['address'].runtimeType == List)
              ? Address()
              : Address.fromJson(json['address'])
          : null,
      location: json['location'],
      banner: json['banner'],
      bannerId: json['banner_id'],
      gravatar: json['gravatar'],
      gravatarId: json['gravatar_id'],
      shopUrl: json['shop_url'],
      productsPerPage: json['products_per_page'],
      showMoreProductTab: json['show_more_product_tab'],
      tocEnabled: json['toc_enabled'],
      storeToc: json['store_toc'],
      featured: json['featured'],
      rating: json['rating'] != null
          ? (json['social'].runtimeType == List)
              ? Rating()
              : Rating.fromJson(json['rating'])
          : null,
      enabled: json['enabled'],
      registered: json['registered'],
      payment: json['payment'],
      trusted: json['trusted'],
      description: json['description'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['id'] = this.id;

    data['store_name'] = this.storeName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    if (this.social != null) {
      data['social'] = this.social!.toJson();
    }
    data['phone'] = this.phone;
    data['show_email'] = this.showEmail;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['location'] = this.location;
    data['banner'] = this.banner;
    data['banner_id'] = this.bannerId;
    data['gravatar'] = this.gravatar;
    data['gravatar_id'] = this.gravatarId;
    data['shop_url'] = this.shopUrl;
    data['products_per_page'] = this.productsPerPage;
    data['show_more_product_tab'] = this.showMoreProductTab;
    data['toc_enabled'] = this.tocEnabled;
    data['store_toc'] = this.storeToc;
    data['featured'] = this.featured;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    data['enabled'] = this.enabled;
    data['registered'] = this.registered;
    data['payment'] = this.payment;
    data['trusted'] = this.trusted;
    data['description'] = this.description;
    data['name'] = this.name;
    data['image'] = this.image;

    return data;
  }
}

class Address {
  String? street1;
  String? street2;
  String? city;
  String? zip;
  String? country;
  String? state;

  Address({this.street1, this.street2, this.city, this.zip, this.country, this.state});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street1: json['street_1'],
      street2: json['street_2'],
      city: json['city'],
      zip: json['zip'],
      country: json['country'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_1'] = this.street1;
    data['street_2'] = this.street2;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['state'] = this.state;
    return data;
  }
}

class Rating {
  String? rating;
  int? count;

  Rating({this.rating, this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['count'] = this.count;
    return data;
  }
}
