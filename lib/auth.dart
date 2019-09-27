import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore

  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
    profile.doOnData((data) => print("Data: $data"));
  }

  Future<FirebaseUser> emailSignIn(String email, String password) async {
    loading.add(true);
    AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    updateUserData(user);
    loading.add(false);
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;

    updateUserData(user);
    print("signed in " + user.displayName);
    loading.add(false);
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'lastSeen': DateTime.now(),
    }, merge: true);
  }

  Future<void> updateUserDataWithMap(FirebaseUser user, Map<String, dynamic> map) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData(map, merge: true);
  }

  Future<Map<String,dynamic>> getUserProfile(FirebaseUser user) async {
    DocumentReference ref = _db.collection("users").document(user.uid);
    DocumentSnapshot snap = await ref.get();
    return snap.data;
  }

  void signOut() {
    _auth.signOut();
  }
}

final AuthService authService = AuthService();
