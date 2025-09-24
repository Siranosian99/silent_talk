import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/utils/localization/local_provider.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // background color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: localeProvider.locale,
          icon: const Icon(Icons.language, color: Colors.blueAccent),
          isExpanded: true,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
          items: const [
            DropdownMenuItem(value: Locale('en'), child: Text("English")),
            DropdownMenuItem(value: Locale('tr'), child: Text("Türkçe")),
            DropdownMenuItem(value: Locale('ar'), child: Text("العربية")),
            DropdownMenuItem(value: Locale('hy'), child: Text("Հայերեն")),
          ],
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localeProvider.setLocale(newLocale);
            }
          },
        ),
      ),
    );
  }
}
