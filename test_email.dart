import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() async {
  String username = 'saitejagadu21@gmail.com'; 
  String password = 'jzxngsgijebmfdoe';    
  final smtpServer = SmtpServer('smtp.gmail.com', port: 465, ssl: true, username: username, password: password, ignoreBadCertificate: true);

  final message = Message()
    ..from = Address(username, 'WorthIt App')
    ..recipients.add('saitejagadu21@gmail.com')
    ..subject = 'Test OTP SSL'
    ..text = 'Test message';

  try {
    await send(message, smtpServer);
    print('SUCCESS');
  } catch (e) {
    print('ERROR: $e');
  }
}
