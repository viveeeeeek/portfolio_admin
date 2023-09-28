import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: (() {
            FocusScope.of(context).unfocus();
          }),
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      suffixIcon: Icon(Icons.title),
                      hintText: "Enter title here",
                    ),
                    maxLength: null,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: "Content",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      hintText: "Enter post content here",
                    ),
                    maxLength: null,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ElevatedButton(
                      onPressed: () async {
                        await databaseReference.collection("posts").add({
                          'title': _titleController.text,
                          'content': _contentController.text,
                          'timestamp': FieldValue.serverTimestamp()
                        });
                        //! It will also work without setstate but as ChatGPT said >> The warning is indicating that the method Navigator.of(context).pop() should be used inside the build method, rather than outside of it. This is because the context argument may not be available outside the build method. To resolve this warning, you can wrap the method inside a setState method or use the BuildContext argument passed to the build method to access the Navigator.
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
