import 'package:url_launcher/url_launcher.dart';
import 'storage_util.dart';

class EmailUtil {
  static Future<void> sendFeedbackEmail({
    required int rating,
    required String feedback,
    String? type,
  }) async {
    final String userName =
        StorageUtil.getString(StorageUtil.keyUserName) ?? "Anonymous User";
    final String typeStr = type != null ? " [$type]" : "";
    const String recipient = "fahadai3214@gmail.com";
    final String subject = 'Diary With Lock Feedback$typeStr';
    final String body =
        'Hi Developer,\n\nI am $userName and I have some feedback regarding the app (Rating: $rating):\n\nType: ${type ?? 'General'}\nFeedback: $feedback';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipient,
      query: _encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      rethrow;
    }
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
