/// Data pengguna yang diterima dari endpoint `/users`.
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String companyName;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
  });

  /// Membuat pengguna dari JSONPlaceholder API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      companyName: json['company']?['name'] ?? '',
    );
  }

  /// Huruf awal nama untuk avatar.
  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}
