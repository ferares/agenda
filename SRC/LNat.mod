IMPLEMENTATION MODULE LNat;

(******************************************************************************)
(*******************************IMPORTACIONES**********************************)
(******************************************************************************)

FROM Storage IMPORT ALLOCATE, DEALLOCATE;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 LNat = POINTER TO TLista;

 TLista = RECORD
  Elem : CARDINAL;
  Sig : LNat;
 END;(*RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(*******************************CREAR LNAT*************************************)
(*Crea la lista vacía*)
PROCEDURE CrearLNat():LNat;
 BEGIN
  RETURN(NIL);
 END CrearLNat;

(****************************INSETAR NAT LNAT**********************************)
(*Inserta x al final de la lista*)
PROCEDURE InsertarNatLNat(x:CARDINAL;VAR l:LNat);
 VAR
  nodo,aux : LNat;

 BEGIN
  NEW(nodo);
  nodo^.Elem := x;
  nodo^.Sig := NIL;

  IF (l = NIL) THEN
   l := nodo;
  ELSE
   aux := l;
   WHILE (aux^.Sig <> NIL) DO
    aux := aux^.Sig;
   END;(*/WHILE*)
   aux^.Sig := nodo;
  END;(*/IF*)
 END InsertarNatLNat;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************PREDICADOS************************************)
(******************************************************************************)

(*****************************EXISTE NAT LNAT**********************************)
(*Retorna TRUE si existe el elemento i en l,(el primer elemento es el 0)*)
PROCEDURE ExisteNatLNat(i:CARDINAL;l:LNat):BOOLEAN;
 VAR
  j : CARDINAL;

 BEGIN
  j := 0;
  WHILE (l <> NIL) AND (j < i) DO
   l := l^.Sig;
   j := j+1;
  END;(*/WHILE*)
  RETURN(l <> NIL);
 END ExisteNatLNat;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(*************************OBTENER NAT ELEMENTO LNAT****************************)
(*Retorna el elemento i de l, debe existir i,(el primer elemento es el 0)*)
PROCEDURE ObtenerNatLNat(i:CARDINAL;l:LNat):CARDINAL;
 VAR
  j : CARDINAL;

 BEGIN
  j := 0;
  WHILE (j < i) DO
   l := l^.Sig;
   j := j+1;
  END;(*/WHILE*)
  RETURN(l^.Elem);
 END ObtenerNatLNat;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(******************************DESTRUIR NAT LNAT*******************************)
(*Destruye el elemento i de l, (el primer elemento es el 0)*)
PROCEDURE DestruirNatLNat(i:CARDINAL;VAR l:LNat);
 VAR
  aux, borrar : LNat;
  j : CARDINAL;

 BEGIN
  IF (l <> NIL) THEN
   IF (i = 0) THEN
    borrar := l;
    l := l^.Sig;
   ELSE
    aux := l;
    j := 0;
    WHILE (aux <> NIL) AND (j < i-1) DO
     aux := aux^.Sig;
     j := j+1;
    END;(*/WHILE*)
    borrar := aux^.Sig;
    aux^.Sig := aux^.Sig^.Sig;
   END;(*/IF*)
   DISPOSE(borrar);
  END;(*/IF*)
 END DestruirNatLNat;

(********************************DESTRUIR LNAT*********************************)
(*Destruye l*)
PROCEDURE DestruirLNat(VAR l:LNat);
 VAR
  aux : LNat;

 BEGIN
  WHILE (l <> NIL) DO
   aux := l;
   l := l^.Sig;
   DISPOSE(aux);
  END;(*/WHILE*)
 END DestruirLNat;
END LNat.