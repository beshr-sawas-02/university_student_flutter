// lib/app/modules/dashboard/views/dashboard_view.dart (updated)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../courses/views/available_courses_view.dart';
import '../../marks/views/marks_view.dart';
import '../../votes/views/create_vote_view.dart';
import '../../../utils/theme.dart';
import '../widgets/profile_card.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    // Don't put controller here, use the binding instead
    // This was causing the issue

    final List<Widget> _pages = [
      _buildHomeTab(),
      AvailableCoursesView(),
      MarksView(),
      CreateVoteView(),
    ];

    return Scaffold(
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.secondaryColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Marks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Voting',
          ),
        ],
      )),
    );
  }

  // Rest of the code remains the same...

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            ProfileCard(),
            SizedBox(height: 20),
            _buildDashboardCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                'Hello, ${controller.student.value?.name ?? "Student"}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  Get.find<AuthController>().logout();
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Obx(() => Text(
            '${controller.student.value?.major ?? ""} - ${controller.getYearText(controller.student.value?.year ?? 1)}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDashboardCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDashboardCard(
                title: 'Courses',
                subtitle: 'View your courses',
                icon: Icons.book,
                color: Colors.blue,
                onTap: () => controller.changeTab(1),
              ),
              _buildDashboardCard(
                title: 'Marks',
                subtitle: 'Check your grades',
                icon: Icons.grade,
                color: Colors.orange,
                onTap: () => controller.changeTab(2),
              ),
              _buildDashboardCard(
                title: 'Vote',
                subtitle: 'Choose your courses',
                icon: Icons.how_to_vote,
                color: Colors.green,
                onTap: () => controller.changeTab(3),
              ),
              _buildDashboardCard(
                title: 'GPA',
                subtitle: 'View your GPA',
                icon: Icons.assessment,
                color: Colors.purple,
                onTap: () => Get.toNamed('/gpa'),
              ),
            ],
          ),
          SizedBox(height: 30),
          _buildGpaSection(),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGpaSection() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your GPA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            final gpa = controller.cumulativeGPA['gpa'] ?? 0.0;
            final credits = controller.cumulativeGPA['credits'] ?? 0;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGpaIndicator(
                  value: gpa.toDouble(),
                  title: 'GPA',
                  max: 4.0,
                ),
                _buildCreditIndicator(
                  value: credits,
                  title: 'Credits',
                ),
              ],
            );
          }),
          SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Get.toNamed('/gpa'),
              child: Text(
                'View Detailed GPA',
                style: TextStyle(color: AppTheme.secondaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGpaIndicator({
    required double value,
    required String title,
    required double max,
  }) {
    final percentage = (value / max * 100).clamp(0, 100);

    Color indicatorColor;
    if (value >= 3.0) {
      indicatorColor = Colors.green;
    } else if (value >= 2.0) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.red;
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
            ),
            Column(
              children: [
                Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                Text(
                  'out of $max',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCreditIndicator({
    required int value,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.secondaryColor,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }
}
