import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_notifications_flutter/bloc/permission_bloc.dart';
import 'package:manage_notifications_flutter/main_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: BlocProvider(
        create: (_) => PermissionBloc(),
        child: MainScreen()
      ),
    );
  }
}
