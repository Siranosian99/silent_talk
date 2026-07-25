
import 'package:flutter/material.dart';

import '../../constants/texts.dart';

Future<void> ShowDialogLocation(BuildContext context) async => await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Info!!!!"),
      content:  Text(
          AppTexts.instance.map
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Continue"),
        ),
      ],
    ),
  );