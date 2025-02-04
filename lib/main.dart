import 'package:app/Provider/dang_ky_email_provider.dart';
import 'package:app/Provider/edit_item_profile_provider.dart';
import 'package:app/Provider/edit_profile_provider.dart';
import 'package:app/Provider/dang_ky_sdt_provider.dart';
import 'package:app/Provider/gui_data_provider.dart';
import 'package:app/View/Widget/bottom_navigation.dart';
import 'package:app/View/Screen/man_hinh_addFriend.dart';
import 'package:app/Provider/quay_video_provider.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_quay_video.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'package:app/View/Screen/Profile/main_hinh_editProfile.dart';
import 'package:app/View/Screen/Profile/man_hinh_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/dang_nhap_sdt_provider.dart';
import 'View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'View/Screen/Pages/trang_chu.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MyData()),
      ChangeNotifierProvider(create: (context) => DangNhapSdtProvider()),
      ChangeNotifierProvider(create: (context) => DangKySdtProvider()),
      ChangeNotifierProvider(create: (context) => DangKyEmailProvider()),
      ChangeNotifierProvider(create: (context) => EditItemProfileProvider()),
      ChangeNotifierProvider(create: (context) => EditProfileProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bottom_Navigation_Bar(),
    );
  }
}
