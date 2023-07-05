import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage

    print("- Getting a child ref");
    print("- Current user UID is: ${_auth.currentUser!.uid}");
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    print("- Creating an Upload task");
    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
      file
    );

    print("- Uploading a file");
    TaskSnapshot snapshot = await uploadTask;
    print("- Getting a url");
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}