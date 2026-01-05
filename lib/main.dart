import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manage_notifications_flutter/bloc/blocs.dart';
import 'package:manage_notifications_flutter/core/injection.dart';
import 'package:manage_notifications_flutter/main_screen.dart';
import 'package:manage_notifications_flutter/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  await init();
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
          BlocProvider(create: (_) => sl<PermissionBloc>()),
          BlocProvider(create: (_) => sl<AlarmPermissionBloc>()),
          BlocProvider(create: (_) => sl<TimePickerBloc>()),
        ],
        child: MainScreen(),
      ),
    );
  }
}
