import 'package:flutter/widgets.dart';

import 'app.dart';

/// Starts the application and provides one future startup configuration point.
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UrusApp());
}
