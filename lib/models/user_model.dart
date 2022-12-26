import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoUser {
  String? id;
  String? name, email, phone, address;

  InfoUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };

  static InfoUser fromJson(Map<String, dynamic> json) => InfoUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
      );
}

Future createUser(InfoUser user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  final json = user.toJson();
  await docUser.set(json);
}

Stream<List<InfoUser>> loadUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => InfoUser.fromJson(doc.data())).toList());

Future<InfoUser?> loadUser() async {
  final docUser = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  final snapshot = await docUser.get();
  if (snapshot.exists) {
    return InfoUser.fromJson(snapshot.data()!);
  }
  return null;
}
