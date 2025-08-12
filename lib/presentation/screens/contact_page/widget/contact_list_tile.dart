import 'package:flutter/material.dart';

import '../../../../domain/entities/contact.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final Function(BuildContext, Contact)? onEdit;
  final Function(Contact)? onDelete;

  const ContactTile({
    super.key,
    required this.contact,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
    this.onTap,
    this.onFavoriteToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDark ? Colors.grey.shade800 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: isDark
          ? Colors.black.withOpacity(0.5)
          : Colors.grey.withOpacity(0.2),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.015,
        ),
        leading: Container(
          width: screenWidth * 0.12,
          height: screenWidth * 0.12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? Colors.blue.shade900 : Colors.blue.shade100,
          ),
          child: Center(
            child: Text(
              contact.name.isNotEmpty ? contact.name[0] : '',
              style: TextStyle(
                color: isDark ? Colors.blue.shade300 : Colors.blue.shade800,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
        ),
        title: Text(
          contact.name,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.045,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          contact.phone,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: screenWidth * 0.035,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  contact.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: contact.isFavorite
                      ? Colors.amber.shade600
                      : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                  size: screenWidth * 0.07,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'edit' && onEdit != null) {
                  onEdit!(context, contact);
                } else if (result == 'delete' && onDelete != null) {
                  onDelete!(contact);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              icon: Icon(
                Icons.more_vert_rounded,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              color: isDark ? Colors.grey.shade700 : Colors.white,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
