// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_rss/app.dart';

void main() {
  testWidgets('App renders login form by default', (WidgetTester tester) async {
    await tester.pumpWidget(const NewsRssApp());

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.textContaining('Đăng nhập', findRichText: true), findsOneWidget);
  });
}
