import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:app/globals.dart' as globals;

Future<String> make_payment(int event_ticket, int user_id) async {

    Map<String, dynamic> purchase_info = {
        "user": user_id,
        "event_ticket": event_ticket
    };

    String json = jsonEncode(purchase_info);
    final url = "${globals.URL}/payment/buy.php";

    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 200) {
        return response.body;
    } else {
        print("Er was een fout bij de betaling. [${response.statusCode}] ${response.body}");
        exit(0);
    }
}
