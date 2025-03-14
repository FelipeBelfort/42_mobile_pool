
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<UserCredential?> signInWithGitHub() async {
  final clientId = "";
  final clientSecret = "";
  final redirectUri = "https://your-app.firebaseapp.com/__/auth/handler";
  final authorizationEndpoint = "https://github.com/login/oauth/authorize";
  final tokenEndpoint = "https://github.com/login/oauth/access_token";

  try {
    if (kIsWeb) {
      // 🔹 Web: Use Firebase's built-in GitHub login
      GithubAuthProvider githubProvider = GithubAuthProvider();
      return await FirebaseAuth.instance.signInWithPopup(githubProvider);
    } else {
      // 🔹 Mobile (Android/iOS): Use FlutterWebAuth2
      final result = await FlutterWebAuth2.authenticate(
        url: "$authorizationEndpoint?client_id=$clientId&redirect_uri=$redirectUri",
        callbackUrlScheme: "https",
      );

      final code = Uri.parse(result).queryParameters["code"];
      if (code == null) throw Exception("No authorization code received");

      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {"Accept": "application/json"},
        body: {
          "client_id": clientId,
          "client_secret": clientSecret,
          "code": code,
        },
      );

      final accessToken = json.decode(response.body)["access_token"];
      if (accessToken == null) throw Exception("Failed to retrieve access token");

      final credential = GithubAuthProvider.credential(accessToken);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  } catch (e) {
    debugPrint("GitHub Login Error: $e"); // 🔹 Now should always print on failure
    return null;
  }
}
