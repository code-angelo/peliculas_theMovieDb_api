import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';
import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/src/widgets/card_swiper_widgets.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';



class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProviders();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){ //para implementar la busqueda
              showSearch(
                context: context, 
                delegate: DataSearch(), //uso de la clase abstracta de la busqueda
                query: '' // lo que va recibir el escribir en la busqueda
              );
            },
          )
        ],
      ),


      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround, //para ajustar los widgets entre ellos
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)

          ],
        ),
      )
    );
  }

  Widget _swiperTarjetas(){

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if(snapshot.hasData){
        return CardSwiper(
          peliculas: snapshot.data,
        );
        }else{
          return Container(
            padding: EdgeInsets.only(top: 100.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );


  }
  
  Widget _footer(BuildContext context){
    
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
            child: Text('populares', style: Theme.of(context).textTheme.subtitle1,)
            ),
          // SizedBox(height: 5.0,),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            // initialData: InitialData,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
                // snapshot.data?.forEach((p) => print(p.title));
              }else{
              return Center(child: CircularProgressIndicator());
              }
              

            },
          ),
        ],
      )
    );
  }

}