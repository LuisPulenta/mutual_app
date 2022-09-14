import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mutual_app/components/loader_component.dart';
import 'package:mutual_app/helpers/api_helper.dart';
import 'package:mutual_app/helpers/constants.dart';
import 'package:mutual_app/models/models.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

class MisDatosScreen extends StatefulWidget {
  final Cliente user;
  const MisDatosScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MisDatosScreen> createState() => _MisDatosScreenState();
}

class _MisDatosScreenState extends State<MisDatosScreen>
    with SingleTickerProviderStateMixin {
//------------------- Variables -----------------------
  Color azul = const Color.fromARGB(255, 164, 166, 171);
  Color celeste = const Color(0xff1cd0e4);
  Color blanco = const Color.fromARGB(255, 210, 234, 233);

  Color azul1 = const Color.fromARGB(255, 26, 169, 247);

  TabController? _tabController;
  bool _showLoader = false;
  String _textComponent = '';
  int paraSincronizar = 0;

  bool _editar = false;
  String _datoEditar = '';
  String _datoEditarError = '';
  bool _datoEditarShowError = false;
  final TextEditingController _datoEditarController = TextEditingController();

  late Cliente _userEditar;

//------------------- initState -----------------------

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _userEditar = widget.user;
  }

//------------------- Pantalla -----------------------
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width * 0.94;
    double altoPantalla = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: celeste,
      appBar: AppBar(
        backgroundColor: azul1,
        title: const Text('Mis Datos'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Text(
                "Editar:",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Switch(
                  value: _editar,
                  activeColor: Color.fromARGB(255, 5, 238, 12),
                  inactiveThumbColor: Colors.grey,
                  onChanged: (value) {
                    _editar = value;
                    setState(() {});
                  }),
            ],
          ),
        ],
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
            _dato('Apellido Titular', _userEditar.apellidoTitular,
                anchoPantalla, 0, 0),
            _separacion(altoPantalla, 0.01),
            _dato('Nombre Titular', _userEditar.nombreTitular, anchoPantalla, 0,
                0),
            _separacion(altoPantalla, 0.01),
            _dato('Apellido', _userEditar.apellido, anchoPantalla, 0, 0),
            _separacion(altoPantalla, 0.01),
            _dato('Nombre', _userEditar.nombre, anchoPantalla, 0, 0),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato(
                    'Fecha Nacimiento',
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(_userEditar.fechaNacimiento!)),
                    anchoPantalla * 0.35,
                    1,
                    0),
                GestureDetector(
                  child: _dato('Lugar de Nacimiento',
                      _userEditar.lugarNacimiento!, anchoPantalla * 0.57, 0, 1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo(
                          'Lugar de Nacimiento', _userEditar.lugarNacimiento!);
                    }
                  },
                ),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            GestureDetector(
              child: _dato('Nacionalidad', _userEditar.nacionalidad!,
                  anchoPantalla, 0, 1),
              onTap: () async {
                if (_editar) {
                  await _editarCampo('Nacionalidad', _userEditar.nacionalidad!);
                }
              },
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato('Sexo', _userEditar.sexo!, anchoPantalla * 0.15, 1, 0),
                _dato('DNI', _userEditar.dni.toString(), anchoPantalla * 0.20,
                    1, 0),
                GestureDetector(
                  child: _dato(
                      'CUIL', _userEditar.cuil!, anchoPantalla * 0.45, 1, 1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo('CUIL', _userEditar.cuil!);
                    }
                  },
                ),
                _dato('Estado Civil', _userEditar.estadoCivil!,
                    anchoPantalla * 0.15, 1, 0),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            GestureDetector(
              child: _dato(
                  'Domicilio', _userEditar.domicilio!, anchoPantalla, 0, 1),
              onTap: () async {
                if (_editar) {
                  await _editarCampo('Domicilio', _userEditar.domicilio!);
                }
              },
            ),
            _separacion(altoPantalla, 0.01),
            GestureDetector(
              child: _dato('Barrio', _userEditar.barrio!, anchoPantalla, 0, 1),
              onTap: () async {
                if (_editar) {
                  await _editarCampo('Barrio', _userEditar.barrio!);
                }
              },
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: _dato('CP', _userEditar.cp.toString(),
                      anchoPantalla * 0.25, 1, 1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo('CP', _userEditar.cp.toString()!);
                    }
                  },
                ),
                GestureDetector(
                  child: _dato('Localidad', _userEditar.localidad!,
                      anchoPantalla * 0.67, 0, 1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo('Localidad', _userEditar.localidad!);
                    }
                  },
                ),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: _dato('Teléfono', _userEditar.telefono!,
                      anchoPantalla * 0.46, 1, 1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo('Teléfono', _userEditar.telefono!);
                    }
                  },
                ),
                GestureDetector(
                  child: _dato('Celular', _userEditar.celular!,
                      anchoPantalla * 0.46, 1, 1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo('Celular', _userEditar.celular!);
                    }
                  },
                ),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            GestureDetector(
              child: _dato(
                  'Correo',
                  _userEditar.email != null ? _userEditar.email! : '',
                  anchoPantalla,
                  0,
                  1),
              onTap: () async {
                if (_editar) {
                  await _editarCampo('Correo', _userEditar.email!);
                }
              },
            ),
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
            GestureDetector(
              child: _dato(
                  'Apellido Cónyuge',
                  _userEditar.apellidoConyuge == null
                      ? ''
                      : _userEditar.apellidoConyuge!,
                  anchoPantalla,
                  0,
                  1),
              onTap: () async {
                if (_editar) {
                  await _editarCampo(
                      'Apellido Cónyuge', _userEditar.apellidoConyuge!);
                }
              },
            ),
            _separacion(altoPantalla, 0.01),
            GestureDetector(
              child: _dato(
                  'Nombre Cónyuge',
                  _userEditar.nombreConyuge == null
                      ? ''
                      : _userEditar.nombreConyuge!,
                  anchoPantalla,
                  0,
                  1),
              onTap: () async {
                if (_editar) {
                  await _editarCampo(
                      'Nombre Cónyuge', _userEditar.nombreConyuge!);
                }
              },
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: _dato(
                      'Fecha Nacimiento',
                      _userEditar.fechaNacimientoConyuge == null
                          ? ''
                          : DateFormat('dd/MM/yyyy').format(DateTime.parse(
                              _userEditar.fechaNacimientoConyuge!)),
                      anchoPantalla * 0.35,
                      1,
                      1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo('Fecha Nacimiento',
                          _userEditar.fechaNacimientoConyuge!);
                    }
                  },
                ),
                GestureDetector(
                  child: _dato('DNI', _userEditar.dniConyuge.toString(),
                      anchoPantalla * 0.26, 0, 1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo(
                          'DNI', _userEditar.dniConyuge.toString()!);
                    }
                  },
                ),
                GestureDetector(
                  child: _dato(
                      'CUIL',
                      _userEditar.cuilConyuge == null
                          ? ''
                          : _userEditar.cuilConyuge!,
                      anchoPantalla * 0.29,
                      1,
                      1),
                  onTap: () async {
                    if (_editar) {
                      await _editarCampo('CUIL', _userEditar.cuilConyuge!);
                    }
                  },
                ),
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
            _dato('Categoría', _userEditar.categoria.toString(), anchoPantalla,
                0, 0),
            _separacion(altoPantalla, 0.01),
            GestureDetector(
              child: _dato('Servicio Especialidad',
                  _userEditar.servicioEspecialidad!, anchoPantalla, 0, 1),
              onTap: () async {
                if (_editar) {
                  await _editarCampo('Servicio Especialidad',
                      _userEditar.servicioEspecialidad!);
                }
              },
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato('Socio', _userEditar.socio! ? 'SI' : 'NO',
                    anchoPantalla * 0.15, 1, 0),
                _dato(
                    'N° Socio',
                    _userEditar.nroSocio != null
                        ? _userEditar.nroSocio.toString()
                        : '',
                    anchoPantalla * 0.30,
                    0,
                    0),
                _dato('N° Cuenta HP', _userEditar.nroCuentaHp!,
                    anchoPantalla * 0.47, 1, 0),
              ],
            ),
            _separacion(altoPantalla, 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dato(
                    'Fecha Alta',
                    _userEditar.fechaAlta == null
                        ? ''
                        : DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(_userEditar.fechaAlta!)),
                    anchoPantalla * 0.25,
                    1,
                    0),
                _dato(
                    'Fecha Jubilación',
                    _userEditar.fechaJubilacion != null
                        ? DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(_userEditar.fechaJubilacion!))
                        : '',
                    anchoPantalla * 0.30,
                    1,
                    0),
                _dato(
                    'Tipo Jubilación',
                    _userEditar.tipoJubilacion != null
                        ? _userEditar.tipoJubilacion!
                        : '',
                    anchoPantalla * 0.37,
                    1,
                    0),
              ],
            ),
            _separacion(altoPantalla, 0.01),
          ],
        ),
      ),
    );
  }

//------------------- _dato -----------------------
  Container _dato(
      String titulo, String dato, double ancho, int centrado, int editable) {
    Color azul = const Color.fromARGB(255, 113, 150, 244);
    Color celeste = const Color.fromARGB(255, 96, 216, 230);
    Color blanco = const Color.fromARGB(255, 225, 234, 234);

    double ancho1 = editable == 1 ? ancho : ancho;

    return Container(
      height: 50,
      width: ancho,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 24,
              width: ancho1,
              decoration: BoxDecoration(
                color: editable == 1 && _editar ? celeste : azul,
                border: Border.all(
                  color: Colors.black,
                  width: 0,
                ),
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
                      color: Color.fromARGB(255, 4, 4, 4),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: 26,
              width: ancho1,
              decoration: BoxDecoration(
                color: blanco,
                border: Border.all(
                  color: Colors.black,
                  width: 0,
                ),
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
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //------------------- _separacion -----------------------

  SizedBox _separacion(double altoPantalla, double porcentaje) {
    return SizedBox(
      height: altoPantalla * porcentaje,
    );
  }

//------------------- _editarCampo -----------------------

  _editarCampo(String titulo, String dato) async {
    _datoEditar = dato;
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "ATENCION!!",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Está por editar el campo",
                      style: TextStyle(color: azul1, fontSize: 16),
                    ),
                  ],
                ),
                content: SizedBox(
                  height: 130,
                  child: Column(
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(color: azul1, fontSize: 16),
                      ),
                      const Text(""),
                      TextFormField(
                        initialValue: _datoEditar,
                        onChanged: (value) {
                          _datoEditar = value;
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: titulo,
                            labelText: titulo,
                            errorText:
                                _datoEditarShowError ? _datoEditarError : null,
                            prefixIcon: const Icon(Icons.edit),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.save),
                        SizedBox(
                          width: 15,
                        ),
                        Text('Guardar'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: azul1,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => _save(titulo, _datoEditar),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cancel),
                        SizedBox(
                          width: 15,
                        ),
                        Text('Cancelar'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: celeste,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
                shape: Border.all(
                    color: azul1, width: 5, style: BorderStyle.solid),
                backgroundColor: Colors.white,
              );
            },
          );
        });
  }

//------------------- _save -----------------------

  void _save(String titulo, String dato) {
    FocusScope.of(context).unfocus(); //Oculta el teclado
    if (!validateFields(titulo, dato)) {
      return;
    }
    _saveRecord();
  }

//------------------- validateFields -----------------------

  bool validateFields(String titulo, String dato) {
    bool isValid = true;

    //-------- Lugar de nacimiento --------
    if (titulo == 'Lugar de Nacimiento') {
      if (dato.length > 25) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 25 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.lugarNacimiento = dato.toUpperCase();
      }
    }

    //-------- Nacionalidad --------
    if (titulo == 'Nacionalidad') {
      if (dato.length > 20) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 20 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.nacionalidad = dato.toUpperCase();
      }
    }

    //-------- CUIL --------
    if (titulo == 'CUIL') {
      if (dato.length > 20) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 20 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.cuil = dato.toUpperCase();
      }
    }

    //-------- Domicilio --------
    if (titulo == 'Domicilio') {
      if (dato.length > 70) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 70 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.domicilio = dato.toUpperCase();
      }
    }

    //-------- Domicilio --------
    if (titulo == 'Barrio') {
      if (dato.length > 50) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 50 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.barrio = dato.toUpperCase();
      }
    }

    //-------- CP --------
    if (titulo == 'CP') {
      if (dato.length > 50) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 50 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.cp = dato as int;
      }
    }

    //-------- Localidad --------
    if (titulo == 'Localidad') {
      if (dato.length > 25) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 25 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.localidad = dato.toUpperCase();
      }
    }

    //-------- Teléfono --------
    if (titulo == 'Teléfono') {
      if (dato.length > 20) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 20 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.telefono = dato.toUpperCase();
      }
    }

    //-------- Celular --------
    if (titulo == 'Celular') {
      if (dato.length > 20) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 20 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.celular = dato.toUpperCase();
      }
    }

    //-------- Correo --------
    if (titulo == 'Correo') {
      if (dato.length > 50) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 50 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.email = dato.toUpperCase();
      }
    }

    //-------- Apellido Cónyuge --------
    if (titulo == 'Apellido Cónyuge') {
      if (dato.length > 25) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 25 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.apellidoConyuge = dato.toUpperCase();
      }
    }

    //-------- Nombre Cónyuge --------
    if (titulo == 'Nombre Cónyuge') {
      if (dato.length > 30) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 30 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.nombreConyuge = dato.toUpperCase();
      }
    }

    //-------- Fecha Nacimiento --------
    if (titulo == 'Fecha Nacimiento') {
      if (dato.length > 30) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 30 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.fechaNacimientoConyuge = dato.toUpperCase();
      }
    }

    //-------- DNI --------
    if (titulo == 'DNI') {
      if (dato.length > 30) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 30 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.dniConyuge = dato as int;
      }
    }

    //-------- CUIL --------
    if (titulo == 'CUIL') {
      if (dato.length > 20) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 20 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.cuilConyuge = dato.toUpperCase();
      }
    }

    //-------- Servicio Especialidad --------
    if (titulo == 'Servicio Especialidad') {
      if (dato.length > 30) {
        showAlertDialog(
            context: context,
            title: 'Error',
            message: 'No debe superar los 30 caracteres',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        isValid = false;
      } else {
        _userEditar.servicioEspecialidad = dato.toUpperCase();
      }
    }

    setState(() {});

    return isValid;
  }

//------------------- _saveRecord -----------------------

  _saveRecord() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Id': _userEditar.id,
      'ApellidoTitular': _userEditar.apellidoTitular,
      'NombreTitular': _userEditar.nombreTitular,
      'Apellido': _userEditar.apellido,
      'Nombre': _userEditar.nombre,
      'Dni': _userEditar.dni,
      'Cuil': _userEditar.cuil,
      'Sexo': _userEditar.sexo,
      'FechaNacimiento': _userEditar.fechaNacimiento,
      'FechaFallecimiento': _userEditar.fechaFallecimiento,
      'EstadoCivil': _userEditar.estadoCivil,
      'LugarNacimiento': _userEditar.lugarNacimiento,
      'Nacionalidad': _userEditar.nacionalidad,
      'Domicilio': _userEditar.domicilio,
      'Barrio': _userEditar.barrio,
      'Localidad': _userEditar.localidad,
      'Cp': _userEditar.cp,
      'Telefono': _userEditar.telefono,
      'Celular': _userEditar.celular,
      'Email': _userEditar.email,
      'ApellidoConyuge': _userEditar.apellidoConyuge,
      'NombreConyuge': _userEditar.nombreConyuge,
      'DniConyuge': _userEditar.dniConyuge,
      'CuilConyuge': _userEditar.cuilConyuge,
      'FechaNacimientoConyuge': _userEditar.fechaNacimientoConyuge,
      'FechaFallecimientoConyuge': _userEditar.fechaFallecimientoConyuge,
      'Categoria': _userEditar.categoria,
      'Socio': _userEditar.socio,
      'FechaCarga': _userEditar.fechaCarga,
      'FechaAlta': _userEditar.fechaAlta,
      'FechaBaja': _userEditar.fechaBaja,
      'MotivoBaja': _userEditar.motivoBaja,
      'NroSocio': _userEditar.nroSocio,
      'NroCuentaHp': _userEditar.nroCuentaHp,
      'TipoJubilacion': _userEditar.tipoJubilacion,
      'FechaJubilacion': _userEditar.fechaJubilacion,
      'ServicioEspecialidad': _userEditar.servicioEspecialidad,
      'AfSeguroTit': _userEditar.afSeguroTit,
      'AfSeguroCony': _userEditar.afSeguroCony,
      'TrabHp': _userEditar.trabHp,
      'TrabFuera': _userEditar.trabFuera,
      'LugarTrab': _userEditar.lugarTrab,
      'SegEnf': _userEditar.segEnf,
      'SegAcc': _userEditar.segAcc,
      'Beneficio1': _userEditar.beneficio1,
      'Supervivencia': _userEditar.supervivencia,
      'FecPagoSepTitular': _userEditar.fecPagoSepTitular,
      'EgresoPagoSepTitular': _userEditar.egresoPagoSepTitular,
      'MontoPagoSepTitular': _userEditar.montoPagoSepTitular,
      'FecPagoSepConyuge': _userEditar.fecPagoSepConyuge,
      'EgresoPagoSepConyuge': _userEditar.egresoPagoSepConyuge,
      'MontoPagoSepConyuge': _userEditar.montoPagoSepConyuge,
      'FecPagoSegEnf': _userEditar.fecPagoSegEnf,
      'EgresoPagoSegEnf': _userEditar.egresoPagoSegEnf,
      'MontoPagoSegEnf': _userEditar.montoPagoSegEnf,
      'PlanSegEnf': _userEditar.planSegEnf,
      'ObsSegEnfAcc': _userEditar.obsSegEnfAcc,
      'ClaveApp': _userEditar.claveApp,
    };

    Response response = await ApiHelper.put(
        '/api/Clientes/', _userEditar.id.toString(), request);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    } else {
      // await showAlertDialog(
      //     context: context,
      //     title: 'Aviso',
      //     message: 'Guardado con éxito!',
      //     actions: <AlertDialogAction>[
      //       const AlertDialogAction(key: null, label: 'Aceptar'),
      //     ]);
      Navigator.pop(context, 'yes');
      //_cargarUsuario();
    }
  }
  //--------------------- _cargarUsuario ---------------------

  void _cargarUsuario() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Dni': _userEditar.dni,
      'ClaveApp': _userEditar.claveApp,
    };

    var url = Uri.parse('${Constants.apiUrl}/API/Clientes/GetUserByDocument');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var user = Cliente.fromJson(decodedJson);

    _userEditar = user;
    setState(() {});
  }
}
