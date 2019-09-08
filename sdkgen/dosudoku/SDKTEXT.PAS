unit sdktext;

interface
uses sdkdecl,dos;


{spocita stranky}
procedure SUM_PAGES(FNAME:string;var POCET:byte;POCRAD:byte);
          {parametrem je: FNAME- cesta k soubor
                          POCET- pocet stran
                          POCRAD- pocet radku na stranu}

{text prepise do okna}
procedure READER(FNAME:string;posx,posy:word;PAGE,POCRAD,POCPIS:byte);
          {parametrem je: FNAME- cesta k souboru
                          posy- y-ova souradnice zacatku stranky
                          posx- x-ova souradnice stredu stranky
                          PAGE- stranka
                          POCRAD- pocet radku na stranku
                          POCPIS- pocet pismen}


implementation
uses crt,graph;

{-----------spocita stranky-----------------------------------------------}
procedure SUM_PAGES(FNAME:string;var POCET:byte;POCRAD:byte);
          var F:text;
              pom:word;
          begin
          assign(F,FNAME);

          {$I-}
          reset(F);
          {$I+}
          if IOresult=0 then
                        begin
                        pom:=0;
                        while not EOF(F) do
                              begin
                              pom:=pom+1;
                              readln(F);
                              end;
                        POCET:=pom div POCRAD;
                        if POCET*POCRAD<pom then POCET:=POCET+1;
                        close(F);
                        end
                        else POCET:=0;
          end;
{------------------text prepise do okna------------------------------------}
procedure READER(FNAME:string;posx,posy:word;PAGE,POCRAD,POCPIS:byte);
          var F:text;
              corr:boolean;
              i:byte;
              setr:string;
              znak:char;
              psx:word;


          function pocword(setr:string):byte;
                   var pom,i:byte;
                   begin
                   pom:=0;
                   for i:=1 to length(setr) do
                       if setr[i]=' ' then pom:=pom+1;
                   if pom>0 then pom:=pom+1;
                   pocword:=pom;
                   end;

          procedure fullstc(var setr:string);
                    var pom,i,l:byte;
                    begin
                    l:=0;
                    pom:=pocpis-length(setr);
                    while pom>0 do
                          begin
                    i:=length(setr);
                    while i>0 do
                        begin
                        if setr[i]=' ' then
                           begin
                           for l:=length(setr) downto i do
                               begin
                               setr[l+1]:=setr[l];
                               end;
                           l:=1;
                           setr[0]:=chr(ord(setr[0])+1);
                           pom:=pom-1;
                           end;
                        if pom=0 then break;
                        i:=i-1;
                        end;
                    if l=0 then break;
                          end;
                    for i:=1 to length(setr) do
                        if setr[i]='^' then setr[i]:=' ';
                    end;

          begin
          assign(F,FNAME);

          {$I-}
          reset(F);
          {$I+}
          if IOresult=0 then corr:=true
                        else corr:=false;

          {nastaveni textu}
          settextstyle(4,0,0);
          settextjustify(centertext,TOPtext);

          if corr then
             begin

             if PAGE=0 then begin
                            {zadny text}
                            setcolor(red);
                            outtextxy(posx,posy,'TEXT SMAZAN');
                            end
                       else
                       {radne popsany soubor}
                       begin
                       setr:='';
                       for i:=1 to POCPIS do setr:=setr+' ';
                       psx:=posx-(textwidth(setr) div 2);


                       {najde prvni radku stranky}
                       for i:=1 to (PAGE-1)*POCRAD do readln(F);
                       setcolor(black);

                       settextjustify(lefttext,toptext);


                       for i:=1 to POCRAD do
                           begin
                           setr:='';
                           while not eoln(F) do
                             begin
                             read(F,znak);
                             setr:=setr+znak;
                             end;

                           fullstc(setr);

                           outtextxy(psx,
                                     posy+((i-1)*(5+textheight('Q'))),
                                     setr);
                           readln(F);
                           end;


                       end;
             close(F);
             end
                  else
                  begin
                  {zadny soubor}
                  setcolor(red);
                  outtextxy(posx,posy,'ZADNY SOUBOR');
                  end;
          end;

{pojistka pro textove soubory------------------------------------}
procedure vytvor(jmeno:string);
          var f:text;
          begin
          assign(f,jmeno);
          rewrite(f);


