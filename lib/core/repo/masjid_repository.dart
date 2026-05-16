import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/services/masjid_database_service.dart';
import '../models/masjid_model.dart';

class MasjidRepository {
  final MasjidDatabaseService _db = MasjidDatabaseService();
  final log = CustomLogger(className: 'MasjidRepository');

  Future<List<Masjid>> getMasjids({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    try {
      log.d(
        'Fetching nearby masjids for location: ($lat, $lng) within $radiusKm km',
      );
      final masjids = await _db.getNearbyMasjids(
        userLat: lat,
        userLng: lng,
        radiusKm: radiusKm,
      );
      if (masjids.isEmpty) {
        log.d('No masjids found nearby');
      } else {
        log.d('Loaded ${masjids.length} masjids from Supabase RPC');
      }
      return masjids;
    } catch (e) {
      log.e('Error in getMasjids: $e');
      return [];
    }
  }
}
