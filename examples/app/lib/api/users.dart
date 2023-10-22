import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:app/globals.dart' as globals;

Future<int?> add(Map<String, dynamic> data) async {
    String url = "${globals.URL}/api/users.php?api_key=${globals.API_KEY}";

    String json = jsonEncode(data);

    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 201) {
        return int.parse(response.body);
    } else {
        return null;
    }
}

Future<Map<String, dynamic>?> get(int id) async {
    String url = "${globals.URL}/api/users.php/$id?api_key=${globals.API_KEY}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
        return null;
    }
}

Future<Map<String, dynamic>?> get_by_email(String email) async {
    String url = "${globals.URL}/api/users.php/email/$email?api_key=${globals.API_KEY}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        return json.decode(response.body)[0];
    } else {
        return null;
    }
}
