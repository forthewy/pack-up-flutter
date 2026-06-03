import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pack Up!'**
  String get appTitle;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @startScreenAppInfo.
  ///
  /// In en, this message translates to:
  /// **'All your prep, in one place —\nfrom trips to tests.'**
  String get startScreenAppInfo;

  /// No description provided for @menuTitlesTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get menuTitlesTravel;

  /// No description provided for @menuTitlesStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get menuTitlesStudy;

  /// No description provided for @menuTitlesShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get menuTitlesShopping;

  /// No description provided for @menuTitlesMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get menuTitlesMove;

  /// No description provided for @menuTitlesFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get menuTitlesFitness;

  /// No description provided for @menuTitlesDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get menuTitlesDaily;

  /// No description provided for @menuTitlesWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get menuTitlesWork;

  /// No description provided for @menuTitlesEtc.
  ///
  /// In en, this message translates to:
  /// **'Etc'**
  String get menuTitlesEtc;

  /// No description provided for @emptyItemText.
  ///
  /// In en, this message translates to:
  /// **'There are no items yet 🙂\nTap the + button to add one'**
  String get emptyItemText;

  /// No description provided for @suggestionBtnText.
  ///
  /// In en, this message translates to:
  /// **'Need Suggestions? Click Here!'**
  String get suggestionBtnText;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @addItemHintText.
  ///
  /// In en, this message translates to:
  /// **'Enter a new item'**
  String get addItemHintText;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// No description provided for @deleteAlertText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?\nItems listed under this will also be deleted'**
  String get deleteAlertText;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get confirmDelete;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @travelPassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get travelPassport;

  /// No description provided for @travelCharger.
  ///
  /// In en, this message translates to:
  /// **'Charger'**
  String get travelCharger;

  /// No description provided for @travelPowerBank.
  ///
  /// In en, this message translates to:
  /// **'Power Bank'**
  String get travelPowerBank;

  /// No description provided for @travelCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency Exchange'**
  String get travelCurrency;

  /// No description provided for @travelInsurance.
  ///
  /// In en, this message translates to:
  /// **'Travel Insurance'**
  String get travelInsurance;

  /// No description provided for @studyPen.
  ///
  /// In en, this message translates to:
  /// **'Pen'**
  String get studyPen;

  /// No description provided for @studyTextbook.
  ///
  /// In en, this message translates to:
  /// **'Textbook'**
  String get studyTextbook;

  /// No description provided for @shoppingMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get shoppingMilk;

  /// No description provided for @shoppingRice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get shoppingRice;

  /// No description provided for @shoppingToiletPaper.
  ///
  /// In en, this message translates to:
  /// **'Toilet Paper'**
  String get shoppingToiletPaper;

  /// No description provided for @shoppingDetergent.
  ///
  /// In en, this message translates to:
  /// **'Detergent'**
  String get shoppingDetergent;

  /// No description provided for @shoppingTrashBags.
  ///
  /// In en, this message translates to:
  /// **'Trash Bags'**
  String get shoppingTrashBags;

  /// No description provided for @moveMold.
  ///
  /// In en, this message translates to:
  /// **'Check for Mold'**
  String get moveMold;

  /// No description provided for @moveDefects.
  ///
  /// In en, this message translates to:
  /// **'Check for Defects'**
  String get moveDefects;

  /// No description provided for @moveSize.
  ///
  /// In en, this message translates to:
  /// **'Check Room Size'**
  String get moveSize;

  /// No description provided for @moveFloor.
  ///
  /// In en, this message translates to:
  /// **'Check Floor Level'**
  String get moveFloor;

  /// No description provided for @moveMoveInDate.
  ///
  /// In en, this message translates to:
  /// **'Confirm Move-in Date'**
  String get moveMoveInDate;

  /// No description provided for @fitnessStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching'**
  String get fitnessStretching;

  /// No description provided for @fitnessCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get fitnessCardio;

  /// No description provided for @fitnessUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper Body Workout'**
  String get fitnessUpperBody;

  /// No description provided for @fitnessLowerBody.
  ///
  /// In en, this message translates to:
  /// **'Lower Body Workout'**
  String get fitnessLowerBody;

  /// No description provided for @fitnessCoolDown.
  ///
  /// In en, this message translates to:
  /// **'Cool Down'**
  String get fitnessCoolDown;

  /// No description provided for @dailyWakeUp.
  ///
  /// In en, this message translates to:
  /// **'Wake Up Early'**
  String get dailyWakeUp;

  /// No description provided for @dailyExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get dailyExercise;

  /// No description provided for @dailyStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get dailyStudy;

  /// No description provided for @dailyCleaning.
  ///
  /// In en, this message translates to:
  /// **'Clean Room'**
  String get dailyCleaning;

  /// No description provided for @dailySleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep Early'**
  String get dailySleep;

  /// No description provided for @etcPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get etcPhone;

  /// No description provided for @etcWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get etcWallet;

  /// No description provided for @etcKeys.
  ///
  /// In en, this message translates to:
  /// **'Keys'**
  String get etcKeys;

  /// No description provided for @etcEarphones.
  ///
  /// In en, this message translates to:
  /// **'Earphones'**
  String get etcEarphones;

  /// No description provided for @etcCharger.
  ///
  /// In en, this message translates to:
  /// **'Charger'**
  String get etcCharger;

  /// No description provided for @workLaptop.
  ///
  /// In en, this message translates to:
  /// **'Laptop'**
  String get workLaptop;

  /// No description provided for @workUsb.
  ///
  /// In en, this message translates to:
  /// **'USB'**
  String get workUsb;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
