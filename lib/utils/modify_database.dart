import 'package:cloud_firestore/cloud_firestore.dart';

import '../configurations/constants.dart';

Future<void> addCollection() async {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  QuerySnapshot query = await _db.collection(cUsers).get();
  List<DocumentSnapshot> docs = query.docs;
  docs.forEach((DocumentSnapshot element) async {
    await _db
        .collection(cUsers)
        .doc(element.id)
        .update({fCreatedDate: Timestamp.now()});
    // await _db
    //     .collection(cUsers)
    //     .doc(element.id)
    //     .collection(cUserProfile)
    //     .doc(dUserProfileStatic)
    //     .set({fCreatedDate: Timestamp.now()});
    // await _db
    //     .collection(cUsers)
    //     .doc(element.id)
    //     .collection(cUserProfile)
    //     .doc(dUserProfileDynamic)
    //     .set({});
  });
}
