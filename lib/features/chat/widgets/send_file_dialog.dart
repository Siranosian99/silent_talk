import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/securitycenter/v1.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/providers/loading_provider.dart';

Future<void> showFileDialog(
  BuildContext context,
  String fileName,
  Future<void> Function() onTap,
) async {
  final loaderProvider = Provider.of<LoadingProvider>(context, listen: false);
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<LoadingProvider>(
        builder: (context, loader, child) {
          return loader.isLoading
              ? Center(child: LinearProgressIndicator())
              : AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Image.asset('assets/icons/document.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(fileName)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        loaderProvider.setLoading(true);
                        await onTap();

                        if (!context.mounted) return;
                        context.pop();
                        loaderProvider.setLoading(false);
                      } finally {
                        loaderProvider.setLoading(false);
                      }
                    },
                    icon: Icon(Icons.send),
                    label: const Text("Send"),
                  ),
                ],
              );
        },
      );
    },
  );
}
