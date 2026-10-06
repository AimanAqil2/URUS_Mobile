import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'router/route_names.dart';
import 'theme/app_theme.dart';

/// The root widget for URUS. Features are connected as they are implemented.
class UrusApp extends StatelessWidget {
  const UrusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URUS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
