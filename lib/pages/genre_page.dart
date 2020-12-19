import 'dart:convert';

import 'package:MovieDetail_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = 'c7a37ce9f0e2cc18f536e7a3ac6d3768';

class GenrePage extends StatefulWidget {
  final String id;
  GenrePage({this.id});
  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  getGenre() async {
    var url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&with_genres=${widget.id}';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<Movie> genreList = List<Movie>();
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
      genreList.add(movies);
    }

    return genreList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getGenre(),
        builder: (BuildContext context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
                      return Text('Loading');
                    }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: dataSnapshot.data.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  padding: 
                  EdgeInsets.all(10),
                  height: 200,
                  child: Image(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${dataSnapshot.data[index].poster}',
                    ),fit: BoxFit.cover,
                  ),
                );
              });
        });
  }
}
