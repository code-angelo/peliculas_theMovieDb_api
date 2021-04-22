import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';


class PeliculaDetalle extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _crearCasting(pelicula),
              ]
            ),
          )
        ],
      )
    );
  }

  Widget _crearAppbar(Pelicula pelicula){

    return SliverAppBar(
      elevation: 10.0,
      backgroundColor: Colors.red,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      // snap: true, solo funciona con floating
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title, style: TextStyle(color: Colors.white, fontSize: 16.0),),
        background: FadeInImage(
          image: NetworkImage(pelicula.gestBackgroundImg() ),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.idUnico,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 10.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle2, overflow: TextOverflow.ellipsis,),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, ),
                    Text(pelicula.voteAverage.toString())
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _descripcion(Pelicula pelicula){
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }


  Widget _crearCasting(Pelicula pelicula){
    
    final peliProvider = new PeliculasProviders();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      // initialData: InitialData, quitar para manejar un loading mientras carga
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return _crearActoresPageview(snapshot.data);
        }else{
        return Center(
          child: CircularProgressIndicator(),
        );
        }
      },
    );
  }

  Widget _crearActoresPageview(List<Actor> actores){

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemCount: actores.length,
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.3
        ),
        itemBuilder: (context, i) => _actorTarjeta(actores[i])
      ),
    );


  }


  Widget _actorTarjeta(Actor actor){

    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              image: NetworkImage( actor.getFoto() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name),
        ],
      ),
    );


  }

}