import 'package:flutter/material.dart';

/// Centralized strings repository for the VetNow application.
///
/// Provides both static and localized access to all app strings.
/// Supports multi-language translation (e.g., English, Hindi).
///
/// Usage:
/// - Static: `AppStrings.appName` or `AppStrings.bookAppointment`
/// - Context-aware (reactive): `AppStrings.of(context).bookAppointment`
/// - Or via extension: `context.strings.bookAppointment`
class AppStrings {
  /// Active language code for static fallback ('en', 'hi', etc.)
  static String currentLanguage = 'en';

  /// Helper to get localized instance from context
  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppStrings(locale.languageCode);
  }

  /// Instance language code
  final String languageCode;

  AppStrings([this.languageCode = 'en']);

  /// Resolves string for the current language code, falling back to English
  String _t(String en, String hi) {
    if (languageCode == 'hi' || currentLanguage == 'hi') {
      return hi;
    }
    return en;
  }

  // ===========================================================================
  // 1. APP & GENERAL ACTIONS
  // ===========================================================================
  String get appName => _t("VetNow", "VetNow");
  String get appTagline => _t(
    "Your pet’s health companion to make your pet healthy and happy",
    "आपके पालतू जानवर का स्वास्थ्य साथी - उन्हें स्वस्थ और खुशहाल रखने के लिए",
  );
  String get appVersion => _t("Version 1.0.0", "संस्करण 1.0.0");
  String get poweredBy => _t("Powered by VetNow", "VetNow द्वारा संचालित");

  String get close => _t("Close", "बंद करें");
  String get cancel => _t("Cancel", "रद्द करें");
  String get ok => _t("OK", "ठीक है");
  String get save => _t("Save", "सहेजें");
  String get submit => _t("Submit", "जमा करें");
  String get continueText => _t("Continue", "आगे बढ़ें");
  String get finish => _t("Finish", "समाप्त");
  String get next => _t("Next", "अगला");
  String get back => _t("Back", "वापस");
  String get skip => _t("Skip", "छोड़ें");
  String get done => _t("Done", "हो गया");
  String get edit => _t("Edit", "संपादित करें");
  String get delete => _t("Delete", "हटाएं");
  String get retry => _t("Retry", "पुनः प्रयास करें");
  String get tryAgain => _t("Try Again", "फिर से प्रयास करें");
  String get search => _t("Search", "खोजें");
  String get yes => _t("Yes", "हाँ");
  String get no => _t("No", "नहीं");
  String get confirm => _t("Confirm", "पुष्टि करें");
  String get viewAll => _t("View All", "सभी देखें");
  String get loading => _t("Loading...", "लोड हो रहा है...");
  String get error => _t("Error", "त्रुटि");
  String get success => _t("Success", "सफलता");
  String get warning => _t("Warning", "चेतावनी");
  String get optional => _t("Optional", "वैकल्पिक");
  String get required => _t("Required", "आवश्यक");

  // Static shortcuts for general actions
  static String get sClose => AppStrings(currentLanguage).close;
  static String get sCancel => AppStrings(currentLanguage).cancel;
  static String get sOk => AppStrings(currentLanguage).ok;
  static String get sSave => AppStrings(currentLanguage).save;
  static String get sContinue => AppStrings(currentLanguage).continueText;
  static String get sFinish => AppStrings(currentLanguage).finish;
  static String get sSkip => AppStrings(currentLanguage).skip;

  // ===========================================================================
  // 2. ONBOARDING & SPLASH
  // ===========================================================================
  String get onboardingTitle1 => _t("Happy pets.\nHappy you.", "खुशहाल पालतू जानवर।\nखुशहाल आप।");
  String get onboardingDesc1 => _t(
    "Stay on top of your pet’s health with reminders, care tips, and easy access to vet support.",
    "रिमाइंडर, देखभाल सुझाव और पशु चिकित्सक सहायता के साथ अपने पालतू जानवर के स्वास्थ्य का ध्यान रखें।",
  );

  String get onboardingTitle2 => _t("Everything in\none place", "सब कुछ\nएक ही स्थान पर");
  String get onboardingDesc2 => _t(
    "Store vaccination records, medical files, and daily health logs. All securely organized.",
    "टीकाकरण रिकॉर्ड, मेडिकल फ़ाइलें और दैनिक स्वास्थ्य लॉग स्टोर करें। सब सुरक्षित रूप से व्यवस्थित।",
  );

  String get onboardingTitle3 => _t("Care when it\nmatters", "देखभाल जब\nज़रूरत हो");
  String get onboardingDesc3 => _t(
    "Book appointments, track symptoms, and reach help on time. Because they rely on you.",
    "अपॉइंटमेंट बुक करें, लक्षणों को ट्रैक करें और समय पर मदद पाएं। क्योंकि वे आप पर निर्भर हैं।",
  );

  String get getStarted => _t("Get Started", "शुरू करें");

  // ===========================================================================
  // 3. AUTHENTICATION & OTP
  // ===========================================================================
  String get welcomeToVetNow => _t("Welcome to VetNow", "VetNow में आपका स्वागत है");
  String get signInSubtitle => _t(
    "Your pet’s health companion to make your pet healthy and happy",
    "आपके पालतू जानवर का स्वास्थ्य साथी - उन्हें स्वस्थ और खुशहाल रखने के लिए",
  );
  String get phoneNumberLabel => _t("Phone Number", "फ़ोन नंबर");
  String get enterPhoneNumberHint => _t("Enter your phone number", "अपना फ़ोन नंबर दर्ज करें");
  String get termsByContinuing => _t("By continuing, you agree to VetNow ", "आगे बढ़कर, आप VetNow की ");
  String get termsAndConditions => _t("Terms and Conditions", "सेवा की शर्तों");
  String get andSymbol => _t(" & ", " और ");
  String get sendingOtp => _t("Sending OTP...", "ओटीपी भेजा जा रहा है...");
  String get getOtpOnWhatsApp => _t("Get OTP on WhatsApp", "व्हाट्सएप पर ओटीपी प्राप्त करें");

  String get enterMobileNumber => _t("Enter Mobile Number", "मोबाइल नंबर दर्ज करें");
  String get mobileNumberHint => _t("Mobile number", "मोबाइल नंबर");
  String get sendOtp => _t("Send OTP", "ओटीपी भेजें");
  String get termsConsentPrefix => _t("By clicking, I accept the ", "आगे बढ़कर, मैं स्वीकार करता/करती हूँ ");
  String get termsOfService => _t("Terms of Service", "सेवा की शर्तें");
  String get and => _t(" and ", " और ");
  String get privacyPolicy => _t("Privacy Policy", "गोपनीयता नीति");
  String get selectCountry => _t("Select Country", "देश चुनें");
  String get searchCountry => _t("Search country...", "देश खोजें...");
  String get invalidPhoneNumber => _t("Please enter a valid phone number", "कृपया एक मान्य फ़ोन नंबर दर्ज करें");

  String get enterTheOtp => _t("Enter the OTP", "ओटीपी दर्ज करें");
  String get weSentVerificationCode => _t(
    "we sent a verification code on your number\n",
    "हमने आपके नंबर पर एक सत्यापन कोड भेजा है\n",
  );
  String get didNotGetOtp => _t("Did not get the OTP? ", "ओटीपी नहीं मिला? ");
  String get verifying => _t("Verifying...", "सत्यापित किया जा रहा है...");
  String get verify => _t("Verify", "सत्यापित करें");

  String get verifyOtp => _t("Verify OTP", "ओटीपी सत्यापित करें");
  String get otpSentTo => _t("We've sent a 6-digit verification code to", "हमने 6-अंकीय सत्यापन कोड भेजा है:");
  String get enterOtp => _t("Enter the code sent to your phone", "अपने फ़ोन पर भेजा गया कोड दर्ज करें");
  String get resendOtp => _t("Resend", "पुनः भेजें");
  String get resendIn => _t("Resend in", "पुनः भेजें:");
  String get verifyAndProceed => _t("Verify & Proceed", "सत्यापित करें और आगे बढ़ें");
  String get invalidOtp => _t("Invalid OTP. Please check and try again.", "अमान्य ओटीपी। कृपया जांचें और पुनः प्रयास करें।");

  // ===========================================================================
  // 4. MEDICAL CONSENT & LEGAL
  // ===========================================================================
  String get medicalConsent => _t("Medical Consent", "चिकित्सा सहमति");
  String get telehealthConsentTitle => _t("Telehealth & Medical Consent", "टेलीहेल्थ और चिकित्सा सहमति");
  String get telehealthConsentSubtitle => _t(
    "Please review and accept our medical consultation terms before proceeding.",
    "कृपया आगे बढ़ने से पहले हमारी चिकित्सा परामर्श शर्तों की समीक्षा करें और स्वीकार करें।",
  );
  String get consentAgreement => _t(
    "I have read, understood, and accept the Telehealth Consent & Terms.",
    "मैंने टेलीहेल्थ सहमति और शर्तों को पढ़, समझ और स्वीकार कर लिया है।",
  );
  String get acceptAndContinue => _t("Accept & Continue", "स्वीकार करें और जारी रखें");
  String get emergencyDisclaimer => _t(
    "VetNow is NOT an emergency service. For life-threatening emergencies, visit your nearest emergency clinic immediately.",
    "VetNow आपातकालीन सेवा नहीं है। जीवन के लिए गंभीर स्थितियों में तुरंत निकटतम पशु चिकित्सालय जाएं।",
  );

  String get telehealthNoticeTitle => _t("Veterinary Telehealth Notice", "पशु चिकित्सा टेलीहेल्थ सूचना");
  String get telehealthNoticeSubtitle => _t(
    "Please review and agree to our medical terms before setting up your pet profile.",
    "कृपया अपने पालतू जानवर की प्रोफ़ाइल सेट करने से पहले हमारी चिकित्सा शर्तों की समीक्षा करें और सहमत हों।",
  );
  String get emergencyDisclaimerTitle => _t("1. Emergency Medical Disclaimer", "1. आपातकालीन चिकित्सा अस्वीकरण");
  String get emergencyDisclaimerText => _t(
    "VetNow is a virtual telemedicine service. In life-threatening emergencies (such as acute trauma, severe bleeding, breathing distress, or poisoning), do not wait for virtual consultation. Transport your pet to the nearest emergency veterinary clinic immediately.",
    "VetNow एक वर्चुअल टेलीमेडिसिन सेवा है। जीवन के लिए गंभीर आपात स्थितियों में (जैसे तीव्र आघात, गंभीर रक्तस्राव, सांस लेने में तकलीफ, या ज़हर), वर्चुअल परामर्श का इंतजार न करें। तुरंत अपने पालतू जानवर को निकटतम आपातकालीन पशु चिकित्सालय ले जाएं।",
  );
  String get virtualCareScopeTitle => _t("2. Scope of Virtual Care", "2. वर्चुअल देखभाल का दायरा");
  String get virtualCareScopeText => _t(
    "Virtual consultations provide remote triage, clinical advice, and wellness guidance based on visual observations and information you provide. Remote care does not replace physical palpation, emergency surgery, or in-clinic diagnostic laboratory tests.",
    "वर्चुअल परामर्श दृश्य अवलोकनों और आपके द्वारा प्रदान की गई जानकारी के आधार पर दूरस्थ नैदानिक सलाह और स्वास्थ्य मार्गदर्शन प्रदान करते हैं। दूरस्थ देखभाल शारीरिक परीक्षा, आपातकालीन सर्जरी या क्लिनिक में प्रयोगशाला परीक्षणों का स्थान नहीं लेती है।",
  );
  String get recordsPrivacyTitle => _t("3. Health Records & Data Sharing", "3. स्वास्थ्य रिकॉर्ड और डेटा साझाकरण");
  String get recordsPrivacyText => _t(
    "You consent to store your pet's medical profile, vaccination records, symptom history, and uploaded photos securely on VetNow, and authorize sharing this data with treating veterinarians for medical evaluations.",
    "आप अपने पालतू जानवर के मेडिकल प्रोफ़ाइल, टीकाकरण रिकॉर्ड, लक्षण इतिहास और अपलोड की गई फ़ोटो को VetNow पर सुरक्षित रूप से संग्रहीत करने के लिए सहमति देते हैं, और चिकित्सा मूल्यांकन के लिए पशु चिकित्सकों के साथ इस डेटा को साझा करने के लिए अधिकृत करते हैं।",
  );
  String get prescriptionsTitle => _t("4. Prescriptions & Clinical Discretion", "4. नुस्खे और नैदानिक विवेक");
  String get prescriptionsText => _t(
    "Any prescriptions, dosage recommendations, or treatment plans are provided at the licensed veterinarian's sole clinical discretion in compliance with governing veterinary medicine regulations.",
    "कोई भी नुस्खे, खुराक की सिफारिशें या उपचार योजनाएं लागू पशु चिकित्सा नियमों के अनुपालन में लाइसेंस प्राप्त पशु चिकित्सक के विवेक पर प्रदान की जाती हैं।",
  );
  String get fullLegalDocuments => _t("Full Legal Documents", "पूर्ण कानूनी दस्तावेज़");
  String get telehealthPolicyLink => _t("Telehealth Policy", "टेलीहेल्थ नीति");
  String get consentCheckboxText => _t(
    "I have read, understood, and agree to the Medical Consent, Telehealth Policy, and Emergency Notice.",
    "मैंने चिकित्सा सहमति, टेलीहेल्थ नीति और आपातकालीन सूचना को पढ़, समझ और स्वीकार कर लिया है।",
  );
  String get iAgreeAndContinue => _t("I Agree & Continue", "मैं सहमत हूँ और जारी रखें");

  // ===========================================================================
  // 5. USER PROFILE
  // ===========================================================================
  String get createYourProfile => _t("Create Your Profile", "अपनी प्रोफ़ाइल बनाएं");
  String get createProfileSubtitle => _t(
    "Your details help us personalize care for your pets.",
    "आपके विवरण आपके पालतू जानवरों की व्यक्तिगत देखभाल में मदद करते हैं।",
  );
  String get enterYourFirstName => _t("Enter your first name", "अपना पहला नाम दर्ज करें");
  String get enterYourLastName => _t("Enter your last name", "अपना अंतिम नाम दर्ज करें");
  String get enterYourEmailAddress => _t("Enter your email address", "अपना ईमेल पता दर्ज करें");
  String get tapToSearchLocation => _t("Tap to search your location", "अपना स्थान खोजने के लिए टैप करें");
  String get invalidEmail => _t("Invalid email", "अमान्य ईमेल");
  String get pleaseEnterValidDetails => _t("Please enter valid details", "कृपया सही विवरण दर्ज करें");
  String get editProfile => _t("Edit Profile", "प्रोफ़ाइल संपादित करें");
  String get firstName => _t("First Name", "पहला नाम");
  String get enterFirstName => _t("Enter first name", "पहला नाम दर्ज करें");
  String get lastName => _t("Last Name", "अंतिम नाम");
  String get enterLastName => _t("Enter last name", "अंतिम नाम दर्ज करें");
  String get email => _t("Email Address", "ईमेल पता");
  String get enterEmail => _t("Enter email address", "ईमेल पता दर्ज करें");
  String get address => _t("Address", "पता");
  String get enterAddress => _t("Enter address", "पता दर्ज करें");
  String get searchAddress => _t("Search address", "पता खोजें");
  String get city => _t("City", "शहर");
  String get state => _t("State", "राज्य");
  String get country => _t("Country", "देश");
  String get pincode => _t("Pincode", "पिनकोड");
  String get profileUpdatedSuccess => _t("Profile updated successfully", "प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई");

  // ===========================================================================
  // 6. HOME & DASHBOARD
  // ===========================================================================
  String get goodMorning => _t("Good Morning", "सुप्रभात");
  String get goodAfternoon => _t("Good Afternoon", "शुभ दोपहर");
  String get goodEvening => _t("Good Evening", "शुभ संध्या");
  String helloUser(String name) => _t("Hello, $name", "नमस्ते, $name");
  String get friend => _t("Friend", "मित्र");
  String get howAreYourPetsToday => _t(
    "How are your pets today?",
    "आज आपके पालतू जानवर कैसे हैं?",
  );
  String get quickActions => _t("Quick Actions", "त्वरित क्रियाएँ");
  String get bookConsultation => _t("Book Consultation", "परामर्श बुक करें");
  String get symptomAssessment => _t("Symptom Checker", "लक्षण जांच");
  String get findClinics => _t("Find Clinics", "क्लिनिक खोजें");
  String get upcomingAppointments => _t("Upcoming Appointments", "आगामी अपॉइंटमेंट्स");
  String get noUpcomingAppointments => _t("No Upcoming Appointments", "कोई आगामी अपॉइंटमेंट नहीं");
  String get medicalRecords => _t("Medical Records", "मेडिकल रिकॉर्ड्स");
  String get healthTimeline => _t("Health Timeline", "स्वास्थ्य समयरेखा");
  String get recentActivity => _t("Recent Activity", "हाल की गतिविधि");
  String get noPetsRegistered => _t("No Pets Registered Yet", "अभी तक कोई पालतू जानवर पंजीकृत नहीं है");
  String get noPetsRegisteredDesc => _t(
    "Add your first pet to start tracking their health and booking appointments.",
    "स्वास्थ्य पर नज़र रखने और अपॉइंटमेंट बुक करने के लिए अपना पहला पालतू जानवर जोड़ें।",
  );
  String get addPet => _t("Add Pet", "पालतू जानवर जोड़ें");
  String get yourPets => _t("Your Pets", "आपके पालतू जानवर");
  String get viewPetProfile => _t("View Profile", "प्रोफ़ाइल देखें");
  String get incompleteProfileBanner => _t(
    "Profile Incomplete - Tap to complete",
    "प्रोफ़ाइल अधूरी है - पूरा करने के लिए टैप करें",
  );
  String get unnamedPet => _t("Unnamed", "बिना नाम");
  String ageMonthsFormat(int months) => _t("$months m", "$months माह");
  String get maleShort => _t("MALE", "नर");
  String get femaleShort => _t("FEMALE", "मादा");
  String get profileIncompleteTapToFinish => _t(
    "Profile incomplete. Tap to finish.",
    "प्रोफ़ाइल अधूरी है। पूरा करने के लिए टैप करें।",
  );
  String get weightLabel => _t("Weight", "वजन");
  String get colorLabel => _t("Color", "रंग");
  String get vaccinesLabel => _t("Vaccines", "टीके");
  String get kgUnit => _t("kg", "किग्रा");

  String get consultAction => _t("Consult", "परामर्श");
  String get petsAction => _t("Pets", "पालतू जानवर");
  String get myDoctorAction => _t("My Doctor", "मेरे डॉक्टर");
  String get recordsAction => _t("Records", "रिकॉर्ड्स");

  String get scheduleVisitWithVet => _t(
    "Schedule a visit with a vet to get started.",
    "शुरू करने के लिए किसी पशु चिकित्सक के साथ परामर्श तय करें।",
  );
  String get petFallback => _t("Pet", "पालतू जानवर");

  String get statusReadyToConnect => _t("READY TO CONNECT", "जुड़ने के लिए तैयार");
  String get statusInProgress => _t("IN PROGRESS", "प्रगति में");

  String get documentFallback => _t("Document", "दस्तावेज़");
  String get reportFallback => _t("Report", "रिपोर्ट");

  String get todaysActivities => _t("Today's Activities", "आज की गतिविधियां");
  String get noTasksForToday => _t("No tasks for today", "आज के लिए कोई कार्य नहीं");
  String appointmentWith(String doctorName) => _t(
    "Appointment with $doctorName",
    "$doctorName के साथ अपॉइंटमेंट",
  );
  String todayAt(String time) => _t("Today at $time", "आज $time बजे");

  String get footerBranding => _t(
    "VetNow: Professional Pet Care",
    "VetNow: पेशेवर पालतू देखभाल",
  );

  String get homeTab => _t("Home", "होम");
  String get bookingsTab => _t("Bookings", "बुकिंग्स");
  String get pressAgainToExit => _t(
    "Press again to exit VetNow",
    "बाहर निकलने के लिए फिर से दबाएं",
  );
  String get registerNewPet => _t("Register New Pet", "नया पालतू जानवर जोड़ें");
  String get registerNewPetSub => _t(
    "Add a digital passport for your pet",
    "अपने पालतू जानवर का डिजिटल पासपोर्ट जोड़ें",
  );
  String get assess => _t("Assess", "जांचें");

  // ===========================================================================
  // 7. PET REGISTRATION WIZARD & PET PROFILE
  // ===========================================================================
  String get myPetFamily => _t("My Pet Family", "मेरे पालतू जानवर");
  String registeredPetsCount(int count) => _t(
    "You have $count pets registered",
    "आपके पास $count पालतू जानवर पंजीकृत हैं",
  );
  String petIdTag(String id) => _t("ID: $id", "आईडी: $id");
  String get noPetsFound => _t("No Pets Found", "कोई पालतू जानवर नहीं मिला");
  String get noPetsFoundDesc => _t(
    "Your pet family is empty. Add your first pet to start tracking their health and records.",
    "आपका पेट परिवार खाली है। उनके स्वास्थ्य और रिकॉर्ड का ध्यान रखने के लिए अपना पहला पालतू जानवर जोड़ें।",
  );
  String get addNewPet => _t("Add New Pet", "नया पालतू जानवर जोड़ें");

  String get unknownBreed => _t("Unknown Breed", "अज्ञात नस्ल");
  String ageInMonthsValue(int months) => _t("$months Months", "$months महीने");
  String get uniquePetId => _t("UNIQUE PET ID", "यूनिक पेट आईडी");
  String get notAssigned => _t("Not Assigned", "आवंटित नहीं");
  String get latestHealthStatus => _t("Latest Health Status", "नवीनतम स्वास्थ्य स्थिति");
  String scoreLabel(int score) => _t("Score: $score", "स्कोर: $score");
  String assessedOnDate(String date) => _t("Assessed on: $date", "मूल्यांकन तिथि: $date");
  String get medicalDetails => _t("Medical Details", "चिकित्सा विवरण");
  String get noVaccinationRecords => _t("No vaccination records found.", "कोई टीकाकरण रिकॉर्ड नहीं मिला।");
  String get editPetProfileButton => _t("Edit Pet Profile", "पालतू जानवर की प्रोफ़ाइल संपादित करें");

  String get birthday => _t("Birthday", "जन्मदिन");
  String get enterPetBirthday => _t("Enter pet birthday", "जन्मदिन दर्ज करें");
  String get enterAge => _t("Enter age", "आयु दर्ज करें");
  String get isAnimalPregnant => _t("Is the animal pregnant?", "क्या पशु गर्भवती है?");
  String get neuteredCastrated => _t("Neutered (Castrated)", "नसबंदी (Neutered)");
  String get spayedSterilized => _t("Spayed (Sterilized)", "नसबंदी (Spayed)");
  String get yesShort => _t("YES", "हाँ");
  String get noShort => _t("NO", "नहीं");
  String get medicalDetailsSubtitle => _t(
    "Add vaccination history and health documents for your pet.",
    "अपने पालतू जानवर का टीकाकरण इतिहास और स्वास्थ्य दस्तावेज़ जोड़ें।",
  );
  String get vaccineAdministered => _t("Vaccine Administered", "लगाया गया टीका");
  String get selectVaccine => _t("Select vaccine", "टीका चुनें");

  String get newPet => _t("New Pet", "नया पालतू जानवर");
  String get editPetProfile => _t("Edit Profile", "प्रोफ़ाइल संपादित करें");
  String get basicDetails => _t("Basic Details", "बुनियादी विवरण");
  String get basicDetailsSubtitle => _t(
    "Provide basic information about your pet",
    "अपने पालतू जानवर के बारे में बुनियादी जानकारी प्रदान करें",
  );
  String get physicalDetails => _t("Physical Details", "शारीरिक विवरण");
  String get physicalDetailsSubtitle => _t(
    "Add physical measurements and any special notes about your pet.",
    "शारीरिक माप और अपने पालतू जानवर के बारे में कोई विशेष विवरण जोड़ें।",
  );
  String get physicalDetailsTip => _t(
    "These details help vets provide better care and track your pet's health over time.",
    "ये विवरण पशु चिकित्सकों को बेहतर देखभाल प्रदान करने और समय के साथ स्वास्थ्य पर नज़र रखने में मदद करते हैं।",
  );
  String get petName => _t("Pet Name", "पालतू जानवर का नाम");
  String get enterPetName => _t("Enter pet name", "पालतू जानवर का नाम दर्ज करें");
  String get species => _t("Species", "प्रजाति");
  String get selectSpecies => _t("Select Species", "प्रजाति चुनें");
  String get breed => _t("Breed", "नस्ल");
  String get selectBreed => _t("Select Breed", "नस्ल चुनें");
  String get gender => _t("Gender", "लिंग");
  String get male => _t("MALE", "नर (MALE)");
  String get female => _t("FEMALE", "मादा (FEMALE)");
  String get age => _t("Age", "आयु");
  String get ageInMonths => _t("Age (in months)", "आयु (महीनों में)");
  String get enterAgeInMonths => _t("Enter age in months", "महीनों में आयु दर्ज करें");
  String get weightKg => _t("Weight (kg)", "वजन (किग्रा)");
  String get enterWeight => _t("Enter pet weight", "पालतू जानवर का वजन दर्ज करें");
  String get color => _t("Color", "रंग");
  String get enterColor => _t("Enter color", "रंग दर्ज करें");
  String get spayedOrNeutered => _t("Spayed / Neutered", "नसबंदी (Spayed/Neutered)");
  String get isSpayed => _t("Spayed", "नसबंदी (Spayed)");
  String get isNeutered => _t("Neutered", "नसबंदी (Neutered)");
  String get milkingStatus => _t("Milking Status", "दूध देने की स्थिति");
  String get pregnancyStatus => _t("Pregnancy Status", "गर्भावस्था की स्थिति");
  String get microchipNumber => _t("Microchip Number (Optional)", "माइक्रोचिप नंबर (वैकल्पिक)");
  String get enterMicrochipNumber => _t("Enter microchip number", "माइक्रोचिप नंबर दर्ज करें");
  String get medicalRecordsOptional => _t("Medical Records (*Optional)", "मेडिकल रिकॉर्ड्स (*वैकल्पिक)");
  String get uploadFiles => _t("🗂️ Upload files", "🗂️ फ़ाइलें अपलोड करें");
  String get wasVaccineGiven => _t("Was this vaccine given?", "क्या यह टीका लगाया गया था?");
  String get vaccinatedOnOptional => _t("Vaccinated on (Optional)", "टीकाकरण की तिथि (वैकल्पिक)");
  String get enterVaccinationDate => _t("Enter vaccination date", "टीकाकरण तिथि दर्ज करें");
  String get vaccinationDateHint => _t(
    "You can skip this if you don't remember the exact date.",
    "यदि आपको सटीक तारीख याद नहीं है तो आप इसे छोड़ सकते हैं।",
  );

  String get petProfileSuccessTitle => _t("Pet Added Successfully!", "पालतू जानवर सफलतापूर्वक जुड़ गया!");
  String get petProfileSuccessSubtitle => _t(
    "Your pet profile is ready. You can now book appointments and track their health.",
    "आपके पालतू जानवर की प्रोफ़ाइल तैयार है। अब आप अपॉइंटमेंट बुक कर सकते हैं और उनके स्वास्थ्य की निगरानी कर सकते हैं।",
  );
  String get addAnotherPet => _t("Add Another Pet", "एक और पालतू जानवर जोड़ें");
  String get goToDashboard => _t("Go to Dashboard", "डैशबोर्ड पर जाएं");

  // USER PROFILE EDITS
  String get personalInformation => _t("Personal Information", "व्यक्तिगत जानकारी");
  String get locationDetails => _t("Location Details", "स्थान विवरण");
  String get locationAddress => _t("Location / Address", "स्थान / पता");
  String get searchCityHint => _t("Search your city...", "अपना शहर खोजें...");
  String get saveChanges => _t("Save Changes", "परिवर्तन सहेजें");

  // ===========================================================================
  // 8. DOCTOR & CLINIC
  // ===========================================================================
  String get myDoctor => _t("My Doctor", "मेरे पशु चिकित्सक");
  String get meetYourVeterinarian => _t("Meet Your Veterinarian", "अपने पशु चिकित्सक से मिलें");
  String get veterinarianSpecialist => _t("Veterinarian Specialist", "पशु चिकित्सा विशेषज्ञ");
  String get experience => _t("Experience", "अनुभव");
  String get yearsExperience => _t("years", "वर्ष");
  String get aboutDoctor => _t("About Doctor", "डॉक्टर के बारे में");
  String get doctorAvailability => _t("Doctor Availability", "डॉक्टर की उपलब्धता");
  String get fee => _t("Fee", "शुल्क");

  String get workingHours => _t("Working Hours", "कार्य समय");
  String get slotsAvailable => _t("Slots Available", "उपलब्ध स्लॉट");
  String get morning => _t("Morning", "सुबह");
  String get afternoon => _t("Afternoon", "दोपहर");
  String get evening => _t("Evening", "शाम");
  String get specializations => _t("Specializations", "विशेषज्ञता");
  String get specGeneralMedicine => _t("General Medicine", "सामान्य चिकित्सा");
  String get specSurgery => _t("Surgery", "सर्जरी");
  String get specPreventiveCare => _t("Preventive Care", "निवारक देखभाल");
  String get specEmergencyCare => _t("Emergency Care", "आपातकालीन देखभाल");
  String get about => _t("About", "के बारे में");
  String aboutDoctorBio(String docName) => _t(
    "$docName is a compassionate veterinarian with over a decade of experience in treating small animals. She specializes in preventive care and emergency surgeries.",
    "$docName छोटे जानवरों के इलाज में एक दशक से अधिक के अनुभव के साथ एक दयालु पशु चिकित्सक हैं। वे निवारक देखभाल और आपातकालीन सर्जरी में विशेषज्ञता रखते हैं।",
  );

  // ===========================================================================
  // 9. APPOINTMENTS & BOOKING
  // ===========================================================================
  String get appointments => _t("Appointments", "अपॉइंटमेंट्स");
  String get bookAppointment => _t("Book Appointment", "अपॉइंटमेंट बुक करें");
  String get bookingHistory => _t("Booking History", "बुकिंग इतिहास");
  String get upcoming => _t("Upcoming", "आगामी");
  String get petInformation => _t("Pet Information", "पालतू जानवर की जानकारी");
  String get appointmentDetailsHeader => _t("Appointment Details", "अपॉइंटमेंट विवरण");
  String get dateLabel => _t("Date", "तारीख");
  String get timeLabel => _t("Time", "समय");
  String get doctorLabel => _t("Doctor", "डॉक्टर");
  String get reasonForVisit => _t("Reason for Visit", "विज़िट का कारण");
  String get past => _t("Past", "पिछला");
  String get selectDate => _t("Select Date", "तारीख चुनें");
  String get selectTimeSlot => _t("Select Time Slot", "समय स्लॉट चुनें");
  String get noSlotsAvailable => _t("No slots available for this date", "इस तारीख के लिए कोई स्लॉट उपलब्ध नहीं है");
  String get selectPetForBooking => _t("Select Pet", "पालतू जानवर चुनें");
  String get selectSymptoms => _t("Symptoms", "लक्षण");
  String get selectSymptomsHint => _t("Select observed symptoms", "देखे गए लक्षण चुनें");
  String get additionalNotes => _t("Additional Notes", "अतिरिक्त नोट्स");
  String get notesPlaceholder => _t(
    "Describe your pet's current condition or questions for the doctor...",
    "अपने पालतू जानवर की वर्तमान स्थिति या डॉक्टर के लिए प्रश्न लिखें...",
  );
  String get attachments => _t("Attachments", "संलग्नक (Attachments)");
  String get addAttachments => _t("Add photos or medical files (Optional)", "फ़ोटो या मेडिकल फ़ाइलें जोड़ें (वैकल्पिक)");
  String get proceedToPayment => _t("Proceed to Payment", "भुगतान के लिए आगे बढ़ें");

  String get reviewVetVisit => _t(
    "Review your pet's vet visit",
    "अपने पालतू जानवर की पशु चिकित्सा यात्रा की समीक्षा करें",
  );
  String get allPastAppointments => _t(
    "All your past appointments",
    "आपके सभी पिछले अपॉइंटमेंट्स",
  );
  String get pastAppointments => _t("Past Appointments", "पिछले अपॉइंटमेंट्स");
  String get noAppointmentsFound => _t("No appointments found", "कोई अपॉइंटमेंट नहीं मिला");
  String get noUpcomingAppointmentsSubtitle => _t(
    "You don't have any upcoming appointments. Schedule a visit with a vet to get started.",
    "आपके पास कोई आगामी अपॉइंटमेंट नहीं है। शुरू करने के लिए पशु चिकित्सक के साथ परामर्श तय करें।",
  );
  String get noPastAppointmentsSubtitle => _t(
    "You haven't had any appointments yet. Your past medical visits will appear here.",
    "आपके पास अभी तक कोई अपॉइंटमेंट नहीं है। आपकी पिछली चिकित्सा यात्राएं यहां दिखाई देंगी।",
  );
  String get unnamedPetTag => _t("Unnamed Pet", "बिना नाम का पालतू जानवर");

  String get choosePetOrSpecies => _t(
    "Choose a registered pet or book by species.",
    "एक पंजीकृत पालतू जानवर चुनें या प्रजाति द्वारा बुक करें।",
  );
  String get other => _t("Other", "अन्य");
  String get bySpecies => _t("By species", "प्रजाति द्वारा");
  String bookingFor(String name) => _t("Booking for $name", "$name के लिए बुकिंग");

  String get morningSlots => _t("Morning Slots", "सुबह के स्लॉट");
  String get afternoonSlots => _t("Afternoon Slots", "दोपहर के स्लॉट");
  String get eveningSlots => _t("Evening Slots", "शाम के स्लॉट");

  String get describeConcernsOrSymptoms => _t(
    "Describe any concerns or symptoms",
    "किसी भी चिंता या लक्षण का वर्णन करें",
  );
  String get uploadFilesText => _t("Upload files", "फ़ाइलें अपलोड करें");
  String get pleaseWait => _t("Please wait...", "कृपया प्रतीक्षा करें...");

  String get bookBySpecies => _t("Book By Species", "प्रजाति अनुसार बुक करें");
  String get selectSpeciesForBooking => _t(
    "Select the species for which you want to book an appointment.",
    "उस प्रजाति का चयन करें जिसके लिए आप अपॉइंटमेंट बुक करना चाहते हैं।",
  );
  String get noSpeciesFound => _t("No species found.", "कोई प्रजाति नहीं मिली।");

  String get telemedicineConsultation => _t(
    "Telemedicine Consultation",
    "टेलीमेडिसिन परामर्श",
  );
  String get telemedicineDesc => _t(
    "Telemedicine consultation allows you to consult a veterinarian remotely through the VetNow platform.",
    "टेलीमेडिसिन परामर्श आपको VetNow प्लेटफ़ॉर्म के माध्यम से दूरस्थ रूप से पशु चिकित्सक से परामर्श करने की अनुमति देता है।",
  );
  String get telemedicineInfo1 => _t(
    "The veterinarian will evaluate the information you provide.",
    "पशु चिकित्सक आपके द्वारा प्रदान की गई जानकारी का मूल्यांकन करेंगे।",
  );
  String get telemedicineInfo2 => _t(
    "The veterinarian may request additional information, photos, videos or reports if required.",
    "यदि आवश्यक हो तो पशु चिकित्सक अतिरिक्त जानकारी, फ़ोटो, वीडियो या रिपोर्ट का अनुरोध कर सकते हैं।",
  );
  String get telemedicineInfo3 => _t(
    "The veterinarian may determine that an in-person examination is required.",
    "पशु चिकित्सक यह निर्धारित कर सकते हैं कि व्यक्तिगत परीक्षण की आवश्यकता है।",
  );
  String get telemedicineAgree => _t(
    "I agree to avail consultation through telemedicine.",
    "मैं टेलीमेडिसिन के माध्यम से परामर्श लेने के लिए सहमत हूँ।",
  );

  // Payment Summary
  String get paymentSummary => _t("Payment Summary", "भुगतान सारांश");
  String get consultationFee => _t("Consultation Fee", "परामर्श शुल्क");
  String get slotDetails => _t("Slot Details", "स्लॉट विवरण");
  String get bookingDetails => _t("Booking Details", "बुकिंग विवरण");
  String get slotsBooked => _t("Slots Booked", "बुक किए गए स्लॉट");
  String get slotsPrice => _t("Slots Price", "स्लॉट मूल्य");
  String get convenienceFee => _t("Convenience Fee", "सुविधा शुल्क");
  String get totalAmount => _t("Total Amount", "कुल राशि");
  String get payNow => _t("Pay Now", "अभी भुगतान करें");
  String get paymentFailed => _t("Payment Failed", "भुगतान विफल");
  String get paymentSuccess => _t("Payment Successful", "भुगतान सफल");

  // Confirmation
  String get appointmentConfirmed => _t("Appointment Confirmed", "अपॉइंटमेंट की पुष्टि हो गई");
  String get appointmentConfirmedDesc => _t(
    "Your consultation has been successfully scheduled.",
    "आपका परामर्श सफलतापूर्वक निर्धारित कर दिया गया है।",
  );
  String get bookingId => _t("Booking ID", "बुकिंग आईडी");
  String get appointmentDate => _t("Appointment Date", "अपॉइंटमेंट की तारीख");
  String get appointmentTime => _t("Appointment Time", "अपॉइंटमेंट का समय");
  String get backToHome => _t("Back to Home", "होम पर वापस जाएं");

  // Booking status
  String get statusConfirmed => _t("Confirmed", "पुष्टीकृत");
  String get statusPending => _t("Pending", "लंबित");
  String get statusCancelled => _t("Cancelled", "रद्द");
  String get statusCompleted => _t("Completed", "पूर्ण");
  String get cancelAppointment => _t("Cancel Appointment", "अपॉइंटमेंट रद्द करें");
  String get reschedule => _t("Reschedule", "पुन पुनर्निर्धारित करें");
  String get joinCall => _t("Join Consultation", "परामर्श में शामिल हों");

  // ===========================================================================
  // 10. HEALTH ASSESSMENT & SYMPTOMS
  // ===========================================================================
  String get healthAssessment => _t("Health Assessment", "स्वास्थ्य मूल्यांकन");
  String get assessmentSubtitle => _t(
    "Answer a few quick questions to evaluate your pet's current health status.",
    "अपने पालतू जानवर की स्वास्थ्य स्थिति जानने के लिए कुछ त्वरित प्रश्नों के उत्तर दें।",
  );
  String get startAssessment => _t("Start Assessment", "मूल्यांकन शुरू करें");
  String get question => _t("Question", "प्रश्न");
  String get ofText => _t("of", "का");
  String get assessmentResults => _t("Assessment Results", "मूल्यांकन परिणाम");
  String get severityLevel => _t("Severity Level", "गंभीरता स्तर");
  String get lowSeverity => _t("Low", "कम");
  String get moderateSeverity => _t("Moderate", "मध्यम");
  String get highSeverity => _t("High", "उच्च");
  String get emergencySeverity => _t("Emergency", "आपातकाल");
  String get recommendations => _t("Recommendations", "अनुशंसाएं");
  String get bookDoctorNow => _t("Book Doctor Now", "अभी डॉक्टर बुक करें");

  // ===========================================================================
  // 11. SETTINGS & PREFERENCES
  // ===========================================================================
  String get settings => _t("Settings", "सेटिंग्स");
  String get generalSection => _t("General", "सामान्य");
  String get preferencesSection => _t("Preferences", "प्राथमिकताएं");
  String get myPets => _t("My Pets", "मेरे पालतू जानवर");
  String get myPetsSubtitle => _t("Manage all your furry friends", "अपने सभी पालतू जानवरों को प्रबंधित करें");
  String get darkMode => _t("Dark Mode", "डार्क मोड");
  String get darkModeSubtitle => _t("Switch app appearance", "ऐप का रंगरूप बदलें");

  // Language Settings
  String get language => _t("Language", "भाषा (Language)");
  String get languageSubtitle => _t("Change app language", "ऐप की भाषा बदलें");
  String get selectLanguage => _t("Select Language", "भाषा चुनें");
  String get english => _t("English", "English");
  String get hindi => _t("हिन्दी (Hindi)", "हिन्दी (Hindi)");

  String get notifications => _t("Notifications", "सूचनाएं");
  String get notificationsSubtitle => _t("Manage notification preferences", "सूचना प्राथमिकताएं प्रबंधित करें");
  String get markAllRead => _t("Mark all read", "सभी को पढ़ा हुआ चिह्नित करें");
  String get noNotifications => _t("No notifications yet", "अभी तक कोई सूचना नहीं");

  // Delete Account
  String get deleteAccount => _t("Delete Account", "खाता हटाएं");
  String get deleteAccountSubtitle => _t("Permanently delete your account", "अपना खाता स्थायी रूप से हटाएं");
  String get deleteAccountQuestion => _t("Delete Account?", "खाता हटाएं?");
  String get deleteAccountWarning => _t(
    "Are you sure you want to delete your account? This will permanently remove all your data including pet profiles, appointments, and activities. This action cannot be undone.",
    "क्या आप वाकई अपना खाता हटाना चाहते हैं? यह आपके पालतू जानवरों की प्रोफ़ाइल, अपॉइंटमेंट और गतिविधियों सहित आपके सभी डेटा को स्थायी रूप से हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।",
  );

  // Logout
  String get logout => _t("Logout", "लॉग आउट");
  String get logoutSubtitle => _t("Sign out of your account", "अपने खाते से साइन आउट करें");
  String get logoutQuestion => _t("Logout?", "लॉग आउट करें?");
  String get logoutConfirmQuestion => _t(
    "Are you sure you want to sign out?",
    "क्या आप वाकई साइन आउट करना चाहते हैं?",
  );
  String get signedOutOfVetNow => _t("You'll be signed out of VetNow", "आप VetNow से साइन आउट हो जाएंगे");
  String get logoutBullet1 => _t("Your data will be saved securely", "आपका डेटा सुरक्षित रूप से सहेजा जाएगा");
  String get logoutBullet2 => _t("You can sign back in anytime", "आप किसी भी समय वापस साइन इन कर सकते हैं");
  String get logoutBullet3 => _t(
    "Upcoming appointments remain scheduled",
    "आगामी अपॉइंटमेंट्स निर्धारित रहेंगी",
  );

  // ===========================================================================
  // 12. NETWORK & ERRORS
  // ===========================================================================
  String get noInternetConnection => _t("No Internet Connection!", "कोई इंटरनेट कनेक्शन नहीं!");
  String get noInternetMessage => _t(
    "Please check your internet settings and try again.",
    "कृपया अपनी इंटरनेट सेटिंग्स जांचें और पुनः प्रयास करें।",
  );
  String get somethingWentWrong => _t(
    "Something went wrong. Please try again.",
    "कुछ गलत हो गया। कृपया पुनः प्रयास करें।",
  );
  String get sessionExpired => _t(
    "Session expired. Please sign in again.",
    "सत्र समाप्त हो गया। कृपया फिर से साइन इन करें।",
  );
  String get fieldRequired => _t("This field is required", "यह फ़ील्ड आवश्यक है");
}

/// Convenient extension on [BuildContext] to access strings reactively:
/// `context.strings.bookAppointment`
extension AppStringsExtension on BuildContext {
  AppStrings get strings => AppStrings.of(this);
}
