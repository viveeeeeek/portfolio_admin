import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  final String postId;
  final String title;
  final String content;

  const EditPost(
      {super.key,
      required this.postId,
      required this.title,
      required this.content});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _contentController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Post"),
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
                    focusNode: _titleFocus,
                    maxLength: null,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _contentController,
                    focusNode: _contentFocus,
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
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("posts")
                            .doc(widget.postId)
                            .update({
                          "title": _titleController.text,
                          "content": _contentController.text,
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Update"),
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
