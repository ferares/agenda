MODULE Agenda;

(******************************************************************************)
(*******************************IMPORTACIONES**********************************)
(******************************************************************************)

FROM Contacto IMPORT Contacto, Nombre, Tipo, Campos, DestruirContacto;
		
FROM Procedimientos IMPORT VerContacto, BuscarContacto, EditarContacto,
                           RecuperarContacto, AgregarContacto, BorrarContacto,
			   ListarContactos, CambiarCelulares, CambiarTelefonos;

FROM LNombres IMPORT LNombres, PersistirLNombres, RecuperarLNombres,
                     DestruirLNombres;
		
FROM LNat IMPORT LNat, ObtenerNatLNat, ExisteNatLNat;

FROM TextIO IMPORT WriteString, WriteLn, ReadChar, ReadString, SkipLine;

FROM WholeStr IMPORT ConvResults, StrToCard;

FROM Strings IMPORT Assign, Equal;

FROM StreamFile IMPORT read, write, old, text, ChanId, OpenResults, Close;

FROM SeqFile IMPORT OpenWrite, OpenRead;

FROM StdChans IMPORT StdOutChan, InChan;

(******************************************************************************)
(******************************PROCEDIMIENTOS**********************************)
(******************************************************************************)

(*************************IMPRIMIR OPCIONES INICIO*****************************)
PROCEDURE ImprimirOpcionesInicio();
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"***************************");WriteLn(Chan);
  WriteString(Chan,"* Agenda Electronica v1.9 *");WriteLn(Chan);
  WriteString(Chan,"***************************");WriteLn(Chan);
  WriteString(Chan,"* B - Buscar Contacto     *");WriteLn(Chan);
  WriteString(Chan,"* A - Agregar Contacto    *");WriteLn(Chan);
  WriteString(Chan,"* L - Listar Contactos    *");WriteLn(Chan);
  WriteString(Chan,"* C - Cambiar Masivamente *");WriteLn(Chan);
(*WriteString(Chan,"* E - Exportar            *");WriteLn(Chan);
  WriteString(Chan,"* I - Importar            *");WriteLn(Chan);*)
  WriteString(Chan,"* S - Salir               *");WriteLn(Chan);
  WriteString(Chan,"***************************");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
 END ImprimirOpcionesInicio;

(**********************IMPRIMIR OPCIONES DE BUSQUEDA***************************)
PROCEDURE ImprimirOpcionesDeBusqueda();
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"**************");WriteLn(Chan);
  WriteString(Chan,"*  CONTACTO  *");WriteLn(Chan);
  WriteString(Chan,"**************");WriteLn(Chan);
  WriteString(Chan,"* E - Editar *");WriteLn(Chan);
  WriteString(Chan,"* B - Borrar *");WriteLn(Chan);
  WriteString(Chan,"* V - Volver *");WriteLn(Chan);
  WriteString(Chan,"**************");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
 END ImprimirOpcionesDeBusqueda;

(***********************IMPRIMIR OPCIONES DE CAMBIO****************************)
PROCEDURE ImprimirOpcionesDeCambio();
 VAR
  Chan : ChanId;

 BEGIN
  Chan := StdOutChan();
  WriteString(Chan,"*****************");WriteLn(Chan);
  WriteString(Chan,"*    CAMBIAR    *");WriteLn(Chan);
  WriteString(Chan,"*****************");WriteLn(Chan);
  WriteString(Chan,"* T - Telefonos *");WriteLn(Chan);
  WriteString(Chan,"* C - Celulares *");WriteLn(Chan);
  WriteString(Chan,"* V - Volver    *");WriteLn(Chan);
  WriteString(Chan,"*****************");WriteLn(Chan);WriteLn(Chan);
  WriteString(Chan,">");
 END ImprimirOpcionesDeCambio;

(******************************RECUPERAR AGENDA********************************)
PROCEDURE RecuperarAgenda(VAR LN:LNombres);
 VAR
  chan : ChanId;
  result : OpenResults;
  Archivo : ARRAY [0..5] OF CHAR;

 BEGIN
  Assign("LN.age",Archivo);
  OpenRead(chan,Archivo,read+write+old+text,result);
  RecuperarLNombres(chan,LN);
  Close(chan);
 END RecuperarAgenda;

(******************************PERSISTIR AGENDA********************************)
PROCEDURE PersistirAgenda(LN:LNombres);
 VAR
  Archivo : ARRAY [0..16] OF CHAR;
  chan : ChanId;
  result : OpenResults;

 BEGIN
  Assign("LN.age",Archivo);
  OpenWrite(chan,Archivo,read+write+old+text,result);
  PersistirLNombres(chan,LN);
  Close(chan);
 END PersistirAgenda;

(******************************************************************************)
(*********************************VARIABLES************************************)
(******************************************************************************)

VAR
 o : CHAR;
 i, Total : CARDINAL;
 N : Nombre;
 C : Contacto;
 T: Tipo;
 Chan : ChanId;
 LN : LNombres;
 L : LNat;
 S : ARRAY [0..6] OF CHAR;
 R : ConvResults;

(******************************************************************************)
(*****************************PROGRAMA PRINCIPAL*******************************)
(******************************************************************************)

BEGIN
 Chan := StdOutChan();

 WriteString(Chan,"Cargando datos...");
 RecuperarAgenda(LN);
 WriteString(Chan," Listo!");WriteLn(Chan);WriteLn(Chan);

 ImprimirOpcionesInicio();
 ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

 WHILE (o <> "S") AND (o <> "s") DO

  (******AGREGAR CONTACTO******)
  IF (o = "A") OR (o = "a") THEN
   WriteString(Chan,"AGREGAR CONTACTO");WriteLn(Chan);WriteLn(Chan);

   (*Obtener el tipo de contacto*)
   WriteString(Chan,"   P   - Personal");WriteLn(Chan);
   WriteString(Chan,"   N   - Negocios");WriteLn(Chan);
   WriteString(Chan," Enter - Cancelar");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

   IF (o = "P") OR (o = "p") OR (o = "N") OR (o = "n") THEN
    REPEAT
     IF (o = "P") OR (o = "p") THEN
      T := Personal;
     ELSE
      T := Negocios;
     END;(*/IF*)

     (*Agregar contacto*)
     AgregarContacto(T,LN);
     PersistirAgenda(LN);

     WriteString(Chan,"Contacto ingresado. ");WriteLn(Chan);WriteLn(Chan);
     WriteString(Chan,"Ingresar otro?");WriteLn(Chan);WriteLn(Chan);
     WriteString(Chan,"  S   - Si");WriteLn(Chan);
     WriteString(Chan,"Enter - No");WriteLn(Chan);WriteLn(Chan);
     WriteString(Chan,">");
     ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
    UNTIL (o <> "S") AND (o <> "s");
   END;(*/IF*)

  (********BUSCAR CONTACTO********)
  ELSIF (o = "B") OR (o = "b") THEN
   WriteString(Chan,"BUSCAR CONTACTO");WriteLn(Chan);WriteLn(Chan);

   WriteString(Chan,"   P   - Personal");WriteLn(Chan);
   WriteString(Chan,"   N   - Negocios");WriteLn(Chan);
   WriteString(Chan," Enter - Cancelar");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

   IF (o = "P") OR (o = "p") OR (o = "N") OR (o = "n") THEN

    IF (o = "P") OR (o = "p") THEN
     T := Personal;
    ELSE
     T := Negocios;
    END;(*/IF*)

    WriteString(Chan,"Buscar nombres que contienen:");WriteLn(Chan);
    WriteLn(Chan);WriteString(Chan,">");
    ReadString(InChan(),N);SkipLine(InChan());WriteLn(Chan);

    (*Buscar contacto*)

    L := BuscarContacto(N,T,LN);

    IF (ExisteNatLNat(0,L)) THEN
     Total := 0;
     WHILE (ExisteNatLNat(Total,L)) DO
      Total := Total+1;
     END;(*/WHILE*)
     IF (Total > 1) THEN
      WriteLn(Chan);
      WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
      REPEAT
       WriteString(Chan,"Contacto numero: ");WriteLn(Chan);WriteLn(Chan);
       WriteString(Chan,">");
       ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
       StrToCard(S,i,R);
       IF ((R <> strAllRight)AND NOT(Equal(S,"")))
         OR (R = strAllRight) AND ((i > Total) OR (i = 0)) THEN
        WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
       END;(*/IF*)
      UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR ((i <= Total) AND (i > 0));
     ELSE
      i := 1;
     END;(*/IF*)

     IF (R=strAllRight) THEN
      C := RecuperarContacto(ObtenerNatLNat(i-1,L));
      VerContacto(C);
      WriteString(Chan,"Enter para continuar");SkipLine(InChan());
      WriteLn(Chan);
      ImprimirOpcionesDeBusqueda();
      ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

      IF (o = "E") OR (o = "e") THEN
       WriteString(Chan,"EDITAR CONTACTO");WriteLn(Chan);WriteLn(Chan);
       EditarContacto(ObtenerNatLNat(i-1,L),C,LN);
       PersistirAgenda(LN);
       WriteString(Chan,"Datos actuales del contacto:");WriteLn(Chan);
       WriteLn(Chan);
       VerContacto(C);
       WriteString(Chan,"Enter para continuar");SkipLine(InChan());
       WriteLn(Chan);

      ELSIF (o = "B") OR (o = "b") THEN
       WriteString(Chan,"BORRAR CONTACTO");WriteLn(Chan);WriteLn(Chan);
       BorrarContacto(ObtenerNatLNat(i-1,L),T,LN);
       PersistirAgenda(LN);
       WriteString(Chan,"Enter para continuar");SkipLine(InChan());
      END;(*/IF*)
      DestruirContacto(C);
     END;(*/IF*)
    END;(*/IF*)
   END;(*/IF*)

  (********LISTAR CONTACTOS*******)
  ELSIF (o = "L") OR (o = "l") THEN
   WriteString(Chan,"LISTAR CONTACTOS");WriteLn(Chan);WriteLn(Chan);

   WriteString(Chan,"   P   - Personal");WriteLn(Chan);
   WriteString(Chan,"   N   - Negocios");WriteLn(Chan);
   WriteString(Chan," Enter - Cancelar");WriteLn(Chan);WriteLn(Chan);
   WriteString(Chan,">");
   ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

   IF (o <> "C") AND (o <> "c") THEN
    IF (o = "P") OR (o = "p") THEN
     T := Personal;
    ELSE
     T := Negocios;
    END;(*/IF*)

    L := ListarContactos(T,LN);

    IF (ExisteNatLNat(0,L)) THEN
     Total := 0;
     WHILE (ExisteNatLNat(Total,L)) DO
      Total := Total+1;
     END;(*/WHILE*)
     WriteLn(Chan);
     WriteString(Chan,"Enter - Volver");WriteLn(Chan);WriteLn(Chan);
     REPEAT
      WriteString(Chan,"Contacto numero: ");WriteLn(Chan);WriteLn(Chan);
      WriteString(Chan,">");
      ReadString(InChan(),S);SkipLine(InChan());WriteLn(Chan);
      StrToCard(S,i,R);
      IF ((R <> strAllRight)AND NOT(Equal(S,"")))
         OR (R = strAllRight) AND ((i > Total) OR (i = 0)) THEN
       WriteString(Chan,"Opcion no valida.");WriteLn(Chan);WriteLn(Chan);
      END;(*/IF*)
     UNTIL ((R <> strAllRight)AND(Equal(S,""))) OR (i <= Total) AND (i <> 0);

     IF (R = strAllRight) THEN
      C := RecuperarContacto(ObtenerNatLNat(i-1,L));
      VerContacto(C);
      WriteString(Chan,"Enter para continuar");SkipLine(InChan());
      WriteLn(Chan);
      ImprimirOpcionesDeBusqueda();
      ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

      IF (o = "E") OR (o = "e") THEN
       WriteString(Chan,"EDITAR CONTACTO");WriteLn(Chan);WriteLn(Chan);
       EditarContacto(ObtenerNatLNat(i-1,L),C,LN);
       PersistirAgenda(LN);
       WriteString(Chan,"Datos actuales del contacto:");WriteLn(Chan);
       WriteLn(Chan);
       VerContacto(C);
       WriteString(Chan,"Enter para continuar");SkipLine(InChan());
       WriteLn(Chan);

      ELSIF (o = "B") OR (o = "b") THEN
       WriteString(Chan,"BORRAR CONTACTO");WriteLn(Chan);WriteLn(Chan);
       BorrarContacto(ObtenerNatLNat(i-1,L),T,LN);
       PersistirAgenda(LN);
       WriteString(Chan,"Enter para continuar");SkipLine(InChan());
      END;(*/IF*)
      DestruirContacto(C);
     END;(*/IF*)
    END;(*/IF*)
   END;(*/IF*)

  (************CAMBIAR************)
  ELSIF (o = "C") OR (o = "c") THEN
   REPEAT
    WriteString(Chan,"CAMBIAR MASIVAMENTE");WriteLn(Chan);WriteLn(Chan);
    ImprimirOpcionesDeCambio();
    ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);
    IF (o = "T") OR (o = "t") THEN
     WriteString(Chan,"CAMBIAR TELEFONOS");WriteLn(Chan);WriteLn(Chan);
     CambiarTelefonos(LN);
    ELSIF (o = "C") OR (o = "c") THEN
     WriteString(Chan,"CAMBIAR CELULARES");WriteLn(Chan);WriteLn(Chan);
     CambiarCelulares(LN);
    END;(*/IF*)
   UNTIL (o <> "t") AND (o <> "T") AND (o <> "C") AND (o <> "c");

  (*(************EXPORTAR************)
  ELSIF (o = "E") OR (o = "e") THEN
   WriteString(Chan,"EXPORTAR");WriteLn(Chan);WriteLn(Chan);

  (************IMPORTAR***********)
  ELSIF (o = "I") OR (o = "i") THEN
   WriteString(Chan,"IMPORTAR");WriteLn(Chan);WriteLn(Chan);*)

  END;(*/IF*)

  ImprimirOpcionesInicio();
  ReadChar(InChan(),o);SkipLine(InChan());WriteLn(Chan);

 END;(*/WHILE*)

 WriteString(Chan,"Guardando datos...");
 PersistirAgenda(LN);
 DestruirLNombres(LN);
 WriteString(Chan," Listo!");

END Agenda.