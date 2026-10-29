// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Baseball5 Community';

  @override
  String get welcomeTitle => 'Willkommen bei der Baseball5 Community';

  @override
  String get welcomeSubtitle =>
      'Entdecke Teams, Aktivitäten und Lerninhalte an einem Ort.';

  @override
  String get quickAccess => 'Schnellzugriff';

  @override
  String get community => 'Community';

  @override
  String get communitySummary =>
      'Updates, Gespräche und lokale Baseball-Netzwerke.';

  @override
  String get communityPlaceholder =>
      'Community-Updates und Diskussionen kommen bald.';

  @override
  String get home => 'Startseite';

  @override
  String get discover => 'Entdecken';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notificationEmptyState => 'Du hast noch keine Benachrichtigungen.';

  @override
  String get teams => 'Teams';

  @override
  String get teamsSummary =>
      'Vereine, Mitgliedschaften und Teamplanung verwalten.';

  @override
  String get teamsPlaceholder =>
      'Teamseiten und Mitgliederverwaltung werden hier verfügbar sein.';

  @override
  String get teamsPageDescription =>
      'Entdecke bestehende Baseball5-Teams oder erstelle dein eigenes.';

  @override
  String get myTeamsSectionTitle => 'Meine Teams';

  @override
  String get myTeamsSignedOutMessage =>
      'Melde dich an, um deine Teams zu sehen und zu verwalten.';

  @override
  String get myTeamsEmptyState => 'Du hast noch keine Teams erstellt.';

  @override
  String get myTeamsLoadError => 'Deine Teams konnten nicht geladen werden.';

  @override
  String get myTeamsRetryAction => 'Erneut versuchen';

  @override
  String get teamOwnerBadge => 'Dein Team';

  @override
  String get createYourFirstTeamAction => 'Erstelle dein erstes Team';

  @override
  String get discoverTeamsSectionTitle => 'Teams entdecken';

  @override
  String get teamSearchHint => 'Teams suchen';

  @override
  String get cityFilterHint => 'Nach Stadt filtern';

  @override
  String get countryFilterHint => 'Nach Land filtern';

  @override
  String get teamEmptyState =>
      'Keine öffentlichen Teams passen zu deinen aktuellen Filtern.';

  @override
  String get teamLoadError => 'Teams konnten nicht geladen werden';

  @override
  String get teamRecruitingOpen => 'Aufnahme offen';

  @override
  String get teamRecruitingClosed => 'Zurzeit keine offenen Stellen';

  @override
  String get createTeamAction => 'Team erstellen';

  @override
  String get createTeamTitle => 'Team erstellen';

  @override
  String get editTeamTitle => 'Team bearbeiten';

  @override
  String get saveTeamAction => 'Änderungen speichern';

  @override
  String get teamEditAction => 'Team bearbeiten';

  @override
  String get teamDeleteAction => 'Team löschen';

  @override
  String get teamDeleteDialogTitle => 'Team löschen?';

  @override
  String teamDeleteDialogContent(Object teamName) {
    return 'Dadurch wird $teamName dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get teamDeleteConfirmAction => 'Löschen';

  @override
  String get teamDeleteCancelAction => 'Abbrechen';

  @override
  String get teamDeleteError =>
      'Das Team konnte nicht gelöscht werden. Bitte versuche es erneut.';

  @override
  String get teamUpdateError =>
      'Das Team konnte nicht aktualisiert werden. Bitte versuche es erneut.';

  @override
  String get teamUpdatePermissionError =>
      'Du kannst nur deine eigenen Teams bearbeiten.';

  @override
  String get teamUpdateNetworkError =>
      'Die Verbindung ist derzeit nicht verfügbar. Bitte versuche es erneut.';

  @override
  String teamUpdateSuccessMessage(Object teamName) {
    return '$teamName wurde erfolgreich aktualisiert.';
  }

  @override
  String get teamNotFoundError =>
      'Dieses Team wurde nicht gefunden oder ist nicht mehr verfügbar.';

  @override
  String get teamNameLabel => 'Teamname';

  @override
  String get teamNameValidationMessage =>
      'Bitte gib einen Teamnamen mit mindestens 2 Zeichen ein.';

  @override
  String get teamNameLengthMessage =>
      'Der Teamname darf 80 Zeichen nicht überschreiten.';

  @override
  String get teamDescriptionLabel => 'Beschreibung';

  @override
  String get teamDescriptionValidationMessage =>
      'Die Beschreibung darf 1000 Zeichen nicht überschreiten.';

  @override
  String get teamOrganizationTypeLabel => 'Organisationstyp';

  @override
  String get teamVisibilityLabel => 'Sichtbarkeit';

  @override
  String get teamVisibilityPublic => 'Öffentlich';

  @override
  String get teamVisibilityPrivate => 'Privat';

  @override
  String get teamRecruitingFieldLabel => 'Aufnahme offen';

  @override
  String teamCreateSuccessMessage(Object teamName) {
    return '$teamName wurde erfolgreich erstellt.';
  }

  @override
  String get teamCreateError =>
      'Das Team konnte nicht erstellt werden. Bitte versuche es erneut.';

  @override
  String get teamCreatePermissionError =>
      'Du musst angemeldet sein, um ein Team zu erstellen.';

  @override
  String get teamCreateNetworkError =>
      'Die Verbindung ist derzeit nicht verfügbar. Bitte versuche es erneut.';

  @override
  String get teamDetailTitle => 'Ausgewähltes Team';

  @override
  String get activities => 'Aktivitäten';

  @override
  String get activitiesSummary => 'Trainingseinheiten, Open Play und Events.';

  @override
  String get activitiesPlaceholder =>
      'Aktivitäten und Anmeldungen werden hier verfügbar sein.';

  @override
  String get createActivityAction => 'Aktivität erstellen';

  @override
  String get createActivityTitle => 'Aktivität erstellen';

  @override
  String get activityTypeTraining => 'Training';

  @override
  String get activityTypeOpenPlay => 'Open Play';

  @override
  String get activityTypeAll => 'Alle';

  @override
  String get activityLabelType => 'Typ';

  @override
  String get activityLabelVisibility => 'Sichtbarkeit';

  @override
  String get activityLabelCity => 'Stadt';

  @override
  String get activityLabelMeetingPlace => 'Treffpunkt';

  @override
  String get activityLabelStartTime => 'Startzeit';

  @override
  String get activityLabelEndTime => 'Endzeit';

  @override
  String get activityLabelParticipantLimit => 'Teilnehmerlimit (optional)';

  @override
  String get activityLabelTeamOptional => 'Team (optional)';

  @override
  String get activityNoUpcoming => 'Keine anstehenden Aktivitäten gefunden.';

  @override
  String get learning => 'Lernen';

  @override
  String get learningSummary => 'Coaching-Insights und Einstiegsressourcen.';

  @override
  String get learningPlaceholder =>
      'Lernmaterialien und Coach-Resources werden hier verfügbar sein.';

  @override
  String get back => 'Zurück';

  @override
  String get playConnectCompete => 'Play. Connect. Compete.';

  @override
  String get homeGreeting =>
      'Finde Trainingseinheiten, lerne neue Mitspieler kennen und halte dein Baseball5-Netzwerk aktiv.';

  @override
  String get homeFeaturedTitle => 'Diese Woche auf dem Feld';

  @override
  String get homeFeaturedSummary =>
      'Open Play, lokale Teams und neue Community-Sessions warten auf dich.';

  @override
  String get openPlayCta => 'Open Play beitreten';

  @override
  String get openPlaySummary =>
      'Sieh, was in deiner Nähe passiert und mach mit.';

  @override
  String get viewTeamsAction => 'Teams ansehen';

  @override
  String get viewTeamsSummary => 'Entdecke Vereine, Kader und Team-Updates.';

  @override
  String get browseLearningAction => 'Lernen entdecken';

  @override
  String get browseLearningSummary =>
      'Lerne Drills, Session-Formate und Grundlagen kennen.';

  @override
  String get homeCommunitySummary => 'Community-Highlights';

  @override
  String get homeEmptyState =>
      'Es gibt noch keine Team- oder Aktivitäts-Updates. Sobald die Community Inhalte teilt, erscheinen sie hier.';

  @override
  String get appLanguageLabel => 'App-Sprache';

  @override
  String get appLanguageDescription =>
      'Wähle deine bevorzugte Sprache für die App-Oberfläche.';

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get pageNotFoundSubtitle =>
      'Die angeforderte Seite konnte nicht gefunden werden.';

  @override
  String get loginTitle => 'Willkommen zurück';

  @override
  String get loginAction => 'Anmelden';

  @override
  String get createAccountAction => 'Konto erstellen';

  @override
  String get registerTitle => 'Dein Profil anlegen';

  @override
  String get registerAction => 'Registrieren';

  @override
  String get backToLoginAction => 'Zurück zur Anmeldung';

  @override
  String get displayNameLabel => 'Anzeigename';

  @override
  String get displayNameValidationMessage =>
      'Bitte gib einen Anzeigenamen mit mindestens 2 Zeichen ein.';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get emailValidationMessage => 'Bitte gib eine gültige E-Mail ein.';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordValidationMessage =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get loading => 'Lädt';

  @override
  String get authInvalidEmail => 'Die E-Mail-Adresse ist ungültig.';

  @override
  String get authUserDisabled => 'Dieses Konto wurde deaktiviert.';

  @override
  String get authUserNotFound => 'Für diese E-Mail wurde kein Konto gefunden.';

  @override
  String get authWrongPassword => 'Das Passwort ist falsch.';

  @override
  String get authEmailAlreadyInUse => 'Diese E-Mail ist bereits registriert.';

  @override
  String get authWeakPassword => 'Bitte wähle ein stärkeres Passwort.';

  @override
  String get authGeneralError =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEmptyState => 'Dein Profil ist noch nicht verfügbar.';

  @override
  String get profileLoadError => 'Profil konnte nicht geladen werden';

  @override
  String get editProfileTitle => 'Profil bearbeiten';

  @override
  String get saveProfileAction => 'Profil speichern';

  @override
  String get notAuthenticatedError => 'Du bist nicht angemeldet.';

  @override
  String get profileSaveError => 'Das Profil konnte nicht gespeichert werden.';

  @override
  String get countryCodeLabel => 'Land';

  @override
  String get cityLabel => 'Stadt';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get experienceLabel => 'Erfahrung';

  @override
  String get bioLabel => 'Über dich';

  @override
  String get countryCodeValidationMessage =>
      'Ländercodes müssen 2 Buchstaben lang sein, zum Beispiel DE oder US.';

  @override
  String get bioValidationMessage =>
      'Die Biografie darf 300 Zeichen nicht überschreiten.';

  @override
  String get logoutAction => 'Abmelden';
}
