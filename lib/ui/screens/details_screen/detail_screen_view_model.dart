import 'package:flutter_antonx_boilerplate/core/enums/view_state.dart';
import 'package:flutter_antonx_boilerplate/core/models/masjid_model.dart';
import 'package:flutter_antonx_boilerplate/core/others/base_view_model.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/services/masjid_database_service.dart';

class DetailScreenViewModel extends BaseViewModel {
  final MasjidDatabaseService _db = MasjidDatabaseService();
  final CustomLogger log = CustomLogger(className: 'DetailViewModel');

  Masjid? masjid;

  Map<String, String> get prayerTimes => masjid?.prayerTimes ?? {};
  bool get isWudu => masjid?.isWudu ?? false;
  bool get isFemale => masjid?.isFemale ?? false;
  bool get isSeating => masjid?.isSeating ?? false;
  bool get isParking => masjid?.isParking ?? false;
  bool get isWashroom => masjid?.isWashroom ?? false;

  Future<void> updatePrayerTime(String prayerName, String newTime) async {
    if (masjid == null) {
      log.e('Masjid is null, cannot update prayer time');
      return;
    }
    if (masjid!.id == null) {
      log.e('Masjid ID is null, cannot update prayer time');
      return;
    }
    if (masjid!.prayerTimes == null) {
      masjid = masjid!.copyWith(prayerTimes: {});
    }
    final updatedPrayerTimes = Map<String, String>.from(masjid!.prayerTimes!);
    updatedPrayerTimes[prayerName] = newTime;
    log.d('Updated prayer times: $updatedPrayerTimes');
    masjid = masjid!.copyWith(prayerTimes: updatedPrayerTimes);
    notifyListeners();
    setState(ViewState.busy);
    try {
      await _db.updatePrayerTimes(
        id: masjid!.id!,
        prayerTimes: updatedPrayerTimes,
      );
      log.d('Prayer time updated successfully in database');
    } catch (e) {
      log.e('Failed to update prayer time in database: $e');
    }
    setState(ViewState.idle);
  }

  Future<void> toggleFacility(String key) async {
    log.d('Key: $key');
    log.d('Masjid ID: ${masjid?.id}');
    if (masjid == null) {
      log.e('Masjid is null, cannot update');
      return;
    }
    if (masjid!.id == null) {
      log.e('Masjid ID is null, cannot update');
      return;
    }
    bool currentValue;
    bool newValue;
    switch (key) {
      case 'has_wudu':
        currentValue = masjid!.isWudu ?? false;
        newValue = !currentValue;
        log.d("Wudu: $currentValue -> $newValue");
        masjid = masjid!.copyWith(isWudu: newValue);
        break;
      case 'has_women_prayer':
        currentValue = masjid!.isFemale ?? false;
        newValue = !currentValue;
        log.d("Female: $currentValue -> $newValue");
        masjid = masjid!.copyWith(isFemale: newValue);
        break;
      case 'has_elderly_seating':
        currentValue = masjid!.isSeating ?? false;
        newValue = !currentValue;
        log.d("Seating: $currentValue -> $newValue");
        masjid = masjid!.copyWith(isSeating: newValue);
        break;
      case 'has_parking':
        currentValue = masjid!.isParking ?? false;
        newValue = !currentValue;
        log.d("Parking: $currentValue -> $newValue");
        masjid = masjid!.copyWith(isParking: newValue);
        break;
      case 'has_washroom':
        currentValue = masjid!.isWashroom ?? false;
        newValue = !currentValue;
        log.d("Washroom: $currentValue -> $newValue");
        masjid = masjid!.copyWith(isWashroom: newValue);
        break;
      default:
        log.e('Unknown key: $key');
        return;
    }
    notifyListeners();
    setState(ViewState.busy);
    try {
      await _db.updateFacility(id: masjid!.id!, key: key, value: newValue);
      log.d('Database update completed successfully');
    } catch (e) {
      log.e('Database update FAILED: $e');
    }
    setState(ViewState.idle);
  }

  DateTime parseTime(String time) {
    try {
      final clean = time.trim();
      final isPM = clean.contains('PM');

      final raw = clean.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = raw.split(':');

      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      return DateTime(2024, 1, 1, hour, minute);
    } catch (_) {
      return DateTime.now();
    }
  }
}
