import 'package:encrypt/encrypt.dart' as encrpt;
import 'package:encrypt/encrypt.dart';
class MyEncryptionDecryption {
  //For AES Encryption/Decryption
  static final key = encrpt.Key.fromLength(32);
  static final iv = encrpt.IV.fromLength(16);
  static final encrypter = encrpt.Encrypter(encrpt.AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
//    print(encrypted.bytes);
//    print(encrypted.base16);
//    print(encrypted.base64);
    return encrypted;
  }

  static dynamic decryptAES(text) {
    final decrypted = encrypter.decrypt64(text, iv: iv);
    print(decrypted);
    return decrypted;
  }
  static String encryp(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
//   print('text : $text');
//   print('encrypted : ${encrypted.base64}');
    return encrypted.base64;
  }

//Flutter decryption
  static String decryp(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
    return decrypted;
  }
}