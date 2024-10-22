import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/AdminSolutionListProvider.dart';
import 'package:thrivers/Provider/LoginAuthProvider.dart';
import 'package:thrivers/Provider/RegisterAndLoginProvider.dart';
import 'package:thrivers/Provider/UniversalListProvider.dart';
import 'package:thrivers/Provider/provider_for_challenges.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/screens/admin_screens/addchallengesScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/authenticateloginscreen.dart';
import 'package:thrivers/screens/not%20used%20screen/homescreentab.dart';
import 'package:thrivers/screens/landing_screen/NewSolutionsLandingScreen.dart';
import 'package:thrivers/screens/admin_screens/AdminAboutMePage.dart';
import 'package:thrivers/screens/admin_screens/NewHomeScreen.dart';
import 'package:thrivers/screens/user_screen/UserProfileDetails.dart';
import 'package:thrivers/screens/user_screen/UserLoginPage.dart';
import 'package:thrivers/screens/user_screen/UserRegisterPage.dart';
import 'package:thrivers/screens/user_screen/forgetPasswordScreen.dart';
import 'package:thrivers/screens/not%20used%20screen/landingscreen.dart';
import 'package:thrivers/screens/not%20used%20screen/loginscreen.dart';
import 'package:thrivers/screens/admin_screens/SuperAdminLoginScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';
import 'package:thrivers/screens/not%20used%20screen/newscreens.dart';
import 'package:thrivers/socketConnection.dart';
import 'package:url_strategy/url_strategy.dart';

import 'Network/FirebaseApi.dart';
import 'Network/my_http_overrides.dart';
import 'Provider/AboutMeProvider.dart';
import 'Provider/importDataProvider.dart';
import 'Provider/previewProvider.dart';
import 'firebase_options.dart';

import 'dart:io';

SharedPreferences? sharedPreferences;

bool? isloggedIn;
var emailId;

Future<Widget>? _cachedAdminScreen;

/// fenil new
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  setPathUrlStrategy();

  // await Hive.initFlutter();
  // ui.platformViewRegistry.registerViewFactory(
  //     'newsletter',
  //         (int viewId) => IFrameElement()
  //       ..src = 'https://ddfc1098.sibforms.com/serve/MUIFABpvhkH3XvL1QIbioH-zuqIy4MzOCoOGIUvjeP5En16VdLe3Xs8sOwqGL-WBmR3yJZ9AnLyTrAN63tBlcgOPuxicwsUw9kNYT37FSmbFUgLBbN6I0ZyOsZAB2pLYJeh7kZ1Qi5tuunqlK43bm4mAfZhll3jEmiwCyq11g3JVjKmviG4OPhOHipT3_DiFHfNxjOON8okN-Sd5'
  //       ..style.border = 'none'
  //
  // );*/

   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

  _cachedAdminScreen = _buildAdminScreen();

  // runApp(const MyApp());
  runApp(
      MultiProvider(
          providers: [
        ChangeNotifierProvider(create: (_) => AddKeywordProvider()),
        ChangeNotifierProvider(create: (_) => ChallengesProvider()),
        ChangeNotifierProvider(create: (_) => UserAboutMEProvider()),
        ChangeNotifierProvider(create: (_) => PreviewProvider()),
        ChangeNotifierProvider(create: (_) => UniversalListProvider()),
        ChangeNotifierProvider(create: (_) => UserSession()),
        ChangeNotifierProvider(create: (_) => LoginRegisterProvider()),
        ChangeNotifierProvider(create: (_) => AboutMeProvider()),
        ChangeNotifierProvider(create: (_) => SolutionsListProvider()),
        ChangeNotifierProvider(create: (_) => ImportDataProvider()),
      ],
        child: const MyApp())
      );
}

Future<Widget> _buildAdminScreen() async {
  bool loggedIn = await ApiRepository().isLoggedIn(); // Implement isLoggedIn() according to your authentication logic
  var username = await ApiRepository().getSavedUsername(); // Implement getSavedUsername() to retrieve the username if logged in
  if (loggedIn) {
    return NewHomeScreenTabs(AdminName: username);
    // return HomePage();
  }
  else {
    return SuperAdminLoginScreen();
  }
}

