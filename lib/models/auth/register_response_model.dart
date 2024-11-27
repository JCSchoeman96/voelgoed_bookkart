
class RegisterResponse {
  int? code;
  NewLogin? res;
  String? message;

  RegisterResponse({this.code, this.message, this.res});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    res = json['data'] != null ? NewLogin.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (data['data'] != null) {
      data['data'] = this.res;
    }

    return data;
  }
}

class NewLogin {
  String? display_name;
  String? iD;
  String? user_activation_key;
  String? user_email;
  String? user_login;
  String? user_nicename;
  String? user_registered;
  String? user_status;
  String? user_url;

  NewLogin({this.display_name, this.iD, this.user_activation_key, this.user_email, this.user_login, this.user_nicename, this.user_registered, this.user_status, this.user_url});

  factory NewLogin.fromJson(Map<String, dynamic> json) {
    return NewLogin(
      display_name: json['display_name'],
      iD: json['ID'],
      user_activation_key: json['user_activation_key'],
      user_email: json['user_email'],
      user_login: json['user_login'],
      user_nicename: json['user_nicename'],
      user_registered: json['user_registered'],
      user_status: json['user_status'],
      user_url: json['user_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.display_name;
    data['ID'] = this.iD;
    data['user_activation_key'] = this.user_activation_key;
    data['user_email'] = this.user_email;
    data['user_login'] = this.user_login;
    data['user_nicename'] = this.user_nicename;
    data['user_registered'] = this.user_registered;
    data['user_status'] = this.user_status;
    data['user_url'] = this.user_url;
    return data;
  }
}
