IMPLEMENTATION MODULE LCelulares;

(******************************************************************************)
(********************************IMPORTACIONES*********************************)
(******************************************************************************)

FROM Storage IMPORT ALLOCATE, DEALLOCATE;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 LCelulares = POINTER TO TLCelulares;

 Lista = POINTER TO TLista;

 TLCelulares = RECORD
  Cont : CARDINAL;
  L : Lista;
 END;(*/RECORD*)

 TLista = RECORD
  Cel : Celular;
  Sig : Lista;
 END;(*/RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(*****************************CREAR LCELULARES*********************************)
(*Crea la LCelulares vacía*)
PROCEDURE CrearLCelulares():LCelulares;
 VAR
  L : LCelulares;

 BEGIN
  NEW(L);
  L^.Cont := 0;
  L^.L := NIL;
  RETURN(L);
 END CrearLCelulares;

(**********************INSERTAR CELULAR LCELULARES*****************************)
(*Inserta C al comienzo de LC*)
PROCEDURE InsertarCelularLCelulares(C:Celular;VAR LC:LCelulares);
 VAR
  Nuevo: Lista;

 BEGIN
  NEW(Nuevo);
  Nuevo^.Cel := C;
  Nuevo^.Sig := LC^.L;
  LC^.L := Nuevo;
  LC^.Cont := LC^.Cont+1;
 END InsertarCelularLCelulares;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************PREDICADOS************************************)
(******************************************************************************)

(*************************EXISTE CELULAR LCELULARES****************************)
(*Retorna TRUE si existe el celular i en LC, (Las posiciones inician en 0)*)
PROCEDURE ExisteCelularLCelulares(i:CARDINAL; LC:LCelulares): BOOLEAN;
 BEGIN
  RETURN(i < LC^.Cont);
 END ExisteCelularLCelulares;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(************************OBTENER CELULAR LCELULARES****************************)
(*Retorna, si existe, el celular i de LC, (Las posiciones inician en 0)*)
PROCEDURE ObtenerCelularLCelulares(i:CARDINAL; LC:LCelulares): Celular;
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
  RETURN(aux^.Cel);
 END ObtenerCelularLCelulares;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(************************DESTRUIR CELULAR LCELULARES***************************)
(*Destruye el celular i de LC, debe existir i, (Las posiciones inician en 0)*)
PROCEDURE DestruirCelularLCelulares(i:CARDINAL; VAR LC:LCelulares);
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
 END DestruirCelularLCelulares;

(*****************************DESTRUIR LCELULARES******************************)
(*Destruye a LC*)
PROCEDURE DestruirLCelulares(VAR LC:LCelulares);
 VAR
  aux : Lista;

 BEGIN
  WHILE (LC^.L <> NIL) DO
   aux := LC^.L;
   LC^.L := LC^.L^.Sig;
   DISPOSE(aux);
  END;(*/WHILE*)
  DISPOSE(LC);
 END DestruirLCelulares;
END LCelulares.