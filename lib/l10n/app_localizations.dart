import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Baseball5 Community'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Baseball5 Community'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover teams, activities and learning resources in one place.'**
  String get welcomeSubtitle;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get quickAccess;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @communitySummary.
  ///
  /// In en, this message translates to:
  /// **'Updates, conversations and local baseball networks.'**
  String get communitySummary;

  /// No description provided for @communityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Community updates and conversations are on the way.'**
  String get communityPlaceholder;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationEmptyState.
  ///
  /// In en, this message translates to:
  /// **'You do not have any notifications yet.'**
  String get notificationEmptyState;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @teamsSummary.
  ///
  /// In en, this message translates to:
  /// **'Manage clubs, memberships and team planning.'**
  String get teamsSummary;

  /// No description provided for @teamsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Team pages and membership management will be available here.'**
  String get teamsPlaceholder;

  /// No description provided for @teamsPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover existing Baseball5 teams or create your own.'**
  String get teamsPageDescription;

  /// No description provided for @myTeamsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My teams'**
  String get myTeamsSectionTitle;

  /// No description provided for @myTeamsSignedOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view and manage your teams.'**
  String get myTeamsSignedOutMessage;

  /// No description provided for @myTeamsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'You have not created any teams yet.'**
  String get myTeamsEmptyState;

  /// No description provided for @myTeamsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your teams.'**
  String get myTeamsLoadError;

  /// No description provided for @myTeamsRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get myTeamsRetryAction;

  /// No description provided for @teamOwnerBadge.
  ///
  /// In en, this message translates to:
  /// **'Your team'**
  String get teamOwnerBadge;

  /// No description provided for @createYourFirstTeamAction.
  ///
  /// In en, this message translates to:
  /// **'Create your first team'**
  String get createYourFirstTeamAction;

  /// No description provided for @discoverTeamsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover teams'**
  String get discoverTeamsSectionTitle;

  /// No description provided for @teamSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search teams'**
  String get teamSearchHint;

  /// No description provided for @cityFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Filter by city'**
  String get cityFilterHint;

  /// No description provided for @countryFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Filter by country'**
  String get countryFilterHint;

  /// No description provided for @teamEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No public teams match your current filters.'**
  String get teamEmptyState;

  /// No description provided for @teamLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load teams'**
  String get teamLoadError;

  /// No description provided for @teamRecruitingOpen.
  ///
  /// In en, this message translates to:
  /// **'Open to join'**
  String get teamRecruitingOpen;

  /// No description provided for @teamRecruitingClosed.
  ///
  /// In en, this message translates to:
  /// **'Currently not recruiting'**
  String get teamRecruitingClosed;

  /// No description provided for @createTeamAction.
  ///
  /// In en, this message translates to:
  /// **'Create team'**
  String get createTeamAction;

  /// No description provided for @createTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Create team'**
  String get createTeamTitle;

  /// No description provided for @editTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit team'**
  String get editTeamTitle;

  /// No description provided for @saveTeamAction.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveTeamAction;

  /// No description provided for @teamEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit team'**
  String get teamEditAction;

  /// No description provided for @teamDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete team'**
  String get teamDeleteAction;

  /// No description provided for @teamDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete team?'**
  String get teamDeleteDialogTitle;

  /// No description provided for @teamDeleteDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete {teamName}. This action cannot be undone.'**
  String teamDeleteDialogContent(Object teamName);

  /// No description provided for @teamDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get teamDeleteConfirmAction;

  /// No description provided for @teamDeleteCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get teamDeleteCancelAction;

  /// No description provided for @teamDeleteError.
  ///
  /// In en, this message translates to:
  /// **'The team could not be deleted. Please try again.'**
  String get teamDeleteError;

  /// No description provided for @teamUpdateError.
  ///
  /// In en, this message translates to:
  /// **'The team could not be updated. Please try again.'**
  String get teamUpdateError;

  /// No description provided for @teamUpdatePermissionError.
  ///
  /// In en, this message translates to:
  /// **'You can only edit your own team.'**
  String get teamUpdatePermissionError;

  /// No description provided for @teamUpdateNetworkError.
  ///
  /// In en, this message translates to:
  /// **'The connection is unavailable. Please try again.'**
  String get teamUpdateNetworkError;

  /// No description provided for @teamUpdateSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'{teamName} was updated successfully.'**
  String teamUpdateSuccessMessage(Object teamName);

  /// No description provided for @teamNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'This team could not be found or is no longer available.'**
  String get teamNotFoundError;

  /// No description provided for @teamNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Team name'**
  String get teamNameLabel;

  /// No description provided for @teamNameValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a team name with at least 2 characters.'**
  String get teamNameValidationMessage;

  /// No description provided for @teamNameLengthMessage.
  ///
  /// In en, this message translates to:
  /// **'Team name must not exceed 80 characters.'**
  String get teamNameLengthMessage;

  /// No description provided for @teamDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get teamDescriptionLabel;

  /// No description provided for @teamDescriptionValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Description must not exceed 1000 characters.'**
  String get teamDescriptionValidationMessage;

  /// No description provided for @teamOrganizationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization type'**
  String get teamOrganizationTypeLabel;

  /// No description provided for @teamVisibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get teamVisibilityLabel;

  /// No description provided for @teamVisibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get teamVisibilityPublic;

  /// No description provided for @teamVisibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get teamVisibilityPrivate;

  /// No description provided for @teamRecruitingFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Recruiting enabled'**
  String get teamRecruitingFieldLabel;

  /// No description provided for @teamCreateSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'{teamName} was created successfully.'**
  String teamCreateSuccessMessage(Object teamName);

  /// No description provided for @teamCreateError.
  ///
  /// In en, this message translates to:
  /// **'The team could not be created. Please try again.'**
  String get teamCreateError;

  /// No description provided for @teamCreatePermissionError.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to create a team.'**
  String get teamCreatePermissionError;

  /// No description provided for @teamCreateNetworkError.
  ///
  /// In en, this message translates to:
  /// **'The connection is unavailable. Please try again.'**
  String get teamCreateNetworkError;

  /// No description provided for @teamDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected team'**
  String get teamDetailTitle;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @activitiesSummary.
  ///
  /// In en, this message translates to:
  /// **'Training sessions, open play and events.'**
  String get activitiesSummary;

  /// No description provided for @activitiesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Activities and event registration will be available here.'**
  String get activitiesPlaceholder;

  /// No description provided for @createActivityAction.
  ///
  /// In en, this message translates to:
  /// **'Create activity'**
  String get createActivityAction;

  /// No description provided for @createActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Create activity'**
  String get createActivityTitle;

  /// No description provided for @activityTypeTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get activityTypeTraining;

  /// No description provided for @activityTypeOpenPlay.
  ///
  /// In en, this message translates to:
  /// **'Open Play'**
  String get activityTypeOpenPlay;

  /// No description provided for @activityTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get activityTypeAll;

  /// No description provided for @activityLabelType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get activityLabelType;

  /// No description provided for @activityLabelVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get activityLabelVisibility;

  /// No description provided for @activityLabelCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get activityLabelCity;

  /// No description provided for @activityLabelMeetingPlace.
  ///
  /// In en, this message translates to:
  /// **'Meeting place'**
  String get activityLabelMeetingPlace;

  /// No description provided for @activityLabelStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get activityLabelStartTime;

  /// No description provided for @activityLabelEndTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get activityLabelEndTime;

  /// No description provided for @activityLabelParticipantLimit.
  ///
  /// In en, this message translates to:
  /// **'Participant limit (optional)'**
  String get activityLabelParticipantLimit;

  /// No description provided for @activityLabelTeamOptional.
  ///
  /// In en, this message translates to:
  /// **'Team (optional)'**
  String get activityLabelTeamOptional;

  /// No description provided for @activityNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming activities found.'**
  String get activityNoUpcoming;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @learningSummary.
  ///
  /// In en, this message translates to:
  /// **'Coaching insights and beginner resources.'**
  String get learningSummary;

  /// No description provided for @learningPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Learning resources and coach materials will be available here.'**
  String get learningPlaceholder;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @playConnectCompete.
  ///
  /// In en, this message translates to:
  /// **'Play. Connect. Compete.'**
  String get playConnectCompete;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Find training sessions, meet new teammates, and keep your baseball5 circle active.'**
  String get homeGreeting;

  /// No description provided for @homeFeaturedTitle.
  ///
  /// In en, this message translates to:
  /// **'This week on the field'**
  String get homeFeaturedTitle;

  /// No description provided for @homeFeaturedSummary.
  ///
  /// In en, this message translates to:
  /// **'Open play, local teams, and fresh community sessions are ready when you are.'**
  String get homeFeaturedSummary;

  /// No description provided for @openPlayCta.
  ///
  /// In en, this message translates to:
  /// **'Join open play'**
  String get openPlayCta;

  /// No description provided for @openPlaySummary.
  ///
  /// In en, this message translates to:
  /// **'See what is happening nearby and get involved.'**
  String get openPlaySummary;

  /// No description provided for @viewTeamsAction.
  ///
  /// In en, this message translates to:
  /// **'View teams'**
  String get viewTeamsAction;

  /// No description provided for @viewTeamsSummary.
  ///
  /// In en, this message translates to:
  /// **'Explore clubs, rosters, and team updates.'**
  String get viewTeamsSummary;

  /// No description provided for @browseLearningAction.
  ///
  /// In en, this message translates to:
  /// **'Browse learning'**
  String get browseLearningAction;

  /// No description provided for @browseLearningSummary.
  ///
  /// In en, this message translates to:
  /// **'Study drills, sessions, and beginner resources.'**
  String get browseLearningSummary;

  /// No description provided for @homeCommunitySummary.
  ///
  /// In en, this message translates to:
  /// **'Community highlights'**
  String get homeCommunitySummary;

  /// No description provided for @homeEmptyState.
  ///
  /// In en, this message translates to:
  /// **'There are no team or activity updates yet. Once the community starts sharing, they will appear here.'**
  String get homeEmptyState;

  /// No description provided for @appLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguageLabel;

  /// No description provided for @appLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language for the app interface.'**
  String get appLanguageDescription;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The requested page could not be found.'**
  String get pageNotFoundSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginAction;

  /// No description provided for @createAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountAction;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get registerTitle;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @backToLoginAction.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLoginAction;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameLabel;

  /// No description provided for @displayNameValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a display name with at least 2 characters.'**
  String get displayNameValidationMessage;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get emailValidationMessage;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 6 characters.'**
  String get passwordValidationMessage;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid.'**
  String get authInvalidEmail;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authUserDisabled;

  /// No description provided for @authUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account was found for this email.'**
  String get authUserNotFound;

  /// No description provided for @authWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is incorrect.'**
  String get authWrongPassword;

  /// No description provided for @authEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get authEmailAlreadyInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password.'**
  String get authWeakPassword;

  /// No description provided for @authGeneralError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authGeneralError;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Your profile is not available yet.'**
  String get profileEmptyState;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your profile'**
  String get profileLoadError;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @saveProfileAction.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfileAction;

  /// No description provided for @notAuthenticatedError.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in.'**
  String get notAuthenticatedError;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Profile could not be saved.'**
  String get profileSaveError;

  /// No description provided for @countryCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryCodeLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @experienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experienceLabel;

  /// No description provided for @bioLabel.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get bioLabel;

  /// No description provided for @countryCodeValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Country codes must be 2 letters, for example DE or US.'**
  String get countryCodeValidationMessage;

  /// No description provided for @bioValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'The bio must not exceed 300 characters.'**
  String get bioValidationMessage;

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
