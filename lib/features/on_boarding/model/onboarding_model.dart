class OnboardingModel {
  final String image;

  OnboardingModel({required this.image});

  static List<OnboardingModel> onboardingList = [
    OnboardingModel(image: "assets/images/onboarding.png"),
    OnboardingModel(image: "assets/images/boarding2.jpeg"),
    OnboardingModel(image: "assets/images/boarding3.jpeg"),
  ];
}
