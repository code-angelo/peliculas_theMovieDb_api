import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});



  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size; //para obtener las dimensines del dispositivo.


    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context,int index){

          peliculas[index].idUnico = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].idUnico,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(                
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
                onTap: (){
                  Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
                },
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        // pagination: new SwiperPagination(), //para el indicador de la pagina (los puntitos)
        // control: new SwiperControl(), //las flechas de siguiente y anterior
      ),
    );
  }
}