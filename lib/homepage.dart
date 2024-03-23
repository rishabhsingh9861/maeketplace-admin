import 'package:adminmarket/const.dart';
import 'package:adminmarket/payments.dart';
import 'package:adminmarket/reviewitemdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ReviewListItem')
          .orderBy('Time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Review Item List'),
              centerTitle: true,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text(
                      'Received Payments',
                      style: textsty,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Payments()),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                String reqid = snapshot.data!.docs[index].id;
                final reqdata =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                String product = reqdata['Products Type'] ?? '';
                Timestamp timestamp = reqdata['Time'] ?? Timestamp.now();
                DateTime dateTime = timestamp.toDate();
                String formattedTime = DateFormat.yMd().format(dateTime);

                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewDetailed(reviewid: reqid),
                        ),
                      );
                    },
                    title: Text(
                      product,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Request Date: $formattedTime',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
