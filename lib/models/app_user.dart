class AppUser {
  String email;
  String password;
  String name;
  String avatar_url;
  String updated_at;
  String refresh_token;
  String token;
  String token_updated_at;

  AppUser(
      {this.email,
      this.password,
      this.name,
      this.avatar_url,
      this.updated_at,
      this.refresh_token,
      this.token,
      this.token_updated_at});

  AppUser.fromJsonMap(Map<String, dynamic> map)
      : email = map["email"],
        password = map["password"],
        name = map["name"],
        avatar_url = map["avatar_url"],
        updated_at = map["created_at"],
        refresh_token = map["refresh_token"],
        token = map["token"],
        token_updated_at = map["token_updated_at"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['avatar_url'] = avatar_url;
    data['created_at'] = updated_at;
    data['refresh_token'] = refresh_token;
    data['token'] = token;
    data['token_updated_at'] = token_updated_at;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
