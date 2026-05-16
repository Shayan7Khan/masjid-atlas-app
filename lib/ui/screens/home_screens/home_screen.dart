import 'package:flutter/material.dart';
import 'package:flutter_antonx_boilerplate/core/constants/styles.dart';
import 'package:flutter_antonx_boilerplate/core/enums/view_state.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/details_screen/detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_antonx_boilerplate/core/services/location_service.dart';
import 'package:flutter_antonx_boilerplate/locator.dart';
import 'home_screen_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationService = locator<LocationService>();
    final log = CustomLogger(className: 'HomeScreen');

    return ChangeNotifierProvider(
      create: (_) => HomeScreenViewModel(),
      child: Consumer<HomeScreenViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            drawer: _buildDrawer(context, model),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/home_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: model.state == ViewState.busy
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE2BE7F),
                          ),
                        )
                      : model.masjid.isEmpty &&
                            model.searchController.text.isEmpty
                      ? _buildEmptyState(model, locationService, context, log)
                      : _buildMasjidList(model, context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, left: 8.w),
      child: Builder(
        builder: (context) => Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFE2BE7F).withValues(alpha: 0.3),
              width: 1.w,
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.menu_outlined,
              color: Color(0xFFE2BE7F),
              size: 28,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    HomeScreenViewModel model,
    LocationService locationService,
    BuildContext context,
    CustomLogger log,
  ) {
    return Stack(
      children: [
        Positioned(
          top: 10.h,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 200.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/background_image_2.png',
                  height: 180.h,
                  width: 291.w,
                ),
                Positioned(
                  bottom: 30.h,
                  child: Text('Masjid Atlas', style: titleStyle),
                ),
              ],
            ),
          ),
        ),
        Positioned(top: 0, left: 0, child: _buildMenuButton(context)),
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFE2BE7F).withValues(alpha: 0.3),
                        const Color(0xFFE2BE7F).withValues(alpha: 0.1),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.mosque_rounded,
                      size: 70.sp,
                      color: const Color(0xFFE2BE7F),
                    ),
                  ),
                ),
                32.verticalSpace,
                Text(
                  'Discover Masjids\nNear You',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: 0.5,
                  ),
                ),
                16.verticalSpace,
                Text(
                  'Find prayer times and directions to\nmasjids in your area',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                48.verticalSpace,
                ElevatedButton(
                  onPressed: () async {
                    try {
                      model.setState(ViewState.busy);
                      final position = await locationService
                          .getCurrentLocation();
                      if (position != null) {
                        await model.getMasjidLocations(
                          latitude: position.latitude,
                          longitude: position.longitude,
                        );
                      }
                    } catch (e) {
                      log.e('Error: $e');
                    } finally {
                      model.setState(ViewState.idle);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2BE7F),
                    foregroundColor: const Color(0xFF1a1a2e),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 18.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        color: Color(0xFF1a1a2e),
                        size: 24,
                      ),
                      12.horizontalSpace,
                      Text(
                        'Find Nearby Masjids',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
Widget _buildMasjidList(HomeScreenViewModel model, BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 210.h,
          floating: false,
          pinned: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 120.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/background_image_2.png',
                              height: 120.h,
                              width: 250.w,
                            ),
                            Positioned(
                              bottom: 5.h,
                              child: Text('Masjid Atlas', style: titleStyle),
                            ),
                          ],
                        ),
                      ),
                      8.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _buildSearchBar(model, context),
                      ),
                    ],
                  ),
                  Positioned(top: 0, left: 0, child: _buildMenuButton(context)),
                ],
              ),
            ),
          ),
        ),
        // if (model.searchController.text.isEmpty)
        //   SliverToBoxAdapter(
        //     child: Padding(
        //       padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
        //       child: _buildHadithCard(model.randomHadith),
        //     ),
        //   ),
        if (model.searchController.text.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Masjids',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      // color: Color(0xFFE2BE7F),
                      letterSpacing: 0.3,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${model.masjid.length} Found',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE2BE7F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        model.masjid.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 80.sp,
                          color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                        ),
                        24.verticalSpace,
                        Text(
                          'No Masjids Found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          model.searchController.text.isNotEmpty
                              ? 'No results for "${model.searchController.text}"\nTry different search terms'
                              : 'No masjids found in your area',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14.sp,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildMasjidCard(model, index);
                  }, childCount: model.masjid.length),
                ),
              ),
      ],
    );
  }

  // Widget _buildHadithCard(hadith) {
  //   return Container(
  //     padding: EdgeInsets.all(20.w),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           const Color(0xFFE2BE7F).withValues(alpha: 0.15),
  //           const Color(0xFFE2BE7F).withValues(alpha: 0.05),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: const Color(0xFFE2BE7F).withValues(alpha: 0.3),
  //         width: 1.5,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.2),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: EdgeInsets.all(10.w),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Icon(
  //                 Icons.auto_stories_rounded,
  //                 color: const Color(0xFFE2BE7F),
  //                 size: 24.sp,
  //               ),
  //             ),
  //             12.horizontalSpace,
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Hadith of the Day',
  //                     style: TextStyle(
  //                       fontSize: 14.sp,
  //                       fontWeight: FontWeight.w600,
  //                       color: const Color(0xFFE2BE7F),
  //                       letterSpacing: 0.5,
  //                     ),
  //                   ),
  //                   4.verticalSpace,
  //                   Text(
  //                     hadith.narrator,
  //                     style: TextStyle(
  //                       fontSize: 12.sp,
  //                       color: Colors.white.withValues(alpha: 0.6),
  //                       fontStyle: FontStyle.italic,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         16.verticalSpace,
  //         Container(
  //           width: 40.w,
  //           height: 3.h,
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [
  //                 const Color(0xFFE2BE7F),
  //                 const Color(0xFFE2BE7F).withValues(alpha: 0.2),
  //               ],
  //             ),
  //             borderRadius: BorderRadius.circular(2),
  //           ),
  //         ),
  //         16.verticalSpace,
  //         Text(
  //           hadith.text,
  //           style: TextStyle(
  //             fontSize: 15.sp,
  //             color: Colors.white.withValues(alpha: 0.95),
  //             height: 1.6,
  //             letterSpacing: 0.2,
  //           ),
  //         ),
  //         12.verticalSpace,
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
  //             decoration: BoxDecoration(
  //               color: Colors.black.withValues(alpha: 0.2),
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(
  //                 color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
  //                 width: 1,
  //               ),
  //             ),
  //             child: Text(
  //               hadith.reference,
  //               style: TextStyle(
  //                 fontSize: 11.sp,
  //                 color: const Color(0xFFE2BE7F).withValues(alpha: 0.8),
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSearchBar(HomeScreenViewModel model, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2BE7F).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: model.searchController,
        focusNode: model.searchFocusNode,
        enableInteractiveSelection: true,
        autofocus: false,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search masjid...',
          hintStyle: TextStyle(
            color: const Color(0xFFE2BE7F).withValues(alpha: 0.5),
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFE2BE7F)),
          suffixIcon: model.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFFE2BE7F)),
                  onPressed: () {
                    model.searchController.clear();
                    model.clearSearch();
                    model.searchFocusNode.unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        onChanged: (query) {
          model.searchMasjids(query);
        },
      ),
    );
  }

  Widget _buildMasjidCard(HomeScreenViewModel model, int index) {
    final masjid = model.masjid[index];
    return Hero(
      tag: 'masjid_${masjid.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            model.searchFocusNode.unfocus();
            await Get.to(
              () => DetailScreen(masjid: masjid),
              transition: Transition.leftToRightWithFade,
              duration: const Duration(milliseconds: 400),
            );
            await model.refreshMasjidData();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE2BE7F).withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 62.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE2BE7F), Color(0xFFD4A574)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF1a1a2e),
                      size: 30,
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          masjid.name,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        6.verticalSpace,
                        Text(
                          masjid.address ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(
                              0xFFE2BE7F,
                            ).withValues(alpha: 0.9),
                            height: 1.4,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  12.horizontalSpace,
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2BE7F).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE2BE7F).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFE2BE7F),
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, HomeScreenViewModel model) {
    return Drawer(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _drawerItem(icon: Icons.person, text: "Profile", onTap: () {}),
              _drawerItem(
                icon: Icons.info_outline,
                text: "About",
                onTap: () {},
              ),
              _drawerItem(
                icon: Icons.settings_outlined,
                text: "Settings",
                onTap: () {},
              ),
              const Spacer(),
              _drawerItem(
                icon: Icons.logout,
                text: "Logout",
                isLogout: true,
                onTap: () async {
                  model.logoutUser();
                  Navigator.pop(context);
                },
              ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isLogout
                ? Colors.red.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isLogout
                  ? Colors.redAccent.withValues(alpha: 0.4)
                  : const Color(0xFFE2BE7F).withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.redAccent : const Color(0xFFE2BE7F),
                size: 22,
              ),
              16.horizontalSpace,
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isLogout ? Colors.redAccent : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
