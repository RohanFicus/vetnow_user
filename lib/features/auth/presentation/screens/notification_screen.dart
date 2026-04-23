import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // 1. Mock Data for Notifications
  List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "Appointment Confirmed",
      "desc": "Your appointment with Dr. Anjani is confirmed for Dec 15.",
      "time": "2 mins ago",
      "type": "appointment",
      "isRead": false,
    },
    {
      "id": 2,
      "title": "Vaccination Reminder",
      "desc": "Kristal is due for a Rabies booster next week.",
      "time": "1 hour ago",
      "type": "medical",
      "isRead": false,
    },
    {
      "id": 3,
      "title": "New Gallery Memory",
      "desc": "You added a new photo to 'Morning Walk' gallery.",
      "time": "5 hours ago",
      "type": "gallery",
      "isRead": true,
    },
    {
      "id": 4,
      "title": "Profile Updated",
      "desc": "Weight and height details have been saved successfully.",
      "time": "Yesterday",
      "type": "otp",
      "isRead": true,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var n in notifications) {
        n['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text(
              "Mark all read",
              style: TextStyle(color: Color(0xFF0070D2)),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item, index);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item, int index) {
    return Dismissible(
      key: Key(item['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          notifications.removeAt(index);
        });
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon based on notification type
            _buildTypeIcon(item['type']),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontWeight: item['isRead']
                              ? FontWeight.w600
                              : FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (!item['isRead'])
                        const CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFF0070D2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['desc'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['time'],
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'appointment':
        icon = Icons.calendar_today_outlined;
        color = const Color(0xFF0070D2);
        break;
      case 'medical':
        icon = Icons.medical_services_outlined;
        color = Colors.orange;
        break;
      case 'gallery':
        icon = Icons.image_outlined;
        color = Colors.purple;
        break;
      default:
        icon = Icons.notifications_none_outlined;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "No notifications yet",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
