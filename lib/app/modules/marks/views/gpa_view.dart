import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mark_controller.dart';
import '../../../utils/theme.dart';

class GpaView extends StatelessWidget {
  final MarkController controller = Get.put(MarkController());

  @override
  Widget build(BuildContext context) {
    controller.fetchCumulativeGPA();

    return Scaffold(
      appBar: AppBar(
        title: Text('my_gpa'.tr),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCumulativeGPACard(),
            SizedBox(height: 24),
            _buildSemesterGPASection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCumulativeGPACard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'cumulative_gpa'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final cumulativeGPA = controller.cumulativeGPA;
              final gpa = cumulativeGPA['gpa']?.toDouble() ?? 0.0;
              final credits = cumulativeGPA['credits'] ?? 0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGPAIndicator(gpa),
                  _buildCreditsIndicator(credits),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGPAIndicator(double gpa) {
    Color gpaColor;
    if (gpa >= 3.5) {
      gpaColor = Colors.green;
    } else if (gpa >= 2.5) {
      gpaColor = Colors.blue;
    } else if (gpa >= 2.0) {
      gpaColor = Colors.orange;
    } else {
      gpaColor = Colors.red;
    }

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: gpa / 4.0,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(gpaColor),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gpa.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  Text(
                    'out_of'.tr,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'gpa'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCreditsIndicator(int credits) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
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
              '$credits',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'credits'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterGPASection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'semester_gpa'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
          ),
        ),
        SizedBox(height: 16),
        _buildSemesterSelectionCard(),
        SizedBox(height: 20),
        _buildSemesterGPACard(),
      ],
    );
  }

  final RxInt selectedYear = 1.obs;
  final RxInt selectedSemester = 1.obs;

  Widget _buildSemesterSelectionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_year'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                children: [1, 2, 3, 4, 5].map((year) {
                  return GestureDetector(
                    onTap: () {
                      selectedYear.value = year;
                      controller.fetchSemesterGPA(year, selectedSemester.value);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedYear.value == year ? AppTheme.secondaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.secondaryColor),
                      ),
                      child: Text(
                        '${'year'.tr} $year',
                        style: TextStyle(
                          color: selectedYear.value == year ? Colors.white : AppTheme.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ),
            SizedBox(height: 16),
            Text(
              'select_semester'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Row(
              children: [1, 2].map((semester) {
                return GestureDetector(
                  onTap: () {
                    selectedSemester.value = semester;
                    controller.fetchSemesterGPA(selectedYear.value, semester);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedSemester.value == semester ? AppTheme.secondaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.secondaryColor),
                    ),
                    child: Text(
                      '${'semester'.tr} $semester',
                      style: TextStyle(
                        color: selectedSemester.value == semester ? Colors.white : AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterGPACard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
              '${'year'.tr} ${selectedYear.value}, ${'semester'.tr} ${selectedSemester.value}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            )),
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final semesterGPA = controller.semesterGPA;

              if (semesterGPA.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'no_data_semester'.tr,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }

              final gpa = semesterGPA['gpa']?.toDouble() ?? 0.0;
              final credits = semesterGPA['credits'] ?? 0;
              final courses = semesterGPA['courses'] ?? [];

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGPAIndicator(gpa),
                      _buildCreditsIndicator(credits),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (courses.isNotEmpty) ...[
                    Text(
                      'courses'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            course['name'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${'code'.tr}: ${course['courseCode'] ?? ''}',
                          ),
                          trailing: Text(
                            '${'grade'.tr}: ${controller.getLetterGrade(course['mark']?.toDouble() ?? 0.0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.getGradeColor(course['mark']?.toDouble() ?? 0.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
