import 'package:encrypt/encrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class EncryptData{
//for AES Algorithms

  static Encrypted? encrypted;
  static var decrypted;

  static final key = Key.fromUtf8('1245714587458888');
  static final iv = IV.fromLength(16);
  static final encrypter =Encrypter(AES(key, mode: AESMode.cbc));

  //ashrafksalim1@gmail.com
  //Qxou7ty9Qgo2uyxKsmFS0+tGLvbmfzIXt+KiK8zMPy0=

  static String encryptAES(plainText){
    plainText = plainText.replaceAll("@", "boltey").replaceAll(".","dot");
    encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted!.base16);
    String b = encrypted!.base16;
    decrypted = encrypter.decrypt(Encrypted.fromBase64(b),iv:iv,);
    print(decrypted);
    String uriFormat = Uri.encodeComponent(encrypted!.base16);

    return uriFormat.replaceAll("%", "ankita");
  }

  static String decryptAES(String plainText){


    plainText = plainText.replaceAll("ankita", "%");
    plainText = Uri.decodeComponent(plainText);
    print("Decrypting $plainText");
    //plainText = "";
    String decrypted = encrypter.decrypt(Encrypted.fromBase16(plainText),iv:iv,);
    print(decrypted);
    return decrypted.replaceAll("boltey","@").replaceAll("dot",".");
  }



  static createJWT(Map dataMap){
    // Generate a JSON Web Token
// You can provide the payload as a key-value map or a string
    final jwt = JWT(
      // Payload
      dataMap,
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );

// Sign it (default with HS256 algorithm)
    final token = jwt.sign(SecretKey('secret passphrase'));
   // final encodedToken = Uri.encodeComponent(token);
    print('Signed token: $token\n');
    print('Signed token: $token\n');

    return token.toString().replaceAll(".", "ashraf").replaceAll("-", "nikita");
  }

  static verifyToken(token){
    Map dataMap = {};
    try {
      token = token.replaceAll("ashraf",".").replaceAll("nikita","-");
      print("Decoded Component $token");
      // Verify a token (SecretKey for HMAC & PublicKey for all the others)
      final jwt = JWT.verify(token, SecretKey('secret passphrase'));

      print('Payload: ${jwt.payload}');
      dataMap = jwt.payload;
    } on JWTExpiredException {
      print('jwt expired');
    } on JWTException catch (ex) {
      print(ex.message); // ex: invalid signature
    }
    return dataMap;
  }




}
