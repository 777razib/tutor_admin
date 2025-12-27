import 'package:admin_tutor_app/feature/home/controller/warming_tutor_controller.dart';
import 'package:admin_tutor_app/feature/home/screen/write_warning_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/const/app_colors.dart';

class HandleDisputesScreen extends StatefulWidget{
  HandleDisputesScreen({super.key});

  @override
  State<HandleDisputesScreen> createState() => _HandleDisputesScreenState();
}

class _HandleDisputesScreenState extends State<HandleDisputesScreen> {
  var controller = Get.put(WarmingController());

  void initState(){
    super.initState();
    controller.fetchWarmingTutors();
  }

  Widget build(BuildContext context){
    controller.fetchWarmingTutors();

    return MaterialApp(
      home: WarningScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WarningScreen  extends StatefulWidget {
  WarningScreen ({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<WarmingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warning'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading:IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: Colors.white,
      body: Obx((){
        if(controller.isLoading.value){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(controller.errorMessage.isNotEmpty){
          return Center(child: Text(controller.errorMessage.value),);
        }
        if(controller.tutors.isEmpty){
          return const Center(child: Text("Not tutors found"),);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tutors.length,
          itemBuilder: (context, index) {
            final tutor = controller.tutors[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  tutor.profileImage ??
                      "https://ui-avatars.com/api/?name=${tutor.fullName ?? 'U'}",
                ),
              ),
              title: Text(tutor.fullName ?? ""),
              subtitle: Text(tutor.createdAt != null ? "${tutor.createdAt}" : "No date"),
              trailing: WarningBadge(current: tutor.rating ?? 0, max: 5),
              onTap: () {
                showBottomDialog(
                  context,
                  userName: tutor.fullName ?? "",
                  userEmail: tutor.email ?? "",
                  warningLevel: tutor.rating ?? 0,
                  warningMax: 5,
                  dateTime: tutor.createdAt?.toString() ?? "-",
                  tutorId: tutor.id ?? "",
                );
              },
            );
          },
        );
      }),
    );
  }
}

void showBottomDialog(
    BuildContext context, {
      required String userName,
      required String userEmail,
      required int warningLevel,
      required int warningMax,
      required String dateTime,
      required String tutorId,
    }) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink(); // handled in transitionBuilder
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedValue = Curves.easeOut.transform(animation.value);
      return Align(
        alignment: Alignment.bottomCenter,
        child: FractionalTranslation(
          translation: Offset(0, 1 - curvedValue),
          child: UserWarningDialog(
            userName: userName,
            userEmail: userEmail,
            warningLevel: warningLevel,
            warningMax: warningMax,
            dateTime: dateTime,
            tutorId: tutorId,
          ),
        ),
      );
    },
  );
}

class UserWarningDialog extends StatefulWidget {
  final String userName;
  final String userEmail;
  final int warningLevel;
  final int warningMax;
  final String dateTime;
  final String tutorId;

  const UserWarningDialog({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.warningLevel,
    required this.warningMax,
    required this.dateTime,
    required this.tutorId,
  });

  @override
  State<UserWarningDialog> createState() => _UserWarningDialogState();
}

class _UserWarningDialogState extends State<UserWarningDialog> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<WarmingController>();

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Center(
                child: Text(
                  'What the user say',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 15),

              // First row: avatar + name + email + date + warning badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/32.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.userEmail,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.dateTime,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  WarningBadge(current: widget.warningLevel, max: widget.warningMax),
                ],
              ),

              const SizedBox(height: 20),

              // Second row: smaller avatar + bold username + stars
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/45.jpg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // 5 stars
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  5,
                      (index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Red info box with border
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Your account creation is successful. You can now experience a good learning platform.',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

              const SizedBox(height: 25),

              // Bottom buttons row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.suspendTutors(widget.tutorId);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        backgroundColor: AppColors.secondColor,
                        side: BorderSide(color: AppColors.secondColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Suspend'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(WriteWarningScreen(
                          tutorId: widget.tutorId,
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                          dateTime: widget.dateTime,
                          warningLevel: widget.warningLevel,
                        ));

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Warning', style: TextStyle(color: AppColors.backgroundColor),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarningBadge extends StatefulWidget {
  final int current;
  final int max;

  const WarningBadge({
    super.key,
    required this.current,
    required this.max,
  });

  @override
  State<WarningBadge> createState() => _WarningBadgeState();
}

class _WarningBadgeState extends State<WarningBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.orange.shade700,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.current}/${widget.max}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.warning_amber_rounded,
              color: Colors.white, size: 18),
        ],
      ),
    );
  }
}
