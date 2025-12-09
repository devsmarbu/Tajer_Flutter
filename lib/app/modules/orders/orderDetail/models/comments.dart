class Comment {
  String? comment;
  String? commentedBy;
  String? dateAdded;

  Comment({
    this.comment,
    this.commentedBy,
    this.dateAdded,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    comment: json["comment"],
    commentedBy: json["commented_by"],
    dateAdded: json["date_added"],
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "commented_by": commentedBy,
    "date_added": dateAdded,
  };
}