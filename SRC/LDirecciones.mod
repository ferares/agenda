IMPLEMENTATION MODULE LDirecciones;

(******************************************************************************)
(********************************IMPORTACIONES*********************************)
(******************************************************************************)

FROM Storage IMPORT ALLOCATE, DEALLOCATE;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 LDirecciones = POINTER TO TLDirecciones;

 Lista = POINTER TO TLista;

 TLDirecciones = RECORD
  Cont : CARDINAL;
  L : Lista;
 END;(*/RECORD*)

 TLista = RECORD
  D : Direccion;
  Sig : Lista;
 END;(*/RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(****************************CREAR LDIRECCIONES********************************)
(*Crea la LDirecciones vacía*)
PROCEDURE CrearLDirecciones():LDirecciones;
 VAR
  L : LDirecciones;

 BEGIN
  NEW(L);
  L^.Cont := 0;
  L^.L := NIL;
  RETURN(L);
 END CrearLDirecciones;


(*********************INSERTAR DIRECCION LDIRECCIONES**************************)
(*Inserta D al comienzo de LD*)
PROCEDURE InsertarDireccionLDirecciones(D:Direccion;VAR LD:LDirecciones);
 VAR
  Nuevo: Lista;

 BEGIN
  NEW(Nuevo);
  Nuevo^.D := D;
  Nuevo^.Sig := LD^.L;
  LD^.L := Nuevo;
  LD^.Cont := LD^.Cont+1;
 END InsertarDireccionLDirecciones;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************PREDICADOS************************************)
(******************************************************************************)

(***********************EXISTE DIRECCION LDIRECCIONES**************************)
(*Retorna TRUE si existe la dirección i en LD, (Las posiciones inician en 0)*)
PROCEDURE ExisteDireccionLDirecciones(i:CARDINAL; LD:LDirecciones): BOOLEAN;
 BEGIN
  RETURN(i < LD^.Cont);
 END ExisteDireccionLDirecciones;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(**********************OBTENER DIRECCION LDIRECCIONES**************************)
(*Retorna, si existe, la dirección i de LD, (Las posiciones inician en 0)*)
PROCEDURE ObtenerDireccionLDirecciones(i:CARDINAL; LD:LDirecciones): Direccion;
 VAR
  j : CARDINAL;
  aux : Lista;

 BEGIN
  aux := LD^.L;
  j := 0;
  WHILE (j < i) DO
   aux := aux^.Sig;
   j := j+1;
  END;(*/WHILE*)
  RETURN(aux^.D);
 END ObtenerDireccionLDirecciones;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(**********************DESTRUIR DIRECCION LDIRECCIONES*************************)
(*Destruye la dirección i de LD, debe existir i, (Las posiciones inician en 0)*)
PROCEDURE DestruirDireccionLDirecciones(i:CARDINAL; VAR LD:LDirecciones);
 VAR
  aux, borrar : Lista;
  j : CARDINAL;

 BEGIN
  IF (i = 0) THEN
   borrar := LD^.L;
   LD^.L := LD^.L^.Sig;
  ELSE
   aux := LD^.L;
   j := 1;
   WHILE (j < i) DO
    aux := aux^.Sig;
    j := j+1;
   END;(*/WHILE*)
   borrar := aux^.Sig;
   aux^.Sig := aux^.Sig^.Sig;
  END;(*/IF*)
  DISPOSE(borrar);
  LD^.Cont := LD^.Cont-1;
 END DestruirDireccionLDirecciones;

(****************************DESTRUIR LDIRECCIONES*****************************)
(*Destruye a LD*)
PROCEDURE DestruirLDirecciones(VAR LD:LDirecciones);
 VAR
  aux : Lista;

 BEGIN
  WHILE (LD^.L <> NIL) DO
   aux := LD^.L;
   LD^.L := LD^.L^.Sig;
   DISPOSE(aux);
  END;(*/WHILE*)
  DISPOSE(LD);
 END DestruirLDirecciones;
END LDirecciones.