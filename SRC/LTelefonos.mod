IMPLEMENTATION MODULE LTelefonos;
(******************************************************************************)
(********************************IMPORTACIONES*********************************)
(******************************************************************************)

FROM Storage IMPORT ALLOCATE, DEALLOCATE;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 LTelefonos = POINTER TO TLTelefonos;

 Lista = POINTER TO TLista;

 TLTelefonos = RECORD
  Cont : CARDINAL;
  L : Lista;
 END;(*/RECORD*)

 TLista = RECORD
  T : Telefono;
  Sig : Lista;
 END;(*/RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(*****************************CREAR LTELEFONOS*********************************)
(*Crea la LTelefonos vacía*)
PROCEDURE CrearLTelefonos():LTelefonos;
 VAR
  L : LTelefonos;

 BEGIN
  NEW(L);
  L^.Cont := 0;
  L^.L := NIL;
  RETURN(L);
 END CrearLTelefonos;

(**********************INSERTAR TELEFONO LTELEFONOS****************************)
(*Inserta T al comienzo de LT*)
PROCEDURE InsertarTelefonoLTelefonos(T:Telefono;VAR LT:LTelefonos);
 VAR
  Nuevo: Lista;

 BEGIN
  NEW(Nuevo);
  Nuevo^.T := T;
  Nuevo^.Sig := LT^.L;
  LT^.L := Nuevo;
  LT^.Cont := LT^.Cont+1;
 END InsertarTelefonoLTelefonos;


(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************PREDICADOS************************************)
(******************************************************************************)

(*************************EXISTE TELEFONO LTELEFONOS***************************)
(*Retorna TRUE si existe el teléfono i en LT, (Las posiciones inician en 0)*)
PROCEDURE ExisteTelefonoLTelefonos(i:CARDINAL; LT:LTelefonos): BOOLEAN;
 BEGIN
  RETURN(i < LT^.Cont);
 END ExisteTelefonoLTelefonos;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(************************OBTENER TELEFONO LTELEFONOS***************************)
(*Retorna, si existe, el teléfono i de LT, (Las posiciones inician en 0)*)
PROCEDURE ObtenerTelefonoLTelefonos(i:CARDINAL; LT:LTelefonos): Telefono;
 VAR
  j : CARDINAL;
  aux : Lista;

 BEGIN
  aux := LT^.L;
  j := 0;
  WHILE (j < i) DO
   aux := aux^.Sig;
   j := j+1;
  END;(*/WHILE*)
  RETURN(aux^.T);
 END ObtenerTelefonoLTelefonos;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(************************DESTRUIR TELEFONO LTELEFONOS**************************)
(*Destruye el teléfono i de LT, debe existir i, (Las posiciones inician en 0)*)
PROCEDURE DestruirTelefonoLTelefonos(i:CARDINAL; VAR LT:LTelefonos);
 VAR
  aux, borrar : Lista;
  j : CARDINAL;

 BEGIN
  IF (i = 0) THEN
   borrar := LT^.L;
   LT^.L := LT^.L^.Sig;
  ELSE
   aux := LT^.L;
   j := 1;
   WHILE (j < i) DO
    aux := aux^.Sig;
    j := j+1;
   END;(*/WHILE*)
   borrar := aux^.Sig;
   aux^.Sig := aux^.Sig^.Sig;
  END;(*/IF*)
  DISPOSE(borrar);
  LT^.Cont := LT^.Cont-1;
 END DestruirTelefonoLTelefonos;

(*****************************DESTRUIR LTELEFONOS******************************)
(*Destruye a LT*)
PROCEDURE DestruirLTelefonos(VAR LT:LTelefonos);
 VAR
  aux : Lista;

 BEGIN
  WHILE (LT^.L <> NIL) DO
   aux := LT^.L;
   LT^.L := LT^.L^.Sig;
   DISPOSE(aux);
  END;(*/WHILE*)
  DISPOSE(LT);
 END DestruirLTelefonos;
END LTelefonos.