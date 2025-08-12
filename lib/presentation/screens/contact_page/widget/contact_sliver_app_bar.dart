import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_book_app/presentation/screens/contact_page/cubit/contact_list_cubit.dart';
import 'package:phone_book_app/presentation/widget/appbar.dart';

class ContactSliverAppBar extends StatelessWidget {
  const ContactSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ContactListCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<ContactListCubit, ContactListState>(
      builder: (context, state) {
        final showFavoritesOnly = (state is ContactListSuccess) ? state.showFavoritesOnly : false;
        final showRecentlyAddedOnly = (state is ContactListSuccess) ? state.showRecentlyAddedOnly : false;
        final isAllContacts = !showFavoritesOnly && !showRecentlyAddedOnly;

        final toggleButtons = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  if (!isAllContacts) {
                    cubit.toggleAllContactsFilter();
                  }
                },
                child: Text(
                  'All Contacts',
                  style: TextStyle(
                    color: isAllContacts ? Colors.blue : Colors.grey,
                    fontWeight: isAllContacts ? FontWeight.bold : FontWeight.normal,
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
                    fontWeight: showFavoritesOnly ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              TextButton(
                onPressed: () {
                  if (!showRecentlyAddedOnly) {
                    cubit.toggleRecentlyAddedFilter();
                  }
                },
                child: Text(
                  'Recently Added',
                  style: TextStyle(
                    color: showRecentlyAddedOnly ? Colors.blue : Colors.grey,
                    fontWeight: showRecentlyAddedOnly ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );

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
      },
    );
  }
}