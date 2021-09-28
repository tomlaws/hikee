import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "bookmarks": "Bookmarks",
          "events": "Events",
          "settings": "Settings",
          "account": "Account",
          "login": "Login",
          "logout": "Logout",
          "language": "Language",
          "changeLanguage": "Change Language",
          "reply": "Reply"
        },
        'zh_HK': {
          "bookmarks": "收藏",
          "events": "活動",
          "settings": "設定",
          "account": "帳號",
          "login": "登入",
          "logout": "登出",
          "language": "語言",
          "changeLanguage": "變更語言",
          "reply": "回覆"
        },
        'zh_CN': {
          "bookmarks": "收藏",
          "events": "活動",
          "settings": "设定",
          "account": "帐号",
          "login": "登入",
          "logout": "登出",
          "language": "语言",
          "changeLanguage": "变更语言",
          "reply": "回覆"
        }
      };
}
