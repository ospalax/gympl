unit sdkui;

interface
const POCITEM=6; {pocet polozek hlavniho menu}
      size=20; {sirka ctverecku mrizky}

type T_M_MENU_ITEMS=array[1..POCITEM] of string;
type T_seznam=array[1..10] of string;

var SEZNAM:T_SEZNAM; {lustitelske menu}


{inicializuje hlavni menu}
procedure INI_M_MENU(var ITEMS:T_M_MENU_ITEMS);
          {parametrem je: ITEMS- polozky hlavniho menu}

{zobrazi nezvyraznenou polozku}
procedure INVISIBLE_ITEM(ITEMS:T_M_MENU_ITEMS;KTERA,brvback:byte);
          {parametrem je: ITEMS- polozky hlavniho menu
                          KTERA- konkretni polozka
                          brvback- barva pozadi}

{zvyrazni polozku hlavniho menu}
procedure EXPLODED_ITEM(ITEMS:T_M_MENU_ITEMS;KTERA,brvback:byte;str:string);
          {parametrem je: ITEMS- polozky hlavniho menu
                          KTERA- konkretni polozka
                          brvback- barva pozadi
                          str- text}

{zobrazi hlavni menu}
procedure SH_M_MENU(var ITEMS:T_M_MENU_ITEMS;VOLBA,brvback:byte);
          {parametrem je: ITEMS- polozky hlavniho menu
                          VOLBA- ktery chceme zvyraznit
                          brvback- barva pozadi}

{pohyb v menu}
procedure MOVE_M_MENU(ITEMS:T_M_MENU_ITEMS;brvback:byte;var VOLBA:byte);
          {parametrem je: ITEMS- polozky hlavniho menu
                          brvback- barva pozadi
                          VOLBA- volba}

{ukoncovaci dialog}
procedure QUIT(var QT:boolean;VOLBA:byte);
          {parametrem je: QT- zda konec nebo ne
                          VOLBA- zda jsme v menu nebo v lustiteli}


{zvyraznuje pomoci ramecku}
procedure SELECT_ITEM(len,brvback,brvstr:byte;posx,posy:word;str:string);
          {parametrem je: len- delka ramecku
                          brvback- barva pozadi
                          brvstr- barva textu
                          posx,posy- souradnice stredu polozky
                          str- text polozky}


{okno}
procedure WINDOW_FRAME(var P:pointer;var size:word;brvback:byte;
                       var posytxt,posytxt2:word;
                       posx1,posx2,posy1,posy2:word);
          {parametrem je: P- ukazatel na puvodni pozadi
                          size- velikost obnovovane oblasti
                          brvback- barav pozadi
                          posytxt- pozice horni textove cary
                          posytxt2- pozice dolni texttove cary
                          posx1,posx2,posy1,posy2- odkud kam}


{ramecek okna}
procedure OKENKO(posx1,posy1,posx2,posy2:word;brvback:byte);
          {parametrem je: posx1- x-ova pozice
                          posy2- y-ova pozice
                          posx2- x-ova pozice
                          posy2- y-ova pozice
                          brvback- barva pozadi}

{presune nadpis volby do zahlavi}
procedure NAME_CHOICE(ITEMS:T_M_MENU_ITEMS;KTERY,brvback:byte);
          {parametrem je: ITEMS- menu polozek
                          KTERY- volba
                          brvback- barva pozadi}


{ridi operace s oknem}
procedure COO_WINDOW(FNAME:string;brvback:byte;jak:boolean);
          {parametrem je: FNAME- cesta k souboru
                          brvback- barva pozadi
                          jak- zda male F, nebo velke T}

{obsluha lustitelskeho rozhrani-------------------------}
procedure USE_LUSTITEL(tab,tab2:word;pocfunc:byte;
                       SEZNAM:T_SEZNAM;var i,JAK:byte;first:boolean);
          {parametrem je: tab- pocatek zobrazeni
                          tab2- pocatek menu
                          pocfunc- pocet funkci
                          SEZNAM- seznam funkci
                          i- vraci vybranou funkci
                          JAK- popripade urcuje obtiznost
                          first- T=poprve spusten}
{ukazuje a skryva PLEASE WAIT}
procedure PLWA_SHOW(var P:pointer;var sz:word;ESC:boolean);
procedure PLWA_HIDD(var P:pointer;sz:word);

