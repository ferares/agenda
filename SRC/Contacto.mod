IMPLEMENTATION MODULE Contacto;

(******************************************************************************)
(*******************************IMPORTACIONES**********************************)
(******************************************************************************)

FROM LDirecciones IMPORT LDirecciones, Direccion, ObtenerDireccionLDirecciones,
                         ExisteDireccionLDirecciones, DestruirLDirecciones,
			 DestruirDireccionLDirecciones, CrearLDirecciones,
			 InsertarDireccionLDirecciones;

FROM LCorreos IMPORT LCorreos, Correo, ObtenerCorreoLCorreos, CrearLCorreos,
                     ExisteCorreoLCorreos, DestruirCorreoLCorreos,
		     InsertarCorreoLCorreos, DestruirLCorreos;

FROM LTelefonos IMPORT LTelefonos, ObtenerTelefonoLTelefonos,DestruirLTelefonos,
                       ExisteTelefonoLTelefonos, DestruirTelefonoLTelefonos,
		       InsertarTelefonoLTelefonos, CrearLTelefonos, Telefono;

FROM LCelulares IMPORT LCelulares, ObtenerCelularLCelulares, DestruirLCelulares,
                       ExisteCelularLCelulares, DestruirCelularLCelulares,
		       InsertarCelularLCelulares, CrearLCelulares, Celular;
		
FROM Strings IMPORT Assign;
		
FROM Storage IMPORT ALLOCATE, DEALLOCATE;

FROM TextIO IMPORT WriteString, WriteLn;

FROM WholeIO IMPORT WriteCard;

FROM IOChan IMPORT ChanId;

FROM StdChans IMPORT StdOutChan;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 Contacto = POINTER TO TContacto;

 TContacto = RECORD
  Name : Nombre;
  LD : LDirecciones;
  LC : LCorreos;
  LT : LTelefonos;
  LCel : LCelulares;
 END;(*/RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(******************************CREAR CONTACTO**********************************)
(*Crea un contacto de nombre N, tipo T y campos vacíos*)
PROCEDURE CrearContacto(N:Nombre):Contacto;
 VAR
  C : Contacto;

 BEGIN
  NEW(C);
  Assign(N,C^.Name);
  C^.LD := CrearLDirecciones();
  C^.LC := CrearLCorreos();
  C^.LT := CrearLTelefonos();
  C^.LCel := CrearLCelulares();
  RETURN(C);
 END CrearContacto;

(**************************EDITAR NOMBRE CONTACTO******************************)
(*Se cambia el campo nombre del contacto C por el valor de la variable N*)
PROCEDURE EditarNombreContacto(N:Nombre; VAR C:Contacto);
 BEGIN
  Assign(N,C^.Name);
 END EditarNombreContacto;

(*************************EDITAR DIRECCION CONTACTO****************************)
(*Se elimina la dirección i del contacto C, y se inserta D,
  si no existe i, solo se inserta D*)
PROCEDURE EditarDireccionContacto(D:Direccion; i:CARDINAL; VAR C:Contacto);
 BEGIN
  IF (ExisteDireccionLDirecciones(i,C^.LD)) THEN
   DestruirDireccionLDirecciones(i,C^.LD);
  END;(*/IF*)
  InsertarDireccionLDirecciones(D,C^.LD);
 END EditarDireccionContacto;

(***************************EDITAR CORREO CONTACTO*****************************)
(*Se elimina el correo i del contacto C, y se inserta Cor,
  si no existe i, solo se inserta Cor*)
PROCEDURE EditarCorreoContacto(Cor:Correo; i:CARDINAL; VAR C:Contacto);
 BEGIN
  IF (ExisteCorreoLCorreos(i,C^.LC)) THEN
   DestruirCorreoLCorreos(i,C^.LC);
  END;(*/IF*)
  InsertarCorreoLCorreos(Cor,C^.LC);
 END EditarCorreoContacto;

(**************************EDITAR TELEFONO CONTACTO****************************)
(*Se elimina el teléfono i del contacto C, y se inserta T,
  si no existe i, solo se inserta T*)
PROCEDURE EditarTelefonoContacto(T:Telefono; i:CARDINAL; VAR C:Contacto);
 BEGIN
  IF (ExisteTelefonoLTelefonos(i,C^.LT)) THEN
   DestruirTelefonoLTelefonos(i,C^.LT);
  END;(*/IF*)
  InsertarTelefonoLTelefonos(T,C^.LT);
 END EditarTelefonoContacto;

(**************************EDITAR CELULAR CONTACTO*****************************)
(*Se elimina el celular i del contacto C, y se inserta Cel,
  si no existe i, solo se inserta Cel*)
PROCEDURE EditarCelularContacto(Cel:Celular; i:CARDINAL; VAR C:Contacto);
 BEGIN
  IF (ExisteCelularLCelulares(i,C^.LCel)) THEN
   DestruirCelularLCelulares(i,C^.LCel);
  END;(*/IF*)
  InsertarCelularLCelulares(Cel,C^.LCel);
 END EditarCelularContacto;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************PREDICADOS************************************)
(******************************************************************************)

(**************************EXISTE CAMPO CONTACTO*******************************)
(*Retorna TRUE si existe el elemento i del Campo Camp en el contacto C.*)
PROCEDURE ExisteCampoContacto(Camp:Campos; i:CARDINAL; C:Contacto):BOOLEAN;
 BEGIN
  CASE Camp OF
   Address  : RETURN(ExisteDireccionLDirecciones(i,C^.LD));|
   Tel : RETURN(ExisteTelefonoLTelefonos(i,C^.LT));|
   Cel  : RETURN(ExisteCelularLCelulares(i,C^.LCel));|
   Mail     : RETURN(ExisteCorreoLCorreos(i,C^.LC));|
  ELSE
   RETURN(TRUE);
  END;(*/CASE*)
 END ExisteCampoContacto;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(**************************OBTENER NOMBRE CONTACTO*****************************)
(*Retorna el nombre del contacto C*)
PROCEDURE ObtenerNombreContacto(C:Contacto):Nombre;
 BEGIN
  RETURN(C^.Name);
 END ObtenerNombreContacto;

(************************OBTENER DIRECCION CONTACTO****************************)
(*Retorna la direccion i del contacto C; debe existir i*)
PROCEDURE ObtenerDireccionContacto(i:CARDINAL; C:Contacto):Direccion;
 BEGIN
  RETURN(ObtenerDireccionLDirecciones(i,C^.LD));
 END ObtenerDireccionContacto;

(*************************OBTENER CORREO CONTACTO******************************)
(*Retorna el correo i del contacto C; debe existir i*)
PROCEDURE ObtenerCorreoContacto(i:CARDINAL; C:Contacto):Correo;
 BEGIN
  RETURN(ObtenerCorreoLCorreos(i,C^.LC));
 END ObtenerCorreoContacto;

(************************OBTENER TELEFONO CONTACTO*****************************)
(*Retorna el teléfono i del contacto C; debe existir i*)
PROCEDURE ObtenerTelefonoContacto(i:CARDINAL; C:Contacto):Telefono;
 BEGIN
  RETURN(ObtenerTelefonoLTelefonos(i,C^.LT));
 END ObtenerTelefonoContacto;

(*************************OBTENER CELULAR CONTACTO*****************************)
(*Retorna el celular i del contacto C; debe existir i*)
PROCEDURE ObtenerCelularContacto(i:CARDINAL; C:Contacto):Celular;
 BEGIN
  RETURN(ObtenerCelularLCelulares(i,C^.LCel));
 END ObtenerCelularContacto;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************ENTRADA/SALIDA**********************************)
(******************************************************************************)

(*************************IMPRIMIR CAMPOS CONTACTO*****************************)
(*Imprime el campo Camp del contacto C en el canal Cid*)
PROCEDURE ImprimirCampoContacto(Cid:ChanId;Camp:Campos;C:Contacto);
 VAR
  i,j : CARDINAL;
  D : Direccion;
  Cor : Correo;
  T : Telefono;
  CL : Celular;

 BEGIN
  i := 0;

  IF (Camp = Nombres) THEN

   WriteString(Cid,C^.Name);WriteLn(Cid);

  ELSIF (Camp = Address) THEN

   WHILE (ExisteDireccionLDirecciones(i,C^.LD)) DO
    D := ObtenerDireccionLDirecciones(i,C^.LD);
    IF (Cid = StdOutChan()) THEN
     WriteCard(Cid,i+1,1);
     WriteString(Cid,") ");
    END;(*/IF*)
    WriteString(Cid,D);
    WriteLn(Cid);
    i := i+1;
   END;(*/WHILE*)

  ELSIF (Camp = Tel) THEN

   WHILE (ExisteTelefonoLTelefonos(i,C^.LT)) DO
    T := ObtenerTelefonoLTelefonos(i,C^.LT);
    IF (Cid = StdOutChan()) THEN
     WriteCard(Cid,i+1,1);
     WriteString(Cid,") ");
    END;(*/IF*)
    FOR j:=0 TO T.Largo-1 DO
     WriteCard(Cid,T.T[j],1);
    END;(*/FOR*)
    WriteLn(Cid);
    i := i+1;
   END;(*/WHILE*)

  ELSIF (Camp = Cel) THEN

   WHILE (ExisteCelularLCelulares(i,C^.LCel)) DO
    CL := ObtenerCelularLCelulares(i,C^.LCel);
    IF (Cid = StdOutChan()) THEN
     WriteCard(Cid,i+1,1);
     WriteString(Cid,") ");
    END;(*/IF*)
    FOR j:=0 TO CL.Largo-1 DO
     WriteCard(Cid,CL.C[j],1);
    END;(*/FOR*)
    WriteLn(Cid);
    i := i+1;
   END;(*/WHILE*)

  ELSE

   WHILE (ExisteCorreoLCorreos(i,C^.LC)) DO
    Cor := ObtenerCorreoLCorreos(i,C^.LC);
    IF (Cid = StdOutChan()) THEN
     WriteCard(Cid,i+1,1);
     WriteString(Cid,") ");
    END;(*/IF*)
    WriteString(Cid,Cor);
    WriteLn(Cid);
    i := i+1;
   END;(*/WHILE*)

  END;(*/IF*)
 END ImprimirCampoContacto;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(************************DESTRUIR DIRECCION CONTACTO***************************)
(*Destruye la direccion i del contacto C; debe existir i*)
PROCEDURE DestruirDireccionContacto(i:CARDINAL; VAR C:Contacto);
 BEGIN
  DestruirDireccionLDirecciones(i,C^.LD);
 END DestruirDireccionContacto;

(*************************DESTRUIR CORREO CONTACTO*****************************)
(*Destruye el correo i del contacto C; debe existir i*)
PROCEDURE DestruirCorreoContacto(i:CARDINAL; VAR C:Contacto);
 BEGIN
  DestruirCorreoLCorreos(i,C^.LC);
 END DestruirCorreoContacto;

(************************DESTRUIR TELEFONO CONTACTO****************************)
(*Destruye el teléfono i del contacto C; debe existir i*)
PROCEDURE DestruirTelefonoContacto(i:CARDINAL; VAR C:Contacto);
 BEGIN
  DestruirTelefonoLTelefonos(i,C^.LT);
 END DestruirTelefonoContacto;

(************************DESTRUIR CELULAR CONTACTO*****************************)
(*Destruye el celular i del contacto C; debe existir i*)
PROCEDURE DestruirCelularContacto(i:CARDINAL; VAR C:Contacto);
 BEGIN
  DestruirCelularLCelulares(i,C^.LCel);
 END DestruirCelularContacto;

(****************************DESTRUIR CONTACTO*********************************)
(*Destruye el contacto C*)
PROCEDURE DestruirContacto(VAR C:Contacto);
 BEGIN
  DestruirLCorreos(C^.LC);
  DestruirLDirecciones(C^.LD);
  DestruirLTelefonos(C^.LT);
  DestruirLCelulares(C^.LCel);
  DISPOSE(C);
 END DestruirContacto;
END Contacto.