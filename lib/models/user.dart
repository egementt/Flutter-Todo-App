class User {
  String status;
  String token;
  int userId;
  String userName;

  User({
    this.status,
    this.token,
    this.userId,
  });

  User.loggedUser({
    this.userName,
  });

  @override
  String toString() {
    return 'User(status: $status, token: $token, userId: $userId)';
  }



  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json['status'] as String,
      token: json['token'] as String,
      userId: json['userId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'token': token,
      'userId': userId,
    };
  }
}
