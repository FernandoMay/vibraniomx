// ```

// ## lib/core/models/user_profile.dart
// ```dart
enum UserType { none, listener, artist }

class UserProfile {
  final UserType userType;
  final List<int> recentMoods;
  final DateTime subscriptionEnd;

  UserProfile({
    required this.userType,
    required this.recentMoods,
    required this.subscriptionEnd,
  });

  factory UserProfile.fromContractResult(List<dynamic> result) {
    final userTypeIndex = (result[0] as BigInt).toInt();
    final userType = UserType.values[userTypeIndex];
    final recentMoods = (result[1] as List).cast<int>();
    final subscriptionEndTimestamp = (result[2] as BigInt).toInt();
    final subscriptionEnd = DateTime.fromMillisecondsSinceEpoch(subscriptionEndTimestamp * 1000);

    return UserProfile(
      userType: userType,
      recentMoods: recentMoods,
      subscriptionEnd: subscriptionEnd,
    );
  }

  bool get hasActiveSubscription => DateTime.now().isBefore(subscriptionEnd);
}