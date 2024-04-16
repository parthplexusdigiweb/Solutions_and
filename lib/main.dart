import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/provider_for_challenges.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/screens/addchallengesScreen.dart';
import 'package:thrivers/screens/addthriverscreen.dart';
import 'package:thrivers/screens/authenticateloginscreen.dart';
import 'package:thrivers/screens/homescreentab.dart';
import 'package:thrivers/screens/new%20added%20screens/NewHomeScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/UserAboutMePage.dart';
import 'package:thrivers/screens/new%20added%20screens/UserLoginPage.dart';
import 'package:thrivers/screens/new%20added%20screens/UserRegisterPage.dart';
import 'package:thrivers/screens/not%20used%20screen/landingscreen.dart';
import 'package:thrivers/screens/not%20used%20screen/loginscreen.dart';
import 'package:thrivers/screens/new%20added%20screens/SuperAdminLoginScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';
import 'package:thrivers/socketConnection.dart';
import 'package:url_strategy/url_strategy.dart';

import 'Network/FirebaseApi.dart';
import 'Network/my_http_overrides.dart';
import 'Provider/previewProvider.dart';
import 'firebase_options.dart';

import 'dart:io';

SharedPreferences? sharedPreferences;

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
  // runApp(const MyApp());
  runApp(
      MultiProvider(
          providers: [
        ChangeNotifierProvider(create: (_) => AddKeywordProvider()),
        ChangeNotifierProvider(create: (_) => ChallengesProvider()),
        ChangeNotifierProvider(create: (_) => UserAboutMEProvider()),
        ChangeNotifierProvider(create: (_) => PreviewProvider()),
      ],
        child: const MyApp())
      );
}

Future<Widget> _buildAdminScreen(BuildContext context, GoRouterState state) async {
  bool loggedIn = await ApiRepository().isLoggedIn(); // Implement isLoggedIn() according to your authentication logic
  var username = await ApiRepository().getSavedUsername(); // Implement getSavedUsername() to retrieve the username if logged in
  if (loggedIn) {
    return NewHomeScreenTabs(AdminName: username);
  }
  else {
    return SuperAdminLoginScreen();
  }
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      // builder: (BuildContext context, GoRouterState state) {
      //   // return  NewHomeScreenTabs();
      //   // return  LandingScreen();
      //   // return  ThriverLandingScreen();
      //   return  SuperAdminLoginScreen();
      //   // return  socketConnection();
      // },
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
      builder: (BuildContext context, GoRouterState state) {
        return FutureBuilder<Widget>(
          future: _buildAdminScreen(context, state),
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
      routes: <RouteBase>[
        GoRoute(
          path: 'authenticate',
   // https://retailhub-ea728.web.app/loginTokeneyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9ashrafeyJlbWFpbCI6ImFzaHJhZmtzYWxpbTFAZ21haWwuY29tIiwiaWF0IjoxNzAzMzY0NDQ2LCJpc3MiOiJodHRwczovL2dpdGh1Yi5jb20vam9uYXNyb3Vzc2VsL2RhcnRfanNvbndlYnRva2VuIn0ashrafle57WUoi1zzp92I9O3flYoCAZZYX98SuwfzLcZP54Ng
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

        // GoRoute(
        //   path: 'admin',
        //   builder: (BuildContext context, GoRouterState state){
        //     return FutureBuilder<Widget>(
        //       future: _buildAdminScreen(context, state),
        //       builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return CircularProgressIndicator();
        //         } else {
        //           return snapshot.data ??
        //               Container(); // Return an empty container if snapshot.data is null
        //         }
        //       },
        //     );
        //   },
        // ),

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

        ),

        GoRoute(
          path: 'userhome',
          builder: (BuildContext context, GoRouterState state) {
            return  UserAboutMePage(isClientLogeddin: true, emailId: "fenilpatel120501@gmail.comm");
          },

        ),

      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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

