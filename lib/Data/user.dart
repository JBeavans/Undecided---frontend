import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int userID;
  final String username;
  final String city;
  final String state;

  User({this.userID, this.username, this.city, this.state});

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      userID: json['id'],
      username: json['username'],
      city: json['city'],
      state: json['state'],
    );
  }

  String getState() {
    return this.state;
  }

  String getCity() {
    return this.city;
  }

  static Future<User> fetchUser(id) async {
    final url = 'http://localhost:3000/users/id/' + id.toString();
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return User.fromJSON(json.decode(response.body));
    } else {
      throw Exception('Failed to get user info');
    }
  }
}
