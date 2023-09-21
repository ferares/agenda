IMPLEMENTATION MODULE ABBNombres;

(******************************************************************************)
(*******************************IMPORTACIONES**********************************)
(******************************************************************************)

FROM Contacto IMPORT Nombre, Tipo;

FROM LNat IMPORT LNat, ObtenerNatLNat, ExisteNatLNat, CrearLNat,InsertarNatLNat;

FROM LNombres IMPORT LNombres, ObtenerNombreLNombres;

FROM Strings IMPORT Compare, CompareResults;
			
FROM Storage IMPORT ALLOCATE, DEALLOCATE;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 ABBNombres = POINTER TO ABB;

 ABB = RECORD
  left,right : ABBNombres;
  I : CARDINAL;
 END;(*/RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(****************************CREAR ABB NOMBRES*********************************)
(*Devuelve el arbol vacio*)
PROCEDURE CrearABBNombres():ABBNombres;
 BEGIN
  RETURN(NIL);
 END CrearABBNombres;

(**************************AGREGAR ABB NOMBRES*********************************)
(*Agrega el elemento de LN con indice i en ABB. Ordenado alfabeticamente*)	
PROCEDURE AgregarABBNombres(i:CARDINAL;LN:LNombres;T:Tipo;VAR ABB:ABBNombres);
 VAR
  No, Nn : Nombre;

 BEGIN
  IF (ABB = NIL) THEN
   NEW(ABB);
   ABB^.I := i;
   ABB^.right := NIL;
   ABB^.left := NIL;
  ELSE
   Nn := ObtenerNombreLNombres(i,T,LN);
   No := ObtenerNombreLNombres(ABB^.I,T,LN);
   IF (Compare(Nn,No) = greater) THEN
    AgregarABBNombres(i,LN,T,ABB^.right);
   ELSE
    AgregarABBNombres(i,LN,T,ABB^.left);
   END;(*/IF*)
  END;(*/IF*)
 END AgregarABBNombres;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(***************************EN ORDEN ABBNOMBRES********************************)
(*Devuelve el recorrido en orden, en indices, de ABB*)
PROCEDURE EnOrdenABBNombres(ABB:ABBNombres):LNat;
 VAR
  Derecha, Izquierda, Salida : LNat;
  i,j : CARDINAL;

 BEGIN

  Salida := CrearLNat();
  IF (ABB <> NIL) THEN

   Derecha := EnOrdenABBNombres(ABB^.right);
   Izquierda := EnOrdenABBNombres(ABB^.left);

   i := 0;
   WHILE (ExisteNatLNat(i,Izquierda)) DO
    j := ObtenerNatLNat(i,Izquierda);
    InsertarNatLNat(j,Salida);
    i := i+1;
   END;(*/WHILE*)

   InsertarNatLNat(ABB^.I,Salida);

   i := 0;
   WHILE (ExisteNatLNat(i,Derecha)) DO
    j := ObtenerNatLNat(i,Derecha);
    InsertarNatLNat(j,Salida);
    i := i+1;
   END;(*/WHILE*)

  END;(*/IF*)

  RETURN(Salida);
 END EnOrdenABBNombres;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(************************DESTRUIR ABB COMBINACIONES****************************)
(*Libera la memoria reservada para 'ABB'*)
PROCEDURE DestruirABBNombres(VAR ABB:ABBNombres);
 BEGIN
  IF (ABB <> NIL) THEN
   DestruirABBNombres(ABB^.right);
   DestruirABBNombres(ABB^.left);
   DISPOSE(ABB);
  END;(*/IF*)
 END DestruirABBNombres;
END ABBNombres.