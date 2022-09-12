import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:mutual_app/helpers/constants.dart';
import 'package:mutual_app/components/loader_component.dart';
import 'package:mutual_app/models/models.dart';
import 'package:mutual_app/screens/screens.dart';
import 'package:mutual_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//------------------- Variables -----------------------

  //String _email = '';
  String _email = '12670579';
  String _emailError = '';
  bool _emailShowError = false;

  //String _password = '';
  String _password = '123456';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;

  bool _passwordShow = false;

  bool _showLoader = false;

  Color azul = const Color.fromARGB(255, 34, 34, 175);
  Color celeste = const Color(0xff1cd0e4);
  Color blanco = Colors.white;

//------------------- Pantalla -----------------------

  @override
  Widget build(BuildContext context) {
    double altoPantalla = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 0),
              color: Colors.white,
              child: Column(
                children: [
                  _separacion(altoPantalla, 0.1),
                  const Logo(),
                  _titulo(),
                  _version(),
                  _separacion(altoPantalla, 0.05),
                  Divider(
                    color: azul,
                  ),
                ],
              )),
          _card(),
          _separacion(altoPantalla, 0.05),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//------------------- _Titulo -----------------------

  Padding _titulo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'MUTUAL DE MEDICOS Y DE PERSONAL JERARQUICO DEL HOSPITAL PRIVADO',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: azul, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

//------------------- _Version -----------------------

  Text _version() {
    return Text(
      Constants.version,
      style: TextStyle(fontSize: 14, color: azul),
    );
  }

//------------------- _card -----------------------

  Transform _card() {
    return Transform.translate(
      offset: const Offset(0, -60),
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            color: celeste,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 15,
            margin: const EdgeInsets.only(
                left: 20, right: 20, top: 260, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _showEmail(),
                  _showPassword(),
                  const SizedBox(
                    height: 10,
                  ),
                  _showRememberme(),
                  _showButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//------------------- _separacion -----------------------

  SizedBox _separacion(double altoPantalla, double porcentaje) {
    return SizedBox(
      height: altoPantalla * porcentaje,
    );
  }

//--------------------- _showEmail --------------------------

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Usuario...',
            labelText: 'Usuario',
            errorText: _emailShowError ? _emailError : null,
            prefixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

//--------------------- _showPassword --------------------------

  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
            fillColor: blanco,
            filled: true,
            hintText: 'Contraseña...',
            labelText: 'Contraseña',
            errorText: _passwordShowError ? _passwordError : null,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: _passwordShow
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordShow = !_passwordShow;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

//--------------------- _showRememberme ---------------------

  _showRememberme() {
    return CheckboxListTile(
      title: const Text(
        'Recordarme:',
        style: TextStyle(
          color: Color(0xff0404fc),
        ),
      ),
      value: _rememberme,
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

//--------------------- _showButtons ---------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Iniciar Sesión'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: azul,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _login(),
            ),
          ),
        ],
      ),
    );
  }

//--------------------- _login ---------------------

  void _login() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado

    setState(() {
      _passwordShow = false;
    });

    if (!validateFields()) {
      return;
    }

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
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Dni': _email,
      'ClaveApp': _password,
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

    if (response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
        _showLoader = false;
      });
      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var user = Cliente.fromJson(decodedJson);

    if (user.claveApp!.toLowerCase() != _password.toLowerCase()) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
      });
      return;
    }

    if (_rememberme) {
      _storeUser(body);
    }

    // Agregar registro a  websesion

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  user: user,
                )));
  }

//--------------------- validateFields ---------------------

  bool validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Usuario';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu Contraseña';
    } else if (_password.length < 6) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'La Contraseña debe tener al menos 6 caracteres';
    } else {
      _passwordShowError = false;
    }

    setState(() {});

    return isValid;
  }

  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
    await prefs.setString('date', DateTime.now().toString());
  }
}
