import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CourseDetailsModel {
  String title;
  String course;
  String description;
  String link;
  //String description;
  //String title;
  //String link;

  CourseDetailsModel({
    //required this.courseId,
    //required this.authorName,
    //required this.uploadDate,
    required this.description,
    required this.title,
    required this.course,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      //'courseId': courseId,
      //'authorName': authorName,
      //'uploadDate': uploadDate,
      'description': description,
      'title': title,
      'course': course,
      'link': link,
    };
  }

  factory CourseDetailsModel.fromMap(Map<String, dynamic> map) {
    return CourseDetailsModel(
      //courseId: map['courseId'] as String,
      //authorName: map['authorName'] as String,
      //uploadDate: map['uploadDate'] as String,
      description: map['description'] as String,
      title: map['title'] as String,
      course: map['course'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseDetailsModel.fromJson(String source) =>
      CourseDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
