unit M_FILE;

interface
uses M_UK;

{databazovy soubor s celebritami}
type S_DATA=file of T_PERSON;

procedure NEW_FILE(var F:S_DATA;NAME:string); {vytvori novy soubor}
procedure ADD_FILE(var F:S_DATA;NAME:string
                   ;CO:T_PERSON;var exec:boolean); {prida polozku}
procedure WRITE_HELPLIST_JM(JM:string;NAME:string;POS:word;var exec:boolean);
procedure MAZ_ZE_HELPLIST(NAME,NAME2:string;pos:word); {maze jmeno z helplistu}
{----------------hleda osobu----------------------------}
procedure SEARCH_ITEM(var F:S_DATA
                      ;var REC:T_PERSON
                      ;var pos:word
                      ;var MODE:boolean);
{------------------------------------------------------}
procedure COLLECT_SEZNAM(var F:S_DATA;var UK:T_UKOS;PAGE:word;var exec:boolean); {sbira zaznamy}



function TOSTR(CISLO:word):string; {prevod do string}
function ORIZSTR(JM:string):string; {oreze mezery}




implementation

const POCATRIB=6; {stejna konstanta urcujici pocet udaju}
type T_POROVSTR=1..3;

{-----------------pomocne funkce-------------------------}
          {funkce jejiz vysledkem je obraceny retezec}
          function TURNSTR(JM:string):string;
                   var pom:string;
                       i:byte;
                   begin
                   pom:='';
                   for i:=length(JM) downto 1 do
                       pom:=pom+JM[i];
                   TURNSTR:=pom;
                   end;
          {vysledkem je obracene jmeno Jan Novak -> NovakJan na porovnani}
          function TURNJM(JM:string):string;
                   var zr,k:integer;
                       i:integer;
                       str:string;
                   begin
                   str:='';
                   i:=length(JM);

                   repeat
                   while JM[i]=' ' do i:=i-1;
                   k:=i;
                   while (JM[i]<>' ')and(i>0) do i:=i-1;

                      begin
                      zr:=i;
                      while i<k do
                            begin
                            i:=i+1;
                            str:=str+JM[i];
                            end;
                      i:=zr-1;
                      end
                   until i=-1;

                   TURNJM:=str;
                   end;
          {vysledkem je obracene jmeno Jan Novak -> Novak Jan na shodu}
          function TURNMEZJM(JM:string):string;
                   var zr,k:integer;
                       i:integer;
                       str:string;
                   begin
                   str:='';
                   i:=length(JM);

                   repeat
                   while JM[i]=' ' do i:=i-1;
                   k:=i;
                   while (JM[i]<>' ')and(i>0) do i:=i-1;

                      begin
                      zr:=i;
                      if (i<>k)and(str<>'') then str:=str+' ';
                      while i<k do
                            begin
                            i:=i+1;
                            str:=str+JM[i];
                            end;
                      i:=zr-1;

                      end
                   until i=-1;

                   TURNMEZJM:=str;
                   end;
          {funkce jejimz vysledkem je prevod cisla na string}
          {pocet mist odpovida parametru POCCIF}
          function TOSTR(CISLO:word):string;
                   var pom:byte;
                       str:string;
                   begin
                   str:='';
                   if CISLO=0 then str:='0'
                    else
                   while CISLO<>0 do
                         begin
                         pom:=CISLO mod 10;
                         CISLO:=CISLO div 10;
                         str:=str+chr(pom+48);
                         end;
                   str:=TURNSTR(str);
                   TOSTR:=str;
                   end;
          {oreze mezery na zacatku a na konci}
          function ORIZSTR(JM:string):string;
                   var str:string[20];
                       i,l,pom:byte;
                   begin
                   str:='';
                   i:=1;
                   l:=length(JM);

                   while JM[i]=' ' do i:=i+1;
                   while JM[l]=' ' do l:=l-1;

                   for pom:=i to l do str:=str+JM[pom];
                   ORIZSTR:=str;
                   end;
          {odstrani vsechny mezery}
          function BEZMEZSTR(JM:string):string;
                   var str,pomstr:string;
                       i:byte;
                   begin
                   str:=ORIZSTR(JM);
                   pomstr:='';
                   i:=0;
                   while i<>length(str) do
                         begin
                         i:=i+1;
                         if str[i]<>' ' then pomstr:=pomstr+str[i];
                         end;
                   BEZMEZSTR:=pomstr;
                   end;
          {porovnava 2 stringy 1=str1>str2,2=str1=str2,3=str1<str2}
          function POROVSTR(str1,str2:string):T_POROVSTR;
                   var str:string;
                       i:byte;
                   begin
                   str:='';
                   {prevede parametry na velka pismena}
                   for i:=1 to length(str1) do str:=str+upcase(str1[i]);
                   str1:=str;
                   str:='';
                   for i:=1 to length(str2) do str:=str+upcase(str2[i]);
                   str2:=str;
                   {----------------------------------}
                   if BEZMEZSTR(str1)>BEZMEZSTR(str2)then POROVSTR:=1
                      else if BEZMEZSTR(str1)=BEZMEZSTR(str2) then POROVSTR:=2
                      else POROVSTR:=3;
                   end;
          {doplni retezci mezery na konci}
          function MEZEROSTR(JM:string):string;
                   begin
                   while length(JM)<>20 do JM:=JM+' ';
                   MEZEROSTR:=JM;
                   end;

{--------------------------------------------------------------------}
{procedure ktera vytvori novy soubor}
procedure NEW_FILE(var F:S_DATA;NAME:string);
          begin
          assign(F,NAME);
          rewrite(F);
          close(F);
          end;

{stara se o HELPLIST celebrit}
procedure WRITE_HELPLIST_JM(JM:string;NAME:string;POS:word;var exec:boolean);

          const soubor='pomsz.txt';
          var SZ,POMSZ:text;
              str:string[20];
              ret:string;
              control:boolean;
              i,l:longint;

          begin
          assign(SZ,NAME);
          {$I-}
          reset(SZ);
          {$I+}
          if IOresult<>0 then begin rewrite(SZ);
                              {specialni zapis do HELPLISTu}
                              writeln(SZ,MEZEROSTR(TURNMEZJM(JM))+TOSTR(POS));
                        {umoznuje ulozeni}
                        exec:=true;
                        end
                   else
                   begin
                   {----------------------------------------}
                   {hleda spravnou pozici pro nove jmeno}
                   i:=-1;
                   control:=false;

                   repeat
                   i:=i+1;
                   readln(SZ,str);
                   if (POROVSTR(str,TURNMEZJM(JM))<>3)
                      or(seekeof(SZ)) then control:=true;
                   until control;

                   if POROVSTR(str,TURNMEZJM(JM))=2 then
                      begin
                      {zakazuje ulozeni}
                      exec:=false;
                      {----------------}
                      end
                   else
                   begin
                   {umoznuje ulozeni}
                   exec:=true;
                   {----------------}
                   if POROVSTR(str,TURNMEZJM(JM))=3 then i:=i+1;

                   {---------------------------------------}
                   {---------------------------------------}
                   {vytvori pomocny soubor}
                   assign(POMSZ,soubor);
                   rewrite(POMSZ);
                   {znovu otevre stary}
                   reset(SZ);
                   {zapise vsechny osoby ktere patri pred novou}
                   for l:=1 to i do
                       begin
                       readln(SZ,ret);
                       writeln(POMSZ,ret);
                       end;
                   {zapise novou osobu}
                   writeln(POMSZ,MEZEROSTR(TURNMEZJM(JM))+TOSTR(POS));
                   {vypise zbytek}
                   while not seekeof(SZ) do
                         begin
                         readln(SZ,ret);
                         writeln(POMSZ,ret);
                         end;
                   close(POMSZ);
                   {--------------------------------------------}
                   {prekopiruje soubory a pomocny smaze}
                   rewrite(SZ);
                   reset(POMSZ);
                   while not seekeof(POMSZ) do
                         begin
                         readln(POMSZ,ret);
                         writeln(SZ,ret);
                         end;
                   close(POMSZ);
                   erase(POMSZ);
                   {--------------------------------------------}
                   end;
                   end;

          close(SZ);

          end;
{prida do souboru novy zaznam}
procedure ADD_FILE(var F:S_DATA;NAME:string;CO:T_PERSON;var exec:boolean);
          var exe:boolean;

          begin
          assign(F,NAME);
          {$I-}
          reset(F);
          if ioresult<>0 then rewrite(F);
          {$I+}
          {kompatibilni uprava atributu}
          with CO do
          begin
          JMENO:=ORIZSTR(JMENO);
          ROK_NAR:=ORIZSTR(ROK_NAR);
          MISTO_NAR:=ORIZSTR(MISTO_NAR);
          end;
          {--------------------------}
          {upravi se HELPLIST celebrit}
          seek(F,filesize(F));
          WRITE_HELPLIST_JM(CO.JMENO,JMSZ,filepos(F),exe);
          {je-li zaznam pripustny ulozi se}
          if exe then write(F,CO);

          exec:=exe;
          close(F);
          end;
{----------------------------------------------------------}
{------------------hleda osobu-------------------------}
procedure SEARCH_ITEM(var F:S_DATA;var REC:T_PERSON;
                      var pos:word;var MODE:boolean);
          type T_pole=array[1..POCATRIB] of string[20];

          var SZ:text;
              str:string[20];
              znak:char;
              POLE:T_pole;
              pom:T_PERSON;
          begin
          assign(F,JMFILE);
          reset(F);

          {-----inicializace pole----------}
          with REC do
               begin
               POLE[1]:=JMENO;
               POLE[2]:=SEX;
               POLE[3]:=ROK_NAR;
               POLE[4]:=MISTO_NAR;
               POLE[5]:=NAROD;
               POLE[6]:=PRACE;
               end;
          {--------------------------------}

          MODE:=false;
          {pokud je vyplneno jmeno vyuzije se HELPLIST}
          if (REC.JMENO<>'')then
             begin
             assign(SZ,JMSZ);
             reset(SZ);

             {dokud neni rovno nebo konec HELPLISTu}
             while (not MODE)and(not seekeof(SZ)) do
                   begin
                   read(SZ,str);
                   readln(SZ,pos);
                   if ORIZSTR(str)=TURNMEZJM(REC.JMENO) then MODE:=true;
                   end;
             {nalezeny zaznam}
             if MODE then begin seek(F,pos);
                                read(F,REC);
                                {kontrola zda je zaznam pravy}
                                {if pom.ROK_NAR<>REC.ROK_NAR
                                 then MODE:=false
                                 else
                                 if pom.SEX<>REC.SEX
                                  then MODE:=false
                                  else
                                  if pom.MISTO_NAR<>REC.MISTO_NAR
                                   then MODE:=false
                                   else
                                   if pom.NAROD<>REC.NAROD
                                    then MODE:=false
                                    else
                                    if pom.PRACE<>REC.PRACE
                                     then MODE:=false;}
                                  with REC do
                                  if (POLE[2]='')or(POLE[2]=SEX) then
                                   if (POLE[3]='')or(POLE[3]=ROK_NAR) then
                                    if (POLE[4]='')or(POLE[4]=MISTO_NAR) then
                                     if (POLE[5]='')or(POLE[5]=NAROD) then
                                      if (POLE[6]='')or(POLE[6]=PRACE) then
                                         else MODE:=false;

                          end;
             close(SZ);
             end
          else
          {jinak..}
          begin

          seek(F,pos);
          while (not eof(F))and(not MODE) do
                begin
                {precteme novy zaznam od mista ktere jsme neprozkoumali}
                read(F,REC);

                {zjisti zda zaznam odpovida}
                with REC do
                     begin
                     if (POLE[2]='')or(POLE[2]=SEX) then
                     if (POLE[3]='')or(POLE[3]=ROK_NAR) then
                      if (POLE[4]='')or(POLE[4]=MISTO_NAR) then
                       if (POLE[5]='')or(POLE[5]=NAROD) then
                        if (POLE[6]='')or(POLE[6]=PRACE) then MODE:=true;
                     end
                end;
          pos:=filepos(F);
          end;
          close(F);
          end;
{-------------------------------------------------------}

{------------mazani jmena z helplistu-------------------}
procedure MAZ_ZE_HELPLIST(NAME,NAME2:string;pos:word);
          const NA='pomsz.txt';
          var str:string[20];
              pom:word;
              SZ,pomsz:text;
          begin
          assign(SZ,JMSZ);
          reset(SZ);
          assign(pomsz,NA);
          rewrite(pomsz);

          {procitame jmena a jejich pozice}
          read(SZ,str);
          readln(SZ,pom);
          {prepisujeme polozky do noveho helplistu po mazaneho}
          while ORIZSTR(str)<>TURNMEZJM(NAME2) do
                begin
                if ORIZSTR(str)<>TURNMEZJM(NAME) then writeln(pomsz,str,pom)
                                                 else writeln(pomsz,str,pos);
                read(SZ,str);
                readln(SZ,pom);
                end;
          {dopise zbytek}
          while not seekeof(SZ) do
                begin
                read(SZ,str);
                readln(SZ,pom);
                if ORIZSTR(str)<>TURNMEZJM(NAME) then writeln(pomsz,str,pom)
                                                 else writeln(pomsz,str,pos);
                end;
          close(SZ);
          close(pomsz);
          erase(SZ);
          rename(pomsz,JMSZ);
          end;
{-------------------------------------------------------}
{-------------------sbira do seznamu--------------------}
procedure COLLECT_SEZNAM(var F:S_DATA;var UK:T_UKOS;PAGE:word;var exec:boolean);
          var i,l:word;
              SZ:text;
              str:string[20];
              POC:byte;
              REC:T_PERSON;
          begin
          exec:=true;

          assign(SZ,JMSZ);
          reset(SZ);
          assign(F,JMFILE);
          reset(F);

          {podle strany skoci na spravny radek}
          for i:=1 to PAGE-1 do
              for l:=1 to 41 do readln(SZ);

          {nacte do seznamu}
          {prvni}
          UK:=nil;
          if not seekeof(SZ) then begin read(SZ,str);
                                        readln(SZ,i);
                                        {hleda zaznam v souboru}
                                        seek(F,i);
                                        read(F,REC);
                                        {prvni zaznam v seznamu}
                                        new(UK);
                                        UK^.os:=REC;
                                        UK^.zpet:=UK;
                                        UK^.tam:=UK;
                                  end;
          POC:=2;
          while (not seekeof(SZ))and(POC<=41) do
                begin
                read(SZ,str);
                readln(SZ,i);
                {hleda zaznam v souboru}
                seek(F,i);
                read(F,REC);
                {prida do seznamu}
                ADD(UK,REC);
                POC:=POC+1;
                end;
          if UK=nil then exec:=false;
          close(F);
          close(SZ);
          end;
{-------------------------------------------------------}
begin
end.