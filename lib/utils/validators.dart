/// Kumpulan fungsi validasi dan sanitasi input pengguna.
class Validators {
  /// Memvalidasi format [email].
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(email.trim());
  }

  /// Memastikan [value] tidak kosong setelah spasi dihapus.
  static bool isNotEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  /// Memastikan panjang [value] berada antara [min] dan [max].
  static bool hasValidLength(String value, {int min = 1, int max = 100}) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  /// Mengubah karakter khusus menjadi HTML entities bila input dipakai di HTML.
  ///
  /// Ini tidak menggantikan validasi di server atau escaping sesuai konteks output.
  static String sanitize(String input) {
    return input
        .trim()
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  /// Mengembalikan pesan error jika teks tidak valid, atau `null` jika valid.
  static String? validateText(
    String? value, {
    String fieldName = 'Field',
    int minLength = 1,
    int maxLength = 100,
  }) {
    if (!isNotEmpty(value)) {
      return '$fieldName tidak boleh kosong';
    }
    if (!hasValidLength(value!, min: minLength, max: maxLength)) {
      return '$fieldName harus antara $minLength-$maxLength karakter';
    }
    return null;
  }

  /// Mengembalikan pesan error jika email tidak valid, atau `null` jika valid.
  static String? validateEmail(String? value) {
    if (!isNotEmpty(value)) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value!)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Memvalidasi nomor telepon: hanya angka, 10–13 digit.
  static String? validatePhone(String? value) {
    if (!isNotEmpty(value)) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!RegExp(r'^[0-9]{10,13}$').hasMatch(value!.trim())) {
      return 'Nomor telepon harus berisi 10-13 digit angka';
    }
    return null;
  }

  /// Memvalidasi URL dengan skema HTTP/HTTPS dan host yang tidak kosong.
  static String? validateUrl(String? value) {
    if (!isNotEmpty(value)) {
      return 'URL tidak boleh kosong';
    }
    final input = value!.trim();
    final uri = Uri.tryParse(input);
    if (!RegExp(r'^https?://[^\s/?#]+(?:[/?#][^\s]*)?$').hasMatch(input) ||
        uri == null ||
        uri.host.isEmpty) {
      return 'URL harus dimulai dengan http:// atau https:// dan memiliki host';
    }
    return null;
  }

  /// Memvalidasi password minimal 8 karakter dengan huruf kapital, angka, dan simbol.
  static String? validatePassword(String? value) {
    if (!isNotEmpty(value)) {
      return 'Password tidak boleh kosong';
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9\s])\S{8,}$')
        .hasMatch(value!)) {
      return 'Password minimal 8 karakter dan harus mengandung huruf kapital, angka, serta simbol';
    }
    return null;
  }
}
