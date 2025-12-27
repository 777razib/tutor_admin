import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../controller/notification_controller.dart';
import '../model/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    controller.markAllAsRead();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
        title: Text('Notification', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(child: Text("No notifications found"));
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchNotifications();

          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return buildNotificationTile(item, index);
            },
          ),
        );
      }),
    );
  }

  Widget buildNotificationTile(NotificationData item, int index) {
    return GestureDetector(
      onTap: () {
        if (!item.read) {
          controller.markAllAsRead();
        }
        // TODO: Navigate to detail if needed
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading Icon
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.read ? Colors.grey[200] : AppColors.secondColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
          SizedBox(width: 12),
          // Title and message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          item.read ? FontWeight.normal : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!item.read)
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  item.createdAt.toLocal().toString().split(".")[0],
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 6),
                Text(item.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
