class Reviews {
  String? commentID;
  String? commentPostID;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentAuthorUrl;
  String? commentAuthorIP;
  String? commentDate;
  String? commentDateGmt;
  String? commentContent;
  String? commentKarma;
  String? commentApproved;
  String? commentAgent;
  String? commentType;
  String? commentParent;
  String? userId;
  String? ratingNum = "0";
  String? dateCreated;
  String? email;
  int? id;
  String? name;
  int? rating;
  String? review;
  bool? verified;

  Reviews(
      {this.commentID,
        this.commentPostID,
        this.commentAuthor,
        this.commentAuthorEmail,
        this.commentAuthorUrl,
        this.commentAuthorIP,
        this.commentDate,
        this.commentDateGmt,
        this.commentContent,
        this.commentKarma,
        this.commentApproved,
        this.commentAgent,
        this.commentType,
        this.commentParent,
        this.ratingNum,
        this.userId,
        this.dateCreated,
        this.email,
        this.id,
        this.name,
        this.rating,
        this.review,
        this.verified});

  Reviews.fromJson(Map<String, dynamic> json) {
    commentID = json['comment_ID'];
    commentPostID = json['comment_post_ID'];
    commentAuthor = json['comment_author'];
    commentAuthorEmail = json['comment_author_email'];
    commentAuthorUrl = json['comment_author_url'];
    commentAuthorIP = json['comment_author_IP'];
    commentDate = json['comment_date'];
    commentDateGmt = json['comment_date_gmt'];
    commentContent = json['comment_content'];
    commentKarma = json['comment_karma'];
    commentApproved = json['comment_approved'];
    commentAgent = json['comment_agent'];
    commentType = json['comment_type'];
    ratingNum = json['rating_num'];
    commentParent = json['comment_parent'];
    userId = json['user_id'];

    dateCreated = json['date_created'];
    email = json['email'];
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    review = json['review'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_ID'] = this.commentID;
    data['comment_post_ID'] = this.commentPostID;
    data['comment_author'] = this.commentAuthor;
    data['comment_author_email'] = this.commentAuthorEmail;
    data['comment_author_url'] = this.commentAuthorUrl;
    data['comment_author_IP'] = this.commentAuthorIP;
    data['comment_date'] = this.commentDate;
    data['comment_date_gmt'] = this.commentDateGmt;
    data['comment_content'] = this.commentContent;
    data['rating_num'] = this.ratingNum;
    data['comment_karma'] = this.commentKarma;
    data['comment_approved'] = this.commentApproved;
    data['comment_agent'] = this.commentAgent;
    data['comment_type'] = this.commentType;
    data['comment_parent'] = this.commentParent;
    data['user_id'] = this.userId;
    data['date_created'] = this.dateCreated;
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['verified'] = this.verified;
    return data;
  }
}