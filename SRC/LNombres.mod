IMPLEMENTATION MODULE LNombres;

(******************************************************************************)
(*******************************IMPORTACIONES**********************************)
(******************************************************************************)

FROM Contacto IMPORT Nombre, Tipo;

FROM LNat IMPORT LNat, CrearLNat, InsertarNatLNat, DestruirLNat, ExisteNatLNat,
                 ObtenerNatLNat, DestruirNatLNat;
		
FROM ABBNombres IMPORT CrearABBNombres, EnOrdenABBNombres, AgregarABBNombres,
                       DestruirABBNombres, ABBNombres;

FROM Storage IMPORT ALLOCATE, DEALLOCATE;

FROM Strings IMPORT FindNext, Extract, Delete, Assign, Capitalize;

FROM WholeIO IMPORT WriteCard, ReadCard;

FROM TextIO IMPORT WriteString, WriteLn, SkipLine, ReadString;

FROM WholeStr IMPORT ConvResults, StrToCard;

FROM IOChan IMPORT ChanId;

(******************************************************************************)
(***********************************TIPOS**************************************)
(******************************************************************************)

TYPE
 LNombres = POINTER TO TLNombres;

 Lista = POINTER TO TLista;

 TLNombres = RECORD
  Cont : CARDINAL; (*Cantidad de nombres totales*)
  LNN : Lista; (*lista de nombres negocios*)
  LNP : Lista; (*lista de nombres personal*)
  PL : LNat; (*posiciones libres*)
 END;(*/RECORD*)

 TLista = RECORD
  N : Nombre;
  Pos : CARDINAL; (*posición, identificador único de c/nombre*)
  Sig : Lista;
 END;(*/RECORD*)

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************CONSTRUCTORES***********************************)
(******************************************************************************)

(******************************CREAR LNOMBRES**********************************)
(*Crea la LNombres vacía*)
PROCEDURE CrearLNombres():LNombres;
 VAR
  L : LNombres;

 BEGIN
  NEW(L);
  L^.Cont := 0;
  L^.LNN := NIL;
  L^.LNP := NIL;
  L^.PL := CrearLNat();
  RETURN(L);
 END CrearLNombres;

(************************INSERTAR NOMBRE LNOMBRES******************************)
(*Inserta N en LN, y devuelve su posición en LN*)
PROCEDURE InsertarNombreLNombres(N:Nombre;T:Tipo;VAR LN:LNombres):CARDINAL;
 VAR
  Nodo : Lista;

 BEGIN
  NEW(Nodo);
  Nodo^.N := N;
  LN^.Cont := LN^.Cont+1;

  IF (T = Personal) THEN
   Nodo^.Sig := LN^.LNP;
   LN^.LNP := Nodo;
  ELSE
   Nodo^.Sig := LN^.LNN;
   LN^.LNN := Nodo;
  END;(*/IF*)

  IF NOT(ExisteNatLNat(0,LN^.PL)) THEN
   Nodo^.Pos := LN^.Cont;
  ELSE
   Nodo^.Pos := ObtenerNatLNat(0,LN^.PL);
   DestruirNatLNat(0,LN^.PL);
  END;(*/IF*)

  RETURN(Nodo^.Pos);
 END InsertarNombreLNombres;

(*************************EDITAR NOMBRE LNOMBRES*******************************)
(*Cambia el nombre de la posicion P y de tipo T por N*)
PROCEDURE EditarNombreLNombres(N:Nombre;P:CARDINAL;VAR LN:LNombres);
 VAR
  aux : Lista;

 BEGIN
  aux := LN^.LNP;
  WHILE (aux <> NIL) AND (aux^.Pos <> P) DO
   aux := aux^.Sig;
  END;(*/WHILE*)

  IF (aux = NIL) THEN
   aux := LN^.LNN;
   WHILE (aux^.Pos <> P) DO
    aux := aux^.Sig;
   END;(*/WHILE*)
  END;(*/IF*)

  aux^.N := N;
 END EditarNombreLNombres;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************PREDICADOS************************************)
