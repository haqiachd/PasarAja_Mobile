import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/firebase_options.dart';
import 'package:pasaraja_mobile/module/auth/providers/providers.dart';
import 'package:pasaraja_mobile/core/services/google_signin_services.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/add_product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/best_selling_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/choose_categories_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/complain_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/detail_list_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/detail_product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/hidden_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/recommended_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/review_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/unavailable_provider.dart';
import 'package:pasaraja_mobile/module/merchant/providers/qr/qr_scan_provider.dart';
import 'package:pasaraja_mobile/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // auth
        ChangeNotifierProvider(create: (context) => GoogleSignService()),
        ChangeNotifierProvider(create: (context) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (context) => ChangePinProvider()),
        ChangeNotifierProvider(create: (context) => SignInGoogleProvider()),
        ChangeNotifierProvider(create: (context) => SignInPhoneProvider()),
        ChangeNotifierProvider(create: (context) => SignUpFirstProvider()),
        ChangeNotifierProvider(create: (context) => SignUpSecondProvider()),
        ChangeNotifierProvider(create: (context) => SignUpThirdProvider()),
        ChangeNotifierProvider(create: (context) => SignUpFourthProvider()),
        ChangeNotifierProvider(create: (context) => VerifyOtpProvider()),
        ChangeNotifierProvider(create: (context) => VerifyPinProvider()),
        // merchant
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => AddProductProvider()),
        ChangeNotifierProvider(create: (context) => BestSellingProvider()),
        ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => ComplainProvider()),
        ChangeNotifierProvider(create: (context) => UnavailableProvider()),
        ChangeNotifierProvider(create: (context) => HiddenProvider()),
        ChangeNotifierProvider(create: (context) => RecommendedProvider()),
        ChangeNotifierProvider(create: (context) => DetailProductProvider()),
        ChangeNotifierProvider(create: (context) => DetailListProvider()),
        ChangeNotifierProvider(create: (context) => ChooseCategoriesProvider()),
        ChangeNotifierProvider(create: (context) => QrScanProvider()),
      ],
      child: GetMaterialApp(
        title: 'PasarAja',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: PasarAjaColor.green2,
            background: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
