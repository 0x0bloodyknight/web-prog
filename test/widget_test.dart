// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kursova/main.dart';
import 'package:kursova/models/announcement.dart';
import 'package:kursova/pages/home_page.dart';
import 'package:kursova/pages/login_page.dart';
import 'package:kursova/state/announcement_state.dart';
import 'package:kursova/state/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Edit announcement', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      home: EditAnnouncement(
        announcement: Announcement(tittle: 'tittle', content: 'content'),
      ),
    ));
  });
  testWidgets('Create announcement', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: CreateAnnouncement()));
  });
  testWidgets('Widget test', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthState()),
    ], child: Scaffold(body: LoginPage()))));
    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthState()),
      ChangeNotifierProvider(create: (_) => AnnouncementState())
    ], child: Scaffold(body: HomePage()))));
  });
}
