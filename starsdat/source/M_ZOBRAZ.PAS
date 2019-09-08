unit M_ZOBRAZ;

interface
uses M_UK,UI;

procedure SH_AUTOR; {animace credits}
procedure CLEAN_OKNO; {cisti okno}
procedure SH_INF(REC:T_PERSON); {ukaze celebritu}
procedure WRITE_LINES; {pise ramecek}
procedure WRITE_SEZNAM; {pise hlavicku seznamu}
procedure LINE_SEZNAM; {pise stredovou caru seznamu}
procedure WRITE_JMENA_SEZNAM(UK:T_ukos); {vypisuje jmena do seznamu}
procedure FIX_SEZNAM(CO:byte;P:T_ukos;PAGE:word); {zvyraznovac v seznamu}
procedure GUM_SEZNAM(CO:byte;P:T_ukos;PAGE:word); {odstranuje zvyraznovac}
procedure INFO_SEZNAM(PAGE,PAGES,POS,POSES:string); {info seznamu}
procedure STATIK_INFO_SEZNAM; {popisky k info}
procedure UCHOVAT_OKNO(var P:pointer); {do pameti ulozi okno}
procedure CALL_OKNO(var P:pointer); {vlozi okno}
function POSTEXT(TEXT:string;STRED:word):word;

implementation
uses GRAPH,CRT;
const VERSTRED=414;
      BOK=210;
      MEZ=3;
      HORSTRED=240;

function POSTEXT(TEXT:string;STRED:word):word;
         begin
         POSTEXT:=STRED-(textwidth(TEXT)div 2);
         end;

{----------------animace credits--------------------}
procedure SH_AUTOR;
          var STRED,i,pomi:longint;
              l:byte;
              znak:char;
              STARSDAT:string[8];
              str:string[8];
          begin
          {inicializace}
          STRED:=240; {horizontalni stred}
          STARSDAT:='STARSDAT'; {text}
          str:=''; {string ktery pomaha pro urcovani spravne y-ove pozice}

          {vykresli padajici STARSDAT}
          for l:=1 to length(STARSDAT) do
              begin
              settextstyle(0,1,4);
              znak:=STARSDAT[l];
              i:=16;
              pomi:=i;
              while i<=((POSTEXT(STARSDAT,STRED)+textwidth(STARSDAT)
                        -textwidth(znak))-textwidth(str))do
                    begin
                    setcolor(blue);
                    outtextxy(300,pomi,znak);
                    pomi:=i;
                    setcolor(white);
                    outtextxy(300,i,znak);
                    i:=i+textwidth(znak);
                    delay(10);
                    end;
              str:=str+znak;
              end;
          {cara}
          settextstyle(4,0,1);
          setlinestyle(0,0,1);
          line(POSTEXT('PETR OSPALY',420),STRED
                 ,POSTEXT('PETR OSPALY',420)+textwidth('PETR OSPALY')
                 ,STRED);

          {text}
          outtextxy(POSTEXT('CREATED BY',420),STRED-textheight('W')-5,
                    'CREATED BY');
          outtextxy(POSTEXT('PETR OSPALY',420),STRED+5,'PETR OSPALY');
          {ctverecky}
          setfillstyle(1,white);
          for i:=0 to 7 do
              begin
              delay(50);
              bar3d( (400)+i*15
                  ,(STRED+40)-i*i
                  ,((400)+i*15)+i+3
                  ,((STRED+40)-i*i)+i+3,i,topon);
              end;
          delay(100);
          setcolor(yellow);
          outtextxy(200,10,'[ESC]');
          {ceka na ESC}
          while readkey<>#27 do;
          end;
{---------------------------------------------------}
{--------------------cisti okno---------------------}
procedure CLEAN_OKNO;
          begin
          setfillstyle(1,blue);
          bar(192,2,636,477);
          end;
{---------------------------------------------------}
{-------------------vykresli cary-------------------}
procedure WRITE_LINES;
          const mez=30;
                ok=2;
                later=5;
          type T_POLE=array[1..6] of string[20];
          var i:byte;
              HOR,SIZE1,SIZE2,SIZE3,SIZE4:word;
              PL:T_POLE;
              h,l:integer;
              a,b,c,d:pointer;
          begin
          PL[1]:='Jmeno a prijmeni';
          PL[2]:='Pohlavi';
          PL[3]:='Rok narozeni';
          PL[4]:='Misto narozeni';
          PL[5]:='Narodnost';
          PL[6]:='Povolani';

          setcolor(white);
          setlinestyle(0,0,1);
          settextstyle(4,0,1);
          setfillstyle(1,black);

          h:=80;
          l:=40;
          {prvni ukladani car}

          while h>0 do
          begin
          h:=h-(ok*2);
          l:=l-ok;

          {------------mazani horni a dolni cara---------------}
          SIZE1:=
          imagesize(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2) -h,
               (20*textwidth('W')+(mez div 2)+10)+VERSTRED,
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2) -h);
          getmem(a,SIZE1);
          getimage(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2) -h,
               (20*textwidth('W')+(mez div 2)+10)+VERSTRED,
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2) -h,
               a^);

          SIZE2:=
          imagesize(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
               (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2) +h,
               (20*textwidth('W')+(mez div 2)+10)+VERSTRED,
               (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2) +h);
          getmem(b,SIZE2);
          getimage(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
               (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2) +h,
               (20*textwidth('W')+(mez div 2)+10)+VERSTRED,
               (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2) +h,
               b^);
          {---------------------------------------------}
          {------------mazani bocni cary-----------------------}
          SIZE3:=
          imagesize(VERSTRED-(20*textwidth('W')+10) -l,
               HORSTRED-((6*textheight('Q')+7*mez)div 2),
               VERSTRED-(20*textwidth('W')+10) -l,
               ((6*textheight('Q')+7*mez)div 2)+HORSTRED);
          getmem(c,SIZE3);
          getimage(VERSTRED-(20*textwidth('W')+10) -l,
               HORSTRED-((6*textheight('Q')+7*mez)div 2),
               VERSTRED-(20*textwidth('W')+10) -l,
               ((6*textheight('Q')+7*mez)div 2)+HORSTRED,
               c^);

          SIZE4:=
          imagesize((20*textwidth('W')+10)+VERSTRED +l,
               HORSTRED-((6*textheight('Q')+7*mez)div 2),
               (20*textwidth('W')+10)+VERSTRED +l,
               ((6*textheight('Q')+7*mez)div 2)+HORSTRED);
          getmem(d,SIZE4);
          getimage((20*textwidth('W')+10)+VERSTRED +l,
               HORSTRED-((6*textheight('Q')+7*mez)div 2),
               (20*textwidth('W')+10)+VERSTRED +l,
               ((6*textheight('Q')+7*mez)div 2)+HORSTRED,
               d^);

          {------------horni a dolni cara---------------}
          line(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2) -h,
               (20*textwidth('W')+(mez div 2)+10)+VERSTRED,
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2) -h);
          line(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
               (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2) +h,
               (20*textwidth('W')+(mez div 2)+10)+VERSTRED,
               (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2) +h);
          {---------------------------------------------}
          {------------bocni cary-----------------------}
          line(VERSTRED-(20*textwidth('W')+10) -l,
               HORSTRED-((6*textheight('Q')+7*mez)div 2),
               VERSTRED-(20*textwidth('W')+10) -l,
               ((6*textheight('Q')+7*mez)div 2)+HORSTRED);
          line((20*textwidth('W')+10)+VERSTRED +l,
               HORSTRED-((6*textheight('Q')+7*mez)div 2),
               (20*textwidth('W')+10)+VERSTRED +l,
               ((6*textheight('Q')+7*mez)div 2)+HORSTRED);


          {-------------cerny obdelnik--------------}
          bar(VERSTRED-(20*textwidth('W')+8)+h-1,
              HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2)+2+h-1,
              (20*textwidth('W')+8)+VERSTRED-h+1,
              (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2)-2-h+1);
          {-----------------------------------------}

          delay(later);
          {skutecne mazani}
          if h>0 then
             begin
          putimage(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2) -h,
               a^,normalput);
          freemem(a,SIZE1);
          putimage(VERSTRED-(20*textwidth('W')+(mez div 2)+10),
                   (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2) +h,
                   b^,normalput);
          freemem(b,SIZE2);
          putimage(VERSTRED-(20*textwidth('W')+10) -l,
                   HORSTRED-((6*textheight('Q')+7*mez)div 2),
                   c^,normalput);
          freemem(c,SIZE3);
          putimage((20*textwidth('W')+10)+VERSTRED +l,
                   HORSTRED-((6*textheight('Q')+7*mez)div 2),
                   d^,normalput);
          freemem(d,SIZE4);
             end
          end;
          {-------------------------------------------------------------------}


          setlinestyle(0,0,1);

          {-------------------stredni cara---------------}
          line(VERSTRED,
               HORSTRED-(((6*textheight('Q')+7*mez)div 2))+(mez div 2),
               VERSTRED,
               (((6*textheight('Q')+7*mez)div 2)+HORSTRED)-(mez div 2));
          {----------------------------------------------}
          {-------------------mezicary-------------------}
          HOR:=HORSTRED-((6*textheight('Q')+7*mez)div 2)+(mez div 2);
          for i:=1 to 5 do
              begin
              line(VERSTRED,
                   HOR+(i*(mez+textheight('Q'))),
                   (20*textwidth('W')+10)+VERSTRED,
                   HOR+(i*(mez+textheight('Q'))));
              end;
          {----------------------------------------------}
          {---------------polozky------------------------}
          setcolor(yellow);
          for i:=0 to 5 do
              begin
              outtextxy(VERSTRED-(20*textwidth('W')+5),
                        (HOR+(mez div 2))+(i*((mez)+textheight('Q'))),
                        PL[i+1]);
              end;
          {----------------------------------------------}
          end;
{---------------------------------------------------}

{-----------------zobrazuje celebritu---------------}
procedure SH_INF(REC:T_PERSON);
          const mez=30;
          type T_POLE=array[1..6] of string[20];
          var i:byte;
              HOR:word;
              PL:T_POLE;
          begin
          PL[1]:=REC.JMENO;
          PL[2]:=REC.SEX;
          PL[3]:=REC.ROK_NAR;
          PL[4]:=REC.MISTO_NAR;
          PL[5]:=REC.NAROD;
          PL[6]:=REC.PRACE;

          setcolor(white);
          settextstyle(4,0,1);

          HOR:=HORSTRED-((6*textheight('Q')+7*mez)div 2)+(mez div 2);

          {---------------polozky------------------------}
          for i:=0 to 5 do
              begin
              outtextxy(VERSTRED+5,
                        (HOR+(mez div 2))+(i*((mez)+textheight('Q'))),
                        PL[i+1]);
              end;
          {----------------------------------------------}

          settextstyle(0,0,2);
          setfillstyle(1,black);
          {cerny ramecek}
          bar(POSTEXT(REC.JMENO,VERSTRED)-5,
              HOR-(textheight('Q')+20)-3,
              VERSTRED+(VERSTRED-POSTEXT(REC.JMENO,VERSTRED)),
              HOR-(textheight('Q')+20)+textheight('Q')+2);

          {nadpis}
          outtextxy(POSTEXT(REC.JMENO,VERSTRED),
                    HOR-(textheight('Q')+20),
                    REC.JMENO);
          end;
{---------------------------------------------------}
{-----------------pise zahlavi seznamu-----------------}
procedure WRITE_SEZNAM;
          var i:byte;
          begin
          {nastavi pismo}
          setcolor(white);
          settextstyle(1,0,0);
          {--------------}
          {cerny ramecek}
          setfillstyle(1,black);
          bar(VERSTRED-BOK,5,VERSTRED+BOK,5+textheight('Q')+2*MEZ);
          {-------------}
          {cary}
          setlinestyle(0,0,1);
          {horni}
          line(VERSTRED-BOK-1,4,VERSTRED+BOK+1,4);
          {dolni}
          line(VERSTRED-BOK-1,(5+textheight('Q')+2*MEZ)+1,
               VERSTRED+BOK+1,(5+textheight('Q')+2*MEZ)+1);
          {bocni}
          line(VERSTRED-BOK-1,4,VERSTRED-BOK-1,475);
          line(VERSTRED+BOK+1,4,VERSTRED+BOK+1,475);
          {---------}
          {text zahlavi}
          outtextxy( POSTEXT('Jmeno a prijmeni',VERSTRED-(BOK div 2)),
                     5+MEZ,'Jmeno a prijmeni');
          outtextxy( POSTEXT('Povolani',VERSTRED+(BOK div 2)),
                     5+MEZ,'Povolani');
          {-------------------}
          end;
{------------------------------------------------------}
{---------------------pise caru seznamu----------------}
procedure LINE_SEZNAM;
          begin
          {stredova cara}
          setlinestyle(0,0,1);
          setcolor(white);
          line(VERSTRED,5,VERSTRED,475);
          end;
{------------------------------------------------------}
procedure WRITE_JMENA_SEZNAM(UK:T_ukos);
          var i:byte;
              P:T_ukos;
          begin
          {prvni jmeno}
          i:=1;
          P:=UK;
          settextstyle(1,0,0);
          setcolor(white);

          {jmeno a prijmeni}
          outtextxy( VERSTRED-BOK+2,
                     9+MEZ*(i+1)+i*textheight('Q'),P^.os.JMENO);
          {povolani}
          outtextxy( VERSTRED+3,
                     9+MEZ*(i+1)+i*textheight('Q'),P^.os.PRACE);
          i:=i+1;
          P:=P^.tam;
          while P<>UK do
          begin
          {vpisuje jmena}
          {jmeno a prijmeni}
          outtextxy( VERSTRED-BOK+2,
                     9+MEZ*(i+1)+i*textheight('Q'),P^.os.JMENO);
          {povolani}
          outtextxy( VERSTRED+3,
                     9+MEZ*(i+1)+i*textheight('Q'),P^.os.PRACE);
          i:=i+1;
          {posune se v poli}
          P:=P^.tam;
          end;
          end;
{-----------------------------------------------------------}
{-------------------zvyraznuje polozku----------------------}
procedure FIX_SEZNAM(CO:byte;P:T_ukos;PAGE:word);
          begin
          settextstyle(1,0,0);
          setfillstyle(1,white);

          CO:=CO-((PAGE-1)*41);
          {bily ramecek}
          bar(VERSTRED-BOK,
              8+MEZ*(CO+1)+CO*textheight('Q'),
              VERSTRED+BOK,
              9+MEZ*(CO+1)+(CO+1)*textheight('Q'));
          {--------------}
          {text polozky}
          {jmeno a prijmeni}
          setcolor(black);
          outtextxy( VERSTRED-BOK+2,
                     9+MEZ*(CO+1)+CO*textheight('Q'),P^.os.JMENO);
          {povolani}
          outtextxy( VERSTRED+3,
                     9+MEZ*(CO+1)+CO*textheight('Q'),P^.os.PRACE);
          end;
{-----------------------------------------------------------}
{-----------------maze zvyraznovac--------------------------}
procedure GUM_SEZNAM(CO:byte;P:T_ukos;PAGE:word);
          begin
          settextstyle(1,0,0);
          setfillstyle(1,blue);

          CO:=CO-((PAGE-1)*41);
          {bily ramecek}
          bar(VERSTRED-BOK,
              8+MEZ*(CO+1)+CO*textheight('Q'),
              VERSTRED+BOK,
              9+MEZ*(CO+1)+(CO+1)*textheight('Q'));
          {--------------}
          {text polozky}
          {jmeno a prijmeni}
          setcolor(white);
          outtextxy( VERSTRED-BOK+2,
                     9+MEZ*(CO+1)+CO*textheight('Q'),P^.os.JMENO);
          {povolani}
          outtextxy( VERSTRED+3,
                     9+MEZ*(CO+1)+CO*textheight('Q'),P^.os.PRACE);
          end;
{-----------------------------------------------------------}
{------------------pise udaje o ovladani a polozkach seznamu}
procedure INFO_SEZNAM(PAGE,PAGES,POS,POSES:string);
          const HOR=30+((POCITEMS-1)*20)+(POCITEMS-1)*5+20;
          var STRED:word;
              i:byte;
              str:string[20];
          begin
          STRED:=( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )div 2;
          settextstyle(1,0,0);


          {vlozeni zvlastniho znaku}
          for i:=1 to 20 do str[i]:=chr(219);
          str[0]:=chr(20);
          {strana}
          setcolor(blue);
          outtextxy(POSTEXT(str,STRED)
                    ,HOR+15+textheight('Q'),str);

          setcolor(yellow);
          outtextxy(POSTEXT(PAGE,STRED),HOR+15+textheight('Q'),PAGE);

          {pocet stran}
          setcolor(blue);
          outtextxy(POSTEXT(str,STRED)
                    ,HOR+25+3*textheight('Q'),str);

          setcolor(yellow);
          outtextxy(POSTEXT(PAGES,STRED),HOR+25+3*textheight('Q'),PAGES);

          {polozka}
          setcolor(blue);
          outtextxy(POSTEXT(str,STRED)
                    ,HOR+35+5*textheight('Q'),str);

          setcolor(yellow);
          outtextxy(POSTEXT(POS,STRED),HOR+35+5*textheight('Q'),POS);

          {pocet polozek}
          setcolor(blue);
          outtextxy(POSTEXT(str,STRED)
                    ,HOR+45+7*textheight('Q'),str);

          setcolor(yellow);
          outtextxy(POSTEXT(POSES,STRED),HOR+45+7*textheight('Q'),POSES);

          end;
procedure STATIK_INFO_SEZNAM;
          const HOR=30+((POCITEMS-1)*20)+(POCITEMS-1)*5+20;
          var STRED:word;
          begin
          STRED:=( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )div 2;
          CLEAN_UI;
          settextstyle(1,0,0);

          {strana}
          setcolor(white);
          outtextxy(5,HOR+10,'STRANA:');

          {pocet stran}
          setcolor(white);
          outtextxy(5,HOR+20+2*textheight('Q'),'POCET STRAN:');

          {polozka}
          setcolor(white);
          outtextxy(5,HOR+30+4*textheight('Q'),'CISLO POLOZKY:');

          {pocet polozek}
          setcolor(white);
          outtextxy(5,HOR+40+6*textheight('Q'),'POCET POLOZEK:');

          {enter , esc}
          setcolor(yellow);
          outtextxy(POSTEXT('ZOBRAZIT: [ENTER]',STRED)
                    ,HOR+150,'ZOBRAZIT: [ENTER]');

          setcolor(yellow);
          outtextxy(POSTEXT('KONEC: [ESC]',STRED)
                    ,HOR+160,'KONEC: [ESC]');
          end;
{-----------------------------------------------------------}
{--------------ulozeni casti obrazovky----------------------}
procedure UCHOVAT_OKNO(var P:pointer);
          var size:word;
          begin
          settextstyle(1,0,0);

          Size := ImageSize(VERSTRED-(20*textwidth('W')+25)-1
                            ,HORSTRED-((6*textheight('Q')+7*30)div 2)-25,
                            (20*textwidth('W')+25)+VERSTRED+1,
                            ((6*textheight('Q')+7*30)div 2)+HORSTRED+1);
          GetMem(P, Size);   { Alokov n¡ pamˆti v haldˆ }
          GetImage(VERSTRED-(20*textwidth('W')+25)-1
                   ,HORSTRED-((6*textheight('Q')+7*30)div 2)-25,
                   (20*textwidth('W')+25)+VERSTRED+1,
                   ((6*textheight('Q')+7*30)div 2)+HORSTRED+1, P^);
          end;
{-----------------------------------------------------------}
{---------------------------vlozeni okna--------------------}
procedure CALL_OKNO(var P:pointer);
          var size:word;
          begin
          settextstyle(1,0,0);

          Size := ImageSize(VERSTRED-(20*textwidth('W')+25)-1
                            ,HORSTRED-((6*textheight('Q')+7*30)div 2)-25,
                            (20*textwidth('W')+25)+VERSTRED+1,
                            ((6*textheight('Q')+7*30)div 2)+HORSTRED+1);
          putimage(VERSTRED-(20*textwidth('W')+25)-1,
                   HORSTRED-((6*textheight('Q')+7*30)div 2)-25,P^,normalput);
          freemem(P,size);
          end;
{-----------------------------------------------------------}
begin
end.