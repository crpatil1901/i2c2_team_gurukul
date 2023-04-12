import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyic/api/models/mentor_model.dart';
import 'package:eyic/api/services/firebase/mentor_database.dart';
import 'package:eyic/screens/mentee/connections_page/logic/mentor_selection_form_controller.dart';
import 'package:eyic/screens/mentee/connections_page/widgets/mentor_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/colors.dart';
import 'widgets/mentor_list_item.dart';

class ConnectionsResultPage extends StatelessWidget {
  ConnectionsResultPage({super.key});
  final MentorDB mentorDB = Get.put(MentorDB());

  final MentorSelectionFormController mentorSelectionFormController =
      Get.find();

  Future<List<MentorModel>> getResultMentors() async {
    /*final MentorSelectionFormController mentorSelectionFormController =
        Get.put(MentorSelectionFormController())*/
    log(mentorSelectionFormController.gender.value);
    var data = await FirebaseFirestore.instance.collection("users").get();
    // log(data.docs
    //     .where((element) => element['languages'].toList().contains("english"))
    //     .toList()
    //     .toString());
    var temp = data.docs
        .where((element) => element['role'] == 'mentor' ? true : false)
        .where((element) =>
            element['gender'] == mentorSelectionFormController.gender.value
                ? true
                : false)
        .where((element) => element['age'] >=
                    int.tryParse(mentorSelectionFormController
                        .startingAgeController.value.text) ??
                0
            ? true
            : false)
        .where((element) => element['age'] <=
                    int.tryParse(mentorSelectionFormController
                        .endingAgeController.value.text) ??
                0
            ? true
            : false)
        .where((element) => element['languages'].toList().contains("english"))
        //.where((element) => element['languages'].toList().contains("english"))
        .toList();

    var list = <MentorModel>[];
    for (var i = 0; i < temp.length; i++) {
      list.add(MentorModel.fromMap(temp[i].data()));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getResultMentors(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('connection state is waiting');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          var mentorList = snapshot.data;
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(30),
                  color: Colors.transparent,
                  child: Center(
                    child: InkWell(
                      onTap: (() {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          isDismissible: false,
                          elevation: 10,
                          constraints: BoxConstraints.tightFor(
                            height: screenSize.height,
                            width: screenSize.width,
                          ),
                          context: context,
                          builder: ((context) {
                            return Container(
                              color: Colors.transparent,
                              child: MentorSelectionForm(),
                            );
                          }),
                        );
                      }),
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.black54,
                            ),
                            Text(
                              'Look for new mentors',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Result mentors:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: mentorList!.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MentorListItem(mentorList[index]),
                      ],
                    );
                    //: MentorListItem(mentorList[index]);
                  }),
                )
              ],
            ),
          );
        }
        print("Future has no data");
        return Center(
          child: Text('${snapshot.data}'),
        );
      }),
    );
  }
}
