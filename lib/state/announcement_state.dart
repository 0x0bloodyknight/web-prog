import 'package:flutter/cupertino.dart';
import 'package:kursova/models/announcement.dart';
import 'package:kursova/repository/api.dart';

class AnnouncementState extends ChangeNotifier {
  List<Announcement>? _announcements;
  Api _api = Api();

  List<Announcement>? get announcements => _announcements;

  Future<void> updateAnnouncements() async {
    _announcements = await _api.getAnnouncements();
    _announcements = [
      ..._announcements!,
      ...(await _api.getLocalAnnouncements())
    ];
    notifyListeners();
  }

  Future<String?> addAnnouncement(Announcement announcement) async {
    final result = await Api().addAnnouncement(
      Announcement(
          tittle: announcement.tittle,
          content: announcement.content,
          isLocal: announcement.isLocal),
    );
    updateAnnouncements();
    return result;
  }

  Future<String?> editAnnouncement(Announcement announcement) async {
    final result = await Api().editAnnouncement(announcement);
    updateAnnouncements();
    return result;
  }

  Future<String?> deleteAnnouncement({required int id}) async {
    final result = await Api().deleteAnnouncement(id);
    updateAnnouncements();
    return result;
  }
}
