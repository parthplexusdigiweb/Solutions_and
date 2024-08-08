import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_paths/go_router_paths.dart';
import 'package:thrivers/screens/admin_screens/addchallengesScreen.dart';
import 'package:thrivers/screens/admin_screens/addthriverscreen.dart';
import 'package:thrivers/screens/admin_screens/AdminAboutMePage.dart';
import 'package:thrivers/screens/admin_screens/NewHomeScreen.dart';
import 'package:thrivers/screens/admin_screens/SuperAdminLoginScreen.dart';
import 'package:thrivers/screens/user_screen/UserLoginPage.dart';
import 'package:thrivers/screens/user_screen/UserRegisterPage.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';

import '../screens/new added screens/authenticateloginscreen.dart';

class AppPaths {

  static Path get home => Path('/admin');
  static AdminPath get admin => AdminPath();

  static UsersPath get users => UsersPath();
  static Path get userLogin => Path('/userlogin');
  static Path get userRegister => Path('/userregister');

  final GoRouter _newrouter = GoRouter(
    initialLocation: '/admin',
    routes: [
      GoRoute(
          path: '/admin',
          builder: (context, state) => SuperAdminLoginScreen(),
          routes: [
            GoRoute(
              path: '/admin/dashboard',
              builder: (context, state) => NewHomeScreenTabs(),
            ),
            GoRoute(
              path: '/admin/report',
              builder: (context, state) => AdminAboutMePage(),
            ),
            GoRoute(
              path: '/admin/solutions',
              builder: (context, state) => AddThriversScreen(),
            ),
            GoRoute(
              path: '/admin/challenges',
              builder: (context, state) => AddChallengesScreen(),
            ),
          ]
      ),
      GoRoute(
          path: '/userlogin',
          builder: (context, state) => UserLoginPage(),
          routes: [
            GoRoute(
              path: '/userlogin/dashboard',
              builder: (BuildContext context, GoRouterState state) {
                print(state.extra);
                print(state.pathParameters);
                print(state.uri.queryParameters['loginToken']);
                final loginToken = state.uri.queryParameters['loginToken']!;
                print("From RouteBase : "+loginToken);
                return AuthenticateLogin(
                  loginToken: loginToken,
                );
              },
            ),
          ]
      ),

      GoRoute(
        path: '/userRegister',
        builder: (context, state) => RegisterPage(),)
      // Add other routes as needed
    ],
  );

}

class AdminPath extends Path<AdminPath> {
  AdminPath() : super('admin');

  Path get login => Path('login', parent: this);
  Path get dashboard => Path('dashboard', parent: this);
}

class UsersPath extends Path<UsersPath> {
  UsersPath() : super('users');

  UserPath get user => UserPath(this);
}

class UserPath extends Param<UserPath> {
  UserPath(UsersPath usersPath) : super.only('userId', parent: usersPath);

  Path get edit => Path('edit', parent: this);
  Path get delete => Path('delete', parent: this);
  Path get dashboard => Path('dashboard', parent: this);
}