{obtiznost,vraci cislo urcujici obtiznost}
function CHS_OBT:byte;


implementation
uses crt,graph,sdkgraph,sdktext,sdkdecl;
const start=starty+posy+(2*15)+20; {urcuje pocatek menu}
      lenstr='WWWWWWWWWWWWWWWWWWWW';
      itemhigh=20; {vyska polozky}
      ods=3; {stin pod polozkou}
      res=25; {boky polozky}
      mez=5; {odstup polozek}
      plwa='Prosim cekejte...';
{--------------------obsluha lustitelskeho rozhrani-------------------------}
procedure USE_LUSTITEL(tab,tab2:word;pocfunc:byte;
                       SEZNAM:T_SEZNAM;var i,JAK:byte;first:boolean);
          var key:char;
              l:byte;
          begin
          {jen poprve}
          if first then
          begin
          LUSTITEL(tab,size,black,blue,false);
          CREATE_LINES_WHOLE(15,tab+textheight('Q')+5,
                             15,tab+textheight('Q')+5,
                             size,lightgray,false);

          {inicializace}
          settextstyle(4,0,0);
          for l:=1 to pocfunc do
              begin
              SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                          white,lightblue,320,
                          tab2+(textheight('Q')div 2)+7+(l-1)*(30),
                          SEZNAM[l]);
              end;

          i:=1;

          if VOLBA=1 then begin JAK:=CHS_OBT; exit; end
                     else
                     if VOLBA=3 then exit;

          end;


          {VZDY}
          SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                      blue,blue,320,
                      tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                      SEZNAM[i]);

          {ovladani mini menu-----------------}
          key:=#27;

          while key<>#13 do
                begin
                key:=readkey;

                case ord(key) of
                {nahoru}
                72 : if i>1 then begin
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             white,lightblue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 i:=i-1;
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             blue,blue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 end
                            else begin
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             white,lightblue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 i:=pocfunc;
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             blue,blue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 end;
                {dolu}
                80 :if i<pocfunc then begin
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             white,lightblue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 i:=i+1;
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             blue,blue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 end
                            else begin
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             white,lightblue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 i:=1;
                                 SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                                             blue,blue,320,
                                             tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                                             SEZNAM[i]);
                                 end;
                end;
                end;
                SELECT_ITEM(639-sizer(size)-14-(15+sizer(size)-1+5)-7,
                            white,lightblue,320,
                            tab2+(textheight('Q')div 2)+7+(i-1)*(30),
                            SEZNAM[i]);
          end;
{---------------inicializuje polozky hlavniho menu--------------------------}
procedure INI_M_MENU(var ITEMS:T_M_MENU_ITEMS);
          begin
          ITEMS[1]:='Generovat nove';
          ITEMS[2]:='Vyresit zadani';
			 ITEMS[3]:='Lustit ulozene';
			 
          ITEMS[POCITEM-2]:='Co je to SUDOKU';
          ITEMS[POCITEM-1]:='O programu';
          ITEMS[POCITEM]:='Konec';
          end;
{-----------------zobrazi nezvyraznenou polozku-----------------------------}
procedure INVISIBLE_ITEM(ITEMS:T_M_MENU_ITEMS;KTERA,brvback:byte);

          begin
          {nastaveni pisma}
          settextstyle(4,0,0);
          settextjustify(centertext,centertext);
          {udelani cisteho mista}
          setfillstyle(1,brvback);
          bar(320-((textwidth(lenstr)div 2)+res),
              start+((KTERA-1)*(itemhigh+ods+mez)),
              320+(textwidth(lenstr)div 2)+res+ods,
              start+itemhigh-1+ods+((KTERA-1)*(itemhigh+ods+mez)));
          {nakresleni nezvyraznene polozky}
          setlinestyle(0,black,1);
          {stin}
          setfillstyle(1,black);
          setcolor(black);
          bar(320-((textwidth(lenstr)div 2)-ods),
              start+ods+((KTERA-1)*(itemhigh+ods+mez)),
              320+(textwidth(lenstr)div 2)+ods,
              start+itemhigh-1+ods+((KTERA-1)*(itemhigh+ods+mez)));
          pieslice(320-((textwidth(lenstr)div 2)-ods),
                   start+(itemhigh div 2)+ods+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);
          pieslice(320+(textwidth(lenstr)div 2)+ods,
                   start+(itemhigh div 2)+ods+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);
          {samotna polozka}
          setfillstyle(1,blue);
          setcolor(blue);
          bar(320-((textwidth(lenstr)div 2)),
              start+((KTERA-1)*(itemhigh+ods+mez)),
              320+(textwidth(lenstr)div 2),
              start+itemhigh-1+((KTERA-1)*(itemhigh+ods+mez)));
          pieslice(320-(textwidth(lenstr)div 2),
                   start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);
          pieslice(320+(textwidth(lenstr)div 2),
                   start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);
          {text polozky}
          setcolor(white);
          outtextxy(320,start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
          ITEMS[KTERA]);

          end;
{----------------zvyrazni polozku hlavniho menu-----------------------------}
procedure EXPLODED_ITEM(ITEMS:T_M_MENU_ITEMS;KTERA,brvback:byte;str:string);
          begin
          {nastaveni pisma}
          settextstyle(4,0,0);
          settextjustify(centertext,centertext);
          {nakresleni nezvyraznene polozky}
          setlinestyle(0,black,1);
          {stin}
          setfillstyle(1,black);
          setcolor(black);
          bar(320-((textwidth(lenstr)div 2)-ods+(res-((itemhigh div 2)-1))),
              start+ods+((KTERA-1)*(itemhigh+ods+mez)),
              320+(textwidth(lenstr)div 2)+ods+(res-((itemhigh div 2)-1)),
              start+itemhigh-1+ods+((KTERA-1)*(itemhigh+ods+mez)));
          pieslice(320-((textwidth(lenstr)div 2)-ods
                   +(res-((itemhigh div 2)-1))),
                   start+(itemhigh div 2)+ods+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);
          pieslice(320+(textwidth(lenstr)div 2)+ods
                   +(res-((itemhigh div 2)-1)),
                   start+(itemhigh div 2)+ods+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);
          {samotna polozka}
          setfillstyle(1,lightblue);
          setcolor(lightblue);
          bar(320-((textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1))),
              start+((KTERA-1)*(itemhigh+ods+mez)),
              320+(textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1)),
              start+itemhigh-1+((KTERA-1)*(itemhigh+ods+mez)));
          pieslice(320-((textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1))),
                   start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);
          pieslice(320+(textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1)),
                   start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,(itemhigh div 2)-1);

          {dirky}
          setfillstyle(1,black);
          setcolor(black);
          pieslice(320-((textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1)))
                   +(res div 4)+ods,
                   start+(itemhigh div 2)+ods+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,
                   (itemhigh div 2)-1-(res div 4));
          pieslice(320+(textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1))
                   -(res div 4)+ods,
                   start+(itemhigh div 2)+ods+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,
                   (itemhigh div 2)-1-(res div 4));

          setfillstyle(1,brvback);
          setcolor(brvback);
          pieslice(320-((textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1)))
                   +res div 4,
                   start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,
                   (itemhigh div 2)-1-(res div 4));
          pieslice(320+(textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1))
                   -res div 4,
                   start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
                   0,360,
                   (itemhigh div 2)-1-(res div 4));
          {text polozky}
          setcolor(yellow);
          outtextxy(320,start+(itemhigh div 2)+((KTERA-1)*(itemhigh+ods+mez)),
          STR);

          end;
{----------------------zobrazi hlavni menu----------------------------------}
procedure SH_M_MENU(var ITEMS:T_M_MENU_ITEMS;VOLBA,brvback:byte);
          var i:byte;
          begin
          INI_M_MENU(ITEMS);
          for i:=1 to pocitem do
              begin
              {EXPLODED_ITEM(ITEMS,i,brvback,ITEMS[i]);}
              delay(5);
              INVISIBLE_ITEM(ITEMS,i,brvback);
              end;
          EXPLODED_ITEM(ITEMS,VOLBA,brvback,ITEMS[VOLBA]);
          end;

{------------------------pohyb v hlavnim menu-------------------------------}
procedure MOVE_M_MENU(ITEMS:T_M_MENU_ITEMS;brvback:byte;var VOLBA:byte);
          var key:char;
          begin
          key:=#27;
          while key<>#13 do
                begin
                key:=readkey;
                case ord(key) of
                {nahore}
                72 : if VOLBA>1 then begin
                                     INVISIBLE_ITEM(ITEMS,VOLBA,brvback);
                                     VOLBA:=VOLBA-1;
                                     EXPLODED_ITEM(ITEMS,VOLBA,
                                                   brvback,ITEMS[VOLBA]);
                                     end
                                else begin
                                     INVISIBLE_ITEM(ITEMS,VOLBA,brvback);
                                     VOLBA:=POCITEM;
                                     EXPLODED_ITEM(ITEMS,VOLBA,
                                                   brvback,ITEMS[VOLBA]);
                                     end;
                {dolu}
                80 : if VOLBA<pocitem then begin
                                           INVISIBLE_ITEM(ITEMS,VOLBA,brvback);
                                           VOLBA:=VOLBA+1;
                                           EXPLODED_ITEM(ITEMS,VOLBA,
                                                         brvback,ITEMS[VOLBA]);
                                           end
                                      else begin
                                           INVISIBLE_ITEM(ITEMS,VOLBA,brvback);
                                           VOLBA:=1;
                                           EXPLODED_ITEM(ITEMS,VOLBA,
                                                         brvback,ITEMS[VOLBA]);
                                           end;
                end;
                end;
          end;
{--------------------zvyraznovaci ramecek-----------------------------------}
procedure SELECT_ITEM(len,brvback,brvstr:byte;posx,posy:word;str:string);
          begin
          {nastaveni pisma}
          settextstyle(4,0,0);
          settextjustify(centertext,centertext);
          {nastaveni ramecku}
          setlinestyle(0,0,3);
          setcolor(brvback);

          {hranaty ramecek}
          rectangle(posx-(len div 2),posy-(textheight('Q')div 2)-5-1,
                    posx+(len div 2),posy+(textheight('Q')div 2)+5);

          {text}
          setcolor(brvstr);
          outtextxy(posx,posy,str);
          end;

{--------------------nadpis vybrane funkce----------------------------------}
procedure NAME_CHOICE(ITEMS:T_M_MENU_ITEMS;KTERY,brvback:byte);
          var i:byte;
              posx1,posx2,posy1,posy2,size:word;
              P:pointer;

          begin
          {vymazani menu}
          setfillstyle(1,brvback);
          bar(320-((textwidth(lenstr)div 2)+res),
              start,
              320+(textwidth(lenstr)div 2)+res+ods,
              start+itemhigh-1+ods+((POCITEM-1)*(itemhigh+ods+mez)));

          {vykresleni polozky}
          EXPLODED_ITEM(ITEMS,KTERY,brvback,ITEMS[KTERY]);

          (*
          for i:=KTERY-1 downto 1 do
              begin
              delay(5);
              setfillstyle(1,brvback);
              bar(320-((textwidth(lenstr)div 2)+res),
                  start+((i)*(itemhigh+ods+mez)),
                  320+(textwidth(lenstr)div 2)+res+ods,
                  start+itemhigh-1+ods+((i)*(itemhigh+ods+mez)));
              {vykresleni polozky}
              EXPLODED_ITEM(ITEMS,i,brvback,ITEMS[KTERY]);
              end;
          *)

          posx1:=320-((textwidth(lenstr)div 2)+(res-((itemhigh div 2)-1)))-10;
          posy1:=start+((KTERY-1)*(itemhigh+ods+mez));
          posx2:=320+(textwidth(lenstr)div 2)+ods+(res-((itemhigh div 2)-1))+10;
          posy2:=start+itemhigh-1+ods+((KTERY-1)*(itemhigh+ods+mez));

          size:=imagesize(posx1,posy1,posx2,posy2);
          GetMem(P, Size);
          GetImage(posx1,posy1,posx2,posy2,P^);
          while posy1>start do
                begin
                putimage(posx1,posy1,P^,normalput);
                freemem(P,size);

                {delay(1);}

                size:=imagesize(posx1,posy1,posx2,posy2);
                GetMem(P, Size);
                GetImage(posx1,posy1,posx2,posy2,P^);

                setfillstyle(1,brvback);
                bar(posx1,posy1,posx2,posy2);

                posy1:=posy1-5;
                posy2:=posy2-5;
                end;
          freemem(P,size);
          EXPLODED_ITEM(ITEMS,1,brvback,ITEMS[KTERY]);
          end;
{--------------------okno---------------------------------------------------}
procedure WINDOW_FRAME(var P:pointer;var size:word;brvback:byte;
                       var posytxt,posytxt2:word;
                       posx1,posx2,posy1,posy2:word);
          const brv=blue;
                brvfrtx=blue;
                brvnotx=lightblue;

                tab=40;
          var i:byte;
              stredx:word;
          begin
          {ulozeni pozadi}
          size:=imagesize(posx1,posy1,posx2,posy2);
          GetMem(P, Size);
          GetImage(posx1,posy1,posx2,posy2,P^);

          setfillstyle(1,brvback);
          bar(posx1,posy1,posx2,posy2);

          {stin}
          setfillstyle(1,black);
          bar(posx1+ods,posy1+ods,posx2,posy2);
          putpixel(posx2,posy1+ods,brvback);
          putpixel(posx1+ods,posy2,brvback);
          putpixel(posx2,posy2,brvback);
          {ramecek}
          setlinestyle(0,black,3);
          setfillstyle(1,brvback);
          setcolor(brv);

          bar(posx1+2,posy1+2,posx2-ods-2,posy2-ods-2);

          rectangle(posx1+1,posy1+1,posx2-ods-1,posy2-ods-1);

          {text}
          {nastaveni pisma}
          settextstyle(4,0,0);
          settextjustify(centertext,TOPtext);
          setcolor(brvback);
          stredx:=(((posx2-ods)-posx1)div 2)+posx1;

          line(stredx-(textwidth('ESC') div 2)-1,posy1+1,
               stredx+(textwidth('ESC') div 2)+1,posy1+1);
          {ESC}
          setcolor(brv);
          outtextxy(stredx,posy1,'ESC');

          {hranicni carky}
          posytxt:=posy1+tab;
          posytxt2:=posy2-ods-tab;

          setlinestyle(0,black,1);

          line(posx1+8,posytxt-5,
               posx2-ods-8,posytxt-5);
          line(posx1+8,posytxt2+5,
               posx2-ods-8,posytxt2+5);
          end;

{------------------ridi operace s oknem-------------------------------------}
{dela sipky}
{TRUE- nahoru
FALSE- dolu}
procedure ARROW(brv:byte;posy:word;UPDW:boolean);
          const stair=7;

          var i,doub,l:byte;

          function srv(i,doub:byte):byte;
                   begin
                   srv:=(i-1-(doub-1))
                   end;
          begin
          if UPDW then posy:=posy-10
                  else posy:=posy+10;

          for i:=1 to stair do
          for doub:=0 to 1 do
              begin
              if UPDW then putpixel(320,posy-srv(i,doub),brv)
                      else putpixel(320,posy+srv(i,doub),brv);
              for l:=1 to (stair-i) do
                  begin
                  if UPDW then putpixel(320-l,posy-srv(i,doub),brv)
                          else putpixel(320-l,posy+srv(i,doub),brv);
                  if UPDW then putpixel(320+l,posy-srv(i,doub),brv)
                          else putpixel(320+l,posy+srv(i,doub),brv);
                  end;
              end;
          end;

procedure COO_WINDOW(FNAME:string;brvback:byte;jak:boolean);
          var P:pointer;
              sz,posytxt,posytxt2,posx1,posx2,posy1,posy2:word;
              POCET,pom,arr1,arr2,POCRAD,POCPIS:byte;
              key:char;
          begin
          {okno}
          if jak then
             begin
             {to radsi nemen}
             posx1:=320-150;
             posy1:=240-50-1;
             posx2:=320+150;
             posy2:=240+225-1;
             POCRAD:=15;
             POCPIS:=34;
             end
             else
             begin
             posx1:=15+sizer(size)-1+5;
             posy1:=tab+textheight('Q')+5;
             posx2:=posx1+639-sizer(size)-14-(15+sizer(size)-1+5)-5;
             posy2:=posy1+sizer(size)-1;
             POCRAD:=9;
             POCPIS:=22;
             end;

          WINDOW_FRAME(P,sz,brvback,posytxt,posytxt2,
                       posx1,posx2,posy1,posy2);

          {text stranky}
          SUM_PAGES(FNAME,POCET,POCRAD);

          if POCET=0 then begin
                          READER(FNAME,(((posx2-ods)-posx1)div 2)+posx1,
                          posytxt,POCET,POCRAD,POCPIS);
                          while readkey<>#27 do;
                          end
                     else
                     begin

                     pom:=1;
                     arr1:=white;
                     arr2:=white;
                     if POCET>1 then arr2:=blue;

                     ARROW(arr1,posytxt,true);
                     ARROW(arr2,posytxt2,false);
                     READER(FNAME,(((posx2-ods)-posx1)div 2)+posx1,
                            posytxt,1,POCRAD,POCPIS);
                     {dokud neni ESC}
                     key:=#13;
                     while key<>#27 do
                           begin

                           key:=readkey;

                           case ord(key) of
                           {nahoru}
                           72 : begin
                                if pom>1 then
                                   begin
                                   arr2:=blue;
                                   pom:=pom-1;
                                   if pom=1 then arr1:=white;

                                   {nastaveni opony}
                                   setfillstyle(1,brvback);
                                   bar(posx1+8,posytxt,posx2-ods-8,posytxt2);
                                   ARROW(arr1,posytxt,true);
                                   ARROW(arr2,posytxt2,false);
                                   READER(FNAME,(((posx2-ods)-posx1)div 2)+posx1,
                                          posytxt,pom,POCRAD,POCPIS);
                                   end
                                end;
                           {dolu}
                           80 : begin
                                if pom<POCET then
                                   begin
                                   arr1:=blue;
                                   pom:=pom+1;
                                   if pom=POCET
                                      then arr2:=white;
                                   {nastaveni opony}
                                   setfillstyle(1,brvback);
                                   bar(posx1+8,posytxt,posx2-ods-8,posytxt2);
                                   ARROW(arr1,posytxt,true);
                                   ARROW(arr2,posytxt2,false);
                                   READER(FNAME,(((posx2-ods)-posx1)div 2)+posx1,
                                          posytxt,pom,POCRAD,POCPIS);
                                   end
                                end;
                           end;

                           end;
                     end;
          {navrat pozadi}
          putimage(posx1,posy1,P^,normalput);
          freemem(P,sz);
          end;


procedure OKENKO(posx1,posy1,posx2,posy2:word;brvback:byte);
          const brv=blue;
          begin
          {stin}
          setfillstyle(1,black);
          bar(posx1+ods,posy1+ods,posx2,posy2);
          putpixel(posx2,posy1+ods,brvback);
          putpixel(posx1+ods,posy2,brvback);
          putpixel(posx2,posy2,brvback);
          {ramecek}
          setlinestyle(0,black,3);
          setfillstyle(1,brvback);
          setcolor(brv);

          bar(posx1+2,posy1+2,posx2-ods-2,posy2-ods-2);

          rectangle(posx1+1,posy1+1,posx2-ods-1,posy2-ods-1);
          end;
{--------------------ukonceni programu--------------------------------------}
procedure QUIT(var QT:boolean;VOLBA:byte);
          const hormez=100;
                vermez=50;
                brv=blue;
                brvback=white;
                brvfrtx=blue;
                brvnotx=lightblue;
          var P:pointer;
              size2,posx1,posy1,posx2,posy2:word;
              key:char;
          begin

          posx1:=15+sizer(size)-1+5;
          posy1:=240-vermez-1;
          posx2:=639-sizer(size)-14-5;
          posy2:=240+vermez+ods+2;
          {ulozeni pozadi}
          Size2:=ImageSize(posx1,posy1,posx2,posy2);
          GetMem(P, Size2);
          GetImage(posx1,posy1,posx2,posy2,P^);

          OKENKO(posx1,posy1,posx2,posy2,brvback);
          (*{stin}
          setlinestyle(0,black,3);
          setcolor(black);
          rectangle(320-hormez+ods-1,240-vermez+ods-1,
                    320+hormez+ods-1,240+vermez+ods-1);
          rectangle(320-hormez+ods+1,240-vermez+ods+1,
                    320+hormez+ods+1,240+vermez+ods+1);
          {ramecek}
          setlinestyle(0,black,3);
          setfillstyle(1,brvback);
          setcolor(brv);

          bar(320-hormez,240-vermez,320+hormez,240+vermez);

          rectangle(320-hormez,240-vermez,320+hormez,240+vermez);*)
          {text}
          {nastaveni pisma}
          settextjustify(centertext,centertext);
          setcolor(brv);

          if VOLBA=POCITEM
             then outtextxy(320,240-25,'Opravdu chcete skoncit?')
             else outtextxy(320,240-25,'Opravdu chcete zpet?');

          setcolor(brvnotx);
          outtextxy(320-(hormez div 2),240+25,'NE');
          outtextxy(320+(hormez div 2),240+25,'ANO');

          key:=#27;
          QT:=false;
          select_item(40,brvfrtx,brvfrtx,320-(hormez div 2),240+25,'NE');
          while key<>#13 do
                begin
                key:=readkey;
                case ord(key) of
                75 : if QT then
                        begin
                        select_item(40,brvback,brvnotx,
                                    320+(hormez div 2),240+25,'ANO');
                        QT:=false;
                        select_item(40,brvfrtx,brvfrtx,
                                    320-(hormez div 2),240+25,'NE');
                        end;
                77 : if not QT then
                        begin
                        select_item(40,brvback,brvnotx,
                                    320-(hormez div 2),240+25,'NE');
                        QT:=true;
                        select_item(40,brvfrtx,brvfrtx,
                                    320+(hormez div 2),240+25,'ANO');
                        end;
                end;
                end;

          {vraci se zpet}
          if not QT then begin
                         PutImage(posx1,posy1, P^, NormalPut);
                         freemem(P,size2);
                         end;
          end;
{---------------------------------------------------------------------------}
{----------------------------obtiznost--------------------------------------}
function CHS_OBT:byte;
         const vermez=20;
               hormez=10;
               poc=3;
               mez=20;
         var sz,posx1,posy1,posx2,posy2:word;
             P:pointer;
             pole:array[1..poc] of string;
             key:char;
             i:byte;
         begin
         {inicializace}
         pole[1]:='Snadne';
         pole[2]:='Stredne tezke';
         pole[3]:='Tezke';
         {----------------------------------------------------}
         settextstyle(4,0,0);
         posx1:=15+sizer(size)-1+5;
         posx2:=639-sizer(size)-14-5;
         posy1:=tab;
         posy2:=tab+(poc*(textheight('Q'))+(poc-1)*mez)+2*vermez-1;
         {uschovani pozadi}
         sz:=imagesize(posx1,posy1,posx2,posy2);
         GetMem(P,Sz);
         GetImage(posx1,posy1,posx2,posy2,P^);
         {------------------------------------}
         OKENKO(posx1,posy1,posx2,posy2,white);
         posy1:=posy1-1;
         posx2:=posx2-ods;
         posy2:=posy2-ods;
         {-------------------obsluha--------------------}

         for i:=1 to poc do SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                        white,lightblue,posx1+(posx2-posx1+1)div 2,
                                        posy1+vermez+(textheight('Q')div 2)+
                                        ((i-1)*(textheight('Q')+mez)),
                                        POLE[i]);

         i:=1;

         SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                     blue,blue,posx1+(posx2-posx1+1)div 2,
                     posy1+vermez+(textheight('Q')div 2)+
                     ((i-1)*(textheight('Q')+mez)),
                     POLE[i]);

         key:=#27;
         while key<>#13 do
                begin
                key:=readkey;

                case ord(key) of
                {nahoru}
                72 : if i>1 then begin
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             white,lightblue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 i:=i-1;
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             blue,blue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 end
                            else begin
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             white,lightblue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 i:=poc;
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             blue,blue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 end;
                {dolu}
                80 :if i<poc then begin
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             white,lightblue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 i:=i+1;
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             blue,blue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 end
                            else begin
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             white,lightblue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 i:=1;
                                 SELECT_ITEM(posx2-posx1-(2*hormez)+1,
                                             blue,blue,posx1+(posx2-posx1+1)div 2,
                                             posy1+vermez+(textheight('Q')div 2)+
                                             ((i-1)*(textheight('Q')+mez)),
                                             POLE[i]);
                                 end;
                end;
                end;
         CHS_OBT:=i;
         {----------------------------------------------}


         {navraceni pozadi}
         PutImage(posx1,posy1+1, P^, NormalPut);
         freemem(P,sz);
         end;
{-----------------------------PLEASE WAIT-----------------------------------}
procedure PLWA_SHOW(var P:pointer;var sz:word;ESC:boolean);
          const hormez=35;
                vermez=20;
                vermeztxt=3;

          var posx1,posy1,posx2,posy2:word;
          begin
          settextstyle(4,0,0);

          posx1:=320-(textwidth(plwa)div 2)-hormez-1;
          posy1:=240-textheight('Q')-vermez-vermeztxt;
          posx2:=320+(textwidth(plwa)div 2)+hormez;
          posy2:=240+textheight('Q')+vermez+vermeztxt;
          {ulozeni pozadi}
          sz:=imagesize(posx1,posy1,posx2,posy2);
          GetMem(P, Sz);
          GetImage(posx1,posy1,posx2,posy2,P^);
          {--------------}
          OKENKO(posx1,posy1,posx2,posy2,white);
          {text}
          if ESC then
          begin
          setcolor(black);
          settextjustify(centertext,toptext);
          outtextxy(320,240-textheight('Q')-vermeztxt,plwa);
          setcolor(lightgray);
          settextjustify(centertext,bottomtext);
          outtextxy(320,240+textheight('Q')+vermeztxt,'[ESC]');
          end
          else
          begin
          setcolor(black);
          settextjustify(centertext,centertext);
          outtextxy(320,240,plwa);
          end;
          end;
procedure PLWA_HIDD(var P:pointer;sz:word);
          const hormez=35;
                vermez=20;
                vermeztxt=3;
          var posx1,posy1:word;
          begin
          posx1:=320-(textwidth(plwa)div 2)-hormez-1;
          posy1:=240-textheight('Q')-vermez-vermeztxt;
          settextstyle(4,0,0);
          PutImage(posx1,posy1,P^, NormalPut);
          freemem(P,sz);
          end;
{---------------------------------------------------------------------------}
begin
end.