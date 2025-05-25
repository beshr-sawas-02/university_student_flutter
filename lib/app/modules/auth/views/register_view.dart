import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university_student_application/app/modules/auth/controllers/auth_controller.dart';
import 'package:university_student_application/app/utils/theme.dart';

class RegisterView extends GetView<AuthController> {

  List<String> yearsLables=['First', 'Second', 'Third', 'Fourth','Fifth'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Register as Student',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(20),
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
                    children: [
                      Text(
                        'Student Registration',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: controller.nameController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: controller.majorController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Major',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: controller.selectedYear.value,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        items: yearsLables
                            .map((year) => DropdownMenuItem(
                          value: yearsLables.indexOf(year)+1,
                          child: Text(year),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) controller.selectedYear.value = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: controller.universityIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'University ID',
                          prefixIcon: Icon(Icons.badge),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      SizedBox(height: 30),
                      Obx(()=>ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.register(),
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 16),
                          )),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
