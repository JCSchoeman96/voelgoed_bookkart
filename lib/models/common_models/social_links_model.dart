class Social {
  String? fb;
  String? gplus;
  String? youtube;
  String? twitter;
  String? linkedin;
  String? pinterest;
  String? instagram;
  String? flickr;
  String? whatsapp;
  String? facebook;
  String? contact;
  String? privacyPolicy;
  String? copyrightText;
  String? termCondition;

  Social({
    this.fb,
    this.gplus,
    this.youtube,
    this.twitter,
    this.linkedin,
    this.pinterest,
    this.instagram,
    this.flickr,
    this.whatsapp,
    this.facebook,
    this.contact,
    this.privacyPolicy,
    this.copyrightText,
    this.termCondition,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      fb: json['fb'],
      gplus: json['gplus'],
      youtube: json['youtube'],
      twitter: json['twitter'],
      linkedin: json['linkedin'],
      pinterest: json['pinterest'],
      instagram: json['instagram'],
      flickr: json['flickr'],
      whatsapp: json['whatsapp'],
      contact: json['contact'],
      privacyPolicy: json['privacy_policy'],
      copyrightText: json['copyright_text'],
      termCondition: json['term_condition'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fb'] = this.fb;
    data['gplus'] = this.gplus;
    data['youtube'] = this.youtube;
    data['twitter'] = this.twitter;
    data['linkedin'] = this.linkedin;
    data['pinterest'] = this.pinterest;
    data['instagram'] = this.instagram;
    data['flickr'] = this.flickr;
    data['whatsapp'] = this.whatsapp;
    data['contact'] = this.contact;
    data['privacy_policy'] = this.privacyPolicy;
    data['copyright_text'] = this.copyrightText;
    data['term_condition'] = this.termCondition;
    return data;
  }
}
