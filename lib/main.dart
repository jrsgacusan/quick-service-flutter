import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/screens/authenticate/initial_screen.dart';
import 'package:quick_service_clone/screens/authenticate/registration_screen.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_edit_profile/client_edit_profile.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_home_screen/client_home_screen.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_request/client_manage_request.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_request/client_request.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_category/client_specific_category.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/client_specific_service.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/service_provider_reviews.dart';
import 'package:quick_service_clone/screens/authenticated/send_requirements_screen.dart';
import 'package:quick_service_clone/screens/authenticated/service_provider_mode/sp_home_screen.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: GetMaterialApp(
        initialRoute: '/wrapper',
        theme: ThemeData(
          dividerColor: Colors.grey,
          // Define the default brightness and colors.
          primaryColor: Colors.teal,
          accentColor: Colors.tealAccent,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.grey[600],
            ),
          ),
        ),
        routes: {
          '/wrapper': (context) => Wrapper(),
          '/initial_screen': (context) => InitialScreen(),
          '/registration_screen': (context) => RegistrationScreen(),
          '/send_requirements_screen': (context) => SendRequirementsScreen(),
          '/client_home_screen': (context) => ClientHomeScreen(),
          '/client_edit_profile': (context) => ClientEditProfile(),
          '/client_specific_category': (context) => ClientSpecificCategory(),
          '/client_specific_service': (context) => ClientSpecificService(),
          '/service_provider_reviews': (context) => ServiceProviderReviews(),
          '/client_request': (context) => ClientRequest(),
          '/client_manage_request': (context) => ClientManageRequest(),
          '/sp_home_screen': (context) => SpHomeScreen(),
        },
      ),
    );
  }
}
