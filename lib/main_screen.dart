import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:manage_notifications_flutter/bloc/permission_bloc.dart';
import 'package:manage_notifications_flutter/bloc/permission_event.dart';
import 'package:manage_notifications_flutter/bloc/permission_state.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void showNotificationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permiso necesario'),
            content: Text(
              'Para poder enviarte notificaciones, debes habilitar los persmisos desde los ajustes del sistema',
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text('Ir a ajustes'),
              ),
            ],
          ),
    );
  }

  void showPermissionGranted(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('El permiso ya ha sido concedido'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionBloc, PermissionState>(
      listener: (context, state) {
        if (state is PermissionDeniedPermanently) {
          showNotificationPermissionDialog(context);
        } else {
          showPermissionGranted(context);
        }
      },
      child: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              context.read<PermissionBloc>().add(
                RequestNotificationPermission(),
              );
            },
            child: Text('Solicitar permiso'),
          ),
        ),
      ),
    );
  }
}
