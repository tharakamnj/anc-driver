import 'package:anc_bus_service_driver/screens/authentication/login/login_view.dart';
import 'package:anc_bus_service_driver/screens/authentication/register/register_view.dart';
import 'package:anc_bus_service_driver/screens/home/home/home_view.dart';
import 'package:anc_bus_service_driver/screens/home/students_list/students_list_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
        name: Routes.LOGIN,
        page: () => const LoginScreen(),
        transition: Transition.leftToRight),
    GetPage(
        name: Routes.HOME,
        page: () => const HomeScreen(),
        transition: Transition.leftToRight),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: Routes.STUDENTLIST,
      page: () => StudentsListScreen(),
    )
  ];
}
