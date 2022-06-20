import 'package:flutter/material.dart';
import 'package:kursova/models/announcement.dart';
import 'package:kursova/state/announcement_state.dart';
import 'package:kursova/state/auth_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    if (authState.loggingIn) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: FractionallySizedBox(
        widthFactor: 1 / 3,
        child: Form(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((authState.loggedIn != null) && authState.loggedIn!)
              const Text('Logged in'),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                // errorText: 'Error message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).colorScheme.onPrimary,
                primary: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: () async {
                final result = await authState.login(
                    username: _usernameController.text,
                    password: _passwordController.text);

                if (result != null) {
                  context.read<AnnouncementState>().updateAnnouncements();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Log in'),
            ),
          ],
        )),
      ),
    );
  }
}
