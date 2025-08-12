import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_book_app/domain/entities/contact.dart';
import 'package:phone_book_app/presentation/screens/contact_page/cubit/contact_list_cubit.dart';
import 'package:phone_book_app/presentation/widget/customtextfield.dart';
import 'package:phone_book_app/presentation/widget/spacing_extensions.dart';

void showAddContactDialog(BuildContext context, {Contact? contact}) {
  final nameController = TextEditingController(text: contact?.name);
  final phoneController = TextEditingController(text: contact?.phone);
  final cubit = context.read<ContactListCubit>();
  final isEditing = contact != null;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          // Add this line to specify a border
          side: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        title: Text(
          isEditing ? 'Edit Contact' : 'Add New Contact',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: nameController,
                hintText: 'Enter name',
                leadingIcon: Icons.person_outline,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                noBorder: true,
                height: 1.0,
              ),
              16.hBox,
              CustomTextField(
                controller: phoneController,
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                leadingIcon: Icons.phone_outlined,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                noBorder: true,
                height: 1.0,
              ),
            ],
          ),
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
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: Text(isEditing ? 'Update' : 'Save'),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                if (isEditing) {
                  cubit.updateContact(
                    contact!.copyWith(
                      name: nameController.text,
                      phone: phoneController.text,
                    ),
                  );
                } else {
                  cubit.addContact(
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                }
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}