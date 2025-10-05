class User {
  final int id;
  final String name;
  final String email;
  final String? birthDate;
  final int? age;
  final String? educationLevel;
  final String? educationDisplay;
  final String? institution;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.birthDate,
    this.age,
    this.educationLevel,
    this.educationDisplay,
    this.institution,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      birthDate: json['birth_date'],
      age: json['age'],
      educationLevel: json['education_level'],
      educationDisplay: json['education_display'],
      institution: json['institution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'birth_date': birthDate,
      'education_level': educationLevel,
      'institution': institution,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      age: age,
      educationLevel: educationLevel ?? this.educationLevel,
      educationDisplay: educationDisplay,
      institution: institution ?? this.institution,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}
