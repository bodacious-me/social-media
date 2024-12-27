class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamps;

  Post(
      {required this.id,
      required this.imageUrl,
      required this.text,
      required this.timestamps,
      required this.userId,
      required this.userName});

  Post copyWith({String? imageUrl}) {
    return Post(
        id: id,
        userId: userId,
        text: text,
        imageUrl: imageUrl ?? this.imageUrl,
        timestamps: timestamps,
        userName: userName);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'text': text,
      'timestamps': DateTime.now().toString(),
      'userId': userId,
      'userName': userName,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      imageUrl: json['imageUrl'],
      text: json['text'],
      timestamps: json['timestamps'],
      userId: json['userId'],
      userName: json['userName'],
    );
  }
}
