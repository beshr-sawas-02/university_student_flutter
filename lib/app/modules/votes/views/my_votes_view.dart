// lib/app/modules/votes/views/my_votes_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vote_controller.dart';
import '../../../utils/theme.dart';
import 'package:intl/intl.dart';

class MyVotesView extends StatelessWidget {
  final VoteController controller = Get.put(VoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Votes'),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchMyVotes(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.myVotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.how_to_vote_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You haven\'t voted for any courses yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/create-vote'),
                    child: Text('Vote Now'),
                  ),

                  ElevatedButton(
                    onPressed: () =>controller.fetchMyVotes(),
                    child: Text('Vote Now'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.myVotes.length,
            itemBuilder: (context, index) {
              final vote = controller.myVotes[index];
              final formattedDate = vote.createdAt != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(vote.createdAt!)
                  : 'Unknown date';

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
                          Text(
                            'Vote #${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Selected Courses:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      if (vote.courses != null && vote.courses!.isNotEmpty)
                        ...vote.courses!.map((course) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                course.courseCode.substring(0, 1),
                                style: TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              course.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Code: ${course.courseCode}',
                            ),
                          );
                        }).toList()
                      else
                        ...vote.courseIds.map((courseId) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              child: Icon(
                                Icons.book,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                            title: Text(
                              'Course ID: $courseId',
                            ),
                          );
                        }).toList(),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.selectedCourseIds.assignAll(vote.courseIds);
                              controller.currentVote.value = vote;
                              Get.toNamed('/create-vote');
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          TextButton(
                            onPressed: () => _confirmDeleteVote(vote.id!),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/create-vote'),
        backgroundColor: AppTheme.secondaryColor,
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDeleteVote(String id) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Vote'),
        content: Text('Are you sure you want to delete this vote?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Get.back();
              await controller.deleteVote(id);
            },
            child: Text('DELETE'),
          ),
        ],
      ),
    );
  }
}