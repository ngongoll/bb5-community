// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Baseball5 Community';

  @override
  String get welcomeTitle => 'Welcome to the Baseball5 Community';

  @override
  String get welcomeSubtitle =>
      'Discover teams, activities and learning resources in one place.';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get community => 'Community';

  @override
  String get communitySummary =>
      'Updates, conversations and local baseball networks.';

  @override
  String get communityPlaceholder =>
      'Community updates and conversations are on the way.';

  @override
  String get home => 'Home';

  @override
  String get discover => 'Discover';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationEmptyState => 'You do not have any notifications yet.';

  @override
  String get teams => 'Teams';

  @override
  String get teamsSummary => 'Manage clubs, memberships and team planning.';

  @override
  String get teamsPlaceholder =>
      'Team pages and membership management will be available here.';

  @override
  String get teamsPageDescription =>
      'Discover existing Baseball5 teams or create your own.';

  @override
  String get myTeamsSectionTitle => 'My teams';

  @override
  String get myTeamsSignedOutMessage =>
      'Sign in to view and manage your teams.';

  @override
  String get myTeamsEmptyState => 'You have not created any teams yet.';

  @override
  String get myTeamsLoadError => 'Unable to load your teams.';

  @override
  String get myTeamsRetryAction => 'Try again';

  @override
  String get teamOwnerBadge => 'Your team';

  @override
  String get createYourFirstTeamAction => 'Create your first team';

  @override
  String get discoverTeamsSectionTitle => 'Discover teams';

  @override
  String get teamSearchHint => 'Search teams';

  @override
  String get cityFilterHint => 'Filter by city';

  @override
  String get countryFilterHint => 'Filter by country';

  @override
  String get teamEmptyState => 'No public teams match your current filters.';

  @override
  String get teamLoadError => 'Unable to load teams';

  @override
  String get teamRecruitingOpen => 'Open to join';

  @override
  String get teamRecruitingClosed => 'Currently not recruiting';

  @override
  String get createTeamAction => 'Create team';

  @override
  String get createTeamTitle => 'Create team';

  @override
  String get editTeamTitle => 'Edit team';

  @override
  String get saveTeamAction => 'Save changes';

  @override
  String get teamEditAction => 'Edit team';

  @override
  String get teamDeleteAction => 'Delete team';

  @override
  String get teamDeleteDialogTitle => 'Delete team?';

  @override
  String teamDeleteDialogContent(Object teamName) {
    return 'This will permanently delete $teamName. This action cannot be undone.';
  }

  @override
  String get teamDeleteConfirmAction => 'Delete';

  @override
  String get teamDeleteCancelAction => 'Cancel';

  @override
  String get teamDeleteError =>
      'The team could not be deleted. Please try again.';

  @override
  String get teamUpdateError =>
      'The team could not be updated. Please try again.';

  @override
  String get teamUpdatePermissionError => 'You can only edit your own team.';

  @override
  String get teamUpdateNetworkError =>
      'The connection is unavailable. Please try again.';

  @override
  String teamUpdateSuccessMessage(Object teamName) {
    return '$teamName was updated successfully.';
  }

  @override
  String get teamNotFoundError =>
      'This team could not be found or is no longer available.';

  @override
  String get teamNameLabel => 'Team name';

  @override
  String get teamNameValidationMessage =>
      'Please enter a team name with at least 2 characters.';

  @override
  String get teamNameLengthMessage =>
      'Team name must not exceed 80 characters.';

  @override
  String get teamDescriptionLabel => 'Description';

  @override
  String get teamDescriptionValidationMessage =>
      'Description must not exceed 1000 characters.';

  @override
  String get teamOrganizationTypeLabel => 'Organization type';

  @override
  String get teamVisibilityLabel => 'Visibility';

  @override
  String get teamVisibilityPublic => 'Public';

  @override
  String get teamVisibilityPrivate => 'Private';

  @override
  String get teamRecruitingFieldLabel => 'Recruiting enabled';

  @override
  String teamCreateSuccessMessage(Object teamName) {
    return '$teamName was created successfully.';
  }

  @override
  String get teamCreateError =>
      'The team could not be created. Please try again.';

  @override
  String get teamCreatePermissionError =>
      'You need to be signed in to create a team.';

  @override
  String get teamCreateNetworkError =>
      'The connection is unavailable. Please try again.';

  @override
  String get teamDetailTitle => 'Selected team';

  @override
  String get activities => 'Activities';

  @override
  String get activitiesSummary => 'Training sessions, open play and events.';

  @override
  String get activitiesPlaceholder =>
      'Activities and event registration will be available here.';

  @override
  String get learning => 'Learning';

  @override
  String get learningSummary => 'Coaching insights and beginner resources.';

  @override
  String get learningPlaceholder =>
      'Learning resources and coach materials will be available here.';

  @override
  String get back => 'Back';

  @override
  String get playConnectCompete => 'Play. Connect. Compete.';

  @override
  String get homeGreeting =>
      'Find training sessions, meet new teammates, and keep your baseball5 circle active.';

  @override
  String get homeFeaturedTitle => 'This week on the field';

  @override
  String get homeFeaturedSummary =>
      'Open play, local teams, and fresh community sessions are ready when you are.';

  @override
  String get openPlayCta => 'Join open play';

  @override
  String get openPlaySummary =>
      'See what is happening nearby and get involved.';

  @override
  String get viewTeamsAction => 'View teams';

  @override
  String get viewTeamsSummary => 'Explore clubs, rosters, and team updates.';

  @override
  String get browseLearningAction => 'Browse learning';

  @override
  String get browseLearningSummary =>
      'Study drills, sessions, and beginner resources.';

  @override
  String get homeCommunitySummary => 'Community highlights';

  @override
  String get homeEmptyState =>
      'There are no team or activity updates yet. Once the community starts sharing, they will appear here.';

  @override
  String get appLanguageLabel => 'App language';

  @override
  String get appLanguageDescription =>
      'Choose your preferred language for the app interface.';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get pageNotFoundSubtitle => 'The requested page could not be found.';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginAction => 'Log in';

  @override
  String get createAccountAction => 'Create an account';

  @override
  String get registerTitle => 'Create your profile';

  @override
  String get registerAction => 'Register';

  @override
  String get backToLoginAction => 'Back to login';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get displayNameValidationMessage =>
      'Please enter a display name with at least 2 characters.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailValidationMessage => 'Please enter a valid email address.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordValidationMessage =>
      'Password must contain at least 6 characters.';

  @override
  String get loading => 'Loading';

  @override
  String get authInvalidEmail => 'The email address is invalid.';

  @override
  String get authUserDisabled => 'This account has been disabled.';

  @override
  String get authUserNotFound => 'No account was found for this email.';

  @override
  String get authWrongPassword => 'The password is incorrect.';

  @override
  String get authEmailAlreadyInUse => 'This email is already registered.';

  @override
  String get authWeakPassword => 'Please choose a stronger password.';

  @override
  String get authGeneralError => 'Something went wrong. Please try again.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEmptyState => 'Your profile is not available yet.';

  @override
  String get profileLoadError => 'Unable to load your profile';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get saveProfileAction => 'Save profile';

  @override
  String get notAuthenticatedError => 'You are not logged in.';

  @override
  String get profileSaveError => 'Profile could not be saved.';

  @override
  String get countryCodeLabel => 'Country';

  @override
  String get cityLabel => 'City';

  @override
  String get languageLabel => 'Language';

  @override
  String get experienceLabel => 'Experience';

  @override
  String get bioLabel => 'About you';

  @override
  String get countryCodeValidationMessage =>
      'Country codes must be 2 letters, for example DE or US.';

  @override
  String get bioValidationMessage => 'The bio must not exceed 300 characters.';

  @override
  String get logoutAction => 'Log out';
}
