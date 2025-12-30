import 'package:admin_tutor_app/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:admin_tutor_app/feature/auth/screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
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
import '../widgets/show_dialog_box_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final TutorRequestController tutorRequestController = Get.put(TutorRequestController());
  final NotificationController notificationsController = Get.put(NotificationController());

  // এই ভ্যারিয়েবল দিয়ে ট্র্যাক করব কোন ট্যাবে ছিলাম আগে
  int _previousIndex = -1;

  @override
  void initState() {
    super.initState();

    // প্রথমবার লোড করার সময় ডেটা ফেচ করি
    homeController.fetchHomeData();
    tutorRequestController.fetchTutorRequests();
  }

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
                    onPressed: () {
                      Get.to(() => NotificationScreen());
                    },
                  ),
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
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          )
        ],
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            homeController.fetchHomeData(),
            tutorRequestController.fetchTutorRequests(),
          ]);
        },
        child: SafeArea(
          child: Obx(() {
            final int currentIndex = homeController.currentIndex.value;

            // মূল ফিক্স: যখন Home ট্যাবে (0) আসি এবং আগে অন্য ট্যাবে ছিলাম
            if (currentIndex == 0 && _previousIndex != 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                print("Home tab visible → Fetching tutor requests...");
                tutorRequestController.fetchTutorRequests();
                homeController.fetchHomeData(); // ঐচ্ছিক: ড্যাশবোর্ড স্ট্যাটস রিফ্রেশ
              });
            }

            // প্রতিবার ইনডেক্স আপডেট করি
            _previousIndex = currentIndex;

            // ট্যাব কন্টেন্ট
            switch (currentIndex) {
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

  // বাকি সব কোড একদম আগের মতোই থাকবে (Drawer, Stats, Request Card ইত্যাদি)
  // শুধু নিচে পেস্ট করো — কোনো পরিবর্তন লাগবে না

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(Get.context!),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    decoration: const BoxDecoration(
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
              Image.asset(IconsPath.logout, height: 24, width: 24, color: Colors.redAccent),
              "Logout",
              null,
              onTap: () async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancel")),
                      TextButton(onPressed: () => Get.back(result: true), child: const Text("Logout")),
                    ],
                  ),
                );
                if (confirm == true) {
                  await SharedPreferencesHelper.clearAccessToken();
                  Get.offAll(() => SignInScreen());
                  Get.snackbar("Logged Out", "You have successfully logged out.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.withOpacity(0.8),
                      colorText: Colors.white);
                }
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("App version 0.2", style: TextStyle(fontSize: 12)),
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
          ? Icon(icon, color: isSelected ? AppColors.secondColor : AppColors.primaryColor)
          : SizedBox(height: 24, width: 24, child: ColorFiltered(colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn), child: icon)),
      title: Text(title, style: TextStyle(color: AppColors.primaryColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryColor),
      selected: isSelected,
      selectedTileColor: AppColors.backgroundColor,
      onTap: () {
        homeController.currentIndex.value = index;
        Navigator.pop(Get.context!);
      },
    );
  }

  Widget _drawerPageItem(Widget icon, String title, Widget? page, {VoidCallback? onTap}) {
    return ListTile(
      leading: SizedBox(height: 24, width: 24, child: icon),
      title: Text(title, style: const TextStyle(color: AppColors.primaryColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryColor),
      onTap: onTap ?? () { Navigator.pop(Get.context!); if (page != null) Get.to(() => page); },
    );
  }

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
          _sectionHeader("New request"),
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
          _buildStatCard(formatNumber(homeController.totalStudents), 'Total Students'),
          _buildStatCard(formatNumber(homeController.totalTutors), 'Total Tutors'),
          _buildStatCard(formatNumber(homeController.newUser7), 'New Users'),
        ],
      );
    });
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 100, height: 90, padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.backgroundColor, borderRadius: BorderRadius.circular(12), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 2, blurRadius: 26, offset: const Offset(0, 8)),
      ]),
      child: Column(children: [
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }

  Widget _sectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Obx(() {
          if (tutorRequestController.isLoading.value) return const Center(child: CircularProgressIndicator());
          if (tutorRequestController.errorMessage.isNotEmpty) return Center(child: Text(tutorRequestController.errorMessage.value));
          if (tutorRequestController.tutorRequests.isEmpty) return const Center(child: Text("No new requests available"));

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tutorRequestController.tutorRequests.length > 2 ? 2 : tutorRequestController.tutorRequests.length,
            itemBuilder: (context, index) => _buildRequestCard(tutorRequestController.tutorRequests[index]),
          );
        }),
      ],
    );
  }

  Widget _buildRequestCard(TutorReqData request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 4)),
      ]),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return ShowProfileDialogWidget(
                  imageUrl: request.profileImage,
                  fullName: request.fullName,
                  email: request.email,
                  phone: request.phoneNumber,
                  gender: request.gender,
                  city: request.city,
                  hourlyRate: request.hourlyRate != null ? '${request.hourlyRate} BDT/hr' : 'N/A',
                  subject: request.subject?.join(', ') ?? "N/A",
                  university: request.education??"N/A",
                  experience: request.experience != null ? '${request.experience} years' : 'N/A',
                  about: request.about,
                );
              },
            );
          },
          child: Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: request.profileImage != null && request.profileImage!.isNotEmpty
                  ? NetworkImage(request.profileImage!) : const AssetImage('assets/images/profile.png') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(request.fullName ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Subject: ${request.subject?.join(", ") ?? "N/A"}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(request.createdAt != null ? "${request.createdAt!.hour}:${request.createdAt!.minute}am" : "-", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(width: 12),
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(request.createdAt != null ? "${request.createdAt!.day}-${request.createdAt!.month}-${request.createdAt!.year}" : "-", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => tutorRequestController.showConfirmDialog(tutorId: request.id ?? '', isAccept: false),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE1F6F4), foregroundColor: const Color(0xFF009D8B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => tutorRequestController.showConfirmDialog(tutorId: request.id ?? '', isAccept: true),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009D8B), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: const Text('Accept'),
            ),
          ),
        ]),
      ]),
    );
  }
}