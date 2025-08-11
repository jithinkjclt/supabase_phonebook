import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/entities/contact.dart';

part 'contact_list_state.dart';

class ContactListCubit extends Cubit<ContactListState> {
  ContactListCubit() : super(ContactListInitial()) {
    fetchContacts();
  }

  final _supabaseClient = Supabase.instance.client;
  List<Contact> _originalContacts = [];
  bool _showFavoritesOnly = false;


  Future<void> fetchContacts() async {
    emit(ContactListLoading());
    try {
      final response = await _supabaseClient
          .from('contacts')
          .select()
          .order('created_at', ascending: false);

      _originalContacts = (response as List)
          .map((e) => Contact.fromJson(e))
          .toList();
      _applyFilter();
    } on PostgrestException catch (e) {
      emit(ContactListError(message: e.message));
    } catch (e) {
      emit(
        ContactListError(message: 'Failed to fetch contacts: ${e.toString()}'),
      );
    }
  }

  void toggleFavoritesFilter() {
    _showFavoritesOnly = !_showFavoritesOnly;
    _applyFilter();
  }

  void _applyFilter() {
    List<Contact> filteredList = _originalContacts;
    if (_showFavoritesOnly) {
      filteredList = _originalContacts
          .where((contact) => contact.isFavorite)
          .toList();
    }
    emit(
      ContactListSuccess(
        contacts: filteredList,
        showFavoritesOnly: _showFavoritesOnly,
      ),
    );
  }

  Future<void> addContact({required String name, required String phone}) async {
    try {
      await _supabaseClient.from('contacts').insert({
        'name': name,
        'phone': phone,
      });
      await fetchContacts();
    } on PostgrestException catch (e) {
      emit(ContactListError(message: e.message));
    } catch (e) {
      emit(ContactListError(message: 'Failed to add contact: ${e.toString()}'));
    }
  }

  Future<void> updateContact(Contact contact) async {
    final currentState = state;
    if (currentState is! ContactListSuccess) return;

    final updatedContacts = List<Contact>.from(currentState.contacts);
    final contactIndex = updatedContacts.indexWhere((c) => c.id == contact.id);
    if (contactIndex != -1) {
      updatedContacts[contactIndex] = contact;
      emit(
        ContactListSuccess(
          contacts: updatedContacts,
          showFavoritesOnly: _showFavoritesOnly,
        ),
      );
    }

    try {
      await _supabaseClient
          .from('contacts')
          .update({
            'name': contact.name,
            'phone': contact.phone,
            'is_favorite': contact.isFavorite,
          })
          .eq('id', contact.id);

      final originalIndex = _originalContacts.indexWhere(
        (c) => c.id == contact.id,
      );
      if (originalIndex != -1) {
        _originalContacts[originalIndex] = contact;
      }
      _applyFilter();
    } on PostgrestException catch (e) {
      emit(ContactListError(message: e.message));
      fetchContacts();
    } catch (e) {
      emit(
        ContactListError(message: 'Failed to update contact: ${e.toString()}'),
      );
    }
  }

  Future<void> deleteContact(String contactId) async {
    final currentState = state;
    if (currentState is! ContactListSuccess) return;

    final updatedContacts = currentState.contacts
        .where((c) => c.id != contactId)
        .toList();
    emit(
      ContactListSuccess(
        contacts: updatedContacts,
        showFavoritesOnly: _showFavoritesOnly,
      ),
    );

    try {
      await _supabaseClient.from('contacts').delete().eq('id', contactId);
      _originalContacts.removeWhere((c) => c.id == contactId);
    } on PostgrestException catch (e) {
      emit(ContactListError(message: e.message));
      fetchContacts();
    } catch (e) {
      emit(
        ContactListError(message: 'Failed to delete contact: ${e.toString()}'),
      );
      fetchContacts();
    }
  }

  Future<void> searchContacts(String query) async {
    _showFavoritesOnly = false; //

    final currentState = state;
    if (currentState is! ContactListSuccess) {
      return;
    }

    if (query.isEmpty) {
      emit(ContactListSuccess(contacts: _originalContacts));
      return;
    }

    final filteredContacts = _originalContacts.where((contact) {
      final lowerQuery = query.toLowerCase();
      final nameMatches = contact.name.toLowerCase().contains(lowerQuery);
      final numberMatches = contact.phone.toLowerCase().contains(lowerQuery);
      return nameMatches || numberMatches;
    }).toList();

    emit(ContactListSuccess(contacts: filteredContacts));
  }
}
