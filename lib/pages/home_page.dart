import 'dart:convert';
import 'package:MovieDetail_app/models/models.dart';
import 'package:MovieDetail_app/pages/genre_page.dart';
import 'package:MovieDetail_app/views/movie_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:MovieDetail_app/pages/genre_page.dart';

const apiKey = 'c7a37ce9f0e2cc18f536e7a3ac6d3768';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  getTrendingMovies() async {
    var url = 'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<Movie> trendingList = List<Movie>();
    for (var cinema in result['results']) {
      Movie movies = Movie(
          poster: cinema['poster_path'],
          title: cinema['title'],
          overview: cinema['overview'],
          id: cinema['id'],
          origin: cinema['original_language'],
          original: cinema['original_title']);
      trendingList.add(movies);
    }

    return trendingList;
  }

  getGenreList() async {
    var url =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey&language=en-US';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, top: 0),
              child: Text(
                'Trending Movies',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: FutureBuilder(
                  future: getTrendingMovies(),
                  builder: (BuildContext context, dataSnapshot) {
                    if (!dataSnapshot.hasData) {
                      return Text('Loading');
                    }
                    return CarouselSlider.builder(
                        itemCount: dataSnapshot.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MovieView(
                                  poster: dataSnapshot.data[index].poster,
                                  title: dataSnapshot.data[index].title,
                                  overview: dataSnapshot.data[index].overview,
                                  rating: dataSnapshot.data[index].rating,
                                  id: dataSnapshot.data[index].id,
                                  origin: dataSnapshot.data[index].origin,
                                  original: dataSnapshot.data[index].original),
                            )),
                            child: Container(
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              child: Hero(
                                tag: dataSnapshot.data[index].poster,
                                child: Image(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${dataSnapshot.data[index].poster}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                            height: 270,
                            viewportFraction: 0.8,
                            enableInfiniteScroll: true,
                            reverse: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 4),
                            autoPlayAnimationDuration:
                                Duration(microseconds: 800),
                            autoPlayCurve: Curves.easeIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal));
                  }),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: 'Action',
                ),
                Tab(
                  text: 'Comedy',
                ),
                Tab(
                  text: 'Crime',
                ),
                Tab(
                  text: 'Thriller',
                ),
                Tab(
                  text: 'Romance',
                ),
              ],
            ),
            SingleChildScrollView(
              child: Container(
                height: 200,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    GenrePage(id: '28'),
                    GenrePage(id: '35'),
                    GenrePage(id: '80'),
                    GenrePage(id: '53'),
                    GenrePage(id: '10749'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
