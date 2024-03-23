// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adminmarket/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReviewDetailed extends StatefulWidget {
  final String reviewid;
  const ReviewDetailed({
    Key? key,
    required this.reviewid,
  }) : super(key: key);

  @override
  State<ReviewDetailed> createState() => _ReviewDetailedState();
}

class _ReviewDetailedState extends State<ReviewDetailed> {
  Timestamp timestamp = Timestamp.now();
  Future<void> deletesolvedIds(String ids) async {
    FirebaseFirestore.instance.collection('ReviewListItem').doc(ids).delete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('ReviewListItem')
          .doc(widget.reviewid)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        } else {
          final reqdata = snapshot.data!.data()! as Map<String, dynamic>;

          String name = reqdata['Name'];
          String address = reqdata['Address'];
          String email = reqdata['EmailId'];
          String producttype = reqdata['Products Type'];
          String productcategory = reqdata['Product Category'];
          String description = reqdata['Decription'];
          int price = int.parse('${reqdata['Price']}');
          int contactno = int.parse('${reqdata['Contact Number']}');
          String image1 = reqdata['Image URL 1'];
          String image2 = reqdata['Image URL 2'];

          return Scaffold(
            appBar: appbar('Detailed Review'),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 600,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: $name',
                                style: textsty,
                              ),
                              Text(
                                'Address: $address',
                                style: textsty,
                              ),
                              Text(
                                'Category: $productcategory',
                                style: textsty,
                              ),
                              Text(
                                'Product Type :$producttype',
                                style: textsty,
                              ),
                              Text(
                                'Price :$price',
                                style: textsty,
                              ),
                              Text(
                                'image1 :$image1',
                                style: textsty,
                              ),
                              Text(
                                'image2 :$image2',
                                style: textsty,
                              ),
                              Text(
                                'Description :$description',
                                style: textsty,
                              ),
                              Text(
                                'contactno :$contactno',
                                style: textsty,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green,
                          ),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection(productcategory)
                              .doc()
                              .set({
                            'Description': description,
                            'Merchant Name': name,
                            'Price': price + price / 20,
                            'Image1': image1,
                            'Image2': image2,
                            'Product': producttype
                          }).then((value) {
                            FirebaseFirestore.instance
                                .collection('SellerUser')
                                .doc(email)
                                .collection('MyItems')
                                .doc()
                                .set({
                              'Description': description,
                              'Merchant Name': name,
                              'Price': price + price / 20,
                              'Image1': image1,
                              'Image2': image2,
                              'Product': producttype,
                              'Time': timestamp
                            });
                          }).then((value) async {
                            final subject =
                                Uri.encodeComponent('Product Accepted');
                            final body = Uri.encodeComponent(
                                'Your ${producttype} Product has beean accepted and it has listed  ');

                            final emailUrl =
                                'mailto:$email?subject=$subject&body=$body';
                            if (await launchUrlString(emailUrl)) {
                              await canLaunchUrlString(emailUrl);
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Mail Sent'),
                                  content: const Text(
                                      'The email has been sent successfully.'),
                                );
                              },
                            );
                          }).then((value) {
                            deletesolvedIds(widget.reviewid).then((value) {
                              int count = 1;
                              Navigator.of(context)
                                  .popUntil((_) => count-- < 0);
                            });
                          });
                        },
                        child: const Text(
                          'Approved',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red,
                          ),
                        ),
                        onPressed: () async {
                          final subject =
                              Uri.encodeComponent('Product Rejected');
                          final body = Uri.encodeComponent(
                              'Your ${producttype} Product has not beean accepted due to  ');

                          final emailUrl =
                              'mailto:$email?subject=$subject&body=$body';

                          if (await launchUrlString(emailUrl)) {
                            await canLaunchUrlString(emailUrl);
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Mail Sent'),
                                content: const Text(
                                    'The email has been sent successfully.'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      deletesolvedIds(widget.reviewid)
                                          .then((value) {
                                        int count = 1;
                                        Navigator.of(context)
                                            .popUntil((_) => count-- < 0);
                                      });
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Revert',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
    ;
  }
}