Future<Map<String, dynamic>> _getStoredPreferences() async {
  final prefs = await SharedPreferences.getInstance();
   isloggedIn = prefs.getBool('isLoggedIn') ?? false;
   emailId = prefs.getString('emailId') ?? '';
  return {'isLoggedIn': isloggedIn, 'emailId': emailId};
}



/// The route configuration.
final GoRouter _router = GoRouter(
  // initialLocation: '/admin',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // return  NewHomeScreenTabs();
        // return  LandingScreen();
        // return  ThriverLandingScreen();
        return  SolutionsLandingScreen();
        // return  socketConnection();
      },
      ///
      // builder: (BuildContext context, GoRouterState state) {
      //   return FutureBuilder<bool>(
      //     future: ApiRepository().isLoggedIn(),
      //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         // Loading state
      //         return CircularProgressIndicator();
      //       } else {
      //         // Check if user is logged in
      //         if (snapshot.hasData && snapshot.data!) {
      //           // User is logged in, navigate to the dashboard
      //           return FutureBuilder<Widget>(
      //             future: _buildAdminScreen(context, state),
      //             builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                 return CircularProgressIndicator();
      //               } else {
      //                 return snapshot.data ?? Container(); // Return an empty container if snapshot.data is null
      //               }
      //             },
      //           );
      //         } else {
      //           // User is not logged in, show the login page
      //           return SuperAdminLoginScreen();
      //         }
      //       }
      //     },
      //   );
      // },
      ///
      // builder: (BuildContext context, GoRouterState state) {
      //   return FutureBuilder<Widget>(
      //     future: _buildAdminScreen(context, state),
      //     builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return CircularProgressIndicator();
      //       } else {
      //         return snapshot.data ??
      //             Container(); // Return an empty container if snapshot.data is null
      //       }
      //     },
      //   );
      // },
      routes: <RouteBase>[
   //      GoRoute(
   //        path: 'authenticate',
   // // https://retailhub-ea728.web.app/loginTokeneyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9ashrafeyJlbWFpbCI6ImFzaHJhZmtzYWxpbTFAZ21haWwuY29tIiwiaWF0IjoxNzAzMzY0NDQ2LCJpc3MiOiJodHRwczovL2dpdGh1Yi5jb20vam9uYXNyb3Vzc2VsL2RhcnRfanNvbndlYnRva2VuIn0ashrafle57WUoi1zzp92I9O3flYoCAZZYX98SuwfzLcZP54Ng
   //        builder: (BuildContext context, GoRouterState state) {
   //          print(state.extra);
   //          print(state.pathParameters);
   //          print(state.uri.queryParameters['loginToken']);
   //          final loginToken = state.uri.queryParameters['loginToken']!;
   //          print("From RouteBase : "+loginToken);
   //          return AuthenticateLogin(
   //            loginToken: loginToken,
   //          );
   //        },
   //      ),

        ///admin
        // GoRoute(
        //   path: 'admin',
        //   builder: (BuildContext context, GoRouterState state) {
        //     // return  LoginScreen();
        //     // return SuperAdminLoginScreen();
        //     return _buildAdminScreen();
        //     // return  AddChallengesScreen()  ;
        //     // return  HomeScreenTabs();
        //     // return  NewHomeScreenTabs();
        //   },
        // ),

        GoRoute(
          path: 'admin',
          builder: (BuildContext context, GoRouterState state){
            return FutureBuilder<Widget>(
              // future: _buildAdminScreen(context),
              future: _cachedAdminScreen,
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return snapshot.data ??
                      Container(); // Return an empty container if snapshot.data is null
                }
              },
            );
          },
        ),

        GoRoute(
          path: 'userRegister',
          builder: (BuildContext context, GoRouterState state) {
            return  RegisterPage();
          },

        ),

        GoRoute(
          path: 'userLogin',
          builder: (BuildContext context, GoRouterState state) {
            return  UserLoginPage();
          },
          routes: [
            GoRoute(
              path: 'authenticate',
              // https://retailhub-ea728.web.app/loginTokeneyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9ashrafeyJlbWFpbCI6ImFzaHJhZmtzYWxpbTFAZ21haWwuY29tIiwiaWF0IjoxNzAzMzY0NDQ2LCJpc3MiOiJodHRwczovL2dpdGh1Yi5jb20vam9uYXNyb3Vzc2VsL2RhcnRfanNvbndlYnRva2VuIn0ashrafle57WUoi1zzp92I9O3flYoCAZZYX98SuwfzLcZP54Ng
              builder: (BuildContext context, GoRouterState state) {
                print("state.extra: ${state.extra}");
                print("state.pathParameters: ${state.pathParameters}");
                print("loginToken : ${state.uri.queryParameters['loginToken']}");
                final loginToken = state.uri.queryParameters['loginToken']!;
                // final islogin = state.uri.queryParameters['islogin']!;

                print("From RouteBase : "+loginToken);
                // print("isloginnnnnn ${islogin}");


                return AuthenticateLogin(
                  loginToken: loginToken,
                    // islogin:islogin
                );
              },
            ),
            // GoRoute(
            //     path: 'home',
            //     builder: (BuildContext context, GoRouterState state) {
            //       return  UserAboutMePage(isClientLogeddin: true, emailId: "fenilpatel120501@gmail.com");
            //     }),
            GoRoute(
              path: 'home',
              builder: (BuildContext context, GoRouterState state) {
                return FutureBuilder(
                  future: _getStoredPreferences(),
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final bool isClientLoggedIn = snapshot.data?['isLoggedIn'] ?? false;
                      final String emailId = snapshot.data?['emailId'] ?? '';

                      if (isClientLoggedIn) {
                        return UserAboutMePage(isClientLogeddin: isClientLoggedIn, emailId: emailId);
                      } else {
                        Future.microtask(() => context.go('/userlogin'));
                        return SizedBox.shrink(); // Empty widget while navigating
                      }
                      // return UserAboutMePage(isClientLogeddin: isClientLoggedIn, emailId: emailId);
                    }
                  },
                );
              },
            ),
          ],
        ),

        GoRoute(
          path: 'userhome',
          builder: (BuildContext context, GoRouterState state) {
            return  UserAboutMePage(isClientLogeddin: true, emailId: "fenilpatel120501@gmail.com");
            // return  UserAboutMePage(isClientLogeddin: isloggedIn, emailId: "pgajdhar@gmail.com");
            // return  UserAboutMePage(isClientLogeddin: isloggedIn, emailId: "mthlondon@gmail.com");
          },

        ),

        GoRoute(
          path: 'forgetPassword',
          builder: (context, state) => ForgetPasswrdScreen(),
        ),

      ],
    ),
  ],

);