if jmeno=attnon then
writeln(f,' Zadani^nema^reseni. ');

if jmeno=attless then
begin
writeln(f,' Nalezeno^jedine ');
writeln(f,' reseni. ');
end;

if jmeno=attesc then
begin
writeln(f,'Kvuli prerusenemu');
writeln(f,'vyhledavani nelze');
writeln(f,'urcit zda nalezene');
writeln(f,'reseni je jedine nebo');
writeln(f,'jedno z mnoha!');
end;


if jmeno=attcoll then
begin
writeln(f,' Spatne^zadani^! ');
writeln(f);
writeln(f,'Zrejme jste zadali 2');
writeln(f,'nebo vice stejnych');
writeln(f,'cisel v jednom radku,');
writeln(f,'sloupci nebo ctverci');
writeln(f,'3x3.');
end;


if jmeno=annnic2 then
begin
writeln(f,'To snad ne, vzdyt');
writeln(f,'vidis reseni^!');
end;

if jmeno=annnic then
writeln(f,'Ted uz to nema smysl^!');

if jmeno=annerr then
writeln(f,' V^mrizce^je^chyba^! ');


if jmeno=anncon then
begin
writeln(f,' GRATULUJI^! ');
writeln(f);
writeln(f,' Spravne^reseni ');
end;




if jmeno=inf then
begin
writeln(f,'SUDOKU je hlavolam, ktery vymyslel');
writeln(f,'Howard Garnes v roce 1979. Hru');
writeln(f,'pojmenoval "Number Place". Velike');
writeln(f,'obliby se dockala v Japonsku');
writeln(f,'a odtud se opet dostava zpet na');
writeln(f,'zapad pod nazvem Sudoku.');
writeln(f);
writeln(f,'Principem hry je postupne vyplnit');
writeln(f,'mrizku tak, aby v kazdem radku,');
writeln(f,'sloupci a ctverci 3x3 byla');
writeln(f,'zastoupena vsechna cisla 1-9, aniz');
writeln(f,'by se v radku, sloupci nebo');
writeln(f,'ctverci 3x3 jakekoliv z cisel');
writeln(f,'opakovalo.');
writeln(f);
writeln(f,'Prvni mistrovstvi v reseni sudoku,');
writeln(f,'ktere se konalo ve meste Lucca');
writeln(f,'v Italii, vyhrala Ceska Jana');
writeln(f,'Tylova.');
end;


if jmeno='readme.txt' then
begin
writeln(f,'SDKgen je program ke generovani');
writeln(f,'a reseni SUDOKU.');
writeln(f);
writeln(f,'Slouzi pouze k osobnim,');
writeln(f,'nekomercnim ucelum s cilem');
writeln(f,'pobavit. Program je freeware,');
writeln(f,'ale nesmi byt modifikovan a ani');
writeln(f,'s nim nesmi byt zachazeno jinak,');
writeln(f,'nez tak jak bylo zamysleno');
writeln(f,'autorem (viz vyse).');
writeln(f);
writeln(f,'Hlavolamy ziskane sebemensim');
writeln(f,'prispenim programu nesmi byt');
writeln(f,'publikovany, pouze po domluve s');
writeln(f,'autorem.');
writeln(f);
writeln(f,'Autorem SDKgen je Petr Ospaly.');
writeln(f);
writeln(f,'KONTAKT: petr@ospalax.cz');
writeln(f);
writeln(f);
writeln(f,'Pozn. Omlouvam se za diakritiku');
end;

if jmeno=annemp then
writeln(f,'Mrizka neni plna !');

if jmeno=attmuch then
writeln(f,'Zadani ma vice reseni.');


          close(f);
          end;


procedure ini;
var f:SearchRec;
    begin
    findfirst('data',16,f);
    if doserror<>0 then mkdir('data');
    findfirst('data\sdk',16,f);
    if doserror<>0 then mkdir('data\sdk');
    end;

begin
ini;

vytvor('readme.txt');
vytvor(inf);
vytvor(anncon);
vytvor(annemp);
vytvor(annerr);
vytvor(annnic);
vytvor(annnic2);
vytvor(attcoll);
vytvor(attesc);
vytvor(attless);
vytvor(attmuch);
vytvor(attnon);
end.