import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/widgets/search_section.dart';
import '../controller/user_screen_controller.dart';
import '../model/user_screen_model.dart';
import 'filter_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    Color _getStatusColor(dynamic status) {
      if (status == true) return Colors.green;
      return Colors.grey;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Users", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ✅ Search Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchSection(
              onSearchChanged: (query) {
                userController.searchQuery.value = query;
              },
              onFilterPressed: () async {
                final result = await showModalBottomSheet<Map<String, List<String>>>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => FilterScreen(),
                );

                if (result != null) {
                  userController.applyFilters(
                    roles: result["roles"],
                    subjects: result["subjects"],
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          // ✅ User List
          Expanded(
            child: Obx(() {
              if (userController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userController.isError.value) {
                return Center(child: Text("Error: ${userController.errorMessage.value}"));
              }

              final users = userController.filteredUsers;

              if (users.isEmpty) {
                return const Center(child: Text("No users found"));
              }

              // Removed RefreshIndicator here
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            (user.fullName != null && user.fullName!.isNotEmpty)
                                ? user.fullName![0].toUpperCase()
                                : "U",
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: _getStatusColor(user.isOnline),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Text(user.fullName ?? "Unknown"),
                    subtitle: Text(user.role == Role.STUDENT ? "Student" : "Tutor"),
                    trailing: const Icon(Icons.more_vert),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
