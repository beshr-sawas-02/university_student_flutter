// lib/app/modules/votes/views/create_vote_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vote_controller.dart';
import '../../../utils/theme.dart';

class CreateVoteView extends StatelessWidget {
  final VoteController controller = Get.put(VoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('course_voting'.tr),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Get.toNamed('/my-votes'),
            tooltip: 'voting_history'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.availableCourses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.ballot_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'no_courses_available'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => controller.fetchAvailableCourses(),
                  child: Text('refresh'.tr),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildVotingInfo(),
            Expanded(
              child: _buildCourseList(),
            ),
            _buildSubmitButton(),
          ],
        );
      }),
    );
  }

  Widget _buildVotingInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      color: AppTheme.primaryColor.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'course_selection'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'select_4_6_courses'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Obx(() => Text(
            'selected_count'.trArgs([
              controller.selectedCourseIds.length.toString(),
              '6',
            ]),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: controller.selectedCourseIds.length < 4
                  ? Colors.red
                  : AppTheme.secondaryColor,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.availableCourses.length,
      itemBuilder: (context, index) {
        final course = controller.availableCourses[index];
        return Obx(() {
          final isSelected = controller.selectedCourseIds.contains(course.id);

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: isSelected ? 4 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color:
                isSelected ? AppTheme.secondaryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () => controller.toggleCourseSelection(course.id!),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) =>
                          controller.toggleCourseSelection(course.id!),
                      activeColor: AppTheme.secondaryColor,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'course_code'.trArgs([course.courseCode ?? '']),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'instructor:'.trArgs([course.teacher ?? '']),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => ElevatedButton(
        onPressed: controller.selectedCourseIds.length < 4 ||
            controller.isLoading.value
            ? null
            : () => _submitVote(),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
        child: controller.isLoading.value
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          'submit_vote'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
    );
  }

  void _submitVote() {
    Get.dialog(
      AlertDialog(
        title: Text('confirm_vote'.tr),
        content: Text('confirm_vote_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await controller.submitVote();
              if (success) {
                Get.toNamed('/my-votes');
              }
            },
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );
  }
}
