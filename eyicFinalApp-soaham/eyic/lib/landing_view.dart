import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyic/screens/mentee/home_view/mentee_home_view.dart';
import 'package:eyic/screens/mentor/mentor_home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});
  //final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!.uid
        : "";
    //print(uid);
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.data != null) {
          return FutureBuilder(
            future: _userData(uid),
            builder: (context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasData) {
                final value = snapshot.data;
                if (value == "mentor") {
                  return const MentorDashboardView();
                } else {
                  return const MenteeDashboardView();
                }
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Invalid user, please try again"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            //Get.offNamed('/sign_in');
                            await FirebaseAuth.instance.signOut();
                          },
                          child: const Text("Sign Out"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              elevation: 100,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PROJECT_GURUKUL",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 30),
                    Text("Welcome to Project_Gurukul!",
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 14),
                    const Text(
                        "Please sign in or sign up to enter the platform"),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 128,
                          height: 32,
                          child: FilledButton(
                            onPressed: () {
                              Get.offNamed('/sign_in');
                            },
                            child: const Text("Sign In"),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          width: 128,
                          height: 32,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.offNamed('/sign_up');
                            },
                            child: const Text("Sign Up"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<String?> _userData(String? uid) async {
  if (uid == null || uid == "") return null;
  final data =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();
  if (data.exists) {
    if (data.data()!["role"] == "mentee") {
      return "mentee";
    }
    if (data.data()!["role"] == "mentor") {
      return "mentor";
    }
  } else {
    return null;
  }
}
