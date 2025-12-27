import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotificationEmptyScreen extends StatelessWidget {
  // Simulate empty list for now
  final List<NotificationItem> notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios)),
        title: Text('Notification', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: notifications.isEmpty
          ? buildEmptyState(context)
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return buildNotificationTile(item);
        },
      ),
    );
  }

  Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Replace with your asset
          Image.asset(
            'assets/images/empty_notifications.png',
            height: 280,
          ),
          SizedBox(height: 24),
          Text(
            'Empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You don't have any notifications at this time",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildNotificationTile(NotificationItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: item.iconColor ?? Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: Colors.black, size: 20),
        ),
        SizedBox(width: 12),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (item.isNew)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                item.dateTime,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 6),
              Text(
                item.message,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NotificationItem {
  final IconData icon;
  final String title;
  final String dateTime;
  final String message;
  final bool isNew;
  final Color? iconColor;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.dateTime,
    required this.message,
    this.isNew = false,
    this.iconColor,
  });
}
