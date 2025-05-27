// lib/app/modules/marks/views/marks_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mark_controller.dart';
import '../../../utils/theme.dart';

class MarksView extends StatelessWidget {
  final MarkController controller = Get.put(MarkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_marks'.tr),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.assessment),
            onPressed: () => Get.toNamed('/gpa'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchMyMarks(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.myMarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.grade_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'no_marks_available'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => controller.fetchMyMarks(),
                    child: Text('refresh'.tr),
                  ),
                ],
              ),
            );
          }

          final Map<String, List<dynamic>> courseMarks = {};
          for (var mark in controller.myMarks) {
            if (mark.course != null) {
              if (!courseMarks.containsKey(mark.courseId)) {
                courseMarks[mark.courseId] = [
                  mark.course,
                  [],
                ];
              }
              courseMarks[mark.courseId]![1].add(mark);
            }
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: courseMarks.length,
            itemBuilder: (context, index) {
              final courseId = courseMarks.keys.elementAt(index);
              final course = courseMarks[courseId]![0];
              final marks = courseMarks[courseId]![1];

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    course.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  subtitle: Text(
                    '${'code'.tr}: ${course.courseCode}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'type'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'mark'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'grade'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          ...marks.map((mark) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(mark.type),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${mark.mark.toStringAsFixed(1)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: controller.getGradeColor(mark.mark),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      controller.getLetterGrade(mark.mark),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: controller.getGradeColor(mark.mark),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
