import 'package:flutter/material.dart';
import 'l10n/l10n.dart';
// Import actual pages once created
import 'pages/home_page.dart';

class SwiftCutApp extends StatelessWidget {
  const SwiftCutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftCut',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      supportedLocales: L10n.all,
      localizationsDelegates: [
        ...L10n.delegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
