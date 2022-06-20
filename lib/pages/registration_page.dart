import 'package:flutter/material.dart';
import 'package:kursova/models/announcement.dart';
import 'package:kursova/state/announcement_state.dart';
import 'package:kursova/state/auth_state.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegistrationPage({Key? key}) : super(key: key);

  String? Function(String?) notLessThan(int characters) {
    return (String? value) {
      if (value != null && value.length >= characters) {
        return null;
      } else {
        return '${value!.length}/${characters} characters provided';
      }
    };
  }

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
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if ((authState.loggedIn != null) && authState.loggedIn!)
                //   const Text('Logged in'),
                TextFormField(
                  controller: _usernameController,
                  validator: notLessThan(4),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _firstnameController,
                  validator: notLessThan(3),
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _lastnameController,
                  validator: notLessThan(3),
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (email) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email ?? '')
                        ? null
                        : 'Invalid email';
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: notLessThan(8),
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
                    if (!_formKey.currentState!.validate()) return;
                    final result = await authState.register(
                        username: _usernameController.text,
                        password: _passwordController.text,
                        firstname: _firstnameController.text,
                        lastname: _lastnameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        city: _cityController.text);

                    if (result != null) {
                      Navigator.of(context).pop();
                      // context.read<AnnouncementState>().updateAnnouncements();
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            )),
      ),
    );
  }
}
