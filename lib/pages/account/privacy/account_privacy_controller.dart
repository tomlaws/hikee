import 'package:get/get.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/user.dart';

class AccountPrivacyController extends GetxController {
  final userProvider = Get.put(UserProvider());
  final _authProvider = Get.find<AuthProvider>();
  final isPrivate = true.obs;

  @override
  void onInit() {
    super.onInit();
    _authProvider.refreshMe().then(
        (_) => isPrivate.value = _authProvider.me.value?.isPrivate ?? true);
  }

  get user {
    return _authProvider.me.value;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<User> updatePrivacy() async {
    return await userProvider.update(isPrivate: isPrivate.value);
  }
}
