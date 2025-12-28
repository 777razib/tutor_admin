import 'package:admin_tutor_app/feature/request_screen/controller/request_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/request_screen_model.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final controller = Get.put(TutorRequestController());


  @override
  void initState() {
    controller.fetchTutorRequests();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Request'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return Center(child: CircularProgressIndicator());
        // }

        if (controller.tutorRequests.isEmpty) {
          return Center(child: Text("No requests available"));
        }

        return Obx((){
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchTutorRequests();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.tutorRequests.length,
              itemBuilder: (context, index) {
                final req = controller.tutorRequests[index];
                return _buildRequestCard(req);
              },
            ),
          );
        });
      }),
    );
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
                backgroundImage: request.profileImage != null && request.profileImage!.isNotEmpty
                    ? NetworkImage(request.profileImage!)
                    : const AssetImage('assets/images/profile.png') as ImageProvider,
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
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          request.createdAt != null
                              ? "${request.createdAt!.day}-${request.createdAt!.month}-${request.createdAt!.year}"
                              : "-",
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 12),
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
                    // Decline button
                    controller.denyTutorRequest(tutorId: request.id);
                    // অথবা আরও ভালো: confirmation dialog দেখাতে
                    // controller.showConfirmDialog(tutorId: request.id, isAccept: false);
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
                    // Accept button - এখানে অবশ্যই acceptTutorRequest হবে
                    controller.acceptTutorRequest(tutorId: request.id);
                    // অথবা: controller.showConfirmDialog(tutorId: request.id, isAccept: true);
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
        /*  Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.denyTutorRequest(tutorId: request.id);
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
                    controller.acceptTutorRequest(tutorId: request.id);
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
          ),*/
        ],
      ),
    );
  }
}

