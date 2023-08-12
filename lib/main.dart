import 'package:counries_info/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 227, 236, 236),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(fontFamily: 'IranYekan');
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: TextTheme(
            headlineMedium: defaultTextStyle.copyWith(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            headlineSmall: defaultTextStyle.copyWith(
              color: Colors.grey.shade800,
              fontSize: 16,
            ),
            bodySmall: defaultTextStyle.copyWith(
              color: Colors.grey.shade800,
              fontSize: 12,
            ),
            bodyMedium: defaultTextStyle.copyWith(
              color: Colors.grey.shade800,
              fontSize: 14,
            ),
            bodyLarge: defaultTextStyle.copyWith(
              color: Colors.grey.shade800,
              fontSize: 24,
            ),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color.fromRGBO(79, 76, 255, 1),
          )

          // primarySwatch: Colors.blue,
          //0xff3971FF
          ),
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: HomeScreen()),
    );
  }
}
