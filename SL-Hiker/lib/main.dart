import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_employer/providers/auth_provider.dart';
import 'package:self_employer/providers/place_provider.dart';
import 'package:self_employer/screens/Loading_Page.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {

    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAbek30PIBq1FGR4U3OLeqRk8AkHiwo2ao",
            appId: "1:669801937866:android:40076d5d14fbe238432d33",
            messagingSenderId: "669801937866",
            projectId: "self-emp",
            storageBucket: "self-emp.appspot.com"
        )
    );
  }

  // runApp(const MyApp());
  await Future.delayed(const Duration(seconds: 5));
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserAuthProvider(),),
            ChangeNotifierProvider(create: (context) => PlaceProvider(),),
          ],
          child: const MyAppnext()));
}



class MyAppnext extends StatelessWidget{
  const MyAppnext({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context){
    return  const MaterialApp(
      home:Loading(),
      debugShowCheckedModeBanner: false,
    );
  }

}


