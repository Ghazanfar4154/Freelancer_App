import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/animation.dart';

import 'Notification_Api_Handler.dart';
import 'Notification_Model.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = NotificationApiHandler.fetchNotifications();
  }

  String formatDate(DateTime date) {
    final today = DateTime.now();
    final yesterday = DateTime.now().subtract(Duration(days: 1));

    if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(today)) {
      return 'Today';
    } else if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.teal, // Set AppBar background color to cyan
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications available'));
          } else {
            final notifications = snapshot.data!;
            final groupedNotifications = <String, List<NotificationModel>>{};

            for (var notification in notifications) {
              final formattedDate = formatDate(notification.timestamp);
              if (groupedNotifications.containsKey(formattedDate)) {
                groupedNotifications[formattedDate]!.add(notification);
              } else {
                groupedNotifications[formattedDate] = [notification];
              }
            }

            return ListView.builder(
              itemCount: groupedNotifications.keys.length,
              itemBuilder: (context, index) {
                final date = groupedNotifications.keys.elementAt(index);
                final items = groupedNotifications[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...items.map((notification) => ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(notification.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.description),
                          Text(DateFormat('hh:mm a').format(notification.timestamp), style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    )).toList(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
