// Copyright (c) 2021 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

class DevUtils {
  /// Remove IP address from the URL
  static String replaceIP(String url, String replaceWithDomain) {
    final a = url.split(RegExp(r'/+[0-9]?'));
    final StringBuffer b = StringBuffer('${a[0]}//');
    b.write(replaceWithDomain);
    for (var i = 2; i < a.length; ++i) {
      b.write('/${a[i]}');
    }
    return b.toString();
  }
}
