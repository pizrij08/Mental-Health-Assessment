
enum Role { user, clinic, admin }

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.gender,
    this.notes = '',
  });
  final String id;
  final String name;
  final String email;
  final int? age;
  final String? gender;
  String notes;
}

class Clinic {
  Clinic({required this.id, required this.name, this.address, List<AppUser>? patients})
      : patients = patients ?? [];
  final String id;
  final String name;
  final String? address;
  final List<AppUser> patients;
}