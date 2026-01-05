import 'package:flutter/material.dart';
import 'package:manage_notifications_flutter/core/app_constant.dart';

class UIHelpers {
  static void showPermissionDialog(
    BuildContext context,
    VoidCallback onGoToSettings,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(AppConstant.permissionNeededTitle),
            content: Text(AppConstant.notificationPermissionMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppConstant.cancelLabel),
              ),
              TextButton(
                onPressed: onGoToSettings,
                child: const Text(AppConstant.goToSettingsLabel),
              ),
            ],
          ),
    );
  }

  static void showSnackBarMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: AppConstant.snackBarDuration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
