import 'package:flutter_antonx_boilerplate/core/constants/api_end_points.dart';
import 'package:flutter_antonx_boilerplate/core/models/masjid_model.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/services/api_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_antonx_boilerplate/locator.dart';

class MasjidApiService {
  final log = CustomLogger(className: 'Masjid Api Service');
  final ApiServices _apiServices = locator<ApiServices>();
  final _apiKey = dotenv.env['API_KEY'];

  Future<List<Masjid>> getMasjidLoctions({
    required double lat,
    required double lng,
  }) async {
    try {
      log.d('calling masjid api');
      final response = await _apiServices.get(
        endPoint: EndPoints.masjidLocation,
        params: {
          "location": "$lat,$lng",
          "radius": 10000,
          "type": "mosque",
          "key": _apiKey,
        },
      );

      if (response == null) {
        log.e("Response is null");
        return [];
      }

      if (!response.success) {
        log.e(response.error ?? "Unknown error");
        return [];
      }

      final results = response.data?["results"] as List?;
      if (results == null || results.isEmpty) {
        log.e("No results found in response");
        return [];
      }

      return results
          .map((json) => Masjid.fromMap(json))
          .whereType<Masjid>()
          .toList();
    } catch (e) {
      log.e('Error in getting masjid locations: $e');
      return [];
    }
  }
}
