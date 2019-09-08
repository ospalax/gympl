unit M_UK;

interface

const JMFILE='data\osob.dat';
      JMSZ='data\seznam\helplist.txt';
      POC_NAROD=42; {pocet narodnosti}
      POC_PRACE_M=15; {pocet povolani}
      POC_PRACE_Z=13;
{typ predstavujici osobu databaze}
type T_PRACE_M=array[1..POC_PRACE_M] of string[20]; {mnozina povolani}
     T_PRACE_Z=array[1..POC_PRACE_Z] of string[20];
     T_NAROD=array[1..POC_NAROD] of string[20]; {mnozina narodu}
     T_SEX=array[1..2] of string[20]; {muz zena}

type T_PERSON=record
     JMENO:string[20];
     SEX:string[20];
     ROK_NAR:string[20];
     MISTO_NAR:string[20];
     NAROD:string[20];
     PRACE:string[20];
     end;
     T_ukos=^T_osoba;
     T_osoba=record
     tam,zpet:T_ukos;
     os:T_PERSON;
     end;

var OSOBA,pomuk:T_ukos;
    REC:T_PERSON;


procedure ADD(var UK:T_ukos;REC:T_PERSON); {prida do seznamu dalsi zaznam}
procedure SH_vlevo(UK:T_ukos;var P:T_ukos;var REC:T_PERSON); {ukaze zaznam vlevo}
procedure SH_vpravo(UK:T_ukos;var P:T_ukos;var REC:T_PERSON); {ukaze zaznam vpravo}
procedure uklid(var UK:T_ukos); {zlikviduje seznam}


implementation

procedure ADD(var UK:T_ukos;REC:T_PERSON);
          var pom:T_ukos;
          begin
          {vytvoreni noveho}
          new(pom);
          pom^.os:=REC;

          {napojeni noveho}
          pom^.zpet:=UK^.zpet;
          pom^.tam:=UK;

          {uprava vazeb}
          pom^.zpet^.tam:=pom;
          UK^.zpet:=pom;

          end;

procedure SH_vlevo(UK:T_ukos;var P:T_ukos;var REC:T_PERSON);
          begin
          if P<>UK then P:=P^.zpet;
          REC:=P^.os;
          end;

procedure SH_vpravo(UK:T_ukos;var P:T_ukos;var REC:T_PERSON);
          begin
          if P<>UK^.zpet then P:=P^.tam;
          REC:=P^.os;
          end;

procedure uklid(var UK:T_ukos);
          var pom:T_ukos;
          begin
          while UK^.zpet<>UK do
                begin
                pom:=UK^.zpet^.zpet;
                dispose(UK^.zpet);
                UK^.zpet:=pom;
                end;
          dispose(UK);
          end;
begin
end.