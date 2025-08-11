part of 'contact_list_cubit.dart';

@immutable
abstract class ContactListState {}

class ContactListInitial extends ContactListState {}

class ContactListLoading extends ContactListState {}

class ContactListSuccess extends ContactListState {
  final List<Contact> contacts;
  final bool showFavoritesOnly;

  ContactListSuccess({required this.contacts, this.showFavoritesOnly = false});
}

class ContactListError extends ContactListState {
  final String message;
  ContactListError({required this.message});
}