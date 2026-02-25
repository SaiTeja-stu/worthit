import 'dart:io';
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> main() async {
  var server = await HttpServer.bind('127.0.0.1', 3000);
  print('Local Email Background Service is running on localhost:${server.port}');

  await for (HttpRequest request in server) {
    // 1. Setup CORS Headers explicitly to allow Edge/Chrome
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      continue;
    }

    if (request.method == 'POST') {
      try {
        String content = await utf8.decoder.bind(request).join();
        var data = jsonDecode(content);
        
        String recipientEmail = data['to'];
        String otp = data['otp'];

        String username = 'saitejagadu21@gmail.com'; 
        String password = 'jzxngsgijebmfdoe';    
        final smtpServer = SmtpServer('smtp.gmail.com', port: 465, ssl: true, username: username, password: password, ignoreBadCertificate: true);

        final message = Message()
          ..from = Address(username, 'WorthIt App')
          ..recipients.add(recipientEmail)
          ..subject = 'Your WorthIt Login OTP'
          ..text = '''Your WorthIt Login One-Time Password (OTP) is $otp
Use the verification code sent in this email to securely access your account. This code is valid for a limited time to ensure your safety and privacy.Do not share this code.''';

        // Print to log window so the DEV can monitor it locally
        print('Forwarding OTP: $otp to Email $recipientEmail...');

        await send(message, smtpServer);
        
        print('Successfully Sent Email Address!');
        
        request.response.statusCode = HttpStatus.ok;
        request.response.write('{"success": true}');
      } catch (e) {
        print('Error forwarding email: $e');
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write('{"success": false, "error": "${e.toString()}"}');
      } finally {
        await request.response.close();
      }
    } else {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      await request.response.close();
    }
  }
}
