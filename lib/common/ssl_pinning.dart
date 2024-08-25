import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class SSLPinning {
  static Client? _clientInstance;
  static Client get instance => _clientInstance ?? Client();

  static Future<Client?> get _instance async {
    return _clientInstance ??= await secureHttpClient();
  }

  static Future init() async => _clientInstance = await _instance;

  static Future<Client> secureHttpClient() async {
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);

    try {
      final sslCertificate = await rootBundle.load('assets/certificate.pem');

      securityContext.setTrustedCertificatesBytes(
        sslCertificate.buffer.asInt8List(),
      );
    } on TlsException catch (error) {
      if (error.osError?.message != null &&
          error.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        log('Certificate already trusted. SKIPPING!');
      } else {
        log('Error: ${error.toString()}');
        rethrow;
      }
    } catch (error) {
      log('Unexpected Error: ${error.toString()}');
      rethrow;
    }

    HttpClient httpClient = HttpClient(context: securityContext);

    httpClient.badCertificateCallback = (
      X509Certificate certificate,
      String host,
      int port,
    ) {
      return false;
    };

    IOClient ioClient = IOClient(httpClient);

    return ioClient;
  }
}
