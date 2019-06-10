import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

String url = "https://api.mlab.com/api/1/databases/thirdeye/collections/user_data?apiKey=AL0LTAZz88PTZwxwi74C-5BT1deihTgK";

Future<http.Response> createPost(Mlab post) async{
  final response = await http.post('$url',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader : ''
      },
      body: mlabToJson(post)
  );
  return response;
}

Mlab mlabFromJson(String str) {
    final jsonData = json.decode(str);
    return Mlab.fromJson(jsonData);
}

String mlabToJson(Mlab data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Mlab {
    String userName;
    String purpose;

    Mlab({
        this.userName,
        this.purpose,
    });

    factory Mlab.fromJson(Map<String, dynamic> json) => new Mlab(
        userName: json["user_name"],
        purpose: json["purpose"],
    );

    Map<String, dynamic> toJson() => {
        "user_name": userName,
        "purpose": purpose,
    };
}
