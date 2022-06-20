import 'package:flutter/material.dart';
import 'package:kursova/models/announcement.dart';
import 'package:kursova/pages/home_page.dart';
import 'package:kursova/pages/login_page.dart';
import 'package:kursova/pages/registration_page.dart';
import 'package:kursova/repository/api.dart';
import 'package:kursova/state/announcement_state.dart';
import 'package:kursova/state/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => AnnouncementState())
      ],
      child: MaterialApp(
        title: 'Announcements',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => AnScaffold(
                title: 'Login',
                child: LoginPage(),
              ),
          '/registration': (context) => AnScaffold(
                title: 'Registration',
                child: RegistrationPage(),
              ),
        },
        theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      ),
    );
  }
}

class AnScaffold extends StatelessWidget {
  const AnScaffold({Key? key, required this.title, required this.child})
      : super(key: key);
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.select((AuthState auth) => auth.loggedIn);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (!loggedIn.notNullOrTrue) ...[
            TextButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/login'),
              icon: const Icon(Icons.login),
              label: const Text('Login'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/registration'),
              icon: const Icon(Icons.create),
              label: const Text('Registration'),
            )
          ] else
            const AccountTextButton(),
        ],
      ),
      body: child,
      floatingActionButton: loggedIn.notNullOrTrue
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => CreateAnnouncement())),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class CreateAnnouncement extends StatefulWidget {
  CreateAnnouncement({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  bool isLocal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: const Text('Add announcement'),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 1 / 3,
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text('Is local?'),
                        Switch(
                            value: isLocal,
                            onChanged: (value) {
                              setState(() {
                                isLocal = value;
                              });
                            }),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final result = await context
                              .read<AnnouncementState>()
                              .addAnnouncement(
                                Announcement(
                                    tittle: _titleController.text,
                                    content: _contentController.text,
                                    isLocal: isLocal),
                              );
                          late final String text;
                          if (result == null) {
                            text = 'Successfully added';
                            _titleController.clear();
                            _contentController.clear();
                          } else {
                            text = result;
                          }

                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(text)));
                          // isLocal = false;
                        },
                        child: Text('Add'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension Ban on bool? {
  bool get notNullOrTrue {
    return this == null || this!;
  }
}

class AccountTextButton extends StatelessWidget {
  const AccountTextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => showModalBottomSheet(
            constraints: BoxConstraints.loose(
              Size(MediaQuery.of(context).size.width / 1.5,
                  MediaQuery.of(context).size.height / 1),
            ),
            context: context,
            builder: (BuildContext context) {
              return const ManageAccount();
            }),
        icon: const Icon(Icons.person),
        label: Text(context.watch<AuthState>().currentUsername!));
  }
}

class ManageAccount extends StatelessWidget {
  const ManageAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UpdateAccountInfo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete, color: Colors.red),
                label: Text(
                  'Delete account',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.red),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<AuthState>().logout();
                  context.read<AnnouncementState>().updateAnnouncements();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.logout, color: Colors.amber),
                label: Text(
                  'Log out',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.amber),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UpdateAccountInfo extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  UpdateAccountInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1 / 3,
      child: Column(
        children: [
          Form(
              child: Column(
            children: [
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  primary: Theme.of(context).colorScheme.primary,
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                onPressed: () async {
                  final result = await context.read<AuthState>().updateUser(
                      username: _usernameController.text,
                      firstname: _firstnameController.text,
                      lastname: _lastnameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      city: _cityController.text);

                  if (result != null) {
                    Navigator.of(context).pop();

                    context.read<AnnouncementState>().updateAnnouncements();
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
