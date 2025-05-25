// lib/app/modules/courses/views/my_courses_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/mark.dart' as MarkModel;
import '../../marks/controllers/mark_controller.dart';
import '../../../utils/theme.dart';

class MyCoursesView extends StatelessWidget {
  final MarkController controller = Get.put(MarkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses'),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
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
                    Icons.book_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You are not enrolled in any courses',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => controller.fetchMyMarks(),
                    child: Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          // Group marks by course
          final Map<String, List<MarkModel.Mark>> courseMarks = {};

          for (var mark in controller.myMarks) {
            if (mark.course != null) {
              if (!courseMarks.containsKey(mark.courseId)) {
                courseMarks[mark.courseId] = [];
              }
              courseMarks[mark.courseId]!.add(mark);
            }
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: courseMarks.length,
            itemBuilder: (context, index) {
              final courseId = courseMarks.keys.elementAt(index);
              final marks = courseMarks[courseId]!;
              final course = marks.first.course!;

              // Calculate total mark
              double totalMark = 0;
              for (var mark in marks) {
                totalMark += mark.mark;
              }

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              course.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              course.courseCode,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Marks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      ...marks.map((mark) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mark.type,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${mark.mark.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: controller.getGradeColor(mark.mark),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${totalMark.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: controller.getGradeColor(totalMark),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grade',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            controller.getLetterGrade(totalMark),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: controller.getGradeColor(totalMark),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}