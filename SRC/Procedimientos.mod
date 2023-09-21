IMPLEMENTATION MODULE Procedimientos;

(******************************************************************************)
(*******************************IMPORTACIONES**********************************)
(******************************************************************************)

FROM Contacto IMPORT Contacto, Nombre, Tipo, ImprimirCampoContacto, Campos,
                     DestruirContacto, EditarNombreContacto, CrearContacto,
		     EditarCelularContacto, EditarTelefonoContacto,
		     EditarDireccionContacto, EditarCorreoContacto,
		     DestruirDireccionContacto, DestruirCelularContacto,
		     DestruirTelefonoContacto, DestruirCorreoContacto,
		     ExisteCampoContacto, ObtenerCelularContacto,
		     ObtenerTelefonoContacto;

FROM LNombres IMPORT LNombres, ObtenerCoincidenciasNombreLNombres,
                     InsertarNombreLNombres, ObtenerNombreLNombres,
		     EditarNombreLNombres, DestruirNombreLNombres,
		     ObtenerPosicionesLNombres;
		
FROM ABBNombres IMPORT ABBNombres, AgregarABBNombres, EnOrdenABBNombres,
                       DestruirABBNombres, CrearABBNombres;	

FROM LDirecciones IMPORT Direccion;

FROM LCorreos IMPORT Correo;

FROM LCelulares IMPORT Celular, LCelulares, InsertarCelularLCelulares,
                       ObtenerCelularLCelulares, DestruirLCelulares,
		       CrearLCelulares;

FROM LTelefonos IMPORT Telefono, LTelefonos, InsertarTelefonoLTelefonos,
                       ObtenerTelefonoLTelefonos, DestruirLTelefonos,
		       CrearLTelefonos;

FROM LNat IMPORT LNat, ObtenerNatLNat, ExisteNatLNat, DestruirLNat;

FROM WholeIO IMPORT ReadCard, WriteCard;

FROM TextIO IMPORT WriteString, WriteLn, ReadString, ReadChar, SkipLine;

FROM WholeStr IMPORT CardToStr, StrToCard, ConvResults;

FROM Strings IMPORT Length, Insert, Assign, Equal;

FROM CharClass IMPORT IsNumeric;

FROM StdChans IMPORT StdOutChan, InChan;

FROM StreamFile IMPORT read, write, old, text, ChanId, OpenResults, Close;

FROM SeqFile IMPORT OpenWrite, OpenRead;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************************************************************)

(**********************IMPRIMIR SUBOPCIONES DE EDICION*************************)(**********************IMPRIMIR SUBOPCIONES DE EDICION*************************)
PROCEDURE ImprimirSubOpcionesDeEdicion(Existen:BOOLEAN);
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"****************");WriteLn(Chan);
  WriteString(Chan,"*    EDITAR    *");WriteLn(Chan);
  WriteString(Chan,"****************");WriteLn(Chan);

  IF Existen THEN
   WriteString(Chan,"* C - Cambiar  *");WriteLn(Chan);
   WriteString(Chan,"* B - Borrar   *");WriteLn(Chan);
  END;(*/IF*)

  WriteString(Chan,"* A - Agregar  *");WriteLn(Chan);
  WriteString(Chan,"* V - Volver   *");WriteLn(Chan);
  WriteString(Chan,"****************");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
 END ImprimirSubOpcionesDeEdicion;

(**********************IMPRIMIR OPCIONES DE EDICION****************************)(**********************IMPRIMIR OPCIONES DE EDICION****************************)
PROCEDURE ImprimirOpcionesDeEdicion();
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"**************************");WriteLn(Chan);
  WriteString(Chan,"*      EDITAR CAMPO      *");WriteLn(Chan);
  WriteString(Chan,"**************************");WriteLn(Chan);
  WriteString(Chan,"* 1 - Nombre             *");WriteLn(Chan);
  WriteString(Chan,"* 2 - Direccion          *");WriteLn(Chan);
  WriteString(Chan,"* 3 - Telefono           *");WriteLn(Chan);
  WriteString(Chan,"* 4 - Celular            *");WriteLn(Chan);
  WriteString(Chan,"* 5 - Correo electronico *");WriteLn(Chan);
  WriteString(Chan,"* 6 - Volver             *");WriteLn(Chan);
  WriteString(Chan,"**************************");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
 END ImprimirOpcionesDeEdicion;

(***********************IMPRIMIR OPCIONES DE CAMBIO****************************)(***********************IMPRIMIR OPCIONES DE CAMBIO****************************)
PROCEDURE ImprimirOpcionesDeCambio();
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"**************************");WriteLn(Chan);
  WriteString(Chan,"*  CAMBIO DE NUMERACION  *");WriteLn(Chan);
  WriteString(Chan,"**************************");WriteLn(Chan);
  WriteString(Chan,"* D - Nuevo Digito       *");WriteLn(Chan);
  WriteString(Chan,"* P - Cambio de Prefijos *");WriteLn(Chan);
  WriteString(Chan,"* V - Volver             *");WriteLn(Chan);
  WriteString(Chan,"**************************");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
 END ImprimirOpcionesDeCambio;

(**********************IMPRIMIR SUBOPCIONES DE CAMBIO**************************)(**********************IMPRIMIR SUBOPCIONES DE CAMBIO**************************)
PROCEDURE ImprimirSubOpcionesDeCambio();
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"**************************");WriteLn(Chan);
  WriteString(Chan,"*  CAMBIO DE NUMERACION  *");WriteLn(Chan);
  WriteString(Chan,"**************************");WriteLn(Chan);
  WriteString(Chan,"* T - Cambiar Todos      *");WriteLn(Chan);
  WriteString(Chan,"* E - Excluir a...       *");WriteLn(Chan);
  WriteString(Chan,"* I - Incluir solo a...  *");WriteLn(Chan);
  WriteString(Chan,"* V - Volver             *");WriteLn(Chan);
  WriteString(Chan,"**************************");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
 END ImprimirSubOpcionesDeCambio;

(*******************************COMPARAR CEL***********************************)(*******************************COMPARAR CEL***********************************)
PROCEDURE CompararCel(C1,C2 : Celular):BOOLEAN;
 VAR
  i, largo : CARDINAL;

 BEGIN
  IF (C1.Largo < C2.Largo) THEN
   largo := C1.Largo;
  ELSE
   largo := C2.Largo;
  END;(*/IF*)

  i := 0;
  WHILE (i < largo) AND (C1.C[i] = C2.C[i]) DO
   i := i+1;
  END;(*/WHILE*)
  RETURN(i >= largo);
 END CompararCel;

(*******************************COMPARAR TEL***********************************)(*******************************COMPARAR TEL***********************************)
PROCEDURE CompararTel(T1,T2 : Telefono):BOOLEAN;
 VAR
  i, largo : CARDINAL;

 BEGIN
  IF (T1.Largo < T2.Largo) THEN
   largo := T1.Largo;
  ELSE
   largo := T2.Largo;
  END;(*/IF*)

  i := 0;
  WHILE (i < largo) AND (T1.T[i] = T2.T[i]) DO
   i := i+1;
  END;(*/WHILE*)
  RETURN(i >= largo);
 END CompararTel;

(*****************************CAMBIAR DIRECCION********************************)(*****************************CAMBIAR DIRECCION********************************)
PROCEDURE CambiarDireccion(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  R : ConvResults;
  D : Direccion;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Address,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Address,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Address,1,C)) THEN
   WriteString(Chan,"Cambiar direccion?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    D := LeerDireccion();
    EditarDireccionContacto(D,0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Direccion numero: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    D := LeerDireccion();
    EditarDireccionContacto(D,i-1,C);
   END;(*/IF*)
  END;(*/IF*)
 END CambiarDireccion;

(*****************************BORRAR DIRECCION*********************************)(*****************************BORRAR DIRECCION*********************************)
PROCEDURE BorrarDireccion(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  o : CHAR;
  R : ConvResults;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Address,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Address,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Address,1,C)) THEN
   WriteString(Chan,"Borrar direccion?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    DestruirDireccionContacto(0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Direccion: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    WriteString(Chan,"Borrar direccion ");WriteString(Chan,S);
    WriteString(Chan,"?");WriteLn(Chan);
    WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
    WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
    ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
    IF (o = "S") OR (o = "s") THEN
     DestruirDireccionContacto(i-1,C);
    END;(*/IF*)
   END;(*/IF*)
  END;(*/IF*)
 END BorrarDireccion;

(*****************************AGREGAR DIRECCION********************************)(*****************************AGREGAR DIRECCION********************************)
PROCEDURE AgregarDireccion(C:Contacto);
 VAR
  Chan : ChanId;
  i : CARDINAL;
  D : Direccion;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  i := 0;
  WHILE (ExisteCampoContacto(Address,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  REPEAT
   D := LeerDireccion();
   EditarDireccionContacto(D,i,C);
   i := i+1;
   WriteString(Chan,"Direccion ingresada, ingresar otra?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  UNTIL (o <> "S") AND (o <> "s");
 END AgregarDireccion;

(******************************CAMBIAR TELEFONO********************************)(******************************CAMBIAR TELEFONO********************************)
PROCEDURE CambiarTelefono(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  R : ConvResults;
  T : Telefono;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Tel,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Tel,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Tel,1,C)) THEN
   WriteString(Chan,"Cambiar telefono?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    T := LeerTelefono();
    EditarTelefonoContacto(T,0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Telefono numero: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    T := LeerTelefono();
    EditarTelefonoContacto(T,i-1,C);
   END;(*/IF*)
  END;(*/IF*)
 END CambiarTelefono;

(******************************BORRAR TELEFONO*********************************)(******************************BORRAR TELEFONO*********************************)
PROCEDURE BorrarTelefono(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  o : CHAR;
  R : ConvResults;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Tel,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Tel,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Tel,1,C)) THEN
   WriteString(Chan,"Borrar telefono?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    DestruirTelefonoContacto(0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Telefono: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    WriteString(Chan,"Borrar telefono ");WriteString(Chan,S);
    WriteString(Chan,"?");WriteLn(Chan);
    WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
    WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
    ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
    IF (o = "S") OR (o = "s") THEN
     DestruirTelefonoContacto(i-1,C);
    END;(*/IF*)
   END;(*/IF*)
  END;(*/IF*)
 END BorrarTelefono;

(******************************AGREGAR TELEFONO********************************)(******************************AGREGAR TELEFONO********************************)
PROCEDURE AgregarTelefono(C:Contacto);
 VAR
  Chan : ChanId;
  i : CARDINAL;
  T : Telefono;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  i := 0;
  WHILE (ExisteCampoContacto(Tel,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  REPEAT
   T := LeerTelefono();
   EditarTelefonoContacto(T,i,C);
   i := i+1;
   WriteString(Chan,"Telefono ingresado, ingresar otro?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  UNTIL (o <> "S") AND (o <> "s");
 END AgregarTelefono;

(*******************************CAMBIAR CELULAR********************************)(*******************************CAMBIAR CELULAR********************************)
PROCEDURE CambiarCelular(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  R : ConvResults;
  CL : Celular;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Cel,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Cel,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Cel,1,C)) THEN
   WriteString(Chan,"Cambiar celular?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    CL := LeerCelular();
    EditarCelularContacto(CL,0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Celular numero: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    CL := LeerCelular();
    EditarCelularContacto(CL,i-1,C);
   END;(*/IF*)
  END;(*/IF*)
 END CambiarCelular;

(******************************BORRAR CELULAR**********************************)(******************************BORRAR CELULAR**********************************)
PROCEDURE BorrarCelular(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  o : CHAR;
  R : ConvResults;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Cel,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Cel,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Cel,1,C)) THEN
   WriteString(Chan,"Borrar celular?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    DestruirCelularContacto(0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Celular: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    WriteString(Chan,"Borrar celular ");WriteString(Chan,S);
    WriteString(Chan,"?");WriteLn(Chan);
    WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
    WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
    ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
    IF (o = "S") OR (o = "s") THEN
     DestruirCelularContacto(i-1,C);
    END;(*/IF*)
   END;(*/IF*)
  END;(*/IF*)
 END BorrarCelular;

(******************************AGREGAR CELULAR*********************************)(******************************AGREGAR CELULAR*********************************)
PROCEDURE AgregarCelular(C:Contacto);
 VAR
  Chan : ChanId;
  i : CARDINAL;
  CL : Celular;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  i := 0;
  WHILE (ExisteCampoContacto(Cel,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  REPEAT
   CL := LeerCelular();
   EditarCelularContacto(CL,i,C);
   i := i+1;
   WriteString(Chan,"Celular ingresado, ingresar otro?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  UNTIL (o <> "S") AND (o <> "s");
 END AgregarCelular;

(******************************CAMBIAR CORREO**********************************)(******************************CAMBIAR CORREO**********************************)
PROCEDURE CambiarCorreo(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  R : ConvResults;
  M : Correo;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Mail,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Mail,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Mail,1,C)) THEN
   WriteString(Chan,"Cambiar correo?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    M := LeerCorreo();
    EditarCorreoContacto(M,0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Correo numero: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    M := LeerCorreo();
    EditarCorreoContacto(M,i-1,C);
   END;(*/IF*)
  END;(*/IF*)
 END CambiarCorreo;

(******************************BORRAR CORREO***********************************)(******************************BORRAR CORREO***********************************)
PROCEDURE BorrarCorreo(C:Contacto);
 VAR
  Chan : ChanId;
  k, i : CARDINAL;
  S : ARRAY [0..6] OF CHAR;
  o : CHAR;
  R : ConvResults;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Mail,C);WriteLn(Chan);
  k := 0;
  WHILE (ExisteCampoContacto(Mail,k,C)) DO
   k := k+1;
  END;(*/WHILE*)
  IF NOT(ExisteCampoContacto(Mail,1,C)) THEN
   WriteString(Chan,"Borrar correo?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "S") OR (o = "s") THEN
    DestruirCorreoContacto(0,C);
   END;(*/IF*)
  ELSE
   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
   REPEAT
    WriteString(Chan,"Correo: ");
    ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
    StrToCard(S,i,R);
    IF ((R <> strAllRight)AND NOT(Equal(S,"")))
       OR (R = strAllRight) AND ((i > k) OR (i=0)) THEN
     WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
    END;(*/IF*)
   UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= k) AND (i>0));
   IF (R = strAllRight) THEN
    WriteString(Chan,"Borrar correo ");WriteString(Chan,S);
    WriteString(Chan,"?");WriteLn(Chan);
    WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
    WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
    WriteString(Chan,">");
    ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
    IF (o = "S") OR (o = "s") THEN
     DestruirCorreoContacto(i-1,C);
    END;(*/IF*)
   END;(*/IF*)
  END;(*/IF*)
 END BorrarCorreo;

(******************************AGREGAR CORREO**********************************)(******************************AGREGAR CORREO**********************************)
PROCEDURE AgregarCorreo(C:Contacto);
 VAR
  Chan : ChanId;
  i : CARDINAL;
  M : Correo;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();
  i := 0;
  WHILE (ExisteCampoContacto(Mail,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  REPEAT
   M := LeerCorreo();
   EditarCorreoContacto(M,i,C);
   i := i+1;
   WriteString(Chan,"Correo ingresado, ingresar otro?");WriteLn(Chan);
   WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
   WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  UNTIL (o <> "S") AND (o <> "s");
 END AgregarCorreo;

(******************************LEER PREFIJOS CEL*******************************)(******************************LEER PREFIJOS CEL*******************************)
PROCEDURE LeerPrefijosCel():Celular;
 VAR
  C : Celular;
  j : CARDINAL;
  S : ARRAY [0..15] OF CHAR;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  REPEAT
   WriteString(Chan,"Prefijo: ");
   ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
   j := 0;
   WHILE (j<=Length(S)) AND (IsNumeric(S[j])) DO
    j := j+1;
   END;(*/WHILE*)
   IF (j<Length(S)) THEN
    WriteString(Chan,"Los prefijos solo pueden contener numeros.");
    WriteLn(Chan);WriteLn(Chan);
   END;(*/IF*)
  UNTIL (j=Length(S));
  C.Largo := 0;
  FOR j:=0 TO Length(S)-1 DO
   C.C[j] := ORD(S[j]) - ORD("0");
   C.Largo := C.Largo+1;
  END;(*/FOR*)
  RETURN(C);
 END LeerPrefijosCel;

(******************************LEER PREFIJOS TEL*******************************)(******************************LEER PREFIJOS TEL*******************************)
PROCEDURE LeerPrefijosTel():Telefono;
 VAR
  T : Telefono;
  j : CARDINAL;
  S : ARRAY [0..15] OF CHAR;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  REPEAT
   WriteString(Chan,"Prefijo: ");
   ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
   j := 0;
   WHILE (j<=Length(S)) AND (IsNumeric(S[j])) DO
    j := j+1;
   END;(*/WHILE*)
   IF (j<Length(S)) THEN
    WriteString(Chan,"Los prefijos solo pueden contener numeros.");
    WriteLn(Chan);WriteLn(Chan);
   END;(*/IF*)
  UNTIL (j=Length(S));
  T.Largo := 0;
  FOR j:=0 TO Length(S)-1 DO
   T.T[j] := ORD(S[j]) - ORD("0");
   T.Largo := T.Largo+1;
  END;(*/FOR*)
  RETURN(T);
 END LeerPrefijosTel;

(*******************************LEER DIRECCION*********************************)(*******************************LEER DIRECCION*********************************)
PROCEDURE LeerDireccion():Direccion;
 VAR
  D : Direccion;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"Direccion: ");
  ReadString(InChan(),D);SkipLine(InChan());WriteLn(Chan);
  RETURN(D);
 END LeerDireccion;

(*******************************LEER TELEFONO**********************************)(*******************************LEER TELEFONO**********************************)
PROCEDURE LeerTelefono():Telefono;
 VAR
  T : Telefono;
  j : CARDINAL;
  S : ARRAY [0..15] OF CHAR;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  REPEAT
   WriteString(Chan,"Numero: ");
   ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
   j := 0;
   WHILE (j<=Length(S)) AND (IsNumeric(S[j])) DO
    j := j+1;
   END;(*/WHILE*)
   IF (j<Length(S)) THEN
    WriteString(Chan,"Los telefonos solo pueden contener numeros.");
    WriteLn(Chan);WriteLn(Chan);
   END;(*/IF*)
  UNTIL (j=Length(S));
  T.Largo := 0;
  FOR j:=0 TO Length(S)-1 DO
   T.T[j] := ORD(S[j]) - ORD("0");
   T.Largo := T.Largo+1;
  END;(*/FOR*)
  RETURN(T);
 END LeerTelefono;

(********************************LEER CELULAR**********************************)(********************************LEER CELULAR**********************************)
PROCEDURE LeerCelular():Celular;
 VAR
  C : Celular;
  j : CARDINAL;
  S : ARRAY [0..15] OF CHAR;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  REPEAT
   WriteString(Chan,"Numero: ");
   ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
   j := 0;
   WHILE (j<=Length(S)) AND (IsNumeric(S[j])) DO
    j := j+1;
   END;(*/WHILE*)
   IF (j<Length(S)) THEN
    WriteString(Chan,"Los celulares solo pueden contener numeros.");
    WriteLn(Chan);WriteLn(Chan);
   END;(*/IF*)
  UNTIL (j=Length(S));
  C.Largo := 0;
  FOR j:=0 TO Length(S)-1 DO
   C.C[j] := ORD(S[j]) - ORD("0");
   C.Largo := C.Largo+1;
  END;(*/FOR*)
  RETURN(C);
 END LeerCelular;

(********************************LEER CORREO***********************************)(********************************LEER CORREO***********************************)
PROCEDURE LeerCorreo():Correo;
 VAR
  C : Correo;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"Correo electronico: ");
  ReadString(InChan(),C);SkipLine(InChan());WriteLn(Chan);
  RETURN(C);
 END LeerCorreo;

(********************************LEER NOMBRE***********************************)(********************************LEER NOMBRE***********************************)
PROCEDURE LeerNombre():Nombre;
 VAR
  N : Nombre;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  REPEAT
   WriteString(Chan,"Contacto: ");
   ReadString(InChan(),N);SkipLine(InChan());WriteLn(Chan);
   IF Equal(N,"") THEN
    WriteString(Chan,"Debe ingresar al menos un caracter.");WriteLn(Chan);
    WriteLn(Chan);
   END;(*/IF*)
  UNTIL NOT(Equal(N,""));
  RETURN(N);
 END LeerNombre;

(*****************************AGREGAR CONTACTO*********************************)(*****************************AGREGAR CONTACTO*********************************)
PROCEDURE AgregarContacto(T:Tipo; VAR LN:LNombres);
 VAR
  C : Contacto;
  Nom : Nombre;
  i : CARDINAL;
  o : CHAR;
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();

  (*Obtener el nombre del contacto*)
  Nom := LeerNombre();
  C := CrearContacto(Nom);

  (*Obtener la/s dirección/es del contacto*)
  WriteLn(Chan);
  WriteString(Chan,"Direccion?");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,"  S   - Si ");WriteLn(Chan);
  WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  IF (o = "s") OR (o = "S") THEN
   AgregarDireccion(C);
  END;(*/IF*)

  (*Obtener el/los EMail/s del contacto*)
  WriteLn(Chan);
  WriteString(Chan,"Correo electronico?");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,"  S   - Si ");WriteLn(Chan);
  WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  IF (o = "s") OR (o = "S") THEN
   AgregarCorreo(C);
  END;(*/IF*)

  (*Obtener el/los teléfono/s del contacto*)
  WriteLn(Chan);
  WriteString(Chan,"Telefono fijo?");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,"  S   - Si ");WriteLn(Chan);
  WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  IF (o = "s") OR (o = "S") THEN
   AgregarTelefono(C);
  END;(*/IF*)

  (*Obtener el/los celular/es del contacto*)
  WriteLn(Chan);
  WriteString(Chan,"Celular?");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,"  S   - Si ");WriteLn(Chan);
  WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
  IF (o = "s") OR (o = "S") THEN
   AgregarCelular(C);
  END;(*/IF*)

  (*Guardar el contacto*)
  i:=InsertarNombreLNombres(Nom,T,LN);
  PersistirContacto(C,i);
  DestruirContacto(C);
 END AgregarContacto;

(****************************PERSISTIR CONTACTO********************************)(****************************PERSISTIR CONTACTO********************************)
(*j es la posición de C en LN*)
PROCEDURE PersistirContacto(C:Contacto;j:CARDINAL);
 VAR
  chan : ChanId;
  result : OpenResults;
  Archivo : ARRAY [0..30] OF CHAR;
  i : CARDINAL;

 BEGIN

  CardToStr(j,Archivo);
  Insert(".cnt",Length(Archivo),Archivo);

  OpenWrite(chan,Archivo,read+write+old+text,result);

  ImprimirCampoContacto(chan,Nombres,C);

  i := 0;
  WHILE (ExisteCampoContacto(Address,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  WriteCard(chan,i,1);WriteLn(chan);
  ImprimirCampoContacto(chan,Address,C);

  i := 0;
  WHILE (ExisteCampoContacto(Tel,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  WriteCard(chan,i,1);WriteLn(chan);
  ImprimirCampoContacto(chan,Tel,C);

  i := 0;
  WHILE (ExisteCampoContacto(Cel,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  WriteCard(chan,i,1);WriteLn(chan);
  ImprimirCampoContacto(chan,Cel,C);

  i := 0;
  WHILE (ExisteCampoContacto(Mail,i,C)) DO
   i := i+1;
  END;(*/WHILE*)
  WriteCard(chan,i,1);WriteLn(chan);
  ImprimirCampoContacto(chan,Mail,C);

  Close(chan);

 END PersistirContacto;

(****************************RECUPERAR CONTACTO********************************)(****************************RECUPERAR CONTACTO********************************)
(*i es la posicion de C en LN*)
PROCEDURE RecuperarContacto(j:CARDINAL):Contacto;
 VAR
  Chan : ChanId;
  result : OpenResults;
  Archivo : ARRAY [0..30] OF CHAR;

  S : ARRAY [0..40] OF CHAR;
  i,k,l : CARDINAL;

  TL : Telefono;
  CL : Celular;
  D : Direccion;
  EM : Correo;
  N : Nombre;
  C : Contacto;

 BEGIN
  CardToStr(j,Archivo);
  Insert(".cnt",Length(Archivo),Archivo);
  OpenRead(Chan,Archivo,read+write+old+text,result);

  (*NOMBRE*)
  ReadString(Chan,S);SkipLine(Chan);
  Assign(S,N);

  C := CrearContacto(N);

  (*DIRECCIONES*)
  ReadCard(Chan,i);
  SkipLine(Chan);
  FOR k:=1 TO i DO
   ReadString(Chan,D);
   EditarDireccionContacto(D,k-1,C);
   SkipLine(Chan);
  END;(*/FOR*)

  (*TELEFONOS*)
  ReadCard(Chan,i);
  SkipLine(Chan);
  FOR k:=1 TO i DO
   ReadString(Chan,S);
   TL.Largo := 0;
   FOR l:=0 TO Length(S)-1 DO
    TL.T[l] := ORD(S[l]) - ORD("0");
    TL.Largo := TL.Largo+1;
   END;(*/FOR*)
   EditarTelefonoContacto(TL,k-1,C);
   SkipLine(Chan);
  END;(*/FOR*)

  (*CELULARES*)
  ReadCard(Chan,i);
  SkipLine(Chan);
  FOR k:=1 TO i DO
   ReadString(Chan,S);
   CL.Largo := 0;
   FOR l:=0 TO Length(S)-1 DO
    CL.C[l] := ORD(S[l]) - ORD("0");
    CL.Largo := CL.Largo+1;
   END;(*/FOR*)
   EditarCelularContacto(CL,k-1,C);
   SkipLine(Chan);
  END;(*/FOR*)

  (*CORREOS*)
  ReadCard(Chan,i);
  SkipLine(Chan);
  FOR k:=1 TO i DO
   ReadString(Chan,S);
   Assign(S,EM);
   EditarCorreoContacto(EM,k-1,C);
   SkipLine(Chan);
  END;(*/FOR*)
  Close(Chan);
  RETURN(C);
 END RecuperarContacto;

(*******************************VER CONTACTO***********************************)(*******************************VER CONTACTO***********************************)
PROCEDURE VerContacto(C:Contacto);
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  ImprimirCampoContacto(Chan,Nombres,C);
  WriteLn(Chan);

  IF (ExisteCampoContacto(Address,0,C)) THEN
   IF (ExisteCampoContacto(Address,1,C)) THEN
    WriteString(Chan,"Direcciones:");WriteLn(Chan);
   ELSE
    WriteString(Chan,"Direccion:");WriteLn(Chan);;
   END;(*/IF*)
   ImprimirCampoContacto(Chan,Address,C);
   WriteLn(Chan);
  END;(*/IF*)

  IF (ExisteCampoContacto(Tel,0,C)) THEN
   IF (ExisteCampoContacto(Tel,1,C)) THEN
    WriteString(Chan,"Telefonos:");WriteLn(Chan);
   ELSE
    WriteString(Chan,"Telefono:");WriteLn(Chan);
   END;(*/IF*)
   ImprimirCampoContacto(Chan,Tel,C);
   WriteLn(Chan);
  END;(*/IF*)

  IF (ExisteCampoContacto(Cel,0,C)) THEN
   IF (ExisteCampoContacto(Cel,1,C)) THEN
    WriteString(Chan,"Celulares:");WriteLn(Chan);
   ELSE
    WriteString(Chan,"Celular:");WriteLn(Chan);
   END;(*/IF*)
   ImprimirCampoContacto(Chan,Cel,C);
   WriteLn(Chan);
  END;(*/IF*)

  IF (ExisteCampoContacto(Mail,0,C)) THEN
   IF (ExisteCampoContacto(Mail,1,C)) THEN
    WriteString(Chan,"Correos:");WriteLn(Chan);
   ELSE
    WriteString(Chan,"Correo:");WriteLn(Chan);
   END;(*/IF*)
   ImprimirCampoContacto(Chan,Mail,C);
   WriteLn(Chan);
  END;(*/IF*)
 END VerContacto;

(******************************BUSCAR CONTACTO*********************************)(******************************BUSCAR CONTACTO*********************************)
PROCEDURE BuscarContacto(N:Nombre;T:Tipo;LN:LNombres):LNat;
 VAR
  L : LNat;
  Chan : ChanId;
  i,j : CARDINAL;
  Continuar : BOOLEAN;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();

  L := ObtenerCoincidenciasNombreLNombres(N,T,LN);
  IF NOT(ExisteNatLNat(0,L)) THEN
   WriteString(Chan,"No hay conincidencias");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,"Enter para continuar");WriteLn(Chan);SkipLine(InChan());
  ELSIF (ExisteNatLNat(1,L)) THEN
   i := 0;
   REPEAT
    WHILE (ExisteNatLNat(i,L)) AND (((i+1) MOD 10) <> 0) DO
     WriteCard(Chan,i+1,1);WriteString(Chan,") ");
     j := ObtenerNatLNat(i,L);
     WriteString(Chan,ObtenerNombreLNombres(j,T,LN));WriteLn(Chan);
     i := i+1;
    END;(*/WHILE*)
    IF (ExisteNatLNat(i,L)) THEN
     WriteCard(Chan,i+1,1);WriteString(Chan,") ");
     j := ObtenerNatLNat(i,L);
     WriteString(Chan,ObtenerNombreLNombres(j,T,LN));WriteLn(Chan);
     i := i+1;
    IF (ExisteNatLNat(i,L)) THEN
     WriteLn(Chan);
     WriteString(Chan,"Continuar?  Enter - Si / N - No >");
     ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
     IF (o = "N") OR (o = "n") THEN
       Continuar := FALSE;
      ELSE
       Continuar := TRUE
      END;(*/IF*)
     ELSE
      Continuar := FALSE;
     END;(*/IF*)
    ELSE
     Continuar := FALSE;
    END;(*/IF*)
   UNTIL NOT(Continuar);
  END;(*/IF*)
  RETURN(L);
 END BuscarContacto;

(*****************************EDITAR CONTACTO**********************************)(*****************************EDITAR CONTACTO**********************************)
PROCEDURE EditarContacto(j:CARDINAL;VAR C:Contacto;LN:LNombres);
 VAR
  Chan : ChanId;
  N : Nombre;
  o, p : CHAR;
  Existe : BOOLEAN;

 BEGIN
  Chan := StdOutChan();
  REPEAT
   ImprimirOpcionesDeEdicion();
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
   IF (o = "1") THEN
    WriteString(Chan,"EDITAR NOMBRE");WriteLn(Chan);
    REPEAT
     WriteString(Chan,"Nuevo nombre: ");
     ReadString(InChan(),N);SkipLine(InChan());WriteLn(Chan);
     IF Equal(N,"") THEN
      WriteString(Chan,"Debe ingresar al menos un caracter.");WriteLn(Chan);
      WriteLn(Chan);
     END;(*/IF*)
    UNTIL NOT(Equal(N,""));
    EditarNombreContacto(N,C);
    EditarNombreLNombres(N,j,LN)

   ELSIF (o = "2") THEN
    WriteString(Chan,"EDITAR DIRECCION");WriteLn(Chan);

    Existe := ExisteCampoContacto(Address,0,C);
    ImprimirSubOpcionesDeEdicion(Existe);
    ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);

    IF Existe AND ((p = "C") OR (p = "c")) THEN
     WriteString(Chan,"CAMBIAR DIRECCION");WriteLn(Chan);WriteLn(Chan);
     CambiarDireccion(C);
    ELSIF Existe AND ((p = "B") OR (p = "b")) THEN
     WriteString(Chan,"BORRAR DIRECCION");WriteLn(Chan);WriteLn(Chan);
     BorrarDireccion(C);
    ELSIF (p = "A") OR (p = "a") THEN
     WriteString(Chan,"AGREGAR DIRECCION");WriteLn(Chan);WriteLn(Chan);
     AgregarDireccion(C);
    END;(*/IF*)

   ELSIF (o = "3") THEN
    WriteString(Chan,"EDITAR TELEFONO");WriteLn(Chan);

    Existe := ExisteCampoContacto(Tel,0,C);
    ImprimirSubOpcionesDeEdicion(Existe);
    ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);

    IF Existe AND ((p = "C") OR (p = "c")) THEN
     WriteString(Chan,"CAMBIAR TELEFONO");WriteLn(Chan);WriteLn(Chan);
     CambiarTelefono(C);
    ELSIF Existe AND ((p = "B") OR (p = "b")) THEN
     WriteString(Chan,"BORRAR TELEFONO");WriteLn(Chan);WriteLn(Chan);
     BorrarTelefono(C);
    ELSIF (p = "A") OR (p = "a") THEN
     WriteString(Chan,"AGREGAR TELEFONO");WriteLn(Chan);WriteLn(Chan);
     AgregarTelefono(C);
    END;(*/IF*)

   ELSIF (o = "4") THEN
    WriteString(Chan,"EDITAR CELULAR");WriteLn(Chan);

    Existe := ExisteCampoContacto(Cel,0,C);
    ImprimirSubOpcionesDeEdicion(Existe);
    ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);

    IF Existe AND ((p = "C") OR (p = "c")) THEN
     WriteString(Chan,"CAMBIAR CELULAR");WriteLn(Chan);WriteLn(Chan);
     CambiarCelular(C);
    ELSIF Existe AND ((p = "B") OR (p = "b")) THEN
     WriteString(Chan,"BORRAR CELULAR");WriteLn(Chan);WriteLn(Chan);
     BorrarCelular(C);
    ELSIF (p = "A") OR (p = "a") THEN
     WriteString(Chan,"AGREGAR CELULAR");WriteLn(Chan);WriteLn(Chan);
     AgregarCelular(C);
    END;(*/IF*)

   ELSIF (o = "5") THEN
    WriteString(Chan,"EDITAR CORREO ELCTRONICO");WriteLn(Chan);

    Existe := ExisteCampoContacto(Cel,0,C);
    ImprimirSubOpcionesDeEdicion(Existe);
    ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);

    IF Existe AND ((p = "C") OR (p = "c")) THEN
     WriteString(Chan,"CAMBIAR CORREO ELCTRONICO");WriteLn(Chan);WriteLn(Chan);
     CambiarCorreo(C);
    ELSIF Existe AND ((p = "B") OR (p = "b")) THEN
     WriteString(Chan,"BORRAR CORREO ELCTRONICO");WriteLn(Chan);WriteLn(Chan);
     BorrarCorreo(C);
    ELSIF (p = "A") OR (p = "a") THEN
     WriteString(Chan,"AGREGAR CORREO ELCTRONICO");WriteLn(Chan);WriteLn(Chan);
     AgregarCorreo(C);
    END;(*/IF*)
   END;(*/IF*)
  UNTIL(o<>"1")AND(o<>"2")AND(o<>"3")AND(o<>"4")AND(o<>"5")
       AND((o="")OR(o="V")OR(o = "v"));
  PersistirContacto(C,j);
 END EditarContacto;

(*****************************BORRAR CONTACTO**********************************)(*****************************BORRAR CONTACTO**********************************)
PROCEDURE BorrarContacto(j:CARDINAL;T:Tipo;VAR LN:LNombres);
 VAR
  Chan : ChanId;
  o : CHAR;

 BEGIN
  Chan := StdOutChan();

  WriteString(Chan,"Confrima que desea borrar a ");
  WriteString(Chan,ObtenerNombreLNombres(j,T,LN));WriteString(Chan,"?");
  WriteLn(Chan);WriteLn(Chan);WriteString(Chan,"  S   - Si");WriteLn(Chan);
  WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

  IF (o = "S") OR (o = "s") THEN
   DestruirNombreLNombres(j,T,LN);
   (*Borrar Archivo del contacto???*)
   WriteString(Chan,"Contacto borrado");WriteLn(Chan);WriteLn(Chan);
  ELSE
   WriteString(Chan,"Contacto NO borrado");WriteLn(Chan);WriteLn(Chan);
  END;(*/IF*)
 END BorrarContacto;

(*****************************LISTAR CONTACTOS*********************************)(*****************************LISTAR CONTACTOS*********************************)
PROCEDURE ListarContactos(T:Tipo;LN:LNombres):LNat;
 VAR
  L : LNat;
  i, j : CARDINAL;
  o : CHAR;
  ABB : ABBNombres;
  Chan : ChanId;
  Continuar : BOOLEAN;

 BEGIN
  Chan := StdOutChan();
  ABB := CrearABBNombres();
  L := ObtenerPosicionesLNombres(T,LN);
  i := 0;
  WHILE (ExisteNatLNat(i,L)) DO
   AgregarABBNombres(ObtenerNatLNat(i,L),LN,T,ABB);
   i := i+1;
  END;(*/WHILE*)
  DestruirLNat(L);
  L := EnOrdenABBNombres(ABB);
  DestruirABBNombres(ABB);
  IF (ExisteNatLNat(0,L)) THEN
   i := 0;
   REPEAT
    WHILE (ExisteNatLNat(i,L)) AND (((i+1) MOD 10) <> 0) DO
     WriteCard(Chan,i+1,1);WriteString(Chan,") ");
     j := ObtenerNatLNat(i,L);
     WriteString(Chan,ObtenerNombreLNombres(j,T,LN));WriteLn(Chan);
     i := i+1;
    END;(*/WHILE*)
    IF (ExisteNatLNat(i,L)) THEN
     WriteCard(Chan,i+1,1);WriteString(Chan,") ");
     j := ObtenerNatLNat(i,L);
     WriteString(Chan,ObtenerNombreLNombres(j,T,LN));WriteLn(Chan);
     i := i+1;
    IF (ExisteNatLNat(i,L)) THEN
     WriteLn(Chan);
     WriteString(Chan,"Continuar?  Enter - Si / N - No >");
     ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
     IF (o = "N") OR (o = "n") THEN
       Continuar := FALSE;
      ELSE
       Continuar := TRUE
      END;(*/IF*)
     ELSE
      Continuar := FALSE;
     END;(*/IF*)
    ELSE
     Continuar := FALSE;
    END;(*/IF*)
   UNTIL NOT(Continuar);
  END;(*/IF*)
  RETURN(L);
 END ListarContactos;

(****************************CAMBIAR CELULARES*********************************)(****************************CAMBIAR CELULARES*********************************)
PROCEDURE CambiarCelulares(LN:LNombres);
 VAR
  Chan : ChanId;
  o, p, q : CHAR;
  S : ARRAY [0..5] OF CHAR;
  R : ConvResults;
  i, j, k, l, m, CPrefijos, n : CARDINAL;
  C : Contacto;
  V, N, P1, P2 : Celular;
  LC, LC2 : LCelulares;
  L : LNat;

 BEGIN
  Chan := StdOutChan();
  ImprimirOpcionesDeCambio();
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

  (*AGREGAR DIGITOS*)
  IF (o = "D") OR (o = "d") THEN

   ImprimirSubOpcionesDeCambio();
   ReadChar(InChan(),q);SkipLine(InChan());WriteLn(Chan);
   LC := CrearLCelulares();
   m := 0;
   CPrefijos := 0;

   (*INCLUIR/EXCLUIR*)
   IF (q = "I") OR (q = "i") OR (q = "E") OR (q = "e") THEN
    REPEAT
     P1 := LeerPrefijosCel();
     InsertarCelularLCelulares(P1,LC);
     CPrefijos := CPrefijos+1;
     WriteString(Chan,"Prefijo ingresado.");WriteLn(Chan);
     WriteString(Chan,"Ingresar otro?");WriteLn(Chan);WriteLn(Chan);
     WriteString(Chan,"  S   - Si");WriteLn(Chan);
     WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
     WriteString(Chan,">");
     ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);
    UNTIL (p <> "S") AND (p <> "s");
    CPrefijos := CPrefijos-1;
   END;(*/IF*)

   (*LEER DIGITOS A AGREGAR*)
   WriteString(Chan,"V - Volver");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,"Digito/s a agregar: ");
   ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
   StrToCard(S,i,R);

   IF (R = strAllRight) THEN

    L := ObtenerPosicionesLNombres(Personal,LN);
    FOR n:=0 TO 1 DO
     j := 0;
     WHILE (ExisteNatLNat(j,L)) DO
      C := RecuperarContacto(ObtenerNatLNat(j,L));
      k := 0;
      WHILE (ExisteCampoContacto(Cel,k,C)) DO
       V :=  ObtenerCelularContacto(k,C);

       IF (q <> "1") THEN
        P1 := ObtenerCelularLCelulares(0,LC);
        m := 0;
        WHILE (m <= CPrefijos) AND NOT(CompararCel(V,P1)) DO
         m := m+1;
 	 IF (m <= CPrefijos) THEN
	  P1 := ObtenerCelularLCelulares(m,LC);
	 END;(*/IF*)
        END;(*/WHILE*)
       END;(*/IF*)

       IF(q="1") OR ((q="2")AND(m>CPrefijos)) OR ((q="3")AND(m<=CPrefijos))THEN
        FOR l:=0 TO Length(S)-1 DO
         N.C[l] := ORD(S[l])-ORD("0");
        END;(*/FOR*)
        N.Largo := V.Largo+Length(S);
        FOR l:=Length(S) TO V.Largo DO
         N.C[l] := V.C[l-Length(S)];
        END;(*/FOR*)
        EditarCelularContacto(N,k,C);
       END;(*/IF*)
       k := k+1;
      END;(*/WHILE*)
      PersistirContacto(C,ObtenerNatLNat(j,L));
      j := j+1;
     END;(*/WHILE*)
     L := ObtenerPosicionesLNombres(Negocios,LN);
    END;(*/FOR*)
   END;(*/IF*)
   DestruirLCelulares(LC);


  (*CAMBIO DE PREFIJOS*)
  ELSIF (o = "P") OR (o = "p") THEN

   LC := CrearLCelulares();
   LC2 := CrearLCelulares();
   CPrefijos := 0;

   (*PREFIJOS A CAMBIAR*)
   REPEAT
    WriteString(Chan,"Cambiar ");
    P1 := LeerPrefijosCel();
    InsertarCelularLCelulares(P1,LC);
    CPrefijos := CPrefijos+1;
    WriteString(Chan,"Por el ");
    P2 := LeerPrefijosCel();
    InsertarCelularLCelulares(P2,LC2);
    WriteString(Chan,"Cambio ingresado.");WriteLn(Chan);
    WriteString(Chan,"Ingresar otro?");WriteLn(Chan);WriteLn(Chan);
    WriteString(Chan,"  S   - Si");WriteLn(Chan);
    WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
    WriteString(Chan,">");
    ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);
   UNTIL (p <> "S") AND (p <> "s");
   CPrefijos := CPrefijos-1;

   L := ObtenerPosicionesLNombres(Personal,LN);
   FOR n:=0 TO 1 DO
    j := 0;
    WHILE (ExisteNatLNat(j,L)) DO
     C := RecuperarContacto(ObtenerNatLNat(j,L));
     k := 0;
     WHILE (ExisteCampoContacto(Cel,k,C)) DO
      V :=  ObtenerCelularContacto(k,C);

      P1 := ObtenerCelularLCelulares(0,LC);
      m := 0;
      WHILE (m <= CPrefijos) AND NOT(CompararCel(P1,V)) DO
       m := m+1;
       IF (m <= CPrefijos) THEN
        P1 := ObtenerCelularLCelulares(m,LC);
       END;(*/IF*)
      END;(*/WHILE*)

      IF (m <= CPrefijos) THEN
       P2 := ObtenerCelularLCelulares(m,LC2);
       FOR l:=0 TO P2.Largo-1 DO
        N.C[l] := P2.C[l];
       END;(*/FOR*)
        N.Largo := P2.Largo-P1.Largo+V.Largo;
       FOR l:=P2.Largo TO N.Largo DO
        N.C[l] := V.C[l-P2.Largo];
       END;(*/FOR*)
       EditarCelularContacto(N,k,C);
      END;(*/IF*)
      k := k+1;
     END;(*/WHILE*)
     PersistirContacto(C,ObtenerNatLNat(j,L));
     j := j+1;
    END;(*/WHILE*)
    L := ObtenerPosicionesLNombres(Negocios,LN);
   END;(*/FOR*)
   DestruirLCelulares(LC);
   DestruirLCelulares(LC2);
  END;(*/IF*)
 END CambiarCelulares;

(****************************CAMBIAR TELEFONOS*********************************)(****************************CAMBIAR TELEFONOS*********************************)
PROCEDURE CambiarTelefonos(LN:LNombres);
 VAR
  Chan : ChanId;
  o, p, q : CHAR;
  S : ARRAY [0..5] OF CHAR;
  R : ConvResults;
  i, j, k, l, m, CPrefijos, n : CARDINAL;
  C : Contacto;
  V, N, P1, P2 : Telefono;
  LT, LT2 : LTelefonos;
  L : LNat;

 BEGIN
  Chan := StdOutChan();
  ImprimirOpcionesDeCambio();
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

  (*AGREGAR DIGITOS*)
  IF (o = "D") OR (o = "d") THEN

   ImprimirSubOpcionesDeCambio();
   ReadChar(InChan(),q);SkipLine(InChan());WriteLn(Chan);
   LT := CrearLTelefonos();
   CPrefijos := 0;
   m := 0;

   (*INCLUIR/EXCLUIR*)
   IF (q = "I") OR (q = "i") OR (q = "E") OR (q = "e") THEN
    REPEAT
     P1 := LeerPrefijosTel();
     InsertarTelefonoLTelefonos(P1,LT);
     CPrefijos := CPrefijos+1;
     WriteString(Chan,"Prefijo ingresado.");WriteLn(Chan);
     WriteString(Chan,"Ingresar otro?");WriteLn(Chan);WriteLn(Chan);
     WriteString(Chan,"  S   - Si");WriteLn(Chan);
     WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
     WriteString(Chan,">");
     ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);
    UNTIL (p <> "S") AND (p <> "s");
    CPrefijos := CPrefijos-1;
   END;(*/IF*)

   WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);

   (*DIGITOS A AGREGAR*)
   WriteString(Chan,"Digito/s a agregar: ");
   ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
   StrToCard(S,i,R);

   IF (R = strAllRight) THEN

    L := ObtenerPosicionesLNombres(Personal,LN);
    FOR n:=0 TO 1 DO
     j := 0;
     WHILE (ExisteNatLNat(j,L)) DO
      C := RecuperarContacto(ObtenerNatLNat(j,L));
      k := 0;
      WHILE (ExisteCampoContacto(Tel,k,C)) DO
       V :=  ObtenerTelefonoContacto(k,C);

       IF (q <> "1") THEN
        P1 := ObtenerTelefonoLTelefonos(0,LT);
        m := 0;
        WHILE (m <= CPrefijos) AND NOT(CompararTel(V,P1)) DO
         m := m+1;
  	 IF (m <= CPrefijos) THEN
	  P1 := ObtenerTelefonoLTelefonos(m,LT);
	 END;(*/IF*)
        END;(*/WHILE*)
       END;(*/IF*)

       IF(q="1") OR ((q="2")AND(m>CPrefijos)) OR ((q="3")AND(m<=CPrefijos))THEN
        FOR l:=0 TO Length(S)-1 DO
         N.T[l] := ORD(S[l])-ORD("0");
        END;(*/FOR*)
        N.Largo := V.Largo+Length(S);
        FOR l:=Length(S) TO V.Largo DO
         N.T[l] := V.T[l-Length(S)];
        END;(*/FOR*)
        EditarTelefonoContacto(N,k,C);
       END;(*/IF*)
       k := k+1;
      END;(*/WHILE*)
      PersistirContacto(C,ObtenerNatLNat(j,L));
      j := j+1;
     END;(*/WHILE*)
     L := ObtenerPosicionesLNombres(Negocios,LN);
    END;(*/FOR*)
    DestruirLTelefonos(LT);
   END;(*/IF*)

  (*CAMBIO DE PREFIJOS*)
  ELSIF (o = "P") OR (o = "p") THEN

   LT := CrearLTelefonos();
   LT2 := CrearLTelefonos();
   CPrefijos := 0;

   (*PREFIJOS A CAMBIAR*)
   REPEAT
    WriteString(Chan,"Cambiar ");
    P1 := LeerPrefijosTel();
    InsertarTelefonoLTelefonos(P1,LT);
    CPrefijos := CPrefijos+1;
    WriteString(Chan,"Por el ");
    P2 := LeerPrefijosTel();
    InsertarTelefonoLTelefonos(P2,LT2);
    WriteString(Chan,"Cambio ingresado.");WriteLn(Chan);
    WriteString(Chan,"Ingresar otro?");WriteLn(Chan);
    WriteString(Chan,"Ingresar otro?");WriteLn(Chan);WriteLn(Chan);
    WriteString(Chan,"  S   - Si");WriteLn(Chan);
    WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
    WriteString(Chan,">");
    ReadChar(InChan(),p);SkipLine(InChan());WriteLn(Chan);
   UNTIL (p <> "S") AND (p <> "s");
   CPrefijos := CPrefijos-1;

   L := ObtenerPosicionesLNombres(Personal,LN);
   FOR n:=0 TO 1 DO
    j := 0;
    WHILE (ExisteNatLNat(j,L)) DO
     C := RecuperarContacto(ObtenerNatLNat(j,L));
     k := 0;
     WHILE (ExisteCampoContacto(Tel,k,C)) DO
      V :=  ObtenerTelefonoContacto(k,C);

      P1 := ObtenerTelefonoLTelefonos(0,LT);
      m := 0;
      WHILE (m <= CPrefijos) AND NOT(CompararTel(P1,V)) DO
       m := m+1;
       IF (m <= CPrefijos) THEN
        P1 := ObtenerTelefonoLTelefonos(m,LT);
       END;(*/IF*)
      END;(*/WHILE*)

      IF (m <= CPrefijos) THEN
       P2 := ObtenerTelefonoLTelefonos(m,LT2);
       FOR l:=0 TO P2.Largo-1 DO
        N.T[l] := P2.T[l];
       END;(*/FOR*)
        N.Largo := P2.Largo-P1.Largo+V.Largo;
       FOR l:=P2.Largo TO N.Largo DO
        N.T[l] := V.T[l-P2.Largo];
       END;(*/FOR*)
       EditarTelefonoContacto(N,k,C);
      END;(*/IF*)
      k := k+1;
     END;(*/WHILE*)
     PersistirContacto(C,ObtenerNatLNat(j,L));
     j := j+1;
    END;(*/WHILE*)
    L := ObtenerPosicionesLNombres(Negocios,LN);
   END;(*/FOR*)
   DestruirLTelefonos(LT);
   DestruirLTelefonos(LT2);
  END;(*/IF*)
 END CambiarTelefonos;
END Procedimientos.