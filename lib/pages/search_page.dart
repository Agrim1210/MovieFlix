import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:MovieDetail_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const apiKey = 'c7a37ce9f0e2cc18f536e7a3ac6d3768';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController = TextEditingController();
  bool valueEntered = false;
  displayNoFilms() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              Icons.movie,
              color: Colors.grey,
              size: 200,
            ),
            Text(
              'Search For Users',
              style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  getSearchQuery() async {
    var url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=en-US&query=${_textEditingController.text}&include_adult=true';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<Movie> searchList = List<Movie>();
    for (var cinema in result['results']) {
      Movie movies = Movie(
          poster: cinema['poster_path'],
          title: cinema['title'],
          overview: cinema['overview'],
          // rating: double.parse(cinema['vote_average']),
          rating: 4.0,
          id: cinema['id'],
          origin: cinema['original_language'],
          original: cinema['original_title']);
      searchList.add(movies);
    }

    return searchList;
  }

  displayFilms() {
    return FutureBuilder(
      
        future: getSearchQuery(),
        builder: (BuildContext context, dataSnapshot) {
          if(!dataSnapshot.hasData){
            return Text('Loading');
          }
          return GridView.builder(
              itemCount: dataSnapshot.data.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(20),
                  height: 200,
                  child: Image(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${dataSnapshot.data[index].poster}'),
                    fit: BoxFit.cover,
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Search here....',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: Colors.blue,
            suffixIcon: RaisedButton.icon(
              onPressed: () {
                setState(() {
                  valueEntered = true;
                });
              },
              icon: Icon(Icons.search),
              label: Text('Search'),
            ),
          ),
        ),
      ),
      body: valueEntered == false ? displayNoFilms() : displayFilms(),
    );
  }
}
