import 'package:MovieDetail_app/pages/home_page.dart';
import 'package:MovieDetail_app/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int pageIndex = 0;
  var pageOption = [HomePage(),SearchPage() ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MovieFlix',style: GoogleFonts.satisfy(fontSize: 50,color: Colors.black87,fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
        ],
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
      body: pageOption[pageIndex],
    );
  }
}
