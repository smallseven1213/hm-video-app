import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/event_controller.dart';

class SystemScreen extends StatelessWidget {
  SystemScreen({Key? key}) : super(key: key);

  final eventsController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          children: [
            ...eventsController.data.map((e) => EventCard(
                  title: e.title,
                  content: e.content,
                  time: "2021-08-08",
                  isSelected: false,
                  id: e.id,
                )),
          ],
        ));
  }
}

class EventCard extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String time;
  final bool isSelected;

  EventCard({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
        gradient: LinearGradient(
          colors: [
            Color(0xFF4277DC),
            Color(0xFF4378DC),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ],
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
