import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

class LicenseVerifier {
  static const String defaultPublicKeyBase64 =
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzTW9ynu/y4vCxN787CzG"
      "NYzTPEMZwfl+pgPcSbjOMKo+5NjqacKPE+3xejbpYWYGXtU5yjBXn85etbf939vT"
      "kvbmCJfKRnjnUyReUav06fbAQKU8eGwbKYd1Aq5S/svzMvStF0ANxXZ+mq8j/CcA"
      "sSUVx3NRv1jZL2WgET9iwYDXDOFYKWQcf+5/K36+2/xMISPgRzW89/eYrDKlHYkZ"
      "jEfrxYBCf2o4045kAazXWWiWwyazYgGzfQL0Gbjcli/+EXbNMWpzJ8+zw8Y4FLVU"
      "sU86Fuj1T6g3K2kKUj94GWEW2l2gmpZAj12KiuKfpyadomLwzX92xyuKlAsypmQG"
      "tQIDAQAB";

  final RSAPublicKey publicKey;

  LicenseVerifier({String? publicKeyBase64})
      : publicKey = parseRsaPublicKey(publicKeyBase64 ?? defaultPublicKeyBase64);

  static RSAPublicKey parseRsaPublicKey(String base64Key) {
    final bytes = base64Decode(base64Key.replaceAll('\n', '').trim());
    final parser = ASN1Parser(bytes);
    final top = parser.nextObject() as ASN1Sequence;
    final bitString = top.elements![1] as ASN1BitString;
    final rsaParser = ASN1Parser(bitString.stringValues as Uint8List);
    final rsaSeq = rsaParser.nextObject() as ASN1Sequence;
    final modulus = (rsaSeq.elements![0] as ASN1Integer).integer!;
    final exponent = (rsaSeq.elements![1] as ASN1Integer).integer!;
    return RSAPublicKey(modulus, exponent);
  }

  bool verifySignature({
    required Uint8List payloadBytes,
    required String signatureBase64,
  }) {
    try {
      final sigBytes = base64Decode(signatureBase64.replaceAll('\n', '').trim());
      final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
      signer.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));
      return signer.verifySignature(payloadBytes, RSASignature(sigBytes));
    } catch (_) {
      return false;
    }
  }
}

