import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'storage_service.dart';

@singleton
class LocalizationService {
  final StorageService _storageService;

  LocalizationService(this._storageService);

  static const List<Locale> supportedLocales = [Locale('tr'), Locale('en')];

  static const String defaultLanguage = 'tr';

  Future<void> initialize(BuildContext context) async {
    await _storageService.initialize();

    final savedLanguage = _storageService.getLanguage();
    if (savedLanguage != null && context.mounted) {
      await context.setLocale(Locale(savedLanguage));
    } else if (context.mounted) {
      await context.setLocale(const Locale(defaultLanguage));
      await _storageService.saveLanguage(defaultLanguage);
    }
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    await context.setLocale(Locale(languageCode));
    await _storageService.saveLanguage(languageCode);
  }

  String getCurrentLanguage(BuildContext context) {
    return context.locale.languageCode;
  }

  bool isTurkish(BuildContext context) {
    return context.locale.languageCode == 'tr';
  }

  bool isEnglish(BuildContext context) {
    return context.locale.languageCode == 'en';
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return 'Türkçe';
    }
  }
}