final GoRouter _newrouter = GoRouter(
  // initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SolutionsLandingScreen();
      },
    ),
    GoRoute(
      path: '/admin',
      builder: (BuildContext context, GoRouterState state) {
        return FutureBuilder<Widget>(
          future: _cachedAdminScreen, // Ensure this future is correctly defined
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return snapshot.data ?? Container();
            }
          },
        );
      },
    ),
    GoRoute(
      path: '/userRegister',
      builder: (BuildContext context, GoRouterState state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      path: '/userLogin',
      builder: (BuildContext context, GoRouterState state) {
        return UserLoginPage();
      },
      routes: [
        GoRoute(
          path: 'authenticate',
          builder: (BuildContext context, GoRouterState state) {
            final loginToken = state.uri.queryParameters['loginToken'];
            return AuthenticateLogin(loginToken: loginToken ?? '');
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return FutureBuilder<Map<String, dynamic>>(
              future: _getStoredPreferences(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final bool isClientLoggedIn = snapshot.data?['isLoggedIn'] ?? false;
                  final String emailId = snapshot.data?['emailId'] ?? '';
                  if (isClientLoggedIn) {
                    return UserAboutMePage(isClientLogeddin: isClientLoggedIn, emailId: emailId);
                  } else {
                    // Using Future.microtask to ensure navigation happens correctly
                    Future.microtask(() => context.go('/userLogin'));
                    return SizedBox.shrink();
                  }
                }
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/userhome',
      builder: (BuildContext context, GoRouterState state) {
        return UserAboutMePage(isClientLogeddin: true, emailId: "fenilpatel120501@gmail.com");
      },
    ),
    GoRoute(
      path: '/forgetPassword',
      builder: (context, state) => ForgetPasswrdScreen(),
    ),
  ],
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _newrouter,
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      title: 'Thrivers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      //home: LandingScreen(),

    );
  }
}

