unit M_ANIM;

interface

procedure UVOD; {vytvari uvodni animaci}
procedure WINDOW(POCITEMS:byte); {vytvari uzivatelske prostredi}
function POSTEXT(TEXT:string;STRED:word):word;
function FINISH:boolean; {konecny dialog}

implementation
uses CRT,GRAPH;

var GD,GM:integer;
{funkce pro vypocet x-ove pozice pro umisteni textu na stred}
function POSTEXT(TEXT:string;STRED:word):word;
         begin
         POSTEXT:=STRED-(textwidth(TEXT)div 2);
         end;
{-------------------------------uvodni sekvence-----------------------}
procedure UVOD;
          const NAZEV='STARSDAT'; {nazev programu}
                AUTOR='by Petr Ospaly'; {autor}
                PRESS='Stisknete ENTER';
          var P:pointer;
              key:char;
              RET:string[10];
              SIZE,SL,SLo,RA,RAd,INH,RADEK,SLOUPEC:word;
          begin
             {vlozi do haldy haldu kachlicek(32)}
             setfillstyle(1,blue);
             setcolor(black);
             for SL:=0 to 32 do
             begin
             bar(0+(SL*8),0,7+(SL*8),9);
             rectangle(0+(SL*8),0,7+(SL*8),9);
             end;
             SIZE:=imagesize(0,0,7+(32*8),9);
             getmem(P,SIZE);
             getimage(0,0,7+(32*8),9,P^);
             {-------------------------}
             {cerna obrazovka}
             cleardevice;
             {----------------------}
             INH:=40; {hodnota o kterou se zpozduje pad}
             SL:=0; {INICIALIZUJE sl tak aby algoritmus fungoval}
             RA:=0;
             setcolor(white);
             settextstyle(0,0,5);
             {pro nadpis}
             RAd:=1;
             SLo:=POSTEXT(NAZEV,320);
             {-----------}
             for RADEK:=1 to 24 do
             begin
             if RADEK>16 then
                begin
                {nazev programu}
                RET:=NAZEV;
                outtextxy(SLo,80,RET[RAd]);
                SLo:=SLo+textwidth(RET[RAd]);
                RAd:=RAd+1;
                {-------------------}
                end;
             if keypressed then if readkey=#27 then INH:=0;
                delay(INH);
                putimage(SL,470-RA,P^,normalput);
                putimage(640-(33*8)-SL,RA,P^,normalput);
                SL:=SL+8;
                RA:=RA+10;
             end;
             {uvolni z haldy kachlicku}
             freemem(P,SIZE);
             {--------------------}
             {NADPISY}
             delay(50);
             settextstyle(1,0,4);
             setcolor(white);
             outtextxy(POSTEXT(AUTOR,320),textwidth(NAZEV)+90,AUTOR);
             {------------------------------------------}
             {RAMECEK}
             delay(100);
             setcolor(white);

             SL:=POSTEXT(PRESS,320)-10;
             RA:=240-(textheight(PRESS)div 2)-10;
             SLOUPEC:=POSTEXT(PRESS,320)+10+textwidth(PRESS);
             RADEK:=240+(textheight(PRESS)div 2)+10;

             rectangle(SL,RA,SLOUPEC,RADEK);
             setfillstyle(1,black);
             {----------------------------------------------}
             {blikani textu}
             repeat
             SIZE:=0;
             bar(SL+1,RA+1,SLOUPEC-1,RADEK-1);
             while not keypressed and (SIZE<>20) do
                   begin
                   SIZE:=SIZE+1;
                   delay(10);
                   end;
             if SIZE<>20 then key:=readkey
                else
                begin
                outtextxy(POSTEXT(PRESS,320),240-(textheight(PRESS)div 2),PRESS);
                SIZE:=0;
                while not keypressed and (SIZE<>30) do
                      begin
                      SIZE:=SIZE+1;
                      delay(10);
                      end;
                if SIZE<>30 then key:=readkey;
                end;
             until key=#13;
             {------------------------------------------}
          end;
{-------------------zakladni vykresleni oken----------------------------}
procedure WINDOW(POCITEMS:byte);
          var i:byte;
              pom:word;
          begin
          setcolor(white);
          {pozadi}
          setfillstyle(1,blue);
          bar(0,0,639,479);
          {-------------------}
          {hlavni ramec}
          setlinestyle(0,$C3,3);
          rectangle(0,0,639,479);
          {--------------------}
          {vykresluje polozky hlavniho menu}
          for i:=0 to POCITEMS-1 do
          begin
          pom:=20*i;
          {cerny ramecek}
          setfillstyle(1,black);
          bar(10,( 10+pom+i*5 )
              ,( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+10 )
              ,( 30+pom+i*5 ));
          end;

          {vykresli spodni caru}
          setlinestyle(0,$C3,3);
          line(0,( 30+pom+i*5+10 )
               ,( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )
               ,( 30+pom+i*5+10 ));
          {vykresli bocni caru}
          line(( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )
               ,0,( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )
               ,479);
          {-----------------------------------------}
          end;
{-----------------------------------------------------------------}
{-----------------------konec programu----------------------------}
function FINISH:boolean;
         const m='Opravdu chcete ukoncit program ?';
         var key:char;
         begin

         settextstyle(1,0,0);
         setfillstyle(1,black);
         setlinestyle(0,white,1);

         bar(POSTEXT(m,320)-5,240-textheight('Q')-2-5,
             320+(320-POSTEXT(m,320))+5,240+2+textheight('Q')+5);

         rectangle(POSTEXT(m,320)-6,240-textheight('Q')-2-6,
                   320+(320-POSTEXT(m,320))+6,240+2+textheight('Q')+6);

         setcolor(red);
         outtextxy(POSTEXT(m,320),240-textheight('Q')-2,m);

         setcolor(yellow);
         outtextxy(POSTEXT('A/N',320),240+2,'A/N');

         {ceka na dezvu}
         key:=readkey;
         while (UPCASE(key)<>'A')and(UPCASE(key)<>'N') do key:=readkey;
         if UPCASE(key)='A' then FINISH:=true
                            else FINISH:=false;
         end;

{-----------------------------------------------------------------}
begin
{inicializace grafiky}
Gd := Detect;
InitGraph(Gd, Gm,' ');
{je-li chyba v inicializaci grafiky animace(UVOD) se neprovede}
if GraphResult <> grOk then
  begin write('Chyba se zavedenim grafickeho rezimu !');
        readln;
        halt(1);
  end;
end.