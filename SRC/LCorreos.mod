IMPLEMENTATION MODULE LCorreos;

(******************************************************************************)
(********************************IMPORTACIONES*********************************)
(******************************************************************************)

FROM Storage IMPORT ALLOCATE, DEALLOCATE;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 LCorreos = POINTER TO TLCorreos;

 Lista = POINTER TO TLista;

 TLCorreos = RECORD
  Cont : CARDINAL;
  L : Lista;
 END;(*/RECORD*)

 TLista = RECORD
  C : Correo;
  Sig : Lista;
 END;(*/RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(******************************CREAR LCORREOS**********************************)
(*Crea la LCorreos vacía*)
PROCEDURE CrearLCorreos():LCorreos;
 VAR
  L : LCorreos;

 BEGIN
  NEW(L);
  L^.Cont := 0;
  L^.L := NIL;
  RETURN(L);
 END CrearLCorreos;

(*************************INSERTAR CORREO LCORREOS*****************************)
(*Inserta C al comienzo de LT*)
PROCEDURE InsertarCorreoLCorreos(C:Correo;VAR LC:LCorreos);
 VAR
  Nuevo: Lista;

 BEGIN
  NEW(Nuevo);
  Nuevo^.C := C;
  Nuevo^.Sig := LC^.L;
  LC^.L := Nuevo;
  LC^.Cont := LC^.Cont+1;
 END InsertarCorreoLCorreos;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************PREDICADOS************************************)
(******************************************************************************)

(***************************EXISTE CORREO LCORREOS*****************************)
(*Retorna TRUE si existe el correo i en LC, (Las posiciones inician en 0)*)
PROCEDURE ExisteCorreoLCorreos(i:CARDINAL; LC:LCorreos): BOOLEAN;
 BEGIN
  RETURN(i < LC^.Cont);
 END ExisteCorreoLCorreos;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(**************************OBTENER CORREO LCORREOS*****************************)
(*Retorna, si existe, el correo i de LC, (Las posiciones inician en 0)*)
PROCEDURE ObtenerCorreoLCorreos(i:CARDINAL; LC:LCorreos): Correo;
 VAR
  j : CARDINAL;
  aux : Lista;

 BEGIN
  aux := LC^.L;
  j := 0;
  WHILE (j < i) DO
   aux := aux^.Sig;
   j := j+1;
  END;(*/WHILE*)
  RETURN(aux^.C);
 END ObtenerCorreoLCorreos;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(**************************DESTRUIR CORREO LCORREOS****************************)
(*Destruye el correo i de LC, debe existir i, (Las posiciones inician en 0)*)
PROCEDURE DestruirCorreoLCorreos(i:CARDINAL; VAR LC:LCorreos);
 VAR
  aux, borrar : Lista;
  j : CARDINAL;

 BEGIN
  IF (i = 0) THEN
   borrar := LC^.L;
   LC^.L := LC^.L^.Sig;
  ELSE
   aux := LC^.L;
   j := 1;
   WHILE (j < i) DO
    aux := aux^.Sig;
    j := j+1;
   END;(*/WHILE*)
   borrar := aux^.Sig;
   aux^.Sig := aux^.Sig^.Sig;
  END;(*/IF*)
  DISPOSE(borrar);
  LC^.Cont := LC^.Cont-1;
 END DestruirCorreoLCorreos;

(******************************DESTRUIR LCORREOS*******************************)
(*Destruye a LC*)
PROCEDURE DestruirLCorreos(VAR LC:LCorreos);
 VAR
  aux : Lista;

 BEGIN
  WHILE (LC^.L <> NIL) DO
   aux := LC^.L;
   LC^.L := LC^.L^.Sig;
   DISPOSE(aux);
  END;(*/WHILE*)
  DISPOSE(LC);
 END DestruirLCorreos;
END LCorreos.