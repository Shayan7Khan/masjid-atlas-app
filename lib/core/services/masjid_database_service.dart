import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/masjid_model.dart';
import '../others/logger_customizations/custom_logger.dart';

class MasjidDatabaseService {
  final supabase = Supabase.instance.client;
  final log = CustomLogger(className: 'MasjidDatabaseService');
  final String tableName = 'masjids';

  Future<List<Masjid>> getNearbyMasjids({
    required double userLat,
    required double userLng,
    double radiusKm = 5.0,
  }) async {
    try {
      log.d(
        'Calling RPC: get_nearby_masjids with lat: $userLat, lng: $userLng, radius: $radiusKm km',
      );

      final response = await supabase.rpc(
        'get_nearby_masjids',
        params: {
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );

      if (response == null || (response as List).isEmpty) {
        log.d('No masjids found nearby');
        return [];
      }

      final masjids = response 
          .map((map) => Masjid.fromMap(Map<String, dynamic>.from(map)))
          .toList();

      log.d('Found ${masjids.length} nearby masjids');
      return masjids;
    } catch (e) {
      log.e('Error fetching nearby masjids via RPC: $e');
      return [];
    }
  }

  Future<void> saveMasjids(List<Masjid> masjids) async {
    try {
      for (var masjid in masjids) {
        await supabase.from(tableName).insert(masjid.toMap());
      }
      log.d('All masjids saved to Supabase');
    } catch (e) {
      log.e('Error saving masjids: $e');
    }
  }

  Future<List<Masjid>> getMasjidsFromDatabase() async {
    try {
      final response = await supabase.from('masjids').select().limit(100);
      if ((response as List).isEmpty) {
        return [];
      }
      return (response as List)
          .map((map) => Masjid.fromMap(Map<String, dynamic>.from(map)))
          .toList();
    } catch (e) {
      log.e('Error fetching masjids from database: $e');
      return [];
    }
  }

  Future<void> updatePrayerTimes({
    required String id,
    required Map<String, String> prayerTimes,
  }) async {
    try {
      log.d('Table: $tableName');
      log.d('ID: $id');
      log.d('Prayer Times to update: $prayerTimes');
      Map<String, dynamic> updateData = {};
      if (prayerTimes.containsKey('Fajr')) {
        updateData['namaz_fajr'] = prayerTimes['Fajr'];
      }
      if (prayerTimes.containsKey('Dhuhr')) {
        updateData['namaz_dhuhr'] = prayerTimes['Dhuhr'];
      }
      if (prayerTimes.containsKey('Asr')) {
        updateData['namaz_asr'] = prayerTimes['Asr'];
      }
      if (prayerTimes.containsKey('Maghrib')) {
        updateData['namaz_maghrib'] = prayerTimes['Maghrib'];
      }
      if (prayerTimes.containsKey('Isha')) {
        updateData['namaz_isha'] = prayerTimes['Isha'];
      }
      if (prayerTimes.containsKey('Jumma')) {
        updateData['namaz_jumma'] = prayerTimes['Jumma'];
      }
      final checkResponse = await supabase
          .from(tableName)
          .select('id, name')
          .eq('id', id)
          .maybeSingle();
      if (checkResponse == null) {
        log.e('The masjid does not exist in the database!');
        return;
      }
      final updateResponse = await supabase
          .from(tableName)
          .update(updateData)
          .eq('id', id)
          .select();
      log.d('Update response: $updateResponse');
    } catch (e) {
      log.e('Error: $e');
      rethrow;
    }
  }

  Future<void> updateFacility({
    required String id,
    required String key,
    required bool value,
  }) async {
    try {
      log.d('ID: $id');
      log.d('Column: $key');
      log.d('Value: $value');
      final checkResponse = await supabase
          .from(tableName)
          .select('id, name, $key')
          .eq('id', id)
          .maybeSingle();
      if (checkResponse == null) {
        log.e('The masjid does not exist in the database!');
        return;
      }

      final updateResponse = await supabase
          .from(tableName)
          .update({key: value})
          .eq('id', id)
          .select();

      log.d('Update response: $updateResponse');
      final verifyResponse = await supabase
          .from(tableName)
          .select(key)
          .eq('id', id)
          .single();
      log.d('Verification $key after update: ${verifyResponse[key]}');
    } catch (e) {
      log.e('Error: $e');
      rethrow;
    }
  }
}
