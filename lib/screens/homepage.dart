import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addpost.dart';
import 'editpost.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final databaseReference = FirebaseFirestore.instance;
  String _orderBy = "descending";

  void _toggleOrder() {
    setState(() {
      _orderBy = _orderBy == "ascending" ? "descending" : "ascending";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin app"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _toggleOrder,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseReference
            .collection("posts")
            .orderBy("timestamp", descending: _orderBy == "descending")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                var post = snapshot.data?.docs[index].data();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: ListTile(
                      title: Text(
                        (post as Map<String, dynamic>)['title'] ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Column(
                        //! To keep eerything at left side ie. start of axis
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (post)['content'] ?? "",
                            style: const TextStyle(),
                          ),
                          //! Here we used string concatination, It will work but is not proper way to do so
                          // Text(DateFormat.yMMMd().format((post
                          //             as Map<String, dynamic>)['timestamp']
                          //         .toDate()) +
                          //     " " +
                          //     DateFormat.Hm().format((post
                          //             as Map<String, dynamic>)['timestamp']
                          //         .toDate())),
                          //! String interpolation is good way

                          Text((post)['timestamp'] !=
                                  null //! Checking if Timestamp in firestore is null or not?
                              ? "${DateFormat.yMMMd().format((post)['timestamp'].toDate())} ${DateFormat.Hm().format((post)['timestamp'].toDate())}"
                              : "N/A"),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (snapshot.data?.docs[index].id != null &&
                                      (post)['title'] != null &&
                                      (post)['content'] != null) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EditPost(
                                        postId: (snapshot.data?.docs[index].id
                                            as String),
                                        //! This works but it is using unecessary casting
                                        // title: (post
                                        //     as Map<String, dynamic>)['title'],
                                        // content: (post
                                        //     as Map<String, dynamic>)['content'],
                                        title: (post)['title'] ?? "",
                                        content: (post)['content'] ?? "",
                                      ),
                                    ));
                                  }
                                },
                                child: const Icon(Icons.edit),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    databaseReference
                                        .collection("posts")
                                        .doc(snapshot.data?.docs[index].id)
                                        .delete();
                                  },
                                  child: const Icon(Icons.delete)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
