import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_book_app/presentation/screens/contact_page/widget/contact_list_tile.dart';
import 'package:phone_book_app/presentation/widget/appbar.dart';
import 'package:phone_book_app/presentation/widget/spacing_extensions.dart';

import '../../../../domain/entities/contact.dart';
import '../../widget/customtextfield.dart';
import 'cubit/contact_list_cubit.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  void _showContactDialog(BuildContext context, {Contact? contact}) {
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
                      contact.copyWith(
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

  void _showDeleteConfirmationDialog(BuildContext context, Contact contact) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = context.deviceSize.width;
    final screenHeight = context.deviceSize.height;

    return BlocProvider(
      create: (context) => ContactListCubit(),
      child: BlocBuilder<ContactListCubit, ContactListState>(
        builder: (context, state) {
          final cubit = context.read<ContactListCubit>();
          final showFavoritesOnly = (state is ContactListSuccess)
              ? state.showFavoritesOnly
              : false;

          final toggleButtons = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  if (showFavoritesOnly) {
                    cubit.toggleFavoritesFilter();
                  }
                },
                child: Text(
                  'All Contacts',
                  style: TextStyle(
                    color: !showFavoritesOnly ? Colors.blue : Colors.grey,
                    fontWeight: !showFavoritesOnly
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              TextButton(
                onPressed: () {
                  if (!showFavoritesOnly) {
                    cubit.toggleFavoritesFilter();
                  }
                },
                child: Text(
                  'Favorites',
                  style: TextStyle(
                    color: showFavoritesOnly ? Colors.blue : Colors.grey,
                    fontWeight: showFavoritesOnly
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );

          return Scaffold(
            backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
            body: Builder(
              builder: (context) {
                if (state is ContactListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ContactListError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                } else {
                  final contacts = (state is ContactListSuccess)
                      ? state.contacts
                      : [];
                  if (contacts.isEmpty) {
                    return CustomScrollView(
                      slivers: [
                        _buildSliverAppBar(
                          context,
                          isDark,
                          cubit,
                          toggleButtons,
                          screenHeight,
                        ),
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
                      _buildSliverAppBar(
                        context,
                        isDark,
                        cubit,
                        toggleButtons,
                        screenHeight,
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final contact = contacts[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: screenHeight * 0.015,
                              ),
                              child: ContactTile(
                                contact: contact,
                                isDark: isDark,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                onTap: () {},
                                onFavoriteToggle: () {
                                  cubit.updateContact(
                                    contact.copyWith(
                                      isFavorite: !contact.isFavorite,
                                    ),
                                  );
                                },
                                onEdit: (context, contactToEdit) {
                                  _showContactDialog(
                                    context,
                                    contact: contactToEdit,
                                  );
                                },
                                onDelete: (contactToDelete) {
                                  _showDeleteConfirmationDialog(
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
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showContactDialog(context),
              backgroundColor: Colors.blue.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.07),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: screenWidth * 0.07,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    bool isDark,
    ContactListCubit cubit,
    Row toggleButtons,
    double screenHeight,
  ) {
    return SliverAppBar(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      expandedHeight: screenHeight * 0.18,
      floating: true,
      pinned: true,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            background: ContactsAppBar(
              onSearchChanged: (value) => cubit.searchContacts(value),
              backgroundColor: isDark
                  ? Colors.black.withOpacity(0.95)
                  : Colors.white.withOpacity(0.95),
              textColor: isDark ? Colors.white : Colors.black87,
              iconColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              hintColor: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              bottomContent: toggleButtons,
              trailing: null,
            ),
          ),
        ),
      ),
    );
  }
}
