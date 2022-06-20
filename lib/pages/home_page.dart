import 'package:flutter/material.dart';
import 'package:kursova/main.dart';
import 'package:kursova/models/announcement.dart';
import 'package:kursova/repository/api.dart';
import 'package:kursova/state/announcement_state.dart';
import 'package:kursova/state/auth_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<AnnouncementState>().updateAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final announcementState = context.watch<AnnouncementState>();

    if (authState.loggedIn == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final api = Api();

    return AnScaffold(
      title: 'Announcements',
      child: Builder(
        builder: (BuildContext context) {
          List<Widget> children;

          if (announcementState.announcements != null) {
            children = <Widget>[
              ...announcementState.announcements!
                  .map((e) => AnnouncementWidget(announcement: e))
                  .toList(),
            ];
          } else {
            children = const <Widget>[
              Center(
                child: CircularProgressIndicator(),
              )
            ];
          }
          return Center(
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 4.0,
                  ),
                  ...children
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnnouncementWidget extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementWidget({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(announcement.tittle),
        subtitle: Text(announcement.content),
        onTap: announcement.author == context.watch<AuthState>().currentUsername
            ? () => Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => EditAnnouncement(
                      announcement: announcement,
                    )))
            : null,
        trailing: RichText(
            text: TextSpan(children: [
          // TextSpan(text: 'by ', style: Theme.of(context).textTheme.titleSmall),
          TextSpan(
              text: announcement.author!,
              style: Theme.of(context).textTheme.caption)
        ])),
      ),
    );
  }
}

class EditAnnouncement extends StatefulWidget {
  final Announcement announcement;

  EditAnnouncement({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  State<EditAnnouncement> createState() => _EditAnnouncementState();
}

class _EditAnnouncementState extends State<EditAnnouncement> {
  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  // bool isLocal = false;

  @override
  void initState() {
    _titleController.text = widget.announcement.tittle;
    _contentController.text = widget.announcement.content;
    // isLocal = widget.announcement.isLocal ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: const Text('Edit announcement'),
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
                    ElevatedButton(
                        onPressed: () async {
                          final result = await context
                              .read<AnnouncementState>()
                              .editAnnouncement(
                                Announcement(
                                  id: widget.announcement.id,
                                  tittle: _titleController.text,
                                  content: _contentController.text,
                                ),
                              );
                          late final String text;
                          if (result == null) {
                            text = 'Successfully edited';
                            Navigator.of(context).pop();
                          } else {
                            text = result;
                          }

                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(text)));
                          // isLocal = false;
                        },
                        child: Text('Save')),
                    SizedBox(
                      height: 32.0,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final result = await context
                              .read<AnnouncementState>()
                              .deleteAnnouncement(
                                id: widget.announcement.id!,
                              );
                          late final String text;
                          if (result == null) {
                            text = 'Successfully deleted';
                            Navigator.of(context).pop();
                          } else {
                            text = result;
                          }

                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(text)));
                          // isLocal = false;
                        },
                        child: RichText(
                            text: TextSpan(text: '', children: [
                          WidgetSpan(child: Icon(Icons.warning_amber)),
                          WidgetSpan(child: Text('Delete')),
                        ])))
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
