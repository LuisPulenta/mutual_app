import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mutual_app/models/models.dart';
import 'package:mutual_app/screens/screens.dart';
import 'package:mutual_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Cliente user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//------------------- Variables -----------------------

  Color azul = const Color(0xff0404fc);
  Color celeste = const Color(0xff1cd0e4);
  Color blanco = Colors.white;

//------------------- initState -----------------------

  @override
  void initState() {
    super.initState();
  }

//------------------- Pantalla -----------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutual App'),
        centerTitle: true,
        backgroundColor: azul,
      ),
      body: _getBody(),
    );
  }

//------------------- _getBody -----------------------
  Widget _getBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffffffff),
            Color.fromARGB(255, 113, 217, 244),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Logo(),
          Text(
            //'Bienvenido/a ${widget.user.catCodigo}',
            'Bienvenido/a',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: azul),
          ),
          Text(
            //'Bienvenido/a ${widget.user.catCodigo}',
            '${widget.user.nombreTitular} ${widget.user.apellidoTitular}',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: azul),
          ),
          Divider(
            color: azul,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MisDatosScreen(
                    user: widget.user,
                  ),
                ),
              );
            },
            child: BotonGordo(
              icon: Icons.mood,
              texto: 'Mis datos',
              color1: azul,
              color2: celeste,
              onPress: () {},
            ),
          ),
          BotonGordo(
            icon: Icons.paid,
            texto: 'Aportes',
            color1: celeste,
            color2: azul,
            onPress: () {},
          ),
          BotonGordo(
            icon: Icons.request_quote,
            texto: 'Retenciones',
            color1: azul,
            color2: celeste,
            onPress: () {},
          ),
          BotonGordo(
            icon: Icons.local_atm,
            texto: 'Mi Jubilación',
            color1: celeste,
            color2: azul,
            onPress: () {},
          ),
          GestureDetector(
            onTap: _logOut,
            child: BotonGordo(
              icon: Icons.exit_to_app,
              texto: 'Cerrar sesión',
              color1: azul,
              color2: celeste,
              onPress: () {},
            ),
          ),
        ],
      ),
    );
  }

//------------------- _logOut -----------------------

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');

    var connectivityResult = await Connectivity().checkConnectivity();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
