import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ContributionController extends GetxController {
  String type = "Resource Type";
  final course = TextEditingController();
  final content = TextEditingController();

  void setType(String value) {
    type = value;
    update();
  }

  void reset() {
    course.clear();
    content.clear();
    type = "Resource Type";
    update();
  }
}

final _contributionCtr = Get.put(ContributionController());

class ContributionView extends StatelessWidget {
  const ContributionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make Contribution"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Type of resource :",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GetBuilder(
                  init: _contributionCtr,
                  builder: (__) {
                    return DropdownButton<String>(
                      underline: Container(),
                      value: _contributionCtr.type,
                      items: ["YouTube", "Blog", "Other", "Resource Type"]
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        _contributionCtr.setType(value!);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(
              "Name of course:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: TextFormField(
              controller: _contributionCtr.course,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              "Contribution Content:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: TextFormField(
              controller: _contributionCtr.content,
              maxLines: 20,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Submit"),
                onPressed: () async {
                  try {
                    final uid = const Uuid().v4();
                    await FirebaseFirestore.instance
                        .collection("contributions")
                        .doc(uid)
                        .set(
                      {
                        "uid": uid,
                        "authorId": FirebaseAuth.instance.currentUser!.uid,
                        "course": _contributionCtr.course.text,
                        "content": _contributionCtr.content.text,
                        "timeStamp": DateTime.now().toIso8601String(),
                      },
                    );
                    _contributionCtr.reset();
                  } catch (err) {
                    debugPrint(err.toString());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
