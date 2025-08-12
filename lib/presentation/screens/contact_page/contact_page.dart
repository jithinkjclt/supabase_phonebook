// lib/presentation/screens/contact_page/contact_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_book_app/presentation/screens/contact_page/cubit/contact_list_cubit.dart';
import 'package:phone_book_app/presentation/screens/contact_page/widget/add_contact_dialog.dart';
import 'package:phone_book_app/presentation/screens/contact_page/widget/contact_list_view.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactListCubit(),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: const ContactListView(),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () => showAddContactDialog(context),
              backgroundColor: Colors.blue.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.07,
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.07,
              ),
            );
          },
        ),
      ),
    );
  }
}
