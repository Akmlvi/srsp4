import 'package:flutter/material.dart';

import '../services/user_storage.dart';
import 'registration_page.dart';

/// Показывает данные, сохранённые в SharedPreferences.
class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late Future<UserData?> _future;

  @override
  void initState() {
    super.initState();
    _future = UserStorage.load();
  }

  Future<void> _reset() async {
    await UserStorage.clear();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info'), centerTitle: true),
      body: FutureBuilder<UserData?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('No saved data'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 44,
                  child: Icon(Icons.person, size: 52),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Full Name'),
                      subtitle: Text(user.name),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.call),
                      title: const Text('Phone Number'),
                      subtitle: Text(user.phone),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email Address'),
                      subtitle: Text(user.email),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.notes),
                      title: const Text('Life Story'),
                      subtitle: Text(
                        user.story.isEmpty ? '—' : user.story,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.logout),
                  label: const Text('Clear data and register again'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
