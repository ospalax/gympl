unit sdkgraph;

interface
uses sdkdecl;

const starty=50; {vertikalni pozice nadpisu SDK}
      lne=1; {sirka linky nadpisu SDK}
      field=4; {rozmer ctverecku SDK FIELDxFIELD}
      sq=field+(2*lne); {rozmer celeho ctverecku}
      posx=21*(sq-lne)+lne; {vypocet x-oveho rozmeru celeho nadpisu SDK}
      posy=12*(sq-lne)+lne; {vypocet y-oveho rozmeru celeho nadpisu SDK}
      AUTOR='''dc]]XW__a`ON77``aaZYOO';
      tab=starty+posy+78; {zacatek zobrazeni pod nadpisem funkce}

{vytvori graficky mrizku 3x3}
{doporuceno pro rozmer 35 a vyse}
procedure CREATE_LINES_BASE(posx,posy,rozmer:word;
                            exe:boolean;brvline,brvback,size:byte);
          {parametrem je: posx- x-ova pocatecni souradnice
                          posy- y-ova pocatecni souradnice
                          rozmer- velikost strany ctverce
                          exe- zda ma probehnout animace
                          brvline- barva linek
                          brvback- barva pozadi
                          size- sirka linky}
{zjisti sirku mrize}
function SIZER(pom:byte):word;

{vytvori kompletni sudoku mriz}
procedure CREATE_LINES_WHOLE(posx,posy,posx2,posy2:word;
                             rozmer:byte;brvline:byte;exe:boolean);
          {parametrem je: posx- x-ova pocatecni souradnice
                          posy- y-ova pocatecni souradnice
                          posx2- druha pozice
                          posy2- druha pozice
                          rozmer- vnitrniho ctverecku
                          brvline- barva linek
                          exe- T=animace}

{zobrazi zakladni lustitelske rozhrani}
procedure LUSTITEL(tab:word;size,brv,brvtext:byte;exe:boolean);
          {parametrem je: tab- zacatek zobrazeni
                          size- sirka ctverecku
                          brv- barva linek
                          brvtext- barva textu
                          exe- T=animace}

{prochazeni grafickou mrizi-------------------------------------------------}
procedure USE_LATTICE_PRIMITIVE(var POMITEM:T_POMLATTICE;var sl:char;
                                var ra:byte;size:byte;posx,posy:word;
                                var chg:boolean);
          {parametrem je: POMITEM- pole grafickych cisel
                          sl- sloupce
                          ra- radky
                          size- sirka ctverecku
                          posx,posy- pocatecni souradnice
                          chg- T-pokud doslo ke zmene}


{prekresluje cisla do mrizky}
procedure WRITE_LATTICE_NUMBERS(POMITEM:T_POMLATTICE;ITEM,ITEM2:T_LATTICE;
                                posx,posy:word;size,rad:byte);

          {parametrem je: POMITEM- pole grafickych cisel
                          ITEM- skutecna mrizka
                          ITEM2- zadani
                          posx,posy- pocatecni souradnice
                          size- sirka ctverecku
                          rad- radic 1-vlevo 2-vpravo mrizka}

procedure WRITE_LATTICE_NUMBERS2(POMITEM:T_POMLATTICE;
                                posx,posy:word;size:byte);

{oznacuje aktivni ctverecek}
procedure SH_SQUARE(posx,posy:word;sl,CO:char;
                    ra,brvtext,brvback,size:byte);
          {parametrem je: POMITEM- pole grafickych cisel
                          posx,posy- pocatecni souradnice
                          sl- sloupce
                          CO- cislo
                          ra- radky
                          brvtext- barva cisel
                          brvback- barva pozadi
                          size- sirka ctverecku}

{---------------------------------------------------------------------------}
{uvodni sekvence}
procedure UVOD(brvline,brvback:byte);
{---------------------------------------------------------------------------}
{vytvori kompletni nadpis}
procedure TITLE(brvback:byte);

implementation
uses crt,graph,sdkmain;

var GD,GM:integer;

{zobrazi zakladni lustitelske rozhrani-------------------------------------}
procedure LUSTITEL(tab:word;size,brv,brvtext:byte;exe:boolean);

          var i:byte;
              stred1,stred2:word;
              Zadani,Reseni:string;
          begin
          Zadani:='Zad n¡';
          Reseni:='Reseni';

          {nastaveni textu}
          settextstyle(4,0,0);
          settextjustify(lefttext,toptext);

          {mrize}
          CREATE_LINES_WHOLE(15,tab+textheight('Q')+5,
                             639-sizer(size)-14,tab+textheight('Q')+5,
                             size,brv,exe);

          {text}
          setcolor(brvtext);

          stred1:=15+(sizer(size)div 2)-textwidth('WWW');
          stred2:=639-(sizer(size)div 2)-14-textwidth('WWW');
          for i:=1 to 6 do
              begin
              delay(20);
              outtextxy(stred1+(i-1)*textwidth('W'),tab,Zadani[i]);
              outtextxy(stred2+(i-1)*textwidth('W'),tab,Reseni[i]);
              end;

          end;

{-----------------umoznuje zapis do mrizky----------------------------------}

{oznacuje aktivni ctverecek}
procedure SH_SQUARE(posx,posy:word;sl,CO:char;
                    ra,brvtext,brvback,size:byte);
          var x,y:word;
          begin
          posx:=posx+3;
          posy:=posy+3;

          setfillstyle(1,brvback);
          x:=posx+(ord(sl)-65)*(size+1);
          if ord(sl)-64>3 then
             if ord(sl)-64>6 then x:=x+4
                             else x:=x+2;
          y:=posy+(ra-1)*(size+1);
          if ra>3 then
             if ra>6 then y:=y+4
                     else y:=y+2;

          setfillstyle(1,brvback);
          bar(x,y,x+size-1,y+size-1);


          settextstyle(4,0,0);
          settextjustify(centertext,centertext);
          setcolor(brvtext);

          if CO<>'0' then
          outtextxy(x+(size div 2)-1,y+(size div 2)-1,
                    CO);
          end;

{prochazeni grafickou mrizi}
procedure USE_LATTICE_PRIMITIVE(var POMITEM:T_POMLATTICE;var sl:char;
                                var ra:byte;size:byte;posx,posy:word;
                                var chg:boolean);
          var key,slpom:char;
              rapom:byte;
          begin
          key:=#13;

          while key<>#27 do
                begin
                key:=readkey;

                case ord(key) of
                {nahoru}
                72 : if ra>1 then
                        begin
                        SH_SQUARE(posx,posy,sl,
                                  chr(POMITEM[sl,ra,1]+48),ra,
                                  POMITEM[sl,ra,2],POMITEM[sl,ra,3],size);
                        {for rapom:=ra-1 downto 1 do
                            if POMITEM[sl,rapom,2]<>brvzadtext
                               then begin
                                    ra:=rapom;
                                    break;
                                    end;}
                        ra:=ra-1;
                        if POMITEM[sl,ra,2]<>brvzadtext
                           then
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     POMITEM[sl,ra,2],yellow,size)
                           else
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     brvzadback,yellow,size);
                        end;
                {dolu}
                80 : if ra<9 then
                        begin
                        SH_SQUARE(posx,posy,sl,
                                  chr(POMITEM[sl,ra,1]+48),ra,
                                  POMITEM[sl,ra,2],POMITEM[sl,ra,3],size);
                        {for rapom:=ra+1 to 9 do
                            if POMITEM[sl,rapom,2]<>brvzadtext
                               then begin
                                    ra:=rapom;
                                    break;
                                    end;}
                        ra:=ra+1;
                        if POMITEM[sl,ra,2]<>brvzadtext
                           then
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     POMITEM[sl,ra,2],yellow,size)
                           else
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     brvzadback,yellow,size);
                        end;
                {vlevo}
                75 : if sl>'A' then
                        begin
                        SH_SQUARE(posx,posy,sl,
                                  chr(POMITEM[sl,ra,1]+48),ra,
                                  POMITEM[sl,ra,2],POMITEM[sl,ra,3],size);
                        {for slpom:=pred(sl) downto 'A' do
                            if POMITEM[slpom,ra,2]<>brvzadtext
                               then begin
                                    sl:=slpom;
                                    break;
                                    end;}
                        sl:=pred(sl);
                        if POMITEM[sl,ra,2]<>brvzadtext
                           then
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     POMITEM[sl,ra,2],yellow,size)
                           else
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     brvzadback,yellow,size);
                        end;
                {vpravo}
                77 : if sl<'I' then
                        begin
                        SH_SQUARE(posx,posy,sl,
                                  chr(POMITEM[sl,ra,1]+48),ra,
                                  POMITEM[sl,ra,2],POMITEM[sl,ra,3],size);
                        {for slpom:=succ(sl) to 'I' do
                            if POMITEM[slpom,ra,2]<>brvzadtext
                               then begin
                                    sl:=slpom;
                                    break;
                                    end;}
                        sl:=succ(sl);
                        if POMITEM[sl,ra,2]<>brvzadtext
                           then
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     POMITEM[sl,ra,2],yellow,size)
                           else
                           SH_SQUARE(posx,posy,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     brvzadback,yellow,size);
                        end;
                49..57 : if POMITEM[sl,ra,2]<>brvzadtext then
                         begin
                         POMITEM[sl,ra,1]:=ord(key)-48;

                         SH_SQUARE(posx,posy,sl,
                                   chr(POMITEM[sl,ra,1]+48),ra,
                                   POMITEM[sl,ra,2],yellow,size);
                         chg:=true;
                         end;
                8 : if POMITEM[sl,ra,2]<>brvzadtext then
                    begin
                    POMITEM[sl,ra,1]:=0;
                    SH_SQUARE(posx,posy,sl,
                              chr(POMITEM[sl,ra,1]+48),ra,
                              POMITEM[sl,ra,2],yellow,size);
                    chg:=true;
                    end;
                end;

                end;
          end;

{------------------prekresluje cisla do mrizky-----------------------------}

procedure WRITE_LATTICE_NUMBERS2(POMITEM:T_POMLATTICE;
                                posx,posy:word;size:byte);
          var ra:byte;
              sl,CO:char;
          begin
          for ra:=1 to 9 do
              for sl:='A' to 'I' do
                  begin
                  if POMITEM[sl,ra,1]<>0 then
                     begin
                     CO:=chr(POMITEM[sl,ra,1]+48);
							SH_SQUARE(posx,posy,sl,CO,ra,POMITEM[sl,ra,2],POMITEM[sl,ra,3],size);
                     end
                  end;
          end;

procedure WRITE_LATTICE_NUMBERS(POMITEM:T_POMLATTICE;ITEM,ITEM2:T_LATTICE;
                                posx,posy:word;size,rad:byte);
          var ra:byte;
              sl,CO:char;
          begin
          for ra:=1 to 9 do
              for sl:='A' to 'I' do
                  begin
                  SH_SQUARE(posx,posy,sl,' ',ra,white,
                            white,size);
                  if ITEM2[sl,ra,10]=1 then
                     begin
                     CO:=chr(ITEM2[sl,ra,1]+48);
                     SH_SQUARE(posx,posy,sl,CO,ra,brvzadtext,
                               brvzadback,size);
                     end
                     else
                     begin

                  if rad=3 then
                     begin
                     CO:=chr(ITEM[sl,ra,1]+48);
                     SH_SQUARE(posx,posy,sl,CO,ra,brvrestext,
                               brvresback,size);
                     end;
                  if rad=2 then
                     begin
                     if POMITEM[sl,ra,1]<>0 then
                        begin
                        if ITEM[sl,ra,1]=POMITEM[sl,ra,1] then
                           begin
                           CO:=chr(ITEM[sl,ra,1]+48);
                           SH_SQUARE(posx,posy,sl,CO,ra,brvrestext,
                                     brvresback,size);
                           end
                           else
                           begin
                           CO:=chr(ITEM[sl,ra,1]+48);
                           SH_SQUARE(posx,posy,sl,CO,ra,red,
                                     yellow,size);
                           end
                        end
                        else
                        begin
                        CO:=chr(ITEM[sl,ra,1]+48);
                        SH_SQUARE(posx,posy,sl,CO,ra,red,
                                  yellow,size);
                        end
                     end
                     end
                  end
          end;

{------------------------vytvori mriz--------------------------------------}
procedure CREATE_LINES_BASE(posx,posy,rozmer:word;
                            exe:boolean;brvline,brvback,size:byte);
          var i,x,x1,x2,y,y1,y2:word;
          begin
          {nastaveni car}
          setlinestyle(0,brvline,size);

          {obrysove cary----------------------------------------------}
          setcolor(brvline);
          y:=posy+1;
          x:=posx+1;
          {horizantalni smazat}
              line(posx,y,posx+rozmer-1,y);
              line(posx,posy+rozmer-2,posx+rozmer-1,posy+rozmer-2);
          {vertikalni smazat}
              line(x,posy,x,posy+rozmer-1);
              line(posx+rozmer-2,posy,posx+rozmer-2,posy+rozmer-1);
          {-----------------------------------------------------------}
          {hlavni vnitrni cary}
          y:=posy+4;
          x:=posx+4;
          y1:=y;
          y2:=y;
          x1:=x;
          x2:=x;
          for i:=1 to ((rozmer-6)div 3)*2 do
              begin
              if exe then
              begin
              {cerne}
              setcolor(brvline);
              line(posx+3,y1,posx+rozmer-4,y1);
              line(x1,posy+3,x1,posy+rozmer-4);
              if i>(rozmer-6)div 3
                 then begin line(posx+3,y2,posx+rozmer-4,y2);
                            line(x2,posy+3,x2,posy+rozmer-4);
                      end;

              delay(100 div rozmer);{promlka}

              {maze cerne}
              setcolor(brvback);
              line(posx+3,y1,posx+rozmer-4,y1);
              line(x1,posy+3,x1,posy+rozmer-4);
              if i>(rozmer-6)div 3
                 then begin line(posx+3,y2,posx+rozmer-4,y2);
                            line(x2,posy+3,x2,posy+rozmer-4);
                      end;

              end;
              {iterace}
              y1:=y1+1;
              x1:=x1+1;
              if i>(rozmer-6)div 3
                 then begin y2:=y2+1;  x2:=x2+1 end;
              end;
          setcolor(brvline);
          line(posx+3,y1,posx+rozmer-4,y1);
          line(x1,posy+3,x1,posy+rozmer-4);

          line(x2-1,posy+3,x2-1,posy+rozmer-4);
          line(posx+3,y2-1,posx+rozmer-4,y2-1);
          end;


(*procedure CREATE_LINES_WHOLE(posx,posy,rozmer:word;brvline,brvback:byte);
          var i,l:byte;
          begin
          {vytvori velkou mriz}
          CREATE_LINES_BASE(posx,posy,rozmer,true,brvline,brvback,3);

          {vytvori dilci mrize}
          for l:=0 to 2 do
          for i:=0 to 2 do
          CREATE_LINES_BASE(posx+2+(i*((rozmer-6)div 3)+i*1),
                            posy+2+(l*((rozmer-6)div 3)+l*1),
                            ((rozmer-6)div 3)+2,false,brvline,brvback,1);

          end;
*)
procedure CREATE_LINES_WHOLE(posx,posy,posx2,posy2:word;
                             rozmer:byte;brvline:byte;exe:boolean);
          var y,x,druhax,druhay,druhax1,druhay1,druhax2,druhay2,
              y1,x1,y2,x2,x3,y3,i:word;
          begin
          {nastaveni car}
          setlinestyle(0,brvline,3);

          {obrysove cary----------------------------------------------}
          setcolor(brvline);
          y:=posy+1;
          x:=posx+1;
          {horizantalni smazat}
              line(posx,y,posx+(9*rozmer)-1+18,y);
              line(posx,posy+(9*rozmer)-2+18,
                   posx+(9*rozmer)-1+18,posy+(9*rozmer)-2+18);
          {vertikalni smazat}
              line(x,posy,x,posy+(9*rozmer)-1+18);
              line(posx+(9*rozmer)-2+18,posy,
                   posx+(9*rozmer)-2+18,posy+(9*rozmer)-1+18);

          druhay:=posy2+1;
          druhax:=posx2+1;
          {horizantalni smazat}
              line(posx2,druhay,posx2+(9*rozmer)-1+18,druhay);
              line(posx2,posy2+(9*rozmer)-2+18,
                   posx2+(9*rozmer)-1+18,posy2+(9*rozmer)-2+18);
          {vertikalni smazat}
              line(druhax,posy2,druhax,posy2+(9*rozmer)-1+18);
              line(posx2+(9*rozmer)-2+18,posy2,
                   posx2+(9*rozmer)-2+18,posy2+(9*rozmer)-1+18);
          {-----------------------------------------------------------}
          {hlavni vnitrni cary}
          y:=posy+3;
          x:=posx+3;
          {vertikalni}
          x1:=x+3*rozmer+2+1;
          x2:=x1+2+3*rozmer+2+1;
          {horizontalni}
          y1:=y+3*rozmer+2+1;
          y2:=y1+2+3*rozmer+2+1;

          {hlavni vnitrni cary}
          druhay:=posy2+3;
          druhax:=posx2+3;
          {vertikalni}
          druhax1:=druhax+3*rozmer+2+1;
          druhax2:=druhax1+2+3*rozmer+2+1;
          {horizontalni}
          druhay1:=druhay+3*rozmer+2+1;
          druhay2:=druhay1+2+3*rozmer+2+1;

          for i:=1 to  (9*rozmer)+12 do
              begin
              if exe then delay(1);
              {hl vertikalni}
              line(x1,y,x1,y+i);
              line(x2,y,x2,y+i);
              {hl horizantalni}
              line(x,y1,x+i,y1);
              line(x,y2,x+i,y2);

              {druha hl vertikalni}
              line(druhax1,druhay,druhax1,druhay+i);
              line(druhax2,druhay,druhax2,druhay+i);
              {druha hl horizantalni}
              line(druhax,druhay1,druhax+i,druhay1);
              line(druhax,druhay2,druhax+i,druhay2);



              {vertikalni}
              putpixel(x+rozmer,(y-1)+i,brvline);
              putpixel(x+1+2*rozmer,(y-1)+i,brvline);

              putpixel(x1+2+rozmer,(y-1)+i,brvline);
              putpixel(x1+2+1+2*rozmer,(y-1)+i,brvline);

              putpixel(x2+2+rozmer,(y-1)+i,brvline);
              putpixel(x2+2+1+2*rozmer,(y-1)+i,brvline);

              {horizontalni}
              putpixel((x-1)+i,y+rozmer,brvline);
              putpixel((x-1)+i,y+1+2*rozmer,brvline);

              putpixel((x-1)+i,y1+2+rozmer,brvline);
              putpixel((x-1)+i,y1+2+1+2*rozmer,brvline);

              putpixel((x-1)+i,y2+2+rozmer,brvline);
              putpixel((x-1)+i,y2+2+1+2*rozmer,brvline);


              {druha vertikalni}
              putpixel(druhax+rozmer,(druhay-1)+i,brvline);
              putpixel(druhax+1+2*rozmer,(druhay-1)+i,brvline);

              putpixel(druhax1+2+rozmer,(druhay-1)+i,brvline);
              putpixel(druhax1+2+1+2*rozmer,(druhay-1)+i,brvline);

              putpixel(druhax2+2+rozmer,(druhay-1)+i,brvline);
              putpixel(druhax2+2+1+2*rozmer,(druhay-1)+i,brvline);

              {druha horizontalni}
              putpixel((druhax-1)+i,druhay+rozmer,brvline);
              putpixel((druhax-1)+i,druhay+1+2*rozmer,brvline);

              putpixel((druhax-1)+i,druhay1+2+rozmer,brvline);
              putpixel((druhax-1)+i,druhay1+2+1+2*rozmer,brvline);

              putpixel((druhax-1)+i,druhay2+2+rozmer,brvline);
              putpixel((druhax-1)+i,druhay2+2+1+2*rozmer,brvline);

              end;
          end;

function SIZER(pom:byte):word;
         begin
         SIZER:=(9*pom)+18;
         end;
{-------------------------------------------------------------------------}
{sbihajici cary}
procedure UVOD_LINE_1(brvline,brvback:byte;var cnt:boolean);
          var x,y,i:word;
          begin
          y:=1;
          x:=1;

          {nastaveni car}
          setlinestyle(0,brvline,3);
          for i:=1 to 90 do
              begin
              setcolor(brvline);
              {horizontalni cerne}
              line(170,y,469,y);
              line(170,479-y,469,479-y);

              {vertikalni cerne}
              line(x,90,x,389);
              line(639-x,90,639-x,389);

              if not keypressed then delay(7){promlka}
                                else if readkey=#27 then
                                        begin
                                        cnt:=false;
                                        break;
                                        end;
              setcolor(brvback);
              {horizantalni smazat}
              line(170,y,469,y);
              line(170,479-y,469,479-y);
              {vertikalni smazat}
              line(x,90,x,389);
              line(639-x,90,639-x,389);

              y:=y+1;
              if (i div 10=0)or(i=90) then x:=x+1
                                      else x:=x+2;
              end;

          end;

{zdegenerovana mrizka}
procedure UVOD_LINE_2(posx,posy,rozmer:word;
                      exe:boolean;brvline,brvback,size:byte;var cnt:boolean);
          var i,x,x1,x2,y,y1,y2:word;
          begin
          {nastaveni car}
          setlinestyle(0,brvline,size);
          {hlavni vnitrni cary}
          y:=posy+4;
          x:=posx+4;
          y1:=y;
          y2:=y;
          x1:=x;
          x2:=x;
          for i:=1 to ((rozmer-6)div 3)*2 do
              begin
              if exe then
              begin
              {viditelne}
              setcolor(brvline);
              line(posx+3,y1,posx+rozmer-4,y1);
              line(x1,posy+3,x1,posy+rozmer-4);
              if i>(rozmer-6)div 3
                 then begin line(posx+3,y2,posx+rozmer-4,y2);
                            line(x2,posy+3,x2,posy+rozmer-4);
                      end;

              if not keypressed then delay(1000 div rozmer){promlka}
                                else if readkey=#27 then
                                        begin
                                        cnt:=false;
                                        break;
                                        end;
              {maze viditelne}
              setcolor(brvback);
              line(posx+3,y1,posx+rozmer-4,y1);
              line(x1,posy+3,x1,posy+rozmer-4);
              if i>(rozmer-6)div 3
                 then begin line(posx+3,y2,posx+rozmer-4,y2);
                            line(x2,posy+3,x2,posy+rozmer-4);
                      end;
              end;
              {iterace}
              y1:=y1+1;
              x1:=x1+1;
              if i>(rozmer-6)div 3
                 then begin y2:=y2+1;  x2:=x2+1 end;
              end;
          if cnt then
          begin
          setcolor(brvline);
          line(posx+3,y1,posx+rozmer-4,y1);
          line(x1,posy+3,x1,posy+rozmer-4);

          line(x2-1,posy+3,x2-1,posy+rozmer-4);
          line(posx+3,y2-1,posx+rozmer-4,y2-1);
          end;
          end;

{rozhazuje cisla}
procedure UVOD_NUMBER(brv:byte;var cnt:boolean);
          var ra,i:byte;
              sl:char;
              x,y:word;
              exe:boolean;
          begin
          settextjustify(centertext,centertext);
          settextstyle(0,0,3);
          setcolor(brv);

          {rozhaze jej}
          for i:=81 downto 1 do
          begin
          exe:=false;
          randomize;
          if not keypressed then delay(i div 2){promlka}
                                else if readkey=#27 then
                                        begin
                                        cnt:=false;
                                        break;
                                        end;
          repeat
          ra:=random(9)+1;
          sl:=chr(random(9)+65);

          if ITEM[sl,ra,1]<>0 then
             begin
             x:=(ord(sl)-65)*(32+round( (ord(sl)-65)/9) )+187;
             y:=(ra-1)*(32+round(ra/9))+107;

             outtextxy(x,y,chr(ITEM[sl,ra,1]+48));
             ITEM[sl,ra,1]:=0;
             exe:=true;
             end;
          until exe;
          end;
          end;

{desticky zaplni obrazovku}
procedure UVOD_TABLETS(brv:byte);
          var x,y:word;
              i:byte;
              cnt:boolean;
          begin
          cnt:=true;
          setfillstyle(1,brv);
          randomize;
          for y:=0 to 47 do
           begin
          for i:=1 to 14 do
              begin
              x:=random(64)*10;
              bar(x,y*10,x+9,(y*10)+9);
              delay(1);
              end;
          for i:=1 to 20 do
              begin
              x:=random(64)*10;
              bar(x,y*10,x+9,(y*10)+9);
              end;
          bar(0,y*10,getmaxx,(y*10)+9);
           end;
          end;
{pripravi nadpis----------------------------------------------------------}
procedure PREPARE_TITLE(brv,brvback:byte;posx,posy:word);

          var i,l:byte;
              y,x,size,yp,yd,xd,sized,ydp,yk,xk,sizek,ykp:word;
              P,Pd,Pk:pointer;
          begin
          for i:=0 to 25 do
              begin
              y:=0;
              yd:=0;
              yk:=0;
              {urceni pomocnych x-ovych souradnic S}
              case i of
              0..3 :   x:=i*(sq-lne);
              4 :      x:=i*(sq-lne);
              5..7 :   x:=5*(sq-lne);
              8..9 :   x:=(12-i)*(sq-lne);
              10:      x:=2*(sq-lne);
              11..13:  x:=1*(sq-lne);
              14:      x:=2*(sq-lne);
              15..18:  x:=(i-12)*(sq-lne);
              else x:=6*(sq-lne);
              end;
              {D}
              case i of
              0..1 :  xd:=8*(sq-lne)+i*(sq-lne);
              2 :     xd:=8*(sq-lne)+i*(sq-lne);
              3..4 :  xd:=8*(sq-lne)+3*(sq-lne);
              5..8 :  xd:=8*(sq-lne)+4*(sq-lne);
              9..10 : xd:=8*(sq-lne)+3*(sq-lne);
              11 :    xd:=8*(sq-lne)+2*(sq-lne);
              12..13 :xd:=8*(sq-lne)+(13-i)*(sq-lne);
              14..25 :xd:=8*(sq-lne);
              end;
              {K}
              case i of
              0..11 : xk:=15*(sq-lne);
              12 :    xk:=16*(sq-lne);
              13..15 :xk:=17*(sq-lne);
              16..17 :xk:=18*(sq-lne);
              18..19 :xk:=19*(sq-lne);
              20..21 :xk:=20*(sq-lne);
              22 :    xk:=18*(sq-lne);
              23 :    xk:=19*(sq-lne);
              24..25 :xk:=20*(sq-lne);
              end;

              {najeti po bilem pozadi do nadpisove zony}
              while yk<posy do
                    begin
                    {S}
                    if i<=18 then
                    begin
                    Size:=ImageSize(posx+x,yk,posx+x+sq-1,yk+sq-1);
                    GetMem(P, Size);   { Alokov n¡ pamˆti v haldˆ }
                    GetImage(posx+x,yk,posx+x+sq-1,yk+sq-1, P^);
                    end;
                    {D}
                    Sized:=ImageSize(posx+xd,yk,posx+xd+sq-1,yk+sq-1);
                    GetMem(Pd, Sized);   { Alokov n¡ pamˆti v haldˆ }
                    GetImage(posx+xd,yk,posx+xd+sq-1,yk+sq-1, Pd^);
                    {K}
                    Sizek:=ImageSize(posx+xk,yk,posx+xk+sq-1,yk+sq-1);
                    GetMem(Pk, Sizek);   { Alokov n¡ pamˆti v haldˆ }
                    GetImage(posx+xk,yk,posx+xk+sq-1,yk+sq-1, Pk^);

                    {ctverecek}
                    {S}
                    if i<=18 then
                    begin
                    setfillstyle(1,brv);
                    bar(posx+x,yk,
                        posx+x+sq-1,yk+sq-1);
                    setfillstyle(1,brvback);
                    bar(posx+x+lne,yk+lne,
                        posx+x+sq-lne-1,yk+sq-lne-1);
                    end;
                    {D}
                    setfillstyle(1,brv);
                    bar(posx+xd,yk,
                        posx+xd+sq-1,yk+sq-1);
                    setfillstyle(1,brvback);
                    bar(posx+xd+lne,yk+lne,
                        posx+xd+sq-lne-1,yk+sq-lne-1);
                    {K}
                    setfillstyle(1,brv);
                    bar(posx+xk,yk,
                        posx+xk+sq-1,yk+sq-1);
                    setfillstyle(1,brvback);
                    bar(posx+xk+lne,yk+lne,
                        posx+xk+sq-lne-1,yk+sq-lne-1);

                    delay(2);{promlka}
                    {znovu obnoveni mista}
                    {S}
                    if i<=18 then
                    begin
                    putimage(posx+x,yk, P^, NormalPut);
                    freemem(P,size);
                    end;
                    {D}
                    putimage(posx+xd,yk, Pd^, NormalPut);
                    freemem(Pd,sized);
                    {K}
                    putimage(posx+xk,yk, Pk^, NormalPut);
                    freemem(Pk,sizek);

                    yk:=yk+sq;
                    end;

              {urceni pomocnych y-ovych souradnic S}
              case i of
              0..3 :   y:=11;
              4 :      y:=10;
              5..7 :   y:=14-i;
              8..9 :   y:=6;
              10:      y:=5;
              11..13:  y:=15-i;
              14:      y:=1;
              15..18:  y:=0;
              else y:=0;
              end;
              {D}
              case i of
              0..1 :  yd:=11;
              2 :     yd:=10;
              3..4 :  yd:=12-i;
              5..8 :  yd:=12-i;
              9..10 : yd:=12-i;
              11 :    yd:=1;
              12..13 :yd:=0;
              14..25 :yd:=i-14;
              end;
              {K}
              case i of
              0..11 : yk:=11-i;
              12 :    yk:=5;
              13..15 :yk:=19-i;
              16..17 :yk:=i-10;
              18..19 :yk:=i-10;
              20..21 :yk:=i-10;
              22 :    yk:=3;
              23 :    yk:=2;
              24..25 :yk:=25-i;
              end;
                  yp:=y;
                  ydp:=yd;
                  ykp:=yk;
                  y:=y+1;
                  yd:=yd+1;
                  yk:=yk+1;
                  repeat
                  {iterace}
                  if y>0 then y:=y-1;
                  if yd>0 then yd:=yd-1;
                  if yk>0 then yk:=yk-1;

                  {S}
                  Size:=ImageSize(posx+x,posy+((yp-y)*(sq-lne)),
                                  posx+x+sq-1,posy+((yp-y)*(sq-lne))+sq-1);
                  GetMem(P, Size);   { Alokov n¡ pamˆti v haldˆ }
                  GetImage(posx+x,posy+((yp-y)*(sq-lne)),
                           posx+x+sq-1,posy+((yp-y)*(sq-lne))+sq-1, P^);
                  {D}
                  Sized:=ImageSize(posx+xd,posy+((ydp-yd)*(sq-lne)),
                                  posx+xd+sq-1,posy+((ydp-yd)*(sq-lne))+sq-1);
                  GetMem(Pd, Sized);   { Alokov n¡ pamˆti v haldˆ }
                  GetImage(posx+xd,posy+((ydp-yd)*(sq-lne)),
                           posx+xd+sq-1,posy+((ydp-yd)*(sq-lne))+sq-1, Pd^);
                  {K}
                  Sizek:=ImageSize(posx+xk,posy+((ykp-yk)*(sq-lne)),
                                  posx+xk+sq-1,posy+((ykp-yk)*(sq-lne))+sq-1);
                  GetMem(Pk, Sizek);   { Alokov n¡ pamˆti v haldˆ }
                  GetImage(posx+xk,posy+((ykp-yk)*(sq-lne)),
                           posx+xk+sq-1,posy+((ykp-yk)*(sq-lne))+sq-1, Pk^);


                  {ctverecek}
                  {S}
                  setfillstyle(1,brv);
                  bar(posx+x,posy+((yp-y)*(sq-lne)),
                      posx+x+sq-1,posy+((yp-y)*(sq-lne))+sq-1);
                  setfillstyle(1,brvback);
                  bar(posx+x+lne,posy+((yp-y)*(sq-lne))+lne,
                      posx+x+sq-lne-1,posy+((yp-y)*(sq-lne))+sq-lne-1);
                  {D}
                  setfillstyle(1,brv);
                  bar(posx+xd,posy+((ydp-yd)*(sq-lne)),
                      posx+xd+sq-1,posy+((ydp-yd)*(sq-lne))+sq-1);
                  setfillstyle(1,brvback);
                  bar(posx+xd+lne,posy+((ydp-yd)*(sq-lne))+lne,
                      posx+xd+sq-lne-1,posy+((ydp-yd)*(sq-lne))+sq-lne-1);
                  {K}
                  setfillstyle(1,brv);
                  bar(posx+xk,posy+((ykp-yk)*(sq-lne)),
                      posx+xk+sq-1,posy+((ykp-yk)*(sq-lne))+sq-1);
                  setfillstyle(1,brvback);
                  bar(posx+xk+lne,posy+((ykp-yk)*(sq-lne))+lne,
                      posx+xk+sq-lne-1,posy+((ykp-yk)*(sq-lne))+sq-lne-1);


                  delay(1);{promlka}
                  {znovu obnoveni mista}
                  {S}
                  putimage(posx+x,posy+((yp-y)*(sq-lne)), P^, NormalPut);
                  freemem(P,size);
                  {D}
                  putimage(posx+xd,posy+((ydp-yd)*(sq-lne)), Pd^, NormalPut);
                  freemem(Pd,sized);
                  {K}
                  putimage(posx+xk,posy+((ykp-yk)*(sq-lne)), Pk^, NormalPut);
                  freemem(Pk,sizek);

                  until (y=0)and(yd=0)and(yk=0);

              {ctverecek natrvalo}
              {S}
                  setfillstyle(1,brv);
                  bar(posx+x,posy+((yp-y)*(sq-lne)),
                      posx+x+sq-1,posy+((yp-y)*(sq-lne))+sq-1);
                  setfillstyle(1,brvback);
                  bar(posx+x+lne,posy+((yp-y)*(sq-lne))+lne,
                      posx+x+sq-lne-1,posy+((yp-y)*(sq-lne))+sq-lne-1);
              {D}
                  setfillstyle(1,brv);
                  bar(posx+xd,posy+((ydp-yd)*(sq-lne)),
                      posx+xd+sq-1,posy+((ydp-yd)*(sq-lne))+sq-1);
                  setfillstyle(1,brvback);
                  bar(posx+xd+lne,posy+((ydp-yd)*(sq-lne))+lne,
                      posx+xd+sq-lne-1,posy+((ydp-yd)*(sq-lne))+sq-lne-1);
              {K}
                  setfillstyle(1,brv);
                  bar(posx+xk,posy+((ykp-yk)*(sq-lne)),
                      posx+xk+sq-1,posy+((ykp-yk)*(sq-lne))+sq-1);
                  setfillstyle(1,brvback);
                  bar(posx+xk+lne,posy+((ykp-yk)*(sq-lne))+lne,
                      posx+xk+sq-lne-1,posy+((ykp-yk)*(sq-lne))+sq-lne-1);
              end;
          end;
{-------------------------------------------------------------------------}
{vytvori kompletni uvodni animaci-----------------------------------------}
procedure UVOD(brvline,brvback:byte);
          const x=5;
          var i:byte;
              pom,px1,py2,px3,py4:word;
              cnt:boolean;

          begin

          cnt:=true;
          {vygeneruje sudoku}
          CREATE_LATTICE(item);

          settextstyle(4,0,1);
          setcolor(brvline);
          outtextxy(0,5,'[ESC]');

          UVOD_LINE_2(170,90,300,true,brvline,brvback,3,cnt);
          if cnt then UVOD_LINE_1(brvline,brvback,cnt);

          {zoomovani---------------------------------}
          setfillstyle(1,brvback);

          pom:=300;
          {druhy,paty,osmy ctverec}
          px1:=169+pom-2;
          {ctvrty,paty,sesty ctverec}
          py2:=89+pom-2;
          {treti,sesty a devaty ctverec}
          px3:=px1+pom-3;
          {sedmy,osmy,devaty ctverec}
          py4:=py2+pom-3;

          if cnt then
          for i:=1 to 40 do
              begin
              if not keypressed then if i<30 then delay(11)
                                             else delay(5){promlka}
                                else if readkey=#27 then
                                        begin
                                        cnt:=false;
                                        break;
                                        end;
              {smazeme stavajici}
              bar(170,90,getmaxx,getmaxy);

              {nakreslime novou mensi}
              pom:=pom-x;
              px1:=px1-x;
              py2:=py2-x;
              px3:=px3-(2*x);
              py4:=py4-(2*x);

              CREATE_LINES_BASE(170,90,pom,false,brvline,brvback,3);{orig}
              CREATE_LINES_BASE(px1,90,pom,false,brvline,brvback,3);{druhy}
              CREATE_LINES_BASE(170,py2,pom,false,brvline,brvback,3);{ctvrty}
              CREATE_LINES_BASE(px1,py2,pom,false,brvline,brvback,3);{paty}
              if i>16 then
                 begin
                 CREATE_LINES_BASE(px3,90,pom,false,brvline,brvback,3);{treti}
                 CREATE_LINES_BASE(170,py4,pom,false,brvline,brvback,3);{sedmy}
                 CREATE_LINES_BASE(px3,py2,pom,false,brvline,brvback,3);{sesty}
                 CREATE_LINES_BASE(px1,py4,pom,false,brvline,brvback,3);{osmy}
                 CREATE_LINES_BASE(px3,py4,pom,false,brvline,brvback,3);{devaty}
                 end;
              end;
          if cnt then UVOD_NUMBER(brvline,cnt);
          {bile pozadi}
          UVOD_TABLETS(brvline);
          end;

{vytvori cely nadpis------------------------------------------------------}
procedure TITLE(brvback:byte);
          const titletext='Gener tor SUDOKU';

          var i:word;
              autortext:string;

{------------------zakodovani autora-------------------------------}
procedure obraceni(var x:string);
 var i,l:integer;
     pom:char;
 begin
 l:=0;
 for i:=1 to (ord(x[0])div 2) do begin pom:=x[ord(x[0])-l];
                                       x[ord(x[0])-l]:=x[i];
                                       x[i]:=pom;
                                       l:=l+1;
                                 end;
 end;
 procedure odcitani(var x:string);
 var i,pom:integer;
 begin
 randomize;
 pom:=ord(x[1]);
 for i:=2 to ord(x[0]) do
     x[i]:=chr(ord(x[i])-pom);

 x:=copy(x,2,ord(x[0])-1);
 end;

procedure oddvojeni(var x:string);
 var i:integer;
 begin
 for i:=1 to (ord(x[0])div 2) do x[i]:=chr(ord(x[i*2-1])+ord(x[i*2]));
 x[0]:=chr(ord(x[0])div 2);
 end;

function GENAUT(x:string):string;
         begin
         odcitani(x);
         obraceni(x);
         oddvojeni(x);
         GENAUT:=x;
         end;
 {--------------------------------------------------------------------------}
          begin
          autortext:='Vytvoril '+genaut(AUTOR);


          settextstyle(0,0,2);
          settextjustify(lefttext,bottomtext);

          PREPARE_TITLE(blue,yellow,
                        (640-(posx+textwidth('GEN')+5))div 2,starty);

          setcolor(lightblue);
          outtextxy(((640-(posx+textwidth('GEN')+5))div 2)+posx+5,
                    starty+posy+2,'GEN');
          {jezdici text------------------------------------------------}
          {nastaveni}
          settextstyle(4,0,0);
          settextjustify(centertext,toptext);
          {---------}
          if titletext>=autortext then i:=(textwidth(titletext)div 2)+1
                                  else i:=(textwidth(autortext)div 2)+1;
          while i<320+50 do
                begin
                setcolor(blue);
                outtextxy(i,starty+5+posy,titletext);
                outtextxy(639-i,starty+5+posy+textheight('Q')+5,autortext);
                delay(5);
                setcolor(brvback);
                outtextxy(i,starty+5+posy,titletext);
                outtextxy(639-i,starty+5+posy+textheight('Q')+5,autortext);

                i:=i+15;

                end;
          i:=i-15;
          while i>320 do
                begin
                setcolor(blue);
                outtextxy(i,starty+5+posy,titletext);
                outtextxy(639-i,starty+5+posy+textheight('Q')+5,autortext);
                delay(5);
                setcolor(brvback);
                outtextxy(i,starty+5+posy,titletext);
                outtextxy(639-i,starty+5+posy+textheight('Q')+5,autortext);

                i:=i-15;

                end;
          setcolor(blue);
          outtextxy(320,starty+5+posy,titletext);
          outtextxy(639-320+(textwidth(autortext) div 2)-1,
                    starty+5+posy+textheight('Q')+4,'''');
          outtextxy(639-320,starty+5+posy+textheight('Q')+5,autortext);
          end;
{-------------------------------------------------------------------------}
begin
{inicializace grafiky}
Gd := Detect;
InitGraph(Gd, Gm,' ');
{je-li chyba v inicializaci grafiky}
if GraphResult <> grOk then
  begin write('Chyba se zavedenim grafickeho rezimu !');
        readln;
        halt(1);
  end;
end.