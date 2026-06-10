class UserProfile {
  const UserProfile({
    this.fullName = 'Dhia',
    this.email = 'athlete@gymcoach.com',
    this.weight = 84.2,
    this.height = 185,
  });

  final String fullName;
  final String email;
  final double weight;
  final double height;

  UserProfile copyWith({
    String? fullName,
    String? email,
    double? weight,
    double? height,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }
}
