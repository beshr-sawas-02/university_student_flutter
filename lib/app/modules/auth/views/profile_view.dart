// lib/app/modules/auth/views/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../utils/theme.dart';

class ProfileView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_title'.tr),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: Obx(() {
        final student = controller.currentStudent.value;
        if (student == null) {
          return Center(
            child: Text('profile_not_available'.tr),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(student.name),
              SizedBox(height: 24),
              _buildSectionTitle('profile_section_personal'.tr),
              _buildInfoCard([
                _buildInfoRow('profile_name'.tr, student.name),
                _buildInfoRow('profile_university_id'.tr, student.universityId.toString()),
                _buildInfoRow('profile_major'.tr, student.major),
                _buildInfoRow('profile_year'.tr, _getYearText(student.year)),
              ]),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _confirmLogout(),
                  icon: Icon(Icons.logout),
                  label: Text('profile_logout'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(String name) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'S',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'profile_role_student'.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getYearText(int year) {
    switch (year) {
      case 1:
        return 'year_first'.tr;
      case 2:
        return 'year_second'.tr;
      case 3:
        return 'year_third'.tr;
      case 4:
        return 'year_fourth'.tr;
      case 5:
        return 'year_fifth'.tr;
      default:
        return 'year_unknown'.tr;
    }
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: Text('logout_dialog_title'.tr),
        content: Text('logout_dialog_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('logout_dialog_cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              controller.logout();
            },
            child: Text('logout_dialog_confirm'.tr),
          ),
        ],
      ),
    );
  }
}
