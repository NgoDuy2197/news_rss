import 'package:flutter/material.dart';

import '../../../core/utils/notification_helper.dart';
import '../../../l10n/app_localizations.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.alertsHeader,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(l10n.alertDialogBody),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(l10n.alertDialogTitle),
                        content: Text(l10n.alertDialogBody),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.close),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.notification_important),
                label: Text(l10n.triggerAlert),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  NotificationHelper.showSnack(
                    context,
                    message: '${l10n.alertDialogTitle}! ${l10n.alertDialogBody}',
                  );
                },
                icon: const Icon(Icons.notifications_active),
                label: const Text('Snack'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
