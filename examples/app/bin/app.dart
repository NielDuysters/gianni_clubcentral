// A basic implementation of Club Central.

import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:app/globals.dart' as globals;
import 'package:app/ui.dart' as ui;
import 'package:app/usersession.dart';

// All functions must be asynchronous
Future<void> main(List<String> arguments) async {
    
    // Initialize session
    // null means there is no user logged in (Default)
    UserSession.user_id = null;

    ui.home();

}
