import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("What is \"All In\"?",
                    style: GoogleFonts.ibmPlexSans(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text(
                    "All In was created to help everyone better themselves, Lakeside, and the community. If you're interested in empowering lessons from guest speakers; becoming an ally for other students; and working to serve the community, remember All In.",
                    style: GoogleFonts.ibmPlexSans(fontSize: 18)),
                SizedBox(height: 12),
                Text("Who is All In for?",
                    style: GoogleFonts.ibmPlexSans(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text(
                    "History has shown us that, sometimes, placing all of our eggs in one basket is not the most effective way to lift up and help each other. Since we recognize that nobody has an easy life, having the empathy to support each other through difficult times is a core aspect of All In. For that reason, this group is designed to be for everyone.",
                    style: GoogleFonts.ibmPlexSans(fontSize: 18)),
                SizedBox(height: 12),
                Text("What does this app do for me?",
                    style: GoogleFonts.ibmPlexSans(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text(
                    "The All In app was designed by Luke Blevins during the COVID-19 pandemic as a way to bring the best of this group to as many people as possible. Having personally dealt with lack of motivation during the Learn from Home experience, Luke seeks to give students an easy way to realize their true potential with lessons directly from group leaders and other members of the community. Further, students now have an easy way to reach out anonymously to leaders they can trust.",
                    style: GoogleFonts.ibmPlexSans(fontSize: 18)),
                SizedBox(height: 12),
              ]),
          padding: EdgeInsets.all(12),
        ),
        physics: BouncingScrollPhysics());
  }
}
