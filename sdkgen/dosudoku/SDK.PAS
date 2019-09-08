program sdkfill;
uses crt,graph,sdkdecl,sdkgraph,sdkmain,sdkui,sdkdat;

const ods=3; {odstupy}

var ITEMS:T_M_MENU_ITEMS;
    brvback,VOLFUNC,ra,SUMCHOICE,JAK:byte;
    QT,chg,ESC,block:boolean;
    sl:char;
    P:pointer;
    sz:word;

begin
(*
{pozadi}
brvback:=black;
setfillstyle(1,brvback);
bar(0,0,getmaxx,getmaxy);

{hlavni inicializace}
brvback:=white;
UVOD(brvback,black);*)
brvback:=white;
setfillstyle(1,brvback);
bar(0,0,getmaxx,getmaxy);

delay(100);

TITLE(brvback);
delay(20);
SH_M_MENU(ITEMS,1,brvback);
VOLBA:=1;
{-------------------}
repeat
MOVE_M_MENU(ITEMS,brvback,VOLBA);

case VOLBA of
{generovat nove}{nacist sudoku}
1       : begin NAME_CHOICE(ITEMS,VOLBA,brvback);
                {inicializace}
                block:=false;

                SUMCHOICE:=7;

                SEZNAM[1]:='Presun na zad n¡';
                SEZNAM[2]:='Ulozit zad n¡';
                SEZNAM[3]:='Nac¡st zad n¡';
                SEZNAM[4]:='Kontrola reseni';
                SEZNAM[5]:='Ukazat reseni';
                SEZNAM[6]:='Generovat dalsi';
                SEZNAM[SUMCHOICE]:='N vrat do menu';

                USE_LUSTITEL(tab,tab+textheight('Q')+5,
                             SUMCHOICE,SEZNAM,VOLFUNC,JAK,true);
                {podle toho zda generujeme poprve nebo nacitame}
                if VOLBA=1 then
                   begin
                   PLWA_SHOW(P,sz,false);
                   GEN_ZADANI(ITEM2,ITEM,JAK);
                   PLWA_HIDD(P,sz);
                   end
                   else ;

                INI_LATTICE_PRIMITIVE(POMITEM,brvrestext,brvresback);
                chg:=true;

                {vypsani zadani do zadani;)}
                TRANS_ITEM_TO_POM(POMITEM,ITEM2);
                WRITE_LATTICE_NUMBERS(POMITEM,ITEM,ITEM2,
                                      15,
                                      tab+textheight('Q')+5,size,1);

                {urceni pocatecni pozice ctverecku}
                ra:=1;
                sl:='A';
                {while POMITEM[sl,ra,1]<>0 do
                      if sl<'I' then sl:=succ(sl)
                                else begin
                                     sl:='A';
                                     ra:=ra+1;
                                     end;
                {-------------------------------------}


                USE_LUSTITEL(tab,tab+textheight('Q')+5,
                             SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                {prace v rozhrani}
                QT:=false;
                while not QT do
                case VOLFUNC of
                {presun na zadani}

                1 : begin
                    if not block then
                    begin
                {deaktivace reseni}
                    CREATE_LINES_WHOLE(639-sizer(size)-14,tab+textheight('Q')+5,
                                       639-sizer(size)-14,tab+textheight('Q')+5,
                                       size,lightgray,false);
                    {aktivace zadani}
                    CREATE_LINES_WHOLE(15,tab+textheight('Q')+5,
                                       15,tab+textheight('Q')+5,
                                       size,black,false);


                    {OBJEVENI KURZORU}
                    if POMITEM[sl,ra,2]<>brvzadtext
                           then
                           SH_SQUARE(15,tab+textheight('Q')+5,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     POMITEM[sl,ra,2],yellow,size)
                           else
                           SH_SQUARE(15,tab+textheight('Q')+5,sl,
                                     chr(POMITEM[sl,ra,1]+48),ra,
                                     brvzadback,yellow,size);

                    {objeveni ESC}
                    settextstyle(4,0,0);
                    setcolor(black);
                    settextjustify(lefttext,toptext);
                    outtextxy(15,tab+textheight('Q')+5+sizer(size)+5,
                              '[ESC] pro presun do menu');
                    {ovladani mrize----------------------------------------}
                    USE_LATTICE_PRIMITIVE(POMITEM,sl,ra,size,
                                          15,tab+textheight('Q')+5,chg);
                    {------------------------------------------------------}
                    {zmizeni ESC}
                    settextstyle(4,0,0);
                    settextjustify(lefttext,toptext);
                    setcolor(brvback);
                    outtextxy(15,tab+textheight('Q')+5+sizer(size)+5,
                              '[ESC] pro presun do menu');
                    {zmizeni KURZORU}
                    SH_SQUARE(15,tab+textheight('Q')+5,sl,
                              chr(POMITEM[sl,ra,1]+48),ra,
                              POMITEM[sl,ra,2],POMITEM[sl,ra,3],size);

                    {deaktivace zadani}
                    CREATE_LINES_WHOLE(15,tab+textheight('Q')+5,
                                       15,tab+textheight('Q')+5,
                                       size,lightgray,false);

                    {aktivace reseni}
                    CREATE_LINES_WHOLE(639-sizer(size)-14,tab+textheight('Q')+5,
                                       639-sizer(size)-14,tab+textheight('Q')+5,
                                       size,black,false);
                    end
                    else COO_WINDOW(annnic2,brvback,false);

                    USE_LUSTITEL(tab,tab+textheight('Q')+5,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                {ulozit zadani}
                2 : begin
                    if not block then
                    begin
                    end;
                    {item2,item}

                    USE_LUSTITEL(tab,tab+textheight('Q')+5,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                {nacist zadani}
                3 : begin
                    if not block then
                    begin
                    end;
                    USE_LUSTITEL(tab,tab+textheight('Q')+5,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                {kontrola reseni}
                4 : begin
                    if not block then
                    begin
                    TRANS_POM_TO_ITEM(POMITEM,SECITEM);
                    if FULL_LATTICE(SECITEM) then
                       begin
                       if CHECK_LATTICE(SECITEM)
                          then
                          COO_WINDOW(anncon,brvback,false)
                          else COO_WINDOW(annerr,brvback,false);
                       end
                       else COO_WINDOW(annemp,brvback,false);
                    end
                    else COO_WINDOW(annnic,brvback,false);

                    USE_LUSTITEL(tab,tab+textheight('Q')+5,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                {ukazat reseni}
                5 : begin
                    if not block then
                       begin
                       block:=true;

                       WRITE_LATTICE_NUMBERS(POMITEM,ITEM,ITEM2,
                                             639-sizer(size)-14,
                                             tab+textheight('Q')+5,size,2);
                       end;
                    USE_LUSTITEL(tab,tab+textheight('Q')+5,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                {generovat dalsi}
                6 : begin
                    block:=false;

                    {smazani reseni}
                    INI_LATTICE_PRIMITIVE(POMITEM,brvrestext,brvresback);
                    TRANS_POM_TO_ITEM(POMITEM,SECITEM);
                    WRITE_LATTICE_NUMBERS(POMITEM,SECITEM,SECITEM,
                                          639-sizer(size)-14,
                                          tab+textheight('Q')+5,size,1);

                    JAK:=CHS_OBT;
                    PLWA_SHOW(P,sz,false);
                    GEN_ZADANI(ITEM2,ITEM,JAK);
                    PLWA_HIDD(P,sz);

                    {vypsani zadani do zadani;)}
                    TRANS_ITEM_TO_POM(POMITEM,ITEM2);
                    WRITE_LATTICE_NUMBERS(POMITEM,ITEM,ITEM2,
                                          15,
                                          tab+textheight('Q')+5,size,1);
                    USE_LUSTITEL(tab,tab+textheight('Q')+5,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                7 : begin

                    QUIT(QT,VOLBA); {ukoncovaci dialog}
                    if QT then
                       begin
                       {pozadi}
                       setfillstyle(1,brvback);
                       bar(0,tab,getmaxx,getmaxy);

                       SH_M_MENU(ITEMS,VOLBA,brvback);
                       end
                       else
                       USE_LUSTITEL(tab,tab+textheight('Q')+5,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                end;
          QT:=false;

          end;
{vyresit zadani------------------------------------------------------------}
2       : begin NAME_CHOICE(ITEMS,VOLBA,brvback);

                OKENKO(15+sizer(size)-1+5,tab+textheight('Q')+5,
                       639-sizer(size)-14-5,
                       tab+textheight('Q')+5+ods+2+4*textheight('Q')+4*5+ods,
                       brvback);

                {text v okne-----------------------------------------------}
                settextstyle(4,0,0);
                setcolor(black);
                settextjustify(centertext,toptext);
                outtextxy(320-ods,tab+ods+2+textheight('Q')+5,
                          'Pro maly pocet zadanych');
                outtextxy(320-ods,tab+ods+2+2*textheight('Q')+2*5,
                          'cisel nebo jejich');
                outtextxy(320-ods,tab+ods+2+3*textheight('Q')+3*5,
                          'nevhodne rozlozeni muze');
                outtextxy(320-ods,tab+5+4*textheight('Q')+4*5,
                          'vzniknout vice reseni.');
                {-----------------------------------------------------------}
                {inicializace}
                ra:=1;
                sl:='A';
                INI_LATTICE_PRIMITIVE(POMITEM,brvzadback,brvzadtext);
                chg:=true;
                SUMCHOICE:=6;

                SEZNAM[1]:='Presun na zad n¡';
                SEZNAM[2]:='Vyresit zad n¡';
                SEZNAM[3]:='Ulozit zad n¡';
                SEZNAM[4]:='Nac¡st zad n¡';
                SEZNAM[5]:='Smazat zad n¡';
                SEZNAM[SUMCHOICE]:='N vrat do menu';

                USE_LUSTITEL(tab,tab+textheight('Q')+5+
                             ods+2+4*textheight('Q')+4*5+ods+1,
                             SUMCHOICE,SEZNAM,VOLFUNC,JAK,true);
                {------------}


                {prace v rozhrani}
                while not QT do
                case VOLFUNC of
                {presun na zadani}
                1 : begin
                    {deaktivace reseni}
                    CREATE_LINES_WHOLE(639-sizer(size)-14,tab+textheight('Q')+5,
                                       639-sizer(size)-14,tab+textheight('Q')+5,
                                       size,lightgray,false);
                    {aktivace zadani}
                    CREATE_LINES_WHOLE(15,tab+textheight('Q')+5,
                                       15,tab+textheight('Q')+5,
                                       size,black,false);


                    {OBJEVENI KURZORU}
                    SH_SQUARE(15,tab+textheight('Q')+5,sl,
                              chr(POMITEM[sl,ra,1]+48),ra,
                              POMITEM[sl,ra,2],yellow,size);

                    {objeveni ESC}
                    settextstyle(4,0,0);
                    setcolor(black);
                    settextjustify(lefttext,toptext);
                    outtextxy(15,tab+textheight('Q')+5+sizer(size)+5,
                              '[ESC] pro presun do menu');
                    {ovladani mrize----------------------------------------}
                    USE_LATTICE_PRIMITIVE(POMITEM,sl,ra,size,
                                          15,tab+textheight('Q')+5,chg);
                    {------------------------------------------------------}
                    {zmizeni ESC}
                    settextstyle(4,0,0);
                    settextjustify(lefttext,toptext);
                    setcolor(brvback);
                    outtextxy(15,tab+textheight('Q')+5+sizer(size)+5,
                              '[ESC] pro presun do menu');
                    {zmizeni KURZORU}
                    SH_SQUARE(15,tab+textheight('Q')+5,sl,
                              chr(POMITEM[sl,ra,1]+48),ra,
                              POMITEM[sl,ra,2],POMITEM[sl,ra,3],size);

                    {deaktivace zadani}
                    CREATE_LINES_WHOLE(15,tab+textheight('Q')+5,
                                       15,tab+textheight('Q')+5,
                                       size,lightgray,false);

                    {aktivace reseni}
                    CREATE_LINES_WHOLE(639-sizer(size)-14,tab+textheight('Q')+5,
                                       639-sizer(size)-14,tab+textheight('Q')+5,
                                       size,black,false);

                    USE_LUSTITEL(tab,tab+textheight('Q')+5+
                                 ods+2+4*textheight('Q')+4*5+ods+1,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                {vyresit zadani}
                2 : begin
                    {prevede do resitelne mrizky uzivatelovo zadani}
                    if chg then begin TRANS_POM_TO_ITEM(POMITEM,ITEM);
                                      TRANS_POM_TO_ITEM(POMITEM,ITEM2);
                                end;

                    {zkontroluje zda ma zadani reseni}
                    if CHECK_LATTICE(ITEM) then
                       begin

                       {byla-li provedena zmena v zadani projde se}
                       if chg then begin
                                   PLWA_SHOW(P,sz,true);
                                   ESC:=true;
                                   CREATE_LATTICE_ONE(ITEM,VICERESENI,ESC);
                                   PLWA_HIDD(P,sz);
                                   end;

                       COPYITEM(SECITEM,ITEM);

                       if not ESC then
                        begin
                       if VICERESENI then
                          begin
                          {kdyz je vice reseni nahodne je zobrazuje}
                          CREATE_LATTICE(SECITEM);
                          WRITE_LATTICE_NUMBERS(POMITEM,SECITEM,ITEM2,
                                             639-sizer(size)-14,
                                             tab+textheight('Q')+5,size,3);
                          if chg then COO_WINDOW(attmuch,brvback,false);
                          end
                          else begin
                               if CHECK_LATTICE(ITEM) then
                                  begin
                                  if chg then
                                     begin
                                     WRITE_LATTICE_NUMBERS(POMITEM,ITEM,ITEM2,
                                                           639-sizer(size)-14,
                                                           tab+textheight('Q')+5,size,3);
                                     COO_WINDOW(attless,brvback,false);
                                     end;
                                  end
                                  else
                                  begin
                                  {prevede do resitelne mrizky uzivatelovo zadani}
                                  COPYITEM(ITEM,ITEM2);
                                  WRITE_LATTICE_NUMBERS(POMITEM,ITEM2,ITEM2,
                                             639-sizer(size)-14,
                                             tab+textheight('Q')+5,size,1);
                                  COO_WINDOW(attnon,brvback,false);
                                  end;
                               end
                        end
                        else begin
                             CREATE_LATTICE(SECITEM);
                             WRITE_LATTICE_NUMBERS(POMITEM,SECITEM,ITEM2,
                                             639-sizer(size)-14,
                                             tab+textheight('Q')+5,size,3);
                             if chg then COO_WINDOW(attesc,brvback,false);
                             end;

                       if ESC then chg:=true
                              else chg:=false;
                       end
                       else
                       COO_WINDOW(attcoll,brvback,false);

                    USE_LUSTITEL(tab,tab+textheight('Q')+5+
                                 ods+2+4*textheight('Q')+4*5+ods+1,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                3 : begin
                {ulozit zadani}
                    USE_LUSTITEL(tab,tab+textheight('Q')+5+
                                 ods+2+4*textheight('Q')+4*5+ods+1,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                4 : begin
                {nacist zadani}
                    USE_LUSTITEL(tab,tab+textheight('Q')+5+
                                 ods+2+4*textheight('Q')+4*5+ods+1,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                5 : begin
                {smazani zadani}
                    INI_LATTICE_PRIMITIVE(POMITEM,brvzadback,brvzadtext);
                    TRANS_POM_TO_ITEM(POMITEM,ITEM);
                    WRITE_LATTICE_NUMBERS(POMITEM,ITEM,ITEM,
                                          15,
                                          tab+textheight('Q')+5,size,1);
                    chg:=true;
                    USE_LUSTITEL(tab,tab+textheight('Q')+5+
                                 ods+2+4*textheight('Q')+4*5+ods+1,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                6 : begin

                    QUIT(QT,VOLBA); {ukoncovaci dialog}
                    if QT then
                       begin
                       {pozadi}
                       setfillstyle(1,brvback);
                       bar(0,tab,getmaxx,getmaxy);

                       SH_M_MENU(ITEMS,VOLBA,brvback);
                       end
                       else
                       USE_LUSTITEL(tab,tab+textheight('Q')+5+
                                 ods+2+4*textheight('Q')+4*5+ods+1,
                                 SUMCHOICE,SEZNAM,VOLFUNC,JAK,false);
                    end;
                end;
          QT:=false;

          end;

{co je to sudoku}
3       : begin NAME_CHOICE(ITEMS,VOLBA,brvback);
                COO_WINDOW(inf,brvback,true);
                SH_M_MENU(ITEMS,VOLBA,brvback);
          end;
{o programu}
4       : begin NAME_CHOICE(ITEMS,VOLBA,brvback);
                COO_WINDOW('readme.txt',brvback,true);
                SH_M_MENU(ITEMS,VOLBA,brvback);
          end;
{konec}
POCITEM : begin NAME_CHOICE(ITEMS,VOLBA,brvback);
                QUIT(QT,VOLBA); {ukoncovaci dialog}
                if not QT then SH_M_MENU(ITEMS,VOLBA,brvback);
          end;
end;

until QT;


closegraph;
end.