import 'package:admin_tutor_app/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:admin_tutor_app/feature/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_tutor_app/feature/home/screen/handle_disputes_screen.dart';
import 'package:admin_tutor_app/feature/home/screen/notification_screen.dart';
import 'package:admin_tutor_app/feature/payment_screen/views/payment_screen.dart';
import 'package:admin_tutor_app/feature/request_screen/views/request_screen.dart';
import 'package:admin_tutor_app/feature/user_screen/views/user_screen.dart';
import '../../../../core/const/app_colors.dart';
import '../../../core/const/icons_path.dart';
import '../../request_screen/controller/request_screen_controller.dart';
import '../../request_screen/models/request_screen_model.dart';
import '../controller/home_controller.dart';
import '../controller/notification_controller.dart';
import '../widgets/bar_chart.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/number_formatter.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final TutorRequestController requestController = Get.put(TutorRequestController());

  final List<double> weeklyEarnings = [30, 43, 20, 10, 40, 35, 45];
  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  var notificationsController = Get.put(NotificationController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.secondColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: Image.asset(IconsPath.notification),
                    onPressed: () async {
                      await Get.to(() => NotificationScreen());
                    },
                  ),
                  // Red dot indicator
                  Obx(() {
                    bool hasUnread = notificationsController.notifications
                        .any((n) => n.read == false);
                    return hasUnread
                        ? Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            )
          )
        ],
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavBar(),
      body: RefreshIndicator(
        onRefresh: ()async {
          await homeController.fetchHomeData();
          await homeController.fetchTutorRequests();
        },
        child: SafeArea(
          child: Obx(() {
            switch (homeController.currentIndex.value) {
              case 0:
                return _buildDashboardContent();
              case 1:
                return UserScreen();
              case 2:
                return RequestScreen();
              case 3:
                return PaymentScreen();
              default:
                return _buildDashboardContent();
            }
          }),
        ),
      ),
    );
  }

  // ----------------- Drawer -----------------

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(Get.context!),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondColor,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.close,
                        color: AppColors.primaryColor, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _drawerItem(Image.asset(IconsPath.home, scale: 3), "Home", 0),
            _drawerItem(Image.asset(IconsPath.user), "User", 1),
            _drawerItem(Image.asset(IconsPath.license), "Request", 2),
            _drawerItem(Image.asset(IconsPath.credit_card), "Payment", 3),

            _drawerPageItem(
              Image.asset(IconsPath.alert),
              "Handle disputes",
              HandleDisputesScreen(),
            ),

            _drawerPageItem(
              Image.asset(
                IconsPath.logout,
                height: 24,
                width: 24,
                color: Colors.redAccent,
              ),
              "Logout",
              null,
              onTap: () async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await SharedPreferencesHelper.clearAccessToken();
                  Get.offAll(() => SignInScreen());
                  Get.snackbar(
                    "Logged Out",
                    "You have successfully logged out.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                }
              },
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "App version 0.2",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _drawerItem(dynamic icon, String title, int index) {
    final bool isSelected = homeController.currentIndex.value == index;

    return ListTile(
      leading: icon is IconData
          ? Icon(icon,
          color:
          isSelected ? AppColors.secondColor : AppColors.primaryColor)
          : SizedBox(
        height: 24,
        width: 24,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              AppColors.primaryColor, BlendMode.srcIn),
          child: icon,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.primaryColor,
      ),
      selected: isSelected,
      selectedTileColor: AppColors.backgroundColor,
      onTap: () {
        homeController.currentIndex.value = index;
        Navigator.pop(Get.context!);
      },
    );
  }

  Widget _drawerPageItem(
      Widget icon,
      String title,
      Widget? page, {
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: SizedBox(height: 24, width: 24, child: icon),
      title: Text(title, style: const TextStyle(color: AppColors.primaryColor)),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 14, color: AppColors.primaryColor),
      onTap: onTap ??
              () {
            Navigator.pop(Get.context!);
            if (page != null) Get.to(() => page);
          },
    );
  }

  // ----------------- Dashboard -----------------

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 30),
          BarChart(),
          const SizedBox(height: 30),
          _sectionHeader("New request", () {}),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(() {
      if (homeController.isLoading.value && homeController.homeModel.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (homeController.errorMessage.isNotEmpty) {
        return Center(child: Text(homeController.errorMessage.value));
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(
            formatNumber(homeController.totalStudents), // apply formatting
            'Total Students', // fixed typo
          ),
          _buildStatCard(
            formatNumber(homeController.totalTutors),
            'Total Tutors', // fixed typo
          ),
          _buildStatCard(
            formatNumber(homeController.newUser7),
            'New Users',
          ),
        ],
      );

    });
  }


  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 100,
      height: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 26,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onViewAll) {
    return Obx(() {
      // if (homeController.isLoading.value) {
      //   return const Center(child: CircularProgressIndicator());
      // }

      if (homeController.errorMessage.isNotEmpty) {
        return Center(child: Text(homeController.errorMessage.value));
      }

      if (homeController.tutorRequests.isEmpty) {
        return const Center(child: Text("No requests available"));
      }

      return RefreshIndicator(
        onRefresh: () async {
          await homeController.fetchTutorRequests();
        },
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: homeController.tutorRequests.length,
          itemBuilder: (context, index) {
            final req = homeController.tutorRequests[index];
            return _buildRequestCard(req);
          },
        ),
      );
    });
  }


  Widget _buildRevenueReport() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Revenue Report',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Obx(() => DropdownButton<String>(
            dropdownColor: AppColors.backgroundColor,
            value: homeController.selectedReportType.value,
            items: ['Weekly', 'Monthly']
                .map((e) =>
                DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                homeController.selectedReportType.value = value;
              }
            },
          )),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(weeklyEarnings.length, (index) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: weeklyEarnings[index] * 2,
                      width: 38,
                      decoration: BoxDecoration(
                        color: index == 1
                            ? AppColors.secondColor
                            : AppColors.primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(days[index]),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    ]);
  }

  Widget _buildRequestCard(TutorReqData request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: request.profileImage != null &&
                    request.profileImage!.isNotEmpty
                    ? NetworkImage(request.profileImage!)
                    : const AssetImage('assets/images/profile.png')
                as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.fullName != null && request.fullName!.isNotEmpty
                          ? request.fullName!
                          : 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Subject: ${request.subject != null && request.subject!.isNotEmpty ? request.subject!.join(", ") : "N/A"}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          request.createdAt != null
                              ? "${request.createdAt!.hour}:${request.createdAt!.minute}am"
                              : "-",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          request.createdAt != null
                              ? "${request.createdAt!.day}-${request.createdAt!.month}-${request.createdAt!.year}"
                              : "-",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    homeController.denyTutorRequest(request.id ?? "");
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1F6F4),
                    foregroundColor: const Color(0xFF009D8B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    homeController.denyTutorRequest(request.id ?? "");
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009D8B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
