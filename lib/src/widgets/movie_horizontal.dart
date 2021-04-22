import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;
  
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );


  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener((){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent-200){

        siguientePagina();
      }
    });

    
    return Container(
      height: _screenSize.height*0.25,
      child: PageView.builder( // pageview renderisa tooodos los elementos que hay simultaneamente. | pageview.builder renderisa con forma vaya necesitado
        pageSnapping: false, //efecto magneto al hacer scroll
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i){
          return _tarjeta(context, peliculas[i]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){

    final _screenSize = MediaQuery.of(context).size;
    pelicula.idUnico = '${pelicula.id}-poster';

    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.idUnico,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: _screenSize.height*0.2,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

    return GestureDetector(
      child: tarjeta,
      onTap: (){
        // print('id de la pelicula ${pelicula.title}');
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
  // metodo sustituido por el de arriba
  List<Widget> _tarjetas(BuildContext context){

    final _screenSize = MediaQuery.of(context).size;

    return peliculas.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
              image: NetworkImage(pelicula.getPosterImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              fit: BoxFit.cover,
              height: _screenSize.height*0.2,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();

  }
}