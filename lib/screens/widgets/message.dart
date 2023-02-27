class Message {
  final String idUser;
  final String sender;
  final String message;
  final String imageAvatar;
  final DateTime createdAt;

  Message(
      {required this.idUser,
      required this.sender,
      required this.message,
      required this.imageAvatar,
      required this.createdAt});
  Map<String, dynamic> toJson() => {
        'userId': idUser,
        'sender': sender,
        'message': message,
        'imageAvatar': imageAvatar,
        'createdAt': createdAt
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
      idUser: json['userId'],
      sender: json['sender'],
      message: json['message'],
      imageAvatar: json['imageAvatar'],
      createdAt: json['createdAt']);
}
