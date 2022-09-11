class Cliente {
  int id = 0;
  String apellidoTitular = '';
  String nombreTitular = '';
  String apellido = '';
  String nombre = '';
  int dni = 0;
  String? cuil = '';
  String? sexo = '';
  String? fechaNacimiento = '';
  String? fechaFallecimiento = '';
  String? estadoCivil = '';
  String? lugarNacimiento = '';
  String? nacionalidad = '';
  String? domicilio = '';
  String? barrio = '';
  String? localidad = '';
  int? cp = 0;
  String? telefono = '';
  String? celular = '';
  String? email = '';
  String? apellidoConyuge = '';
  String? nombreConyuge = '';
  int? dniConyuge = 0;
  String? cuilConyuge = '';
  String? fechaNacimientoConyuge = '';
  String? fechaFallecimientoConyuge = '';
  int? categoria = 0;
  bool? socio = false;
  String? fechaCarga = '';
  String? fechaAlta = '';
  String? fechaBaja = '';
  String? motivoBaja = '';
  String? nroSocio = '';
  String? nroCuentaHp = '';
  String? tipoJubilacion = '';
  String? fechaJubilacion = '';
  String? servicioEspecialidad = '';
  bool? afSeguroTit = false;
  bool? afSeguroCony = false;
  bool? trabHp = false;
  bool? trabFuera = false;
  String? lugarTrab = '';
  bool? segEnf = false;
  bool? segAcc = false;
  bool? beneficio1 = false;
  String? supervivencia = '';
  String? fecPagoSepTitular = '';
  String? egresoPagoSepTitular = '';
  double? montoPagoSepTitular = 0;
  String? fecPagoSepConyuge = '';
  String? egresoPagoSepConyuge = '';
  String? montoPagoSepConyuge = '';
  String? fecPagoSegEnf = '';
  String? egresoPagoSegEnf = '';
  double? montoPagoSegEnf = 0;
  String? planSegEnf = '';
  String? obsSegEnfAcc = '';
  String? claveApp = '';

  Cliente(
      {required this.id,
      required this.apellidoTitular,
      required this.nombreTitular,
      required this.apellido,
      required this.nombre,
      required this.dni,
      required this.cuil,
      required this.sexo,
      required this.fechaNacimiento,
      required this.fechaFallecimiento,
      required this.estadoCivil,
      required this.lugarNacimiento,
      required this.nacionalidad,
      required this.domicilio,
      required this.barrio,
      required this.localidad,
      required this.cp,
      required this.telefono,
      required this.celular,
      required this.email,
      required this.apellidoConyuge,
      required this.nombreConyuge,
      required this.dniConyuge,
      required this.cuilConyuge,
      required this.fechaNacimientoConyuge,
      required this.fechaFallecimientoConyuge,
      required this.categoria,
      required this.socio,
      required this.fechaCarga,
      required this.fechaAlta,
      required this.fechaBaja,
      required this.motivoBaja,
      required this.nroSocio,
      required this.nroCuentaHp,
      required this.tipoJubilacion,
      required this.fechaJubilacion,
      required this.servicioEspecialidad,
      required this.afSeguroTit,
      required this.afSeguroCony,
      required this.trabHp,
      required this.trabFuera,
      required this.lugarTrab,
      required this.segEnf,
      required this.segAcc,
      required this.beneficio1,
      required this.supervivencia,
      required this.fecPagoSepTitular,
      required this.egresoPagoSepTitular,
      required this.montoPagoSepTitular,
      required this.fecPagoSepConyuge,
      required this.egresoPagoSepConyuge,
      required this.montoPagoSepConyuge,
      required this.fecPagoSegEnf,
      required this.egresoPagoSegEnf,
      required this.montoPagoSegEnf,
      required this.planSegEnf,
      required this.obsSegEnfAcc,
      required this.claveApp});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apellidoTitular = json['apellidoTitular'];
    nombreTitular = json['nombreTitular'];
    apellido = json['apellido'];
    nombre = json['nombre'];
    dni = json['dni'];
    cuil = json['cuil'];
    sexo = json['sexo'];
    fechaNacimiento = json['fechaNacimiento'];
    fechaFallecimiento = json['fechaFallecimiento'];
    estadoCivil = json['estadoCivil'];
    lugarNacimiento = json['lugarNacimiento'];
    nacionalidad = json['nacionalidad'];
    domicilio = json['domicilio'];
    barrio = json['barrio'];
    localidad = json['localidad'];
    cp = json['cp'];
    telefono = json['telefono'];
    celular = json['celular'];
    email = json['email'];
    apellidoConyuge = json['apellidoConyuge'];
    nombreConyuge = json['nombreConyuge'];
    dniConyuge = json['dniConyuge'];
    cuilConyuge = json['cuilConyuge'];
    fechaNacimientoConyuge = json['fechaNacimientoConyuge'];
    fechaFallecimientoConyuge = json['fechaFallecimientoConyuge'];
    categoria = json['categoria'];
    socio = json['socio'];
    fechaCarga = json['fechaCarga'];
    fechaAlta = json['fechaAlta'];
    fechaBaja = json['fechaBaja'];
    motivoBaja = json['motivoBaja'];
    nroSocio = json['nroSocio'];
    nroCuentaHp = json['nroCuentaHp'];
    tipoJubilacion = json['tipoJubilacion'];
    fechaJubilacion = json['fechaJubilacion'];
    servicioEspecialidad = json['servicioEspecialidad'];
    afSeguroTit = json['afSeguroTit'];
    afSeguroCony = json['afSeguroCony'];
    trabHp = json['trabHp'];
    trabFuera = json['trabFuera'];
    lugarTrab = json['lugarTrab'];
    segEnf = json['segEnf'];
    segAcc = json['segAcc'];
    beneficio1 = json['beneficio1'];
    supervivencia = json['supervivencia'];
    fecPagoSepTitular = json['fecPagoSepTitular'];
    egresoPagoSepTitular = json['egresoPagoSepTitular'];
    montoPagoSepTitular = json['montoPagoSepTitular'];
    fecPagoSepConyuge = json['fecPagoSepConyuge'];
    egresoPagoSepConyuge = json['egresoPagoSepConyuge'];
    montoPagoSepConyuge = json['montoPagoSepConyuge'];
    fecPagoSegEnf = json['fecPagoSegEnf'];
    egresoPagoSegEnf = json['egresoPagoSegEnf'];
    montoPagoSegEnf = json['montoPagoSegEnf'];
    planSegEnf = json['planSegEnf'];
    obsSegEnfAcc = json['obsSegEnfAcc'];
    claveApp = json['claveApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['apellidoTitular'] = apellidoTitular;
    data['nombreTitular'] = nombreTitular;
    data['apellido'] = apellido;
    data['nombre'] = nombre;
    data['dni'] = dni;
    data['cuil'] = cuil;
    data['sexo'] = sexo;
    data['fechaNacimiento'] = fechaNacimiento;
    data['fechaFallecimiento'] = fechaFallecimiento;
    data['estadoCivil'] = estadoCivil;
    data['lugarNacimiento'] = lugarNacimiento;
    data['nacionalidad'] = nacionalidad;
    data['domicilio'] = domicilio;
    data['barrio'] = barrio;
    data['localidad'] = localidad;
    data['cp'] = cp;
    data['telefono'] = telefono;
    data['celular'] = celular;
    data['email'] = email;
    data['apellidoConyuge'] = apellidoConyuge;
    data['nombreConyuge'] = nombreConyuge;
    data['dniConyuge'] = dniConyuge;
    data['cuilConyuge'] = cuilConyuge;
    data['fechaNacimientoConyuge'] = fechaNacimientoConyuge;
    data['fechaFallecimientoConyuge'] = fechaFallecimientoConyuge;
    data['categoria'] = categoria;
    data['socio'] = socio;
    data['fechaCarga'] = fechaCarga;
    data['fechaAlta'] = fechaAlta;
    data['fechaBaja'] = fechaBaja;
    data['motivoBaja'] = motivoBaja;
    data['nroSocio'] = nroSocio;
    data['nroCuentaHp'] = nroCuentaHp;
    data['tipoJubilacion'] = tipoJubilacion;
    data['fechaJubilacion'] = fechaJubilacion;
    data['servicioEspecialidad'] = servicioEspecialidad;
    data['afSeguroTit'] = afSeguroTit;
    data['afSeguroCony'] = afSeguroCony;
    data['trabHp'] = trabHp;
    data['trabFuera'] = trabFuera;
    data['lugarTrab'] = lugarTrab;
    data['segEnf'] = segEnf;
    data['segAcc'] = segAcc;
    data['beneficio1'] = beneficio1;
    data['supervivencia'] = supervivencia;
    data['fecPagoSepTitular'] = fecPagoSepTitular;
    data['egresoPagoSepTitular'] = egresoPagoSepTitular;
    data['montoPagoSepTitular'] = montoPagoSepTitular;
    data['fecPagoSepConyuge'] = fecPagoSepConyuge;
    data['egresoPagoSepConyuge'] = egresoPagoSepConyuge;
    data['montoPagoSepConyuge'] = montoPagoSepConyuge;
    data['fecPagoSegEnf'] = fecPagoSegEnf;
    data['egresoPagoSegEnf'] = egresoPagoSegEnf;
    data['montoPagoSegEnf'] = montoPagoSegEnf;
    data['planSegEnf'] = planSegEnf;
    data['obsSegEnfAcc'] = obsSegEnfAcc;
    data['claveApp'] = claveApp;
    return data;
  }
}
