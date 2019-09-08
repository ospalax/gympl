unit UI;

interface
uses M_UK;

const POCITEMS=7; {udava pocet polozek hlavniho menu}
      POCATRIB=7; {udava pocet polozek vedlejsiho menu}

{pole ktere slouzi k ulozeni polozek menu}
type T_POSL_POL=array[0..POCITEMS-1] of string[20];
     {vedlejsi menu}
     T_NABIDKA=array[0..POCATRIB] of string[20];

var CHOICE:byte; {volba menu}
    REC:T_PERSON;
    PP:T_POSL_POL;{pole nabidky}

procedure HL_MENU(POCITEMS:byte;PP:T_POSL_POL); {vypisuje polozky menu}
procedure INI_MENU; {slouzi pouze k vnitrni inicializaci menu polozek}
procedure USE_MENU(POCITEMS:byte;var CHOICE:byte); {slouzi k zakladni komunikaci s programem}
procedure OUT_MENU;{vykresluje vedlejsi menu}
procedure USE_OUT_MENU(var REC:T_PERSON
                       ;var exec:boolean;MODE:boolean); {interakce s menu}
procedure CLEAN_UI; {cisti uzivatelske rozhrani}

implementation
uses CRT,GRAPH,M_ANIM;

const mokz=461;
var NAB:T_NABIDKA;
    P_NAROD:T_NAROD;
    P_PRACE_M:T_PRACE_M;
    P_PRACE_Z:T_PRACE_Z;
    P_SEX:T_SEX;
{---------------inicializuje menu polozek a podslozky----------------------}
procedure INI_MENU;
          begin
          PP[0]:='Pridat celebritu';
          PP[1]:='Najit celebritu';
          PP[2]:='Upravit celebritu';
          PP[3]:='Smazat celebritu';
          PP[4]:='Seznam celebrit';
          PP[5]:='Autor programu';
          PP[POCITEMS-1]:='Ukoncit program';

          {polozky osoby}
          NAB[0]:='Jmeno a prijmeni';
          NAB[1]:='Pohlavi';
          NAB[2]:='Rok narozeni';
          NAB[3]:='Misto narozeni';
          NAB[4]:='Narodnost';
          NAB[5]:='Povolani';
          NAB[POCATRIB-1]:='OK';
          NAB[POCATRIB]:='ZRUSIT';

          {pohlavi}
          P_SEX[1]:='Muzske';
          P_SEX[2]:='Zenske';

          {povolani muz}
          P_PRACE_M[1]:='Badatel';
          P_PRACE_M[2]:='Dobrodruh';
          P_PRACE_M[3]:='Herec';
          P_PRACE_M[4]:='Panovnik';
          P_PRACE_M[5]:='Podnikatel';
          P_PRACE_M[6]:='Politik';
          P_PRACE_M[7]:='Programator';
          P_PRACE_M[8]:='Reziser';
          P_PRACE_M[9]:='Spisovatel';
          P_PRACE_M[10]:='Sportovec';
          P_PRACE_M[11]:='Umelec';
          P_PRACE_M[12]:='Vedec';
          P_PRACE_M[13]:='Vojevudce';
          P_PRACE_M[14]:='Zpevak';
          P_PRACE_M[15]:='';

          {povolani zena}
          P_PRACE_Z[1]:='Badatelka';
          P_PRACE_Z[2]:='Dobrodruzka';
          P_PRACE_Z[3]:='Herecka';
          P_PRACE_Z[4]:='Panovnice';
          P_PRACE_Z[5]:='Podnikatelka';
          P_PRACE_Z[6]:='Politicka';
          P_PRACE_Z[7]:='Programatorka';
          P_PRACE_Z[8]:='Reziserka';
          P_PRACE_Z[9]:='Spisovatelka';
          P_PRACE_Z[10]:='Sportovkyne';
          P_PRACE_Z[11]:='Umelkyne';
          P_PRACE_Z[12]:='Zpevacka';
          P_PRACE_Z[13]:='';
          {narodnost}
          P_NAROD[1]:='Americka';
          P_NAROD[2]:='Anglicka';
          P_NAROD[3]:='Argentinska';
          P_NAROD[4]:='Australska';
          P_NAROD[5]:='Belgicka';
          P_NAROD[6]:='Brazilska';
          P_NAROD[7]:='Ceska';
          P_NAROD[8]:='Chilska';
          P_NAROD[9]:='Cinska';
          P_NAROD[10]:='Egyptska';
          P_NAROD[11]:='Finska';
          P_NAROD[12]:='Francouzska';
          P_NAROD[13]:='Holandska';
          P_NAROD[14]:='Indicka';
          P_NAROD[15]:='Iracka';
          P_NAROD[16]:='Italska';
          P_NAROD[17]:='Japonska';
          P_NAROD[18]:='Jihoafricka';
          P_NAROD[19]:='Kanadska';
          P_NAROD[20]:='Kolumbijska';
          P_NAROD[21]:='Korejska';
          P_NAROD[22]:='Madarska';
          P_NAROD[23]:='Malajska';
          P_NAROD[24]:='Mexicka';
          P_NAROD[25]:='Nemecka';
          P_NAROD[26]:='Norska';
          P_NAROD[27]:='Polska';
          P_NAROD[28]:='Portugalska';
          P_NAROD[29]:='Rakouska';
          P_NAROD[30]:='Recka';
          P_NAROD[31]:='Rumunska';
          P_NAROD[32]:='Ruska';
          P_NAROD[33]:='Slovenska';
          P_NAROD[34]:='Spanelska';
          P_NAROD[35]:='Svedska';
          P_NAROD[36]:='Thajska';
          P_NAROD[37]:='Turecka';
          P_NAROD[38]:='Ukrajinska';
          P_NAROD[39]:='Venezuelska';
          P_NAROD[40]:='Vietnamska';
          P_NAROD[41]:='Zidovska';
          P_NAROD[42]:='';


          end;
{---------------------procedura pro vypis polozek menu-------}
procedure HL_MENU(POCITEMS:byte; PP:T_POSL_POL);
          var i:byte;
              pom:word;
          begin
          setcolor(white);
          settextstyle(4,0,1);
          for i:=0 to POCITEMS-1 do
          begin
          pom:=20*i;
          {text polozky}
          setcolor(white);
          outtextxy(15,( ((20-textheight('W'))div 2)+10+pom+(i*5) )
                    ,PP[I])
          end;
          end;
{--------------------------------------------------------------------}
{----------------procedura umoznujici interaktivni praci s menu-----}
procedure USE_MENU(POCITEMS:byte;var CHOICE:byte);
          var key:char;
          begin
          setcolor(red);
          settextstyle(4,0,1);
          outtextxy(15
                    ,( ((20-textheight('W'))div 2)+10+(20*CHOICE)+CHOICE*5 )
                    ,PP[CHOICE]);
          repeat
          key:=readkey;
          case key of
          chr(80):if CHOICE=POCITEMS-1 then CHOICE:=0
                                       else CHOICE:=CHOICE+1;
          chr(72):if CHOICE=0 then CHOICE:=POCITEMS-1
                              else CHOICE:=CHOICE-1;
          else continue;
          end;

          HL_MENU(POCITEMS,PP);

          setcolor(red);
          settextstyle(4,0,1);
          outtextxy(15,( ((20-textheight('W'))div 2)+10+(20*CHOICE)+CHOICE*5 )
                    ,PP[CHOICE]);
          until key=#13;
          end;
{-------------------slouzi k vytvoreni vedlejsiho menu-----}
procedure OUT_MENU;
          var STRED:word; {verikalni stred menu}
              HOR:word; {vrchni hrana menu}
              i:byte;
          begin

          STRED:=( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )div 2;
          HOR:=30+((POCITEMS-1)*20)+(POCITEMS-1)*5+20;

          settextstyle(4,0,10);
          {vykresli ramecky a polozky}
          for i:=0 to POCATRIB-2 do
              begin
              setcolor(yellow);
              outtextxy(POSTEXT(NAB[i],STRED),HOR+i*40+i*5,NAB[i]);
              setcolor(white);
              setlinestyle(0,1,1);
              rectangle(5,(HOR+i*40+i*5)+textheight(NAB[i])
                        ,185,(HOR+i*40+i*5)+textheight(NAB[i])+20);
              end;
          {spodni ramecky}
          setfillstyle(1,black);
          bar(POSTEXT(NAB[POCATRIB-1],STRED)-70,mokz-5
              ,POSTEXT(NAB[POCATRIB-1],STRED)+textwidth(NAB[POCATRIB-1])-50
              ,mokz+5+textheight(NAB[POCATRIB-1]));

          bar(((2*STRED)-(POSTEXT(NAB[POCATRIB-1],STRED)-60))
              -textwidth(NAB[POCATRIB])-10,mokz-5
              ,((2*STRED)-(POSTEXT(NAB[POCATRIB-1],STRED)-60))+10
              ,mokz+5+textheight(NAB[POCATRIB]));
          {ok}
          outtextxy( POSTEXT(NAB[POCATRIB-1],STRED)-60,mokz,NAB[POCATRIB-1]);
          {zrusit}
          outtextxy( ((2*STRED)-(POSTEXT(NAB[POCATRIB-1],STRED)-60))
                     -textwidth(NAB[POCATRIB]),mokz,NAB[POCATRIB]);
          end;
{---------------slouzi k ovladani vedlejsiho menu----------------}
procedure USE_OUT_MENU(var REC:T_PERSON;var exec:boolean;MODE:boolean);
          var key,pomkey:char;
              STRED:word; {verikalni stred menu}
              HOR:word; {vrchni hrana menu}
              POS:word;
              POL:array[0..POCATRIB-2] of string[20];
              VOLBA,i,l,j,pom:byte; {udava polozku}
          begin
          i:=1;
          l:=1;

          STRED:=( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )div 2;
          HOR:=30+((POCITEMS-1)*20)+(POCITEMS-1)*5+20;
          VOLBA:=0;
          {napise uz vyplneny nebo prazdny zaznam}
          with REC do
          begin
          POL[0]:=JMENO;
          POL[1]:=SEX;
          POL[2]:=ROK_NAR;
          POL[3]:=MISTO_NAR;
          POL[4]:=NAROD;
          POL[5]:=PRACE;
          end;

          if POL[1]<>'' then
             begin
             if POL[1]=P_SEX[1] then j:=1
                                else if POL[1]=P_SEX[2] then j:=2
             end
                        else j:=1;

          setcolor(white);
          settextstyle(4,0,1);

          for POS:=1 to POCATRIB-2 do
              begin
              outtextxy(15,(HOR+POS*40+POS*5)+textheight(NAB[POS])+6
                        ,POL[POS]);
              end;
          {--------------------------------------}

          repeat

          if (VOLBA<POCATRIB-1)then
             begin
             {na zaklade aktualni pozice vykresluje bile ramecky}
             setfillstyle(1,white);
             bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                 ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
             setcolor(black);
             outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6
                      ,POL[VOLBA]);
             end
             else
             begin
             if VOLBA=POCATRIB-1 then
                begin
                {rozsviti OK}
                setcolor(red);
                outtextxy( POSTEXT(NAB[POCATRIB-1],STRED)-60,mokz
                           ,NAB[POCATRIB-1]);
                end
                                 else
                begin
                {rozsviti "zrusit"}
                setcolor(red);
                outtextxy( ((2*STRED)-(POSTEXT(NAB[POCATRIB-1],STRED)-60))
                           -textwidth(NAB[POCATRIB]),mokz,NAB[POCATRIB]);
                end;
             end;
          key:=readkey;
          case key of
          {predchozi vyssi polozku deaktivuje}
          chr(72) : if VOLBA<>0 then
                    begin
                    if VOLBA<POCATRIB-1 then
                    begin
                    setfillstyle(1,blue);
                    bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                    ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                    setcolor(white);
                    outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6
                              ,POL[VOLBA]);
                    end
                       else
                       begin
                       if VOLBA=POCATRIB-1 then
                       begin
                       setcolor(white);
                       outtextxy( POSTEXT(NAB[POCATRIB-1],STRED)-60
                                 ,mokz,NAB[POCATRIB-1]);
                       end
                          else begin
                          setcolor(white);
                               outtextxy( ((2*STRED)-(POSTEXT(NAB[POCATRIB-1],STRED)-60))
                               -textwidth(NAB[POCATRIB]),mokz,NAB[POCATRIB]);
                               VOLBA:=VOLBA-1;
                               end;
                       end;
                    VOLBA:=VOLBA-1;
                    end;
          {predchozi nizsi polozku deaktivuje}
          chr(80) : if (VOLBA<>POCATRIB-1)and(VOLBA<>POCATRIB) then
                    begin
                    setfillstyle(1,blue);
                    bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                    ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                    setcolor(white);
                    outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6
                              ,POL[VOLBA]);
                    VOLBA:=VOLBA+1;
                    end;
          chr(75) : if VOLBA=POCATRIB then
                    begin
                    setcolor(white);
                    outtextxy( ((2*STRED)-(POSTEXT(NAB[POCATRIB-1],STRED)-60))
                              -textwidth(NAB[POCATRIB]),mokz,NAB[POCATRIB]);
                    VOLBA:=VOLBA-1;
                    end;
          chr(77) : if VOLBA=POCATRIB-1 then
                    begin
                    setcolor(white);
                    outtextxy( POSTEXT(NAB[POCATRIB-1],STRED)-60,mokz
                              ,NAB[POCATRIB-1]);
                    VOLBA:=VOLBA+1;
                    end;
          {pokud neni OK,zrusit ale je stisknuto enter zadavame do polozky}
          else if (key=chr(13))
                  and(VOLBA<POCATRIB-3)and(VOLBA<>1) then
           begin
           {smaze obsah polozky}
           setfillstyle(1,white);
           bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
               ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
           POL[VOLBA]:='';
           {vypise kurzor}
           POS:=15;
           setcolor(black);
           settextstyle(4,0,1);
           outtextxy(POS,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6
                     ,'_');
           {zde piseme..}
           repeat
           key:=readkey;
           until (ord(key)>=33)and(ord(key)<=125)or(key=chr(13))
                 or(key=chr(8))or(key=' ');
           {--}
           {dokud neni stisknuto enter a text nepresahuje 20 znaku}
           while (key<>chr(13))and(ord(POL[VOLBA][0])<20) do
           begin
           {je-li stisknuto backspace}
           if (key=chr(8)) then begin if (ord(POL[VOLBA][0])>0)
           then begin
                {pozice kurzoru se snizi}
                POS:=POS-textwidth(POL[VOLBA][ord(POL[VOLBA][0])]);
                {smaze znak}
                delete(POL[VOLBA],ord(POL[VOLBA][0]),1);
                {vykresli zkraceny text}
                setfillstyle(1,white);
                bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                   ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                setcolor(black);
                outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6
                          ,POL[VOLBA]+'_');
                end
                                end
           else begin
           {smaze kurzor}
           setcolor(white);
           outtextxy(POS,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6
                     ,'_');
           {napise dalsi znak s kurzorem}
           setcolor(black);
           outtextxy(POS,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6
                     ,key+'_');
           {posune pozici}
           POS:=POS+textwidth(key);
           {..do aktivni polozky}
           if key<>chr(8) then POL[VOLBA]:=POL[VOLBA]+key;
                end;
           repeat
           key:=readkey;
           until (ord(key)>=33)and(ord(key)<=125)or(key=chr(13))
                 or(key=chr(8))or(key=' ');

           {kontrola spravneho udaje roku}
           if VOLBA=2 then
              if key=chr(13) then
                 begin
                 pom:=1;
                 while (pom<=length(POL[VOLBA]))and((
                       (ord(POL[VOLBA][pom])>=48)
                       and(ord(POL[VOLBA][pom])<=57))
                       or(POL[VOLBA][1]='-'))
                       do pom:=pom+1;
                 if not (pom>length(POL[VOLBA])) then
                    begin
                    setfillstyle(1,white);
                    bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                        ,184
                        ,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                    setcolor(red);
                    settextstyle(4,0,1);
                    outtextxy(15,
                              (HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6,
                              'NEPLATNY ZAPIS');
                    POL[VOLBA]:='';
                    POS:=15;
                    while readkey<>chr(13) do;
                    end;
                 end;
           {kontrola spravneho udaje mista}
           if VOLBA=3 then
              if key=chr(13) then
                 begin
                 pom:=1;
                 while (pom<=length(POL[VOLBA]))
                       and
                       (( ( ord(upcase(POL[VOLBA][pom])) >=65)
                       and(ord(upcase(POL[VOLBA][pom])) <=90))
                       or(POL[VOLBA][pom]=' '))
                       do pom:=pom+1;
                 if not (pom>length(POL[VOLBA])) then
                    begin
                    setfillstyle(1,white);
                    bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                        ,184
                        ,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                    setcolor(red);
                    settextstyle(4,0,1);
                    outtextxy(15,
                              (HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6,
                              'NEPLATNY ZAPIS');
                    POL[VOLBA]:='';
                    POS:=15;
                    while readkey<>chr(13) do;
                    end;
                 end;
            {----------------zde konci rok---------------------}
           end;
           end
           {-------------zde konci psani------------------------------}
           else if (key=chr(13))and(VOLBA=1) then
                begin
                repeat
                {bily ramecek a pohlavi}
                setfillstyle(1,white);
                bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                    ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                setcolor(black);
                settextstyle(4,0,1);
                outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6,
                          P_SEX[j]);
                {zmena pohlavi}
                key:=readkey;
                if key=chr(80) then j:=j+1
                               else if key=chr(72) then j:=j-1;
                if j=0 then j:=2
                   else if j=3 then j:=1;
                {dokud neni enter}
                until key=#13;
                POL[VOLBA]:=P_SEX[j];
                end
           else if (key=chr(13))and(VOLBA=POCATRIB-3) then
                begin
                repeat
                {bily ramecek a narodnost}
                setfillstyle(1,white);
                bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                    ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                setcolor(black);
                settextstyle(4,0,1);
                outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6,
                          P_NAROD[l]);
                {zmena narodnosti}
                key:=readkey;
                if key=chr(80) then l:=l+1
                               else if key=chr(72) then l:=l-1;
                if l=0 then l:=POC_NAROD
                   else if l=POC_NAROD+1 then l:=1;
                {dokud neni enter}
                until key=#13;
                POL[VOLBA]:=P_NAROD[l];
                end
           {je-li vyplnovano povolani}
           else if (key=chr(13))and(VOLBA=POCATRIB-2) then
                begin
                if j=1 then
                   begin
                repeat
                {muzska povolani}
                {bily ramecek a povolani}
                setfillstyle(1,white);
                bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                    ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                setcolor(black);
                settextstyle(4,0,1);
                outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6,
                          P_PRACE_M[i]);
                {zmena povolani}
                key:=readkey;
                if key=chr(80) then i:=i+1
                               else if key=chr(72) then i:=i-1;
                if i=0 then i:=POC_PRACE_M
                   else if i=POC_PRACE_M+1 then i:=1;
                {dokud neni enter}
                until key=#13;
                POL[VOLBA]:=P_PRACE_M[i];
                   end
                   else
                begin
                repeat
                {zenska povolani}
                {bily ramecek a povolani}
                setfillstyle(1,white);
                bar(6,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+1
                    ,184,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+20-1);
                setcolor(black);
                settextstyle(4,0,1);
                outtextxy(15,(HOR+VOLBA*40+VOLBA*5)+textheight(NAB[VOLBA])+6,
                          P_PRACE_Z[i]);
                {zmena povolani}
                key:=readkey;
                if key=chr(80) then i:=i+1
                               else if key=chr(72) then i:=i-1;
                if i=0 then i:=POC_PRACE_Z
                   else if i=POC_PRACE_Z+1 then i:=1;
                {dokud neni enter}
                until key=#13;
                POL[VOLBA]:=P_PRACE_Z[i];
                end
                end;

           {--}
           {priradi retezec do spravne polozky}
           with REC do
           case VOLBA of
           0 : JMENO:=POL[VOLBA];
           1 : SEX:=POL[VOLBA];
           2 : ROK_NAR:=POL[VOLBA];
           3 : MISTO_NAR:=POL[VOLBA];
           4 : NAROD:=POL[VOLBA];
           5 : PRACE:=POL[VOLBA];
           end;

          end;
          until (key=#13)and((VOLBA=POCATRIB)or(VOLBA=POCATRIB-1));
          CLEAN_UI;
          if VOLBA=POCATRIB then exec:=false
                            else exec:=true;
          if MODE and(exec)and(REC.JMENO='') then begin
                               setcolor(red);
                               outtextxy(POSTEXT('BEZE JMENA NELZE',STRED)
                                         ,hor+10,'BEZE JMENA NELZE');
                               outtextxy(POSTEXT('ULOZIT CELEBRITU',STRED)
                                         ,hor+15+textheight('W')
                                         ,'ULOZIT CELEBRITU');
                               setcolor(white);
                               outtextxy(POSTEXT('-STISKNI ESC-',STRED)
                                         ,hor+30+2*textheight('W')
                                         ,'-STISKNI ESC-');
                               while readkey<>#27 do;
                               exec:=false;
                               end;
          end;


procedure CLEAN_UI;
          begin
          setfillstyle(1,blue);
          bar(2,30+((POCITEMS-1)*20)+(POCITEMS-1)*5+12
              ,188,477);
          end;
{-------------------------------------------------------------------}

begin
{provede startovni nastaveni obrazovky}
M_ANIM.UVOD;
INI_MENU;
CHOICE:=0;
          M_ANIM.WINDOW(POCITEMS);
          HL_MENU(POCITEMS,PP);
          setcolor(red);
          settextstyle(4,0,1);
          outtextxy(15
          ,( ((20-textheight('W'))div 2)+10+(20*CHOICE)+CHOICE*5 )
          ,PP[CHOICE]);
end.