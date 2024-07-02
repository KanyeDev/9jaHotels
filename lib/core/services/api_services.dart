



import 'dart:convert';
import 'package:http/http.dart' as http;

import 'data_models.dart';

class ApiService {

  //static const String baseUrl = "https://9jahotels.ascolab.org/api";

  Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse('https://9jahotels.ascolab.org/api/auth/login-hotel/');
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['password'] = password;


    final response = await http.post(
      url,
      body: map,
      headers: {"Accept": "application/json"});

    print("Response status ${response.statusCode}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(LoginResponse.fromJson(jsonData));
      return LoginResponse.fromJson(jsonData);

    }
    else if (response.statusCode == 302) {
      final redirectUrl = response.headers['location'];
      print('Redirecting to: $redirectUrl');
    }
    else {
      return null;
    }
  }

  Future<RegisterResponse?> register(
      String name,
      String address,
      String hotelEmail,
      String hotelPhoneNumber,
      String stateId,
      String cityId,
      String ownerFirstName,
      String ownerLastName,
      String ownerEmail,
      String ownerPhoneNumber,
      String ownerPassword) async {

    final url = Uri.parse('https://9jahotels.ascolab.org/api/auth/register-hotel/');
    Map<String, dynamic> map = {
      'name': name,
      'address': address,
      'state_id': stateId,
      'city_id': cityId,
      'phone_number': hotelPhoneNumber,
      'email': hotelEmail,
      'owner': {
        'first_name': ownerFirstName,
        'last_name': ownerLastName,
        'email': ownerEmail,
        'phone_number': ownerPhoneNumber,
        'password': ownerPassword,
      }
    };

    final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(map)  // Convert the map to a JSON string
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return RegisterResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to register');
    }
  }
}
