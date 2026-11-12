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
}
