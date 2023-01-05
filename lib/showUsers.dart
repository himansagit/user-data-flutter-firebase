import 'package:flutter/material.dart';
// import 'database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutterfirebaseapp/inputScreen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List users = [];

  FirebaseStorage store = FirebaseStorage.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> getUserList() async {
    QuerySnapshot querySnapshot = await userCollection.get();
    setState(() {
      users = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<String?> downloadURL(String filePath) async {
    String downloadURL =
        await store.ref('usersImages/$filePath').getDownloadURL();
    return downloadURL;
  }

  Widget getUserCard(dynamic e) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.network('${e['imagePath']}'),
              title: Text('${e['Name']}'),
              subtitle: Text('${e['Info']}'),
            ),
            Padding(padding: EdgeInsets.all(10), child: Text('${e['Email']}')),
          ],
        ),
      ),
    );
    // if (k == 'imagePath') {
    //       print('image path $v');

    //       userWidget.add(Image.network(
    //         '$v',
    //         key: UniqueKey(),
    //       ));
    //       // print(URL);
    //       // userWidget.add(Container(
    //       //   width: 300,
    //       //   height: 250,
    //       //   child: Image.network(URL!, fit: BoxFit.cover),
    //       // ));

    //       print(userWidget);
    //     } else {
    //       userWidget.add(Text(
    //         '$v',
    //         style: TextStyle(fontSize: 20.0),
    //       ));
    //       userWidget.add(SizedBox(
    //         height: 10,
    //       ));
    //     }
  }

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(" CURRENT USERS"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: users.map((e) {
            return getUserCard(e);
            // List<Widget> userWidget = [];

            // e.forEach((k, v) {
            //   userWidget.add(getUserCard(k, v));
            // });
            // userWidget.add(Image.network('https://picsum.photos/200/300'));
            // return Center(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: userWidget,
            //   ),
            // );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getUserList();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

// class UserCard extends StatelessWidget {
//   final Map data;
//   const UserCard({this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//           child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text("name"),
//           SizedBox(height: 20.0),
//           Text("email"),
//         ],
//       )),
//     );
//   }
// }
