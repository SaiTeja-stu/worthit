import 'package:mailer/smtp_server.dart';
void main() {
  final smtpServer = SmtpServer('smtp.gmail.com', port: 465, ssl: true, username: 'a', password: 'b', ignoreBadCertificate: true); 
  print('Constructed successfully!: ${smtpServer.host}');
}
