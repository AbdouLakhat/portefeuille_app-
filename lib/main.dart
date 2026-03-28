import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/login_telephone_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/pin_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/transfer/screens/transfer_screen.dart';
import 'features/bills/screens/bill_payment_screen.dart';
import 'features/qr_code/screens/qr_scanner_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await initializeDateFormatting('fr_FR', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENPAY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/':                (context) => const SplashScreen(),
        '/login':           (context) => const LoginScreen(),
        '/login-telephone': (context) => const LoginTelephoneScreen(),
        '/register':        (context) => const RegisterScreen(),
        '/pin':             (context) => const PinScreen(mode: PinMode.login),
        '/pin-register':    (context) => const PinScreen(mode: PinMode.register),
        '/home':            (context) => const HomeScreen(),
        '/transfer':        (context) => const TransferScreen(),
        '/bills':           (context) => const BillPaymentScreen(),
        '/qr':              (context) => const QrScannerScreen(),
        '/profile':         (context) => const ProfileScreen(),
      },
    );
  }
}