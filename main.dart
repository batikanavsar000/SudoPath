// lib/main.dart
// SudoPath — Uygulama Giriş Noktası
// ─────────────────────────────────────────────────────────────
// Başlatma sırası:
//   1. Flutter binding hazırla
//   2. Firebase başlat
//   3. Hive veritabanını başlat + kutularını aç
//   4. easy_localization'ı başlat
//   5. ProviderScope ile Riverpod'u sarmala
//   6. SudoPathApp'i çalıştır
// ─────────────────────────────────────────────────────────────

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, Persistence;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:SudoPath/app.dart';
import 'package:SudoPath/core/constants/app_constants.dart';
import 'package:SudoPath/data/models/hive_models.dart';
import 'package:SudoPath/firebase_options.dart';

Future<void> main() async {
  // ── 1. Flutter binding ──────────────────────────────────────
  WidgetsFlutterBinding.ensureInitialized();

  // ── 2. Firebase başlatma ────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── 2a. Web'de oturum kalıcılığını garanti et ───────────────
  // LOCAL: tarayıcı/uygulama kapatılsa bile oturum korunur (IndexedDB)
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  // ── 3a. AdMob başlatma (web'de çalışmaz) ───────────────────
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }

  // ── 3. Sistem UI ayarları ───────────────────────────────────
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Yalnızca dikey ekran yönü
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── 4. Hive başlatma ────────────────────────────────────────
  await Hive.initFlutter();

  // TypeAdapter kayıtları — hive_models.dart'taki yardımcı fonksiyon
  registerHiveAdapters();

  // Kutuları aç
  await Future.wait([
    Hive.openBox(AppConstants.boxProgress),
    Hive.openBox(AppConstants.boxSettings),
    Hive.openBox(AppConstants.boxWorlds),
  ]);

  // ── 5. easy_localization başlatma ───────────────────────────
  await EasyLocalization.ensureInitialized();

  // ── 6. Uygulamayı başlat ────────────────────────────────────
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: AppConstants.translationsPath,
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: const ProviderScope(
        child: SudoPathApp(),
      ),
    ),
  );
}
