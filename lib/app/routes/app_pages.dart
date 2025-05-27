// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:university_student_application/app/modules/auth/views/register_view.dart';

import '../bindings/dashboard_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/profile_view.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/courses/views/available_courses_view.dart';
import '../modules/courses/views/course_detail_view.dart';
import '../modules/courses/views/my_courses_view.dart';
import '../modules/marks/views/marks_view.dart';
import '../modules/marks/views/gpa_view.dart';
import '../modules/votes/views/create_vote_view.dart';
import '../modules/votes/views/my_votes_view.dart';

import '../bindings/auth_binding.dart';
import '../bindings/course_binding.dart';
import '../bindings/mark_binding.dart';
import '../bindings/vote_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileView(),
      binding: AuthBinding(),  // أو binding مناسب، أو تركها بدون binding إذا ليس مطلوب
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.AVAILABLE_COURSES,
      page: () => AvailableCoursesView(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: Routes.MY_COURSES,
      page: () => MyCoursesView(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: Routes.COURSE_DETAIL,
      page: () => CourseDetailView(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: Routes.MARKS,
      page: () => MarksView(),
      binding: MarkBinding(),
    ),
    GetPage(
      name: Routes.GPA,
      page: () => GpaView(),
      binding: MarkBinding(),
    ),
    GetPage(
      name: Routes.CREATE_VOTE,
      page: () => CreateVoteView(),
      binding: VoteBinding(),
    ),
    GetPage(
      name: Routes.MY_VOTES,
      page: () => MyVotesView(),
      binding: VoteBinding(),
    ),
  ];
}
