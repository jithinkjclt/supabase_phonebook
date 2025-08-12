import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_book_app/domain/entities/contact.dart';
import 'package:phone_book_app/presentation/screens/contact_page/cubit/contact_list_cubit.dart';

void showDeleteConfirmationDialog(BuildContext context, Contact contact) {
  final cubit = context.read<ContactListCubit>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Contact'),
        content: Text(
          'Are you sure you want to delete ${contact.name}? This action cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
            onPressed: () {
              cubit.deleteContact(contact.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}