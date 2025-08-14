# 📱 Phone Book App with Supabase

A lightweight and responsive **Phone Book App** built with **Flutter** and **Supabase**.  
The app allows users to **create**, **edit**, **delete**, **search**, and **favorite** contacts with a clean and optimized UI for speed and responsiveness.

---

## ✨ Features

- ✅ **View Contacts** – Display all saved contacts with name and phone number.
- ➕ **Add Contact** – Add new contacts using a simple form.
- ✏️ **Edit Contact** – Update existing contact details.
- ❌ **Delete Contact** – Remove a contact from the list.
- 🔍 **Search Contacts** – Real-time search by name or phone number.
- ⭐ **Favorite Contacts** – Mark/unmark contacts as favorite.
- 🆕 **Recently Added** – Sort contacts by newest first.
- ⚡ **Optimized Performance** – Snappy UI and minimal latency with Supabase.

---

## 🛠 Tech Stack

- **Flutter** – Latest stable version
- **Supabase** – Backend & Database
- **State Management** – (e.g., Bloc / Riverpod / Provider – your choice)
- **Dart** – Null safety enabled

---

## 🗄 Database Schema

**Table:** `contacts`

| Field         | Type      | Description                            |
|---------------|-----------|----------------------------------------|
| `id`          | UUID      | Primary Key (auto-generated)           |
| `name`        | Text      | Contact’s full name                    |
| `phone`       | Text      | Phone number                           |
| `is_favorite` | Boolean   | Whether the contact is a favorite      |
| `created_at`  | Timestamp | Auto-generated timestamp on creation   |

---

## 🚀 Getting Started

### 1️⃣ Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable)
- [Supabase Account](https://supabase.com/)
- Code editor (VS Code / Android Studio)

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/jithinkjclt/supabase_phonebook
cd phone-book-app
