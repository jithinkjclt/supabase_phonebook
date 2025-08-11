import 'package:flutter/material.dart';

class ContactsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? bottomContent;
  final ValueChanged<String> onSearchChanged;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color hintColor;
  final Widget? trailing;

  const ContactsAppBar({
    super.key,
    required this.onSearchChanged,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.hintColor,
    this.trailing,
    this.bottomContent,
  });

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Contacts',
        style: TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [if (trailing != null) trailing!, const SizedBox(width: 16)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (bottomContent != null) bottomContent!,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  onChanged: onSearchChanged,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search contacts...',
                    hintStyle: TextStyle(color: hintColor),
                    prefixIcon: Icon(Icons.search, color: iconColor),
                    filled: true,
                    fillColor: iconColor.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
