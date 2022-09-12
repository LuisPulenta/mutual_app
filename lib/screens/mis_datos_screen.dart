import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mutual_app/components/loader_component.dart';
import 'package:mutual_app/models/models.dart';
import 'package:flutter/gestures.dart';

class MisDatosScreen extends StatefulWidget {
  final Cliente user;
  MisDatosScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MisDatosScreen> createState() => _MisDatosScreenState();
}

class _MisDatosScreenState extends State<MisDatosScreen>
    with SingleTickerProviderStateMixin {
//------------------- Variables -----------------------
  Color azul = Color.fromARGB(255, 34, 34, 175);
  Color celeste = const Color(0xff1cd0e4);
  Color blanco = Color.fromARGB(255, 210, 234, 233);

  TabController? _tabController;
  bool _showLoader = false;
  String _textComponent = '';
  int paraSincronizar = 0;

//------------------- initState -----------------------

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

//------------------- Pantalla -----------------------
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    double altoPantalla = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: celeste,
      appBar: AppBar(
        backgroundColor: azul,
        title: const Text('Mis Datos'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(
                    (0xffdadada),
                  ),
                  Color(
                    (0xffb3b3b4),
                  ),
                ],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              physics: const AlwaysScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: <Widget>[
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                SingleChildScrollView(
                    child: _datosPersonales(anchoPantalla, altoPantalla)),
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                SingleChildScrollView(
                    child: _datosFamiliares(anchoPantalla, altoPantalla)),

//-------------------------------------------------------------------------
//-------------------------- 3° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                SingleChildScrollView(
                    child: _datosAfiliacion(anchoPantalla, altoPantalla)),
              ],
            ),
          ),
          Center(
            child: _showLoader
                ? LoaderComponent(text: _textComponent)
                : Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: paraSincronizar > 0
            ? const Color.fromARGB(255, 219, 8, 5)
            : Colors.white,
        child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xff282886),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            labelColor: const Color(0xff282886),
            unselectedLabelColor:
                paraSincronizar > 0 ? Colors.white : Colors.grey,
            labelPadding: const EdgeInsets.all(10),
            tabs: <Widget>[
              Tab(
                child: Column(
                  children: const [
                    Icon(Icons.person),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Personales",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(Icons.groups),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Familiares",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(Icons.local_hospital),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Afiliación",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

//------------------- _datosPersonales -----------------------
  SingleChildScrollView _datosPersonales(
      double anchoPantalla, double altoPantalla) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _dato('Apellido Titular', widget.user.apellidoTitular,
                anchoPantalla, 0),
            _separacion(altoPantalla, 0.01),
            _dato(
                'Nombre Titular', widget.user.nombreTitular, anchoPantalla, 0),
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
            _dato('Nacionalidad', widget.user.nacionalidad!, anchoPantalla, 0),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato('Sexo', widget.user.sexo!, anchoPantalla * 0.15, 1),
                _dato(
                    'DNI', widget.user.dni.toString(), anchoPantalla * 0.20, 1),
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
                _dato('CP', widget.user.cp.toString(), anchoPantalla * 0.15, 1),
                _dato('Localidad', widget.user.localidad!, anchoPantalla * 0.77,
                    0),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato(
                    'Teléfono', widget.user.telefono!, anchoPantalla * 0.46, 1),
                _dato('Celular', widget.user.celular!, anchoPantalla * 0.46, 1),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            _dato('Correo', widget.user.email != null ? widget.user.email! : '',
                anchoPantalla, 0),
          ],
        ),
      ),
    );
  }

  //------------------- _datosFamiliares -----------------------
  SingleChildScrollView _datosFamiliares(
      double anchoPantalla, double altoPantalla) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _dato('Apellido Cónyuge', widget.user.apellidoConyuge!,
                anchoPantalla, 0),
            _separacion(altoPantalla, 0.01),
            _dato(
                'Nombre Cónyuge', widget.user.nombreConyuge!, anchoPantalla, 0),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato(
                    'Fecha Nacimiento',
                    DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(widget.user.fechaNacimientoConyuge!)),
                    anchoPantalla * 0.35,
                    1),
                _dato('DNI', widget.user.dniConyuge.toString(),
                    anchoPantalla * 0.26, 0),
                _dato(
                    'CUIL', widget.user.cuilConyuge!, anchoPantalla * 0.29, 1),
              ],
            ),
            _separacion(altoPantalla, 0.01),
          ],
        ),
      ),
    );
  }

  //------------------- _datosAfiliacion -----------------------
  SingleChildScrollView _datosAfiliacion(
      double anchoPantalla, double altoPantalla) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _dato('Categoría', widget.user.categoria.toString(), anchoPantalla,
                0),
            _separacion(altoPantalla, 0.01),
            _dato('Servicio Especialidad.', widget.user.servicioEspecialidad!,
                anchoPantalla, 0),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato('Socio', widget.user.socio! ? 'SI' : 'NO',
                    anchoPantalla * 0.15, 1),
                _dato(
                    'N° Socio',
                    widget.user.nroSocio != null
                        ? widget.user.nroSocio.toString()
                        : '',
                    anchoPantalla * 0.30,
                    0),
                _dato('N° Cuenta HP', widget.user.nroCuentaHp!,
                    anchoPantalla * 0.47, 1),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato(
                    'Fecha Alta',
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(widget.user.fechaAlta!)),
                    anchoPantalla * 0.25,
                    1),
                _dato(
                    'Fecha Jubilación',
                    widget.user.fechaJubilacion != null
                        ? DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(widget.user.fechaJubilacion!))
                        : '',
                    anchoPantalla * 0.30,
                    1),
                _dato(
                    'Tipo Jubilación',
                    widget.user.tipoJubilacion != null
                        ? widget.user.tipoJubilacion!
                        : '',
                    anchoPantalla * 0.37,
                    1),
              ],
            ),
            _separacion(altoPantalla, 0.01),
          ],
        ),
      ),
    );
  }

//------------------- _dato -----------------------
  Center _dato(String titulo, String dato, double ancho, int centrado) {
    Color azul = const Color.fromARGB(255, 34, 34, 175);

    Color celeste = const Color(0xff1cd0e4);

    Color blanco = Color.fromARGB(255, 210, 234, 233);

    return Center(
        child: Column(
      children: [
        Container(
          height: 24,
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
                  color: Color.fromARGB(255, 210, 234, 233),
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
