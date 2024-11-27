class FirebaseNotificationModel {
  String? notificationId;
  String? templateId;
  String? templateName;
  String? sound;
  String? title;
  String? body;
  String? launchUrl;
  Map<String, dynamic>? additionalData;
  Map<String, dynamic>? attachments;
  bool? contentAvailable;
  bool? mutableContent;
  String? category;
  int? badge;
  int? badgeIncrement;
  String? subtitle;
  double? relevanceScore;
  String? interruptionLevel;
  int? androidNotificationId;
  String? smallIcon;
  String? largeIcon;
  String? bigPicture;
  String? smallIconAccentColor;
  String? ledColor;
  int? lockScreenVisibility;
  String? groupKey;
  String? groupMessage;
  String? fromProjectNumber;
  String? collapseId;
  int? priority;

  FirebaseNotificationModel.fromJson(Map<String, dynamic> json) {
    this.contentAvailable = json['contentAvailable'];
    this.mutableContent = json['mutableContent'];
    this.category = json['category'];
    this.badge = json['badge'];
    this.badgeIncrement = json['badgeIncrement'];
    this.subtitle = json['subtitle'];
    this.attachments = json['attachments']??{};
    this.relevanceScore = json['relevanceScore'];
    this.interruptionLevel = json['interruptionLevel'];

    // Android Specific Parameters
    this.smallIcon = json['smallIcon'];
    this.largeIcon = json['largeIcon'];
    this.bigPicture = json['bigPicture'];
    this.smallIconAccentColor = json['smallIconAccentColor'];
    this.ledColor = json['ledColor'];
    this.lockScreenVisibility = json['lockScreenVisibility'];
    this.groupMessage = json['groupMessage'];
    this.groupKey = json['groupKey'];
    this.fromProjectNumber = json['fromProjectNumber'];
    this.collapseId = json['collapseId'];
    this.priority = json['priority'];
    this.androidNotificationId = json['androidNotificationId'];

    this.templateName = json['templateName'];
    this.templateId = json['templateId'];
    this.sound = json['sound'];
    this.title = json['title'];
    this.body = json['body'];
    this.launchUrl = json['launchUrl'];
    this.additionalData = json['additionalData']??{};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['notificationId'] = this.notificationId;
    data['contentAvailable'] = this.contentAvailable;
    data['mutableContent'] = this.mutableContent;
    data['category'] = this.category;
    data['badge'] = this.badge;
    data['badgeIncrement'] = this.badgeIncrement;
    data['subtitle'] = this.subtitle;
    data['attachments'] = this.attachments;
    data['relevanceScore'] = this.relevanceScore;
    data['interruptionLevel'] = this.interruptionLevel;

    // Android Specific Parameters
    data['smallIcon'] = this.smallIcon;
    data['largeIcon'] = this.largeIcon;
    data['bigPicture'] = this.bigPicture;
    data['smallIconAccentColor'] = this.smallIconAccentColor;
    data['ledColor'] = this.ledColor;
    data['lockScreenVisibility'] = this.lockScreenVisibility;
    data['groupMessage'] = this.groupMessage;
    data['groupKey'] = this.groupKey;
    data['fromProjectNumber'] = this.fromProjectNumber;
    data['collapseId'] = this.collapseId;
    data['priority'] = this.priority;
    data['androidNotificationId'] = this.androidNotificationId;

    data['templateName'] = this.templateName;
    data['templateId'] = this.templateId;
    data['sound'] = this.sound;
    data['title'] = this.title;
    data['body'] = this.body;
    data['launchUrl'] = this.launchUrl;
    data['additionalData'] = this.additionalData;

    return data;
  }
}
