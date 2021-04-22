// el metodo para hacer una busqueda se puede implementar en cualquier apliaciones de igual manera

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';


class DataSearch extends SearchDelegate{

  final peliculasProvider = new PeliculasProviders();


  String seleccion = '';
  final peliculas = [
    'Avatar',
    'John Wick',
    '007',
    'batman',
    'Piratas del caribe',
    'Valerian',
    'MIB',
  ];

  final peliculasRecientes = [
    'John Wick 3',
    'Marvel',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // las accionde de nuuestro AppBar (limpiar o cancelar busqueda)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = ''; //el boton para limpiar el texto
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        color: Colors.red,
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        child: Text(seleccion),
        color: Colors.deepOrangeAccent,
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen cuando la persona escribe

    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {

        if(snapshot.hasData){

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  height: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text('Votos promedio: '+pelicula.voteAverage.toString()),
                onTap: (){
                  close(context, null);
                  pelicula.idUnico = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList()
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }
  // @override FUE USADO PARA PRUEBAS DE BUSQUEDAS DE LISTAS LOCAL
  // Widget buildSuggestions(BuildContext context) {
  //   // son las sugerencias que aparecen cuando la persona escribe

  // final listaSugerida = (query.isEmpty)
  //                                       ? peliculasRecientes 
  //                                       : peliculas.where(
  //                                         (p) => p.toLowerCase().startsWith(query.toLowerCase())
  //                                         ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i){
  //       return ListTile(
  //         leading: Icon(Icons.local_movies),
  //         title: Text(listaSugerida[i]),
  //         onTap: (){
  //           seleccion = listaSugerida[i];
  //           showResults(context); //este metodo construye los resultados
  //         },
  //       );
  //     },
  //   );
  // }

}