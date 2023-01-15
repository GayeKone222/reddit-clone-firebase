import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/firebase_options.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/router.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    //get the user
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getuserData(data.uid)
        .first;

    // update the userProvider value

    ref.read(userProvider.notifier).update((state) => userModel);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data) => MaterialApp.router(
              title: 'Reddit tutorial',
              debugShowCheckedModeBanner: false,
              theme: ref.watch(themeNotifierProvider),
              routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                  if (userModel != null) {
                    return loggedInRoute;
                  }
                }
                return loggedOutRoute;
              }),
              routeInformationParser: const RoutemasterParser(),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ref.watch(authStateChangeProvider).when(
//         data: (data) => MaterialApp.router(
//               title: 'Reddit tutorial',
//               debugShowCheckedModeBanner: false,
//               theme: Pallete.darkModeAppTheme,
//               routerDelegate: RoutemasterDelegate(
//                   routesBuilder: (context) {
//                     if(data != null){
//                        return loggedInRoute;
//                     }
//                     return loggedOutRoute;
//                   }),
//               routeInformationParser: const RoutemasterParser(),
//             ),
//         error: (error, stackTrace) => ErrorText(error: error.toString()),
//         loading: () => const Loader());
//   }
// }
