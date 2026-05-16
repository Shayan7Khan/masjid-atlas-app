import 'package:flutter/material.dart';
import 'package:flutter_antonx_boilerplate/core/models/masjid_model.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/details_screen/detail_screen_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final Masjid masjid;

  const DetailScreen({super.key, required this.masjid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailScreenViewModel()..masjid = masjid,
      child: Consumer<DetailScreenViewModel>(
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(context),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/home_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Hero(
                    tag: 'masjid_${masjid.id ?? masjid.name}',
                    child: Material(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            30.verticalSpace,
                            _buildTitleAddressSection(),
                            24.verticalSpace,
                            _buildAvailabilityRow(context, model),
                            24.verticalSpace,
                            _buildPrayerTimesSection(context, model),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildTitleAddressSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.4),
            Colors.black.withValues(alpha: 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2BE7F).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            masjid.name,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: const Color(0xFFE2BE7F),
                size: 18.sp,
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  masjid.address ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityRow(
    BuildContext context,
    DetailScreenViewModel model,
  ) {
    final facilities = [
      (
        label: 'Wudu',
        key: 'has_wudu',
        available: model.isWudu,
        image: 'assets/images/ablution.png',
      ),
      (
        label: 'Ladies Prayer',
        key: 'has_women_prayer',
        available: model.isFemale,
        image: 'assets/images/female.png',
      ),
      (
        label: 'Elderly Seating',
        key: 'has_elderly_seating',
        available: model.isSeating,
        image: 'assets/images/chair.png',
      ),
      (
        label: 'Parking',
        key: 'has_parking',
        available: model.isParking,
        image: 'assets/images/parked-car.png',
      ),
      (
        label: 'Washroom',
        key: 'has_washroom',
        available: model.isWashroom,
        image: 'assets/images/toilet.png',
      ),
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2BE7F).withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE2BE7F), Color(0xFFD4A574)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Facilities',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Color(0xFFE2BE7F),
                  ),
                  onPressed: () => _showFacilitySelectionDialog(context, model),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: facilities
                .map(
                  (facility) => _buildAvailabilityIcon(
                    facility.image,
                    facility.available,
                    facility.label,
                    onTap: null,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesSection(
    BuildContext context,
    DetailScreenViewModel model,
  ) {
    final hasAnyPrayerTimes = model.prayerTimes.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE2BE7F), Color(0xFFD4A574)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Prayer Times',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (hasAnyPrayerTimes)
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Color(0xFFE2BE7F),
                    ),
                    onPressed: () => _showPrayerSelectionDialog(context, model),
                  ),
                ),
            ],
          ),
          20.verticalSpace,
          ..._buildPrayerTimesList(context, model),
        ],
      ),
    );
  }

  List<Widget> _buildPrayerTimesList(
    BuildContext context,
    DetailScreenViewModel model,
  ) {
    final standardPrayers = [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
      'Jumma',
    ];

    return standardPrayers.map((prayerName) {
      final time = model.prayerTimes[prayerName];
      final isAvailable = time != null && time.isNotEmpty;

      if (isAvailable) {
        return _buildPrayerRow(context, model, prayerName, time);
      } else {
        return _buildMissingPrayerRow(context, model, prayerName);
      }
    }).toList();
  }

  Widget _buildMissingPrayerRow(
    BuildContext context,
    DetailScreenViewModel model,
    String prayerName,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2BE7F).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayerName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'Not added yet',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.3),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showMaterialTimePicker(
              context,
              model,
              prayerName,
              '12:00 PM',
              requireConfirmation: false,
            ),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFE2BE7F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(
    BuildContext context,
    DetailScreenViewModel model,
    String name,
    String time,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE2BE7F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityIcon(
    String image,
    bool isAvailable,
    String label, {
    VoidCallback? onTap,
  }) {
    const double iconSize = 55;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: iconSize.w,
              height: iconSize.h,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    image,
                    height: iconSize.h,
                    width: iconSize.w,
                    fit: BoxFit.contain,
                    color: isAvailable
                        ? const Color(0xFFE2BE7F)
                        : const Color(0xFFBDBDBD),
                  ),
                  if (!isAvailable)
                    Icon(
                      Icons.block,
                      color: Colors.red.withValues(alpha: 0.7),
                      size: iconSize,
                    ),
                ],
              ),
            ),
            10.verticalSpace,
            SizedBox(
              width: iconSize.w,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isAvailable
                      ? const Color(0xFFE2BE7F)
                      : const Color(0xFFBDBDBD),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFacilitySelectionDialog(
    BuildContext context,
    DetailScreenViewModel model,
  ) {
    final facilities = [
      (label: 'Wudu', key: 'has_wudu', available: model.isWudu),
      (
        label: 'Ladies Prayer',
        key: 'has_women_prayer',
        available: model.isFemale,
      ),
      (
        label: 'Elderly Seating',
        key: 'has_elderly_seating',
        available: model.isSeating,
      ),
      (label: 'Parking', key: 'has_parking', available: model.isParking),
      (label: 'Washroom', key: 'has_washroom', available: model.isWashroom),
    ];
    final tempFacilities = facilities.toList();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final hasChanges = tempFacilities.any((facility) {
              switch (facility.key) {
                case 'has_wudu':
                  return facility.available != model.isWudu;
                case 'has_women_prayer':
                  return facility.available != model.isFemale;
                case 'has_elderly_seating':
                  return facility.available != model.isSeating;
                case 'has_parking':
                  return facility.available != model.isParking;
                case 'has_washroom':
                  return facility.available != model.isWashroom;
                default:
                  return false;
              }
            });

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2BE7F).withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit Facilities',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE2BE7F),
                      ),
                    ),
                    16.verticalSpace,
                    ...tempFacilities.map((facility) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 6.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFE2BE7F,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              facility.label,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                            Switch(
                              value: facility.available,
                              activeThumbColor: const Color(0xFFE2BE7F),
                              activeTrackColor: const Color(
                                0xFFE2BE7F,
                              ).withValues(alpha: 0.5),
                              inactiveThumbColor: Colors.white.withValues(
                                alpha: 0.5,
                              ),
                              inactiveTrackColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              onChanged: (bool value) {
                                setState(() {
                                  final idx = tempFacilities.indexOf(facility);
                                  tempFacilities[idx] = (
                                    label: facility.label,
                                    key: facility.key,
                                    available: value,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        TextButton(
                          onPressed: hasChanges
                              ? () {
                                  for (final facility in tempFacilities) {
                                    bool currentValue;
                                    switch (facility.key) {
                                      case 'has_wudu':
                                        currentValue = model.isWudu;
                                        break;
                                      case 'has_women_prayer':
                                        currentValue = model.isFemale;
                                        break;
                                      case 'has_elderly_seating':
                                        currentValue = model.isSeating;
                                        break;
                                      case 'has_parking':
                                        currentValue = model.isParking;
                                        break;
                                      case 'has_washroom':
                                        currentValue = model.isWashroom;
                                        break;
                                      default:
                                        continue;
                                    }
                                    if (facility.available != currentValue) {
                                      model.toggleFacility(facility.key);
                                    }
                                  }
                                  Navigator.pop(dialogContext);
                                }
                              : null,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: hasChanges
                                ? const Color(0xFFE2BE7F)
                                : const Color(
                                    0xFFE2BE7F,
                                  ).withValues(alpha: 0.3),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _pickPrayerTime(
    BuildContext context,
    DetailScreenViewModel model,
    String currentTime,
  ) async {
    final initialTime = model.parseTime(currentTime);
    final timeOfDay = TimeOfDay.fromDateTime(initialTime);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE2BE7F),
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
              secondary: Color(0xFFE2BE7F),
              onSecondary: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE2BE7F),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFF1E1E1E),
              hourMinuteTextColor: const Color(0xFFE2BE7F),
              hourMinuteColor: const Color(0xFF2A2A2A),
              dayPeriodTextColor: const Color(0xFFE2BE7F),
              dayPeriodColor: const Color(0x33E2BE7F),
              dialHandColor: const Color(0xFFE2BE7F),
              dialBackgroundColor: const Color(0xFF2A2A2A),
              dialTextColor: const Color(0xFFE2BE7F),
              entryModeIconColor: const Color(0xFFE2BE7F),
              helpTextStyle: TextStyle(
                color: const Color(0xFFE2BE7F),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return null;
    final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
    final minute = picked.minute.toString().padLeft(2, '0');
    final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  void _showPrayerSelectionDialog(
    BuildContext context,
    DetailScreenViewModel model,
  ) {
    final rootContext = context;
    final standardPrayers = [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
      'Jumma',
    ];
    final Map<String, String> tempTimes = Map<String, String>.from(
      model.prayerTimes,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final hasChanges = standardPrayers.any(
              (prayer) =>
                  (tempTimes[prayer] ?? '') !=
                  (model.prayerTimes[prayer] ?? ''),
            );

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2BE7F).withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit Prayer Times',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE2BE7F),
                      ),
                    ),
                    16.verticalSpace,
                    ...standardPrayers.map((prayerName) {
                      final time = tempTimes[prayerName];
                      final isAvailable = time != null && time.isNotEmpty;

                      return GestureDetector(
                        onTap: () async {
                          final picked = await _pickPrayerTime(
                            rootContext,
                            model,
                            time ?? model.prayerTimes[prayerName] ?? '05:00 AM',
                          );
                          if (picked != null) {
                            setState(() => tempTimes[prayerName] = picked);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFFE2BE7F,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prayerName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                              if (isAvailable)
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFE2BE7F),
                                  ),
                                )
                              else
                                Text(
                                  'Not added yet',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white.withValues(alpha: 0.3),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        TextButton(
                          onPressed: hasChanges
                              ? () {
                                  for (final entry in standardPrayers) {
                                    final newVal = tempTimes[entry] ?? '';
                                    final oldVal =
                                        model.prayerTimes[entry] ?? '';
                                    if (newVal != oldVal && newVal.isNotEmpty) {
                                      model.updatePrayerTime(entry, newVal);
                                    }
                                  }
                                  Navigator.pop(dialogContext);
                                }
                              : null,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: hasChanges
                                ? const Color(0xFFE2BE7F)
                                : const Color(
                                    0xFFE2BE7F,
                                  ).withValues(alpha: 0.3),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showMaterialTimePicker(
    BuildContext context,
    DetailScreenViewModel model,
    String prayerName,
    String currentTime, {
    bool requireConfirmation = true,
  }) async {
    final initialTime = model.parseTime(currentTime);
    final timeOfDay = TimeOfDay.fromDateTime(initialTime);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE2BE7F),
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
              secondary: Color(0xFFE2BE7F),
              onSecondary: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE2BE7F),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFF1E1E1E),
              hourMinuteTextColor: const Color(0xFFE2BE7F),
              hourMinuteColor: const Color(0xFF2A2A2A),
              dayPeriodTextColor: const Color(0xFFE2BE7F),
              dayPeriodColor: const Color(0x33E2BE7F),
              dialHandColor: const Color(0xFFE2BE7F),
              dialBackgroundColor: const Color(0xFF2A2A2A),
              dialTextColor: const Color(0xFFE2BE7F),
              entryModeIconColor: const Color(0xFFE2BE7F),
              helpTextStyle: TextStyle(
                color: const Color(0xFFE2BE7F),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final formatted = '${hour.toString().padLeft(2, '0')}:$minute $period';

      model.updatePrayerTime(prayerName, formatted);
    }
  }
}
