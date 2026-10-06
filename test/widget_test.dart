import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urus_app/app/app.dart';
import 'package:urus_app/app/theme/app_theme.dart';
import 'package:urus_app/features/auth/presentation/screens/login_screen.dart';
import 'package:urus_app/features/auth/presentation/screens/register_screen.dart';

void main() {
  testWidgets('Register password visibility control reveals entered text', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const RegisterScreen(),
      ),
    );

    final passwordField = find.byType(EditableText).at(2);
    await tester.enterText(passwordField, 'Password123');
    expect(tester.widget<EditableText>(passwordField).obscureText, isTrue);

    await tester.tap(find.byTooltip('Show password').first);
    await tester.pump();

    expect(tester.widget<EditableText>(passwordField).obscureText, isFalse);
    expect(find.byTooltip('Hide password').first, findsOneWidget);
  });

  testWidgets('Register adapts to a compact phone width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const RegisterScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('Register shows validation errors for incomplete input', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const RegisterScreen(),
      ),
    );

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('CREATE ACCOUNT  →'));
    await tester.pump();

    expect(find.text('Enter your full name.'), findsOneWidget);
    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Confirm your password.'), findsOneWidget);
    expect(
      find.text('Please accept the Terms & Privacy Policy.'),
      findsOneWidget,
    );
  });

  testWidgets('Login shows validation errors for required fields', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );

    await tester.tap(find.text('SIGN IN  →'));
    await tester.pump();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
  });

  testWidgets('Login scrolls safely in a constrained viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Login fits a 360 by 800 viewport', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('URUS application boots', (WidgetTester tester) async {
    await tester.pumpWidget(const UrusApp());

    expect(find.byType(UrusApp), findsOneWidget);
  });
}
