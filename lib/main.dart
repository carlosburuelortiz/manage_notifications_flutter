import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manage_notifications_flutter/bloc/blocs.dart';
import 'package:manage_notifications_flutter/main_screen.dart';
import 'package:manage_notifications_flutter/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PermissionBloc()),
          BlocProvider(create: (_) => AlarmPermissionBloc()),
        ],
        child: MainScreen(),
      ),
    );
  }
}
