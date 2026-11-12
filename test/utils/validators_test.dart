import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('menerima format email valid', () {
      expect(Validators.isValidEmail('nama@example.com'), isTrue);
      expect(Validators.isValidEmail('nama.depan@kampus.ac.id'), isTrue);
    });

    test('menolak email tanpa @, domain, atau dengan spasi', () {
      expect(Validators.isValidEmail('nama.example.com'), isFalse);
      expect(Validators.isValidEmail('nama@domain'), isFalse);
      expect(Validators.isValidEmail('nama depan@example.com'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('Validators.sanitize', () {
    test('mengubah karakter khusus menjadi HTML entities', () {
      expect(
        Validators.sanitize('  <script>"&\'</script>  '),
        '&lt;script&gt;&quot;&amp;&#39;&lt;/script&gt;',
      );
    });

    test('menghapus spasi di awal dan akhir', () {
      expect(Validators.sanitize('  teks aman  '), 'teks aman');
    });
  });

  group('Validators.validateText', () {
    test('menolak null dan teks kosong', () {
      expect(Validators.validateText(null), 'Field tidak boleh kosong');
      expect(Validators.validateText('   '), 'Field tidak boleh kosong');
    });

    test('menolak teks lebih pendek dari batas minimum', () {
      expect(
        Validators.validateText('ab', fieldName: 'Nama', minLength: 3),
        'Nama harus antara 3-100 karakter',
      );
    });

    test('menerima teks tepat pada batas minimum dan maksimum', () {
      expect(
        Validators.validateText('abc', minLength: 3, maxLength: 5),
        isNull,
      );
      expect(
        Validators.validateText('abcde', minLength: 3, maxLength: 5),
        isNull,
      );
    });

    test('menolak teks melebihi batas maksimum', () {
      expect(
        Validators.validateText('abcdef', fieldName: 'Nama', maxLength: 5),
        'Nama harus antara 1-5 karakter',
      );
    });
  });
}