(******************************************************************************)

(************************PERTENECE NOMBRE LNOMBRES*****************************)
(*Retorna TRUE si y solo si, existe en LN el de la posicion P*)
PROCEDURE PerteneceNombreLNombres(P:CARDINAL;T:Tipo;LN:LNombres):BOOLEAN;
 VAR
  L : Lista;

 BEGIN
  IF (T = Personal) THEN
   L := LN^.LNP;
  ELSE
   L := LN^.LNN;
  END;(*/IF*)

  WHILE (L <> NIL) AND (L^.Pos <> P) DO
   L := L^.Sig;
  END;(*/WHILE*)

  RETURN(L <> NIL);
 END PerteneceNombreLNombres;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(********************************SELECTORES************************************)
(******************************************************************************)

(**************************OBTENER NOMBRE LNOMBRES*****************************)
(*Si existe en LN, retorna el nombre de la posicion P*)
PROCEDURE ObtenerNombreLNombres(P:CARDINAL;T:Tipo;LN:LNombres):Nombre;
 VAR
  L : Lista;

 BEGIN
  IF (T = Personal) THEN
   L := LN^.LNP;
  ELSE
   L := LN^.LNN;
  END;(*/IF*)

  WHILE (L <> NIL) AND (L^.Pos <> P) DO
   L := L^.Sig;
  END;(*/WHILE*)

  RETURN(L^.N);
 END ObtenerNombreLNombres;

(********************OBTENER COINCIDENCIAS NOMBRE LNOMBRES*********************)
(*Retorna las posiciones de todos los nombres que contienen a N en LN*)
PROCEDURE ObtenerCoincidenciasNombreLNombres(N:Nombre;T:Tipo;LN:LNombres):LNat;
 VAR
  i,j,l : CARDINAL;
  contiene : BOOLEAN;
  ABB : ABBNombres;
  indices, coin, salida, aux : LNat;
  Naux : Nombre;
  L : Lista;
  A : ARRAY [0..30] OF CARDINAL;

 BEGIN
  Capitalize(N);
  salida := CrearLNat();
  indices := CrearLNat();
  coin := CrearLNat();
  aux := CrearLNat();

  FOR i:=0 TO 30 DO
   A[i] := 0;
  END;(*/FOR*)

  IF (T = Personal) THEN
   L := LN^.LNP;
  ELSE
   L := LN^.LNN;
  END;(*/IF*)

  WHILE (L <> NIL) DO
   Naux := L^.N;
   Capitalize(Naux);
   FindNext(N,Naux,0,contiene,l);
   IF (contiene) THEN
    InsertarNatLNat(l,indices);
    InsertarNatLNat(L^.Pos,coin);
    A[l] := A[l]+1;
   END;(*/IF*)
   L := L^.Sig;
  END;(*/WHILE*)

  FOR i:=0 TO 30 DO
   WHILE (A[i] <> 0) DO

    j := 0;
    WHILE (ObtenerNatLNat(j,indices) <> i) DO
     j := j+1;
    END;(*/WHILE*)
    InsertarNatLNat(ObtenerNatLNat(j,coin),aux);
    DestruirNatLNat(j,coin);
    DestruirNatLNat(j,indices);
    A[i] := A[i] - 1;
   END;(*/WHILE*)

   ABB := CrearABBNombres();
   j := 0;
   WHILE (ExisteNatLNat(j,aux)) DO
    AgregarABBNombres(ObtenerNatLNat(j,aux),LN,T,ABB);
    j := j+1;
   END;(*/WHILE*)
   aux := EnOrdenABBNombres(ABB);
   DestruirABBNombres(ABB);
   j := 0;
   WHILE (ExisteNatLNat(j,aux)) DO
    InsertarNatLNat(ObtenerNatLNat(j,aux),salida);
    j := j+1;
   END;(*/WHILE*)
   DestruirLNat(aux);
   aux := CrearLNat();

  END;(*/FOR*)
  DestruirLNat(coin);
  DestruirLNat(indices);
  RETURN(salida);
 END ObtenerCoincidenciasNombreLNombres;

(************************OBTENER POSICIONES LNOMBRES***************************)
(*Retorna una lista con todos las posiciones de los nombres del tipo T*)
PROCEDURE ObtenerPosicionesLNombres(T:Tipo;LN:LNombres):LNat;
 VAR
  L : Lista;
  Lnat : LNat;

 BEGIN
  Lnat := CrearLNat();

  IF (T = Personal) THEN
   L := LN^.LNP;
  ELSE
   L := LN^.LNN;
  END;(*/IF*)

  WHILE (L <> NIL) DO
   InsertarNatLNat(L^.Pos,Lnat);
   L := L^.Sig;
  END;(*/WHILE*)
  RETURN(Lnat);
 END ObtenerPosicionesLNombres;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************ENTRADA/SALIDA**********************************)
(******************************************************************************)

(****************************PERSISTIR LNOMBRES********************************)
(*Persiste LN en el archivo Cid*)
PROCEDURE PersistirLNombres(Cid:ChanId;LN:LNombres);
 VAR
  aux : Lista;
  L : LNat;
  i : CARDINAL;

 BEGIN

  (*******POSICIONES LIBRES*******)
  (*Cantidad de posiciones libres*)
  L := LN^.PL;
  i := 0;
  WHILE (ExisteNatLNat(i,L)) DO
   i := i+1;
  END;(*/WHILE*)
  WriteCard(Cid,i,1);WriteLn(Cid);

  (*Posiciones libres*)
  IF (i <> 0) THEN
   L := LN^.PL;
   i:=0;
   WHILE (ExisteNatLNat(i,L)) DO
    WriteCard(Cid,ObtenerNatLNat(i,L),1);WriteLn(Cid);
    i := i+1;
   END;(*/WHILE*)
  END;(*/IF*)

  (********PERSONAL********)
  (*Cantidad de nombres*)
  aux := LN^.LNP;
  i := 0;
  WHILE (aux <> NIL) DO
   aux := aux^.Sig;
   i := i+1;
  END;(*/WHILE*)
  WriteCard(Cid,i,1);WriteLn(Cid);

  (*Nombres y posiciones*)
  IF (i <> 0) THEN
   aux := LN^.LNP;
   WHILE (aux <> NIL) DO
    WriteCard(Cid,aux^.Pos,1);WriteString(Cid,",");
    WriteString(Cid,aux^.N);WriteLn(Cid);
    aux := aux^.Sig;
   END;(*/WHILE*)
  END;(*/IF*)

  (********NEGOCIOS********)
  (*Cantidad de nombres*)
  aux := LN^.LNN;
  i := 0;
  WHILE (aux <> NIL) DO
   aux := aux^.Sig;
   i := i+1;
  END;(*/WHILE*)
  WriteCard(Cid,i,1);WriteLn(Cid);

  (*Nombres y posiciones*)
  IF (i <> 0) THEN
   aux := LN^.LNN;
   WHILE (aux <> NIL) DO
    WriteCard(Cid,aux^.Pos,1);WriteString(Cid,",");
    WriteString(Cid,aux^.N);WriteLn(Cid);
    aux := aux^.Sig;
   END;(*/WHILE*)
  END;(*/IF*)
 END PersistirLNombres;

(****************************RECUPERAR LNOMBRES********************************)
(*Recupera LN con el archivo Chan*)
PROCEDURE RecuperarLNombres(Chan:ChanId;VAR LN:LNombres);
 VAR
  LNaux : Lista;
  i,j,k,l,Cont : CARDINAL;
  Pos : ARRAY [0..7] OF CHAR;
  S : ARRAY [0..32] OF CHAR;
  N : Nombre;
  r : ConvResults;

 BEGIN
  LN := CrearLNombres();

  (*POSICIONES LIBRES*)
  ReadCard(Chan,i);
  FOR j:=1 TO i DO
   SkipLine(Chan);
   ReadCard(Chan,k);
   InsertarNatLNat(k,LN^.PL);
  END;(*/FOR*)
  SkipLine(Chan);

  (*****PERSONAL*****)
  ReadCard(Chan,i);
  Cont := i;
  FOR j:=1 TO i DO
   SkipLine(Chan);

   ReadString(Chan,S);
   l := 0;
   WHILE (S[l] <> ",") DO
    l := l+1;
   END;(*/WHILE*)
   Extract(S,0,l,Pos);
   StrToCard(Pos,k,r);
   Delete(S,0,l+1);
   Assign(S,N);

   NEW(LNaux);
   LNaux^.N := N;
   LNaux^.Pos := k;
   LNaux^.Sig := LN^.LNP;
   LN^.LNP := LNaux;
  END;(*/FOR*)
  SkipLine(Chan);

  (*****NEGOCIOS*****)
  ReadCard(Chan,i);
  Cont := Cont+i;
  FOR j:=1 TO i DO
   SkipLine(Chan);

   ReadString(Chan,S);
   l := 0;
   WHILE (S[l] <> ",") DO
    l := l+1;
   END;(*/WHILE*)
   Extract(S,0,l,Pos);
   StrToCard(Pos,k,r);
   Delete(S,0,l+1);
   Assign(S,N);

   NEW(LNaux);
   LNaux^.N := N;
   LNaux^.Pos := k;
   LNaux^.Sig := LN^.LNN;
   LN^.LNN := LNaux;
  END;(*/FOR*)
  LN^.Cont := Cont;
 END RecuperarLNombres;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(*******************************DESTRUCTORES***********************************)
(******************************************************************************)

(*************************DESTRUIR NOMBRE LNOMBRES*****************************)
(*Destruye al contacto de la posicion P y tipo T, debe existir dicho contacto*)
PROCEDURE DestruirNombreLNombres(P:CARDINAL;T:Tipo;VAR LN:LNombres);
 VAR
  aux, borrar : Lista;

 BEGIN

  IF (T = Personal) THEN

   IF (LN^.LNP^.Pos = P) THEN
    borrar := LN^.LNP;
    LN^.LNP := LN^.LNP^.Sig;
   ELSE
    aux := LN^.LNP;
    WHILE (aux^.Sig^.Pos <> P) DO
     aux := aux^.Sig;
    END;(*/WHILE*)

    borrar := aux^.Sig;
    aux^.Sig := aux^.Sig^.Sig;
   END;(*/IF*)

  ELSE

   IF (LN^.LNN^.Pos = P) THEN
    borrar := LN^.LNN;
    LN^.LNN := LN^.LNN^.Sig;
   ELSE
    aux := LN^.LNN;
    WHILE (aux^.Sig^.Pos <> P) DO
     aux := aux^.Sig;
    END;(*/WHILE*)

    borrar := aux^.Sig;
    aux^.Sig := aux^.Sig^.Sig;
   END;(*/IF*)

  END;(*/IF*)

  InsertarNatLNat(P,LN^.PL);
  DISPOSE(borrar);
  LN^.Cont := LN^.Cont-1;
 END DestruirNombreLNombres;

(****************************DESTRUIR LNOMBRES*********************************)
(*Destruye a LN*)
PROCEDURE DestruirLNombres(VAR LN:LNombres);
 VAR
  borrar, aux : Lista;

 BEGIN
  aux := LN^.LNP;
  WHILE (aux <> NIL) DO
   borrar := aux;
   aux := aux^.Sig;
   DISPOSE(borrar);
  END;(*/WHILE*)

  aux := LN^.LNN;
  WHILE (aux <> NIL) DO
   borrar := aux;
   aux := aux^.Sig;
   DISPOSE(borrar);
  END;(*/WHILE*)

  DestruirLNat(LN^.PL);
  DISPOSE(LN);
 END DestruirLNombres;
END LNombres.