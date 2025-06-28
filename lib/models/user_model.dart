class User {
  final String id;
  final String email;
  final String name;
  final String title;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.title,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      title: json['title'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'title': title,
      'avatar': avatar,
    };
  }
}