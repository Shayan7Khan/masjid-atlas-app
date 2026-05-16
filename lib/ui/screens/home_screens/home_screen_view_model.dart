import 'package:flutter/widgets.dart';
import 'package:flutter_antonx_boilerplate/core/enums/view_state.dart';
import 'package:flutter_antonx_boilerplate/core/models/masjid_model.dart';
import 'package:flutter_antonx_boilerplate/core/others/base_view_model.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/repo/masjid_repository.dart';
import 'package:flutter_antonx_boilerplate/core/services/auth_service.dart';
import 'package:flutter_antonx_boilerplate/locator.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/auth_screen/auth_screen.dart';
import 'package:get/get.dart';

class HomeScreenViewModel extends BaseViewModel {
  final MasjidRepository _masjidRepository = locator<MasjidRepository>();
  final AuthService _authService = locator<AuthService>();
  final log = CustomLogger(className: 'HomeScreenViewModel');

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  // final randomHadith = MasjidHadiths.getRandomHadith();

  List<Masjid> _allMasjids = [];
  List<Masjid> _filteredMasjids = [];
  String _searchQuery = '';

  double? _lastLat;
  double? _lastLng;
  double _searchRadiusKm = 5.0; 

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  List<Masjid> get masjid => _filteredMasjids.isEmpty && _searchQuery.isEmpty
      ? _allMasjids
      : _filteredMasjids;

  Future<void> getMasjidLocations({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    setState(ViewState.busy);
    try {
      _lastLat = latitude;
      _lastLng = longitude;
      _searchRadiusKm = radiusKm;

      log.d(
        'Fetching masjids near ($latitude, $longitude) within $radiusKm km',
      );
      _allMasjids = await _masjidRepository.getMasjids(
        lat: latitude,
        lng: longitude,
        radiusKm: radiusKm,
      );
      _filteredMasjids = _allMasjids;
      log.d('Successfully loaded ${_allMasjids.length} masjids');
      notifyListeners();
    } catch (e) {
      log.e('Error fetching masjid locations: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  void searchMasjids(String query) {
    _searchQuery = query.toLowerCase().trim();

    if (_searchQuery.isEmpty) {
      _filteredMasjids = _allMasjids;
    } else {
      _filteredMasjids = _allMasjids.where((masjid) {
        final name = masjid.name.toLowerCase();
        final address = (masjid.address ?? '').toLowerCase();
        return name.contains(_searchQuery) || address.contains(_searchQuery);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> refreshMasjidData() async {
    log.d('Refreshing masjid data...');
    if (_lastLat != null && _lastLng != null) {
      try {
        final freshMasjids = await _masjidRepository.getMasjids(
          lat: _lastLat!,
          lng: _lastLng!,
          radiusKm: _searchRadiusKm,
        );
        if (freshMasjids.isNotEmpty) {
          _allMasjids = freshMasjids;
          if (_searchQuery.isNotEmpty) {
            _filteredMasjids = _allMasjids.where((masjid) {
              final name = masjid.name.toLowerCase();
              final address = (masjid.address ?? '').toLowerCase();
              return name.contains(_searchQuery) ||
                  address.contains(_searchQuery);
            }).toList();
          } else {
            _filteredMasjids = _allMasjids;
          }

          notifyListeners();
          log.d('Masjid data refreshed. Count: ${_allMasjids.length}');
        }
      } catch (e) {
        log.e('Error refreshing masjid data: $e');
      }
    } else {
      log.w('No last location available for refresh');
    }
  }
  void clearSearch() {
    _searchQuery = '';
    _filteredMasjids = _allMasjids;
    searchController.clear();
    notifyListeners();
  }

  Future<void> changeSearchRadius(double newRadiusKm) async {
    if (_lastLat != null && _lastLng != null) {
      await getMasjidLocations(
        latitude: _lastLat!,
        longitude: _lastLng!,
        radiusKm: newRadiusKm,
      );
    }
  }
  void logoutUser() async {
    setState(ViewState.busy);
    await _authService.logout();
    setState(ViewState.idle);
    Get.offAll(AuthScreen());
  }
}
