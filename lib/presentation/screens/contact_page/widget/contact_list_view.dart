import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_book_app/presentation/screens/contact_page/cubit/contact_list_cubit.dart';
import 'package:phone_book_app/presentation/screens/contact_page/widget/contact_list_tile.dart';
import 'package:phone_book_app/presentation/screens/contact_page/widget/delete_confirmation_dialog.dart';
import 'package:phone_book_app/presentation/screens/contact_page/widget/add_contact_dialog.dart';
import 'package:phone_book_app/presentation/screens/contact_page/widget/contact_sliver_app_bar.dart';

class ContactListView extends StatelessWidget {
  const ContactListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cubit = context.read<ContactListCubit>();

    return BlocBuilder<ContactListCubit, ContactListState>(
      builder: (context, state) {
        if (state is ContactListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContactListError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          );
        } else {
          final contacts = (state is ContactListSuccess) ? state.contacts : [];
          if (contacts.isEmpty) {
            return CustomScrollView(
              slivers: [
                const ContactSliverAppBar(),
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No contacts found.',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return CustomScrollView(
            slivers: [
              const ContactSliverAppBar(),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final contact = contacts[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                      child: ContactTile(
                        contact: contact,
                        isDark: isDark,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        onTap: () {},
                        onFavoriteToggle: () {
                          cubit.updateContact(
                            contact.copyWith(isFavorite: !contact.isFavorite),
                          );
                        },
                        onEdit: (context, contactToEdit) {
                          showAddContactDialog(context, contact: contactToEdit);
                        },
                        onDelete: (contactToDelete) {
                          showDeleteConfirmationDialog(
                            context,
                            contactToDelete,
                          );
                        },
                      ),
                    );
                  }, childCount: contacts.length),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
