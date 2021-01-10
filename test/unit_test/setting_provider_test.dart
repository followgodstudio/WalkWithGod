import 'package:flutter_test/flutter_test.dart';
import 'package:walk_with_god/providers/user/setting_provider.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:walk_with_god/configurations/constants.dart';

void main() {
  test('Test Setting Provider', () async {
    final instance = MockFirestoreInstance();
    const ourMission = "我们的使命";
    const whoAreWe = "我们是谁";
    await instance
        .collection(cAppInfo)
        .doc(dAppInfoAboutUs)
        .set({fAppInfoOurMission: ourMission, fAppInfoWhoAreWe: whoAreWe});
    final settingProvider = SettingProvider(fdb: instance);
    settingProvider.setUserId("V1");
    expect(settingProvider.userId, "V1");

    expect(settingProvider.ourMission, "");
    expect(settingProvider.whoAreWe, "");
    await settingProvider.fetchAboutUs();
    expect(settingProvider.ourMission, ourMission);
    expect(settingProvider.whoAreWe, whoAreWe);
  });
}
