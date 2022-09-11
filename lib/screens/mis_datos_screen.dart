import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mutual_app/models/models.dart';

class MisDatosScreen extends StatefulWidget {
  final Cliente user;
  MisDatosScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MisDatosScreen> createState() => _MisDatosScreenState();
}

class _MisDatosScreenState extends State<MisDatosScreen> {
  //------------------- Variables -----------------------
  Color azul = const Color(0xff0404fc);

  Color celeste = const Color(0xff1cd0e4);

  Color blanco = Colors.white;

//------------------- Pantalla -----------------------
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    double altoPantalla = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azul,
        title: const Text('Mis Datos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _dato('Apellido Titular', widget.user.apellidoTitular,
                  anchoPantalla, 0),
              _separacion(altoPantalla, 0.01),
              _dato('Nombre Titular', widget.user.nombreTitular, anchoPantalla,
                  0),
              _separacion(altoPantalla, 0.01),
              _dato('Apellido', widget.user.apellido, anchoPantalla, 0),
              _separacion(altoPantalla, 0.01),
              _dato('Nombre', widget.user.nombre, anchoPantalla, 0),
              _separacion(altoPantalla, 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dato(
                      'Fecha Nacimiento',
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(widget.user.fechaNacimiento!)),
                      anchoPantalla * 0.35,
                      1),
                  _dato('Lugar de Nacimiento', widget.user.lugarNacimiento!,
                      anchoPantalla * 0.57, 0),
                ],
              ),
              _separacion(altoPantalla, 0.01),
              _dato(
                  'Nacionalidad', widget.user.nacionalidad!, anchoPantalla, 0),
              _separacion(altoPantalla, 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dato('Sexo', widget.user.sexo!, anchoPantalla * 0.15, 1),
                  _dato('DNI', widget.user.dni.toString(), anchoPantalla * 0.20,
                      1),
                  _dato('CUIL', widget.user.cuil!, anchoPantalla * 0.30, 1),
                  _dato('Estado Civil', widget.user.estadoCivil!,
                      anchoPantalla * 0.15, 1),
                ],
              ),
              _separacion(altoPantalla, 0.01),
              _dato('Domicilio', widget.user.domicilio!, anchoPantalla, 0),
              _separacion(altoPantalla, 0.01),
              _dato('Barrio', widget.user.barrio!, anchoPantalla, 0),
              _separacion(altoPantalla, 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dato(
                      'CP', widget.user.cp.toString(), anchoPantalla * 0.15, 1),
                  _dato('Localidad', widget.user.localidad!,
                      anchoPantalla * 0.77, 0),
                ],
              ),
              _separacion(altoPantalla, 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dato('Teléfono', widget.user.telefono!, anchoPantalla * 0.46,
                      1),
                  _dato(
                      'Celular', widget.user.celular!, anchoPantalla * 0.46, 1),
                ],
              ),
              _separacion(altoPantalla, 0.01),
              _dato(
                  'Correo',
                  widget.user.email != null ? widget.user.email! : '',
                  anchoPantalla,
                  0),
            ],
          ),
        ),
      ),
    );
  }

//------------------- _dato -----------------------
  Center _dato(String titulo, String dato, double ancho, int centrado) {
    return Center(
        child: Column(
      children: [
        Container(
          height: 22,
          width: ancho,
          decoration: BoxDecoration(
            color: azul,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ),
        Container(
          height: 26,
          width: ancho,
          decoration: BoxDecoration(
            color: blanco,
            border: Border.all(),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text(
              dato,
              textAlign: centrado == 0 ? TextAlign.left : TextAlign.center,
              style: TextStyle(
                  color: azul, fontWeight: FontWeight.w300, fontSize: 12),
            ),
          ),
        ),
      ],
    ));
  }
  //------------------- _separacion -----------------------

  SizedBox _separacion(double altoPantalla, double porcentaje) {
    return SizedBox(
      height: altoPantalla * porcentaje,
    );
  }
}
