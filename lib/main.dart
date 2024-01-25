import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/blocs/debug_bloc.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/l10n/app_localizations.dart';
import 'package:nososova/ui/config/responsive.dart';
import 'package:nososova/ui/pages/main/main_page.dart';
import 'package:window_manager/window_manager.dart';

import 'blocs/events/app_data_events.dart';
import 'generated/assets.dart';

Future<void> main() async {
  await dotenv.load(fileName: Assets.nososova);
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 800),
      center: true,
      minimumSize: Size(1000, 800),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future testWindowFunctions() async {}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    FontLoader("GilroyHeavy").addFont(rootBundle.load(Assets.fontsGilroyHeavy));
    FontLoader("GilroyBold").addFont(rootBundle.load(Assets.fontsGilroyBold));
    FontLoader("GilroyRegular")
        .addFont(rootBundle.load(Assets.fontsGilroyRegular));
    FontLoader("GilroySemiBold")
        .addFont(rootBundle.load(Assets.fontsGilroyRegular));

    if (Responsive.isMobile(context)) {
      ScreenUtil.init(context, designSize: const Size(414, 896));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DebugBloc>(create: (context) => locator<DebugBloc>()),
          BlocProvider<WalletBloc>(
            create: (context) => locator<WalletBloc>(),
          ),
          BlocProvider<AppDataBloc>(create: (context) {
            final appDataBloc = locator<AppDataBloc>();
            appDataBloc.add(InitialConnect());
            return appDataBloc;
          }),
        ],
        child: const MainPage(),
      ),
    );
  }
}