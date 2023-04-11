import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eyic/api/models/course_model.dart';
import 'package:eyic/api/models/course_details_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CourseDetailsView extends StatelessWidget {
  final String courseName;
  const CourseDetailsView({super.key, required this.courseName});

  Future<List<CourseDetailsModel>> _getBlogLinks() async {
    print("get BlogLinks called");
    final data = await FirebaseFirestore.instance
        .collection("blogLinks")
        .where("course", isEqualTo: courseName)
        .get();
    return data.docs.map((e) => CourseDetailsModel.fromMap(e.data())).toList();
  }

  Future<List<CourseDetailsModel>> _getYtLinks() async {
    print("get ytLinks called");
    final data = await FirebaseFirestore.instance
        .collection("ytLinks")
        .where("course", isEqualTo: courseName)
        .get();
    return data.docs.map((e) => CourseDetailsModel.fromMap(e.data())).toList();
  }

  Future<List<CourseDetailsModel>> _getOtherLinks() async {
    print("get otherLinks called");
    final data = await FirebaseFirestore.instance
        .collection("otherLinks")
        .where("course", isEqualTo: courseName)
        .get();
    return data.docs.map((e) => CourseDetailsModel.fromMap(e.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/coursesWallpaper.jpg",
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
            ListTile(
              title: Text(courseName, style: TextStyle(fontSize: 32)),
            ),
            const Divider(),
            ListTile(
              title: Text("Youtube Videos:", style: TextStyle(fontSize: 24)),
            ),
            FutureBuilder(
              future: _getYtLinks(),
              builder:
                  (context, AsyncSnapshot<List<CourseDetailsModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //print("snapshot is waiting");
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //final ytData = (data["ytLinks"] as List)[index];
                      return ListTile(
                        onTap: () => launchUrlString(data[index].link),
                        title: Text(
                          data[index].title,
                        ),
                        subtitle: Text(
                          data[index].description,
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            const Divider(),
            ListTile(
              title: Text("Blogs", style: TextStyle(fontSize: 24)),
            ),
            FutureBuilder(
              future: _getBlogLinks(),
              builder:
                  (context, AsyncSnapshot<List<CourseDetailsModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //print("snapshot is waiting");
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //final ytData = (data["ytLinks"] as List)[index];
                      return ListTile(
                        onTap: () => launchUrlString(data[index].link),
                        title: Text(
                          data[index].title,
                        ),
                        subtitle: Text(
                          data[index].description,
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            const Divider(),
            ListTile(
              title: Text("Resources"),
            ),
            FutureBuilder(
              future: _getOtherLinks(),
              builder:
                  (context, AsyncSnapshot<List<CourseDetailsModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //print("snapshot is waiting");
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //final ytData = (data["ytLinks"] as List)[index];
                      return ListTile(
                        onTap: () => launchUrlString(data[index].link),
                        title: Text(
                          data[index].title,
                        ),
                        subtitle: Text(
                          data[index].description,
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

// class eachCourse extends StatelessWidget {
//   eachCourse({super.key});

//   final List<String> useTitle = [
//     "Youtube video: Free code camp",
//     "introduction to web development",
//     "HTML, CSS AND JAVASCRIPT FOR DEVELOPERS",
//     "Youtube video on web dev",
//     "HTML and CSS blog",
//     "Useful Front-End Boilerplates And Starter Kits blog",
//     "Web development wikipedia"
//   ];
//   final List<String> useDescription = [
//     "Learn full-stack web development in this full course for beginners. First, you will learn the basics of HTML, CSS, and JavaScript. Then, you will learn how to put everything together to create a frontend movie search app. Finally, you will learn how to create a backend API to create movie reviews and connect the frontend to the backend. The backend uses Node.js, Express, and MongoDB.",
//     "This course is designed to start you on a path toward future studies in web development and design, no matter how little experience or technical knowledge you currently have. The web is a very big place, and if you are the typical internet user, you probably visit several websites every day, whether for business, entertainment or education",
//     "In this course, we will learn the basic tools that every web page coder needs to know. We will start from the ground up by learning how to implement modern web pages with HTML and CSS. We will then advance to learning how to code our pages such that its components rearrange and resize themselves automatically based on the size of the user’s screen.	",
//     "Learn JavaScript, HTML, and CSS in this Frontend Web Development course. In this massive course, you will go from no coding experience to having the essential skills of a frontend web developer. You will learn various web development technologies and create a few projects along the way. ",
//     "This blog will cover the basics of html and css",
//     "This blog will help you with front end boilder plates and provide starter kits",
//     "This link will lead you to the wikipedia page for web development"
//   ];
//   final List<String> useLink = [
//     "https://youtu.be/nu_pCVPKzTk",
//     "https://www.coursera.org/learn/web-development",
//     "https://www.coursera.org/learn/html-css-javascript-for-web-developers",
//     "https://youtu.be/zJSY8tbf_ys",
//     "https://webdesign.tutsplus.com/articles/html-css-for-beginners-mega-free-course--cms-93199",
//     "https://youtu.be/zJSY8tbf_ys",
//     "https://webdesign.tutsplus.com/articles/html-css-for-beginners-mega-free-course--cms-93199",
//     "https://www.smashingmagazine.com/2021/06/useful-frontend-boilerplates-starter-kits/",
//     "https://en.wikipedia.org/wiki/Web_development#:~:text=Web%20development%20is%20the%20work%20involved%20in%20developing,web%20applications%2C%20electronic%20businesses%2C%20and%20social%20network%20services.",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Get.offNamed("/");
//               },
//               icon: Icon(Icons.arrow_back)),
//           title: Text("Web development course kit"),
//         ),
//         body: ListView.builder(
//             //padding:
//             //  const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
//             itemCount: useTitle.length,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 title: Text(useTitle[index]),
//                 subtitle: Text(useDescription[index]),
//                 leading: ElevatedButton(
//                     onPressed: () {
//                       _launchInBrowser(Uri.parse(useLink[index]));
//                     },
//                     child: Icon(Icons.link)),
//               );
//             }));
//   }
// }

// Future<void> _launchInBrowser(Uri url) async {
//   if (!await launchUrl(
//     url,
//     mode: LaunchMode.externalApplication,
//   )) {
//     throw Exception('Could not launch $url');
//   }
// }
