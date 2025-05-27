// lib/app/modules/dashboard/widgets/profile_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university_student_application/app/modules/auth/views/profile_view.dart';
import '../controllers/dashboard_controller.dart';
import '../../../utils/theme.dart';

class ProfileCard extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryColor,
              child: Obx(() => Text(
                controller.student.value?.name.isNotEmpty ?? false
                    ? controller.student.value!.name[0].toUpperCase()
                    : 'S',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              )),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    controller.student.value?.name ?? 'Student',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  )),
                  SizedBox(height: 4),
                  Obx(() => Text(
                    'ID: ${controller.student.value?.universityId ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )),
                  SizedBox(height: 4),
                  Obx(() => Text(
                    '${controller.student.value?.major ?? ''} - ${controller.getYearText(controller.student.value?.year ?? 1)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: AppTheme.secondaryColor,
              ),
              onPressed: () {
                Get.to(() => ProfileView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
