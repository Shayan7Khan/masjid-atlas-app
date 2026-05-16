class Masjid {
  final String? id;
  final String name;
  final double lat;
  final double lng;
  final String? address;
  final String? placeId;
  final Map<String, String>? prayerTimes;
  final bool? isWudu;
  final bool? isFemale;
  final bool? isSeating;
  final bool? isParking;
  final bool? isWashroom;
  final double? distanceKm; 

  Masjid({
    this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.placeId,
    this.address,
    this.prayerTimes,
    this.isWudu,
    this.isFemale,
    this.isSeating,
    this.isParking,
    this.isWashroom,
    this.distanceKm,
  });

  factory Masjid.fromMap(Map<String, dynamic> map) {
    Map<String, String> prayerTimesMap = {};

    if (map['namaz_fajr'] != null && map['namaz_fajr'].toString().isNotEmpty) {
      prayerTimesMap['Fajr'] = map['namaz_fajr'].toString();
    }
    if (map['namaz_dhuhr'] != null &&
        map['namaz_dhuhr'].toString().isNotEmpty) {
      prayerTimesMap['Dhuhr'] = map['namaz_dhuhr'].toString();
    }
    if (map['namaz_asr'] != null && map['namaz_asr'].toString().isNotEmpty) {
      prayerTimesMap['Asr'] = map['namaz_asr'].toString();
    }
    if (map['namaz_maghrib'] != null &&
        map['namaz_maghrib'].toString().isNotEmpty) {
      prayerTimesMap['Maghrib'] = map['namaz_maghrib'].toString();
    }
    if (map['namaz_isha'] != null && map['namaz_isha'].toString().isNotEmpty) {
      prayerTimesMap['Isha'] = map['namaz_isha'].toString();
    }
    if (map['namaz_jumma'] != null &&
        map['namaz_jumma'].toString().isNotEmpty) {
      prayerTimesMap['Jumma'] = map['namaz_jumma'].toString();
    }

    return Masjid(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      lat: (map['latitude'] ?? 0.0).toDouble(),
      lng: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'],
      placeId: map['place_id'],
      prayerTimes: prayerTimesMap.isEmpty ? null : prayerTimesMap,
      isWudu: map['has_wudu'] ?? false,
      isFemale: map['has_women_prayer'] ?? false,
      isSeating: map['has_elderly_seating'] ?? false,
      isParking: map['has_parking'] ?? false,
      isWashroom: map['has_washroom'] ?? false,
      distanceKm: map['distance_km'] != null
          ? (map['distance_km'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': lat,
      'longitude': lng,
      'address': address,
      'place_id': placeId,
      'namaz_fajr': prayerTimes?['Fajr'],
      'namaz_dhuhr': prayerTimes?['Dhuhr'],
      'namaz_asr': prayerTimes?['Asr'],
      'namaz_maghrib': prayerTimes?['Maghrib'],
      'namaz_isha': prayerTimes?['Isha'],
      'namaz_jumma': prayerTimes?['Jumma'],
      'has_wudu': isWudu ?? false,
      'has_women_prayer': isFemale ?? false,
      'has_elderly_seating': isSeating ?? false,
      'has_parking': isParking ?? false,
      'has_washroom': isWashroom ?? false,
    };
  }

  Masjid copyWith({
    Map<String, String>? prayerTimes,
    bool? isWudu,
    bool? isFemale,
    bool? isSeating,
    bool? isParking,
    bool? isWashroom,
  }) {
    return Masjid(
      id: id,
      name: name,
      lat: lat,
      lng: lng,
      placeId: placeId,
      address: address,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      isWudu: isWudu ?? this.isWudu,
      isFemale: isFemale ?? this.isFemale,
      isSeating: isSeating ?? this.isSeating,
      isParking: isParking ?? this.isParking,
      isWashroom: isWashroom ?? this.isWashroom,
      distanceKm: distanceKm,
    );
  }
}
