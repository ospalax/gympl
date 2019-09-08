program STARSDAT;
uses CRT,GRAPH,UI,M_FILE,M_ZOBRAZ,M_UK,M_ANIM;

var VOLBA,STRED,HOR,vlp:byte;
    F:S_DATA;
    exec,vys,control:boolean;
    NAB:T_NABIDKA;
    pos,poc,filepoc,PAGE,PAGES:word;
    pomrec:T_PERSON;
    key:char;
    P:pointer;

begin

repeat
control:=false;

USE_MENU(POCITEMS,CHOICE);
setcolor(white);
settextstyle(4,0,1);
outtextxy(15,( ((20-textheight('W'))div 2)+10+(20*CHOICE)+CHOICE*5 )
         ,PP[CHOICE]);
case CHOICE of
0 : begin
    CLEAN_UI;
    {inicializace polozek nove osoby}
          with  REC do
          begin
          JMENO:='';
          SEX:='';
          ROK_NAR:='';
          MISTO_NAR:='';
          NAROD:='';
          PRACE:='';
          end;
    {prida novou osobnost}
    CLEAN_OKNO;
    HL_MENU(POCITEMS,PP);
    OUT_MENU;
    USE_OUT_MENU(REC,exec,true);

    settextstyle(4,0,1);
    if exec then begin ADD_FILE(F,JMFILE,REC,exec);
                 if exec then
                    begin
                    {napise uspesne ulozeni}
                    setcolor(white);
                    outtextxy(POSTEXT('CELEBRITA BYLA USPESNE ULOZENA',414),
                              240-(textheight('N')div 2),
                              'CELEBRITA BYLA USPESNE ULOZENA')
                    end
                    else begin
                         {napise neuspesne ulozeni}
                         setcolor(red);
                         outtextxy(
                          POSTEXT('CELEBRITA TOHOTO JMENA UZ EXISTUJE',414),
                          240-(textheight('N')div 2),
                          'CELEBRITA TOHOTO JMENA UZ EXISTUJE')
                         end

                 end;

    CLEAN_UI;
    {nulovani polozek nove osoby}
          with  REC do
          begin
          JMENO:='';
          SEX:='';
          ROK_NAR:='';
          MISTO_NAR:='';
          NAROD:='';
          PRACE:='';
          end;
    end;
1 : begin
    CLEAN_UI;
    {nulovani polozek osoby}
          with  REC do
          begin
          JMENO:='';
          SEX:='';
          ROK_NAR:='';
          MISTO_NAR:='';
          NAROD:='';
          PRACE:='';
          end;
    {hleda osobnost}
    assign(F,JMFILE);
    {$I-}
    reset(F);
    {$I+}
    if IOresult=0 then
    begin
    {pripravi vyhledavaci menu}
    CLEAN_OKNO;
    OUT_MENU;
    USE_OUT_MENU(REC,exec,false);

    {kontrola zda-li je neco vyplneno}
    if exec then with REC do
                 begin
                 if (JMENO='')and
                    (SEX='')and
                    (ROK_NAR='')and
                    (MISTO_NAR='')and
                    (NAROD='')and
                    (PRACE='') then exec:=false;

                 if not exec then begin
                                  CLEAN_OKNO;
                                  setcolor(red);
                                  settextstyle(4,0,1);
                                  outtextxy(POSTEXT('NELZE VYHLEDAVAT',414),
                                            240-(textheight('N')div 2),
                                            'NELZE VYHLEDAVAT');
                                  end;
                 end;
    {je-li neco vyplneno a neni zrusit pak vyhledava}
    if exec then
    begin
    {---------------------------}
    {vyhledava}
    {prvni typ vyhledavani}
    if REC.JMENO<>'' then
       begin
       SEARCH_ITEM(F,REC,pos,vys);
       if vys then
          begin
          {vypise nalezeneho}
          WRITE_LINES;
          SH_INF(REC);
          end
          else begin
               {nenalezen}
               CLEAN_OKNO;
               setcolor(red);
               settextstyle(4,0,1);
               outtextxy(POSTEXT('ZAZNAM NENALEZEN',414),
                         240-(textheight('N')div 2),
                         'ZAZNAM NENALEZEN');
               end;

       end
       else
       {druhy typ vyhledavani}
       begin
       pos:=0;
       {do filepoc se ulozi pocet zaznamu}
       assign(F,JMFILE);
       reset(F);
       filepoc:=filesize(F);
       close(F);
       {---------------------------------}
       {vytvoreni seznamu ukazatelu}
       OSOBA:=nil;

       {hleda prvni odpovidajici polozku}
       {do pomocneho zaznamu priradime vstupni podminku}
       pomrec:=REC;
       SEARCH_ITEM(F,REC,pos,vys);
             if vys then begin
                         new(OSOBA);
                         OSOBA^.os:=REC;
                         OSOBA^.zpet:=OSOBA;
                         OSOBA^.tam:=OSOBA;
                         poc:=1;
                         end;
       {pokud neni konec projde zbytek}
       if OSOBA<>nil then
         while pos<>filepoc do
               begin
               REC:=pomrec;
               SEARCH_ITEM(F,REC,pos,vys);
               if vys then begin ADD(OSOBA,REC); poc:=poc+1 end;
               end;

       if OSOBA=nil then
                    begin
                    {nenalezen}
                    CLEAN_OKNO;
                    setcolor(red);
                    settextstyle(4,0,1);
                    outtextxy(POSTEXT('NIC NENALEZENO',414),
                              240-(textheight('N')div 2),
                              'NIC NENALEZENO');
                    end
                    else
                    {umoznuje prohledavani seznamu}
                    begin
                    {vypise prvniho nalezeneho ze seznamu}
                    REC:=OSOBA^.os;
                    WRITE_LINES;
                    SH_INF(REC);

                    settextstyle(4,0,1);
                    {napise pocet nalezenych}
                    setcolor(white);

                    STRED:=( 10+textwidth('WWWWWWWWWWWWWWWWWWWW')+20 )div 2;
                    HOR:=30+((POCITEMS-1)*20)+(POCITEMS-1)*5+20;

                    if poc>1 then
                       begin
                       {pise informace o nalezenych}
                       outtextxy(POSTEXT('NALEZENO ZAZNAMU:'
                                         ,STRED)
                                         ,hor+10
                                         ,'NALEZENO ZAZNAMU:');
                       outtextxy(POSTEXT(TOSTR(poc),STRED),
                                 hor+15+textheight('Q'),
                                 TOSTR(poc));
                       setcolor(yellow);
                       outtextxy(POSTEXT('[ENTER]'
                                         ,STRED)
                                         ,hor+30+2*textheight('Q')
                                         ,'[ENTER]');
                       end
                       else
                       outtextxy(POSTEXT('NALEZEN 1 ZAZNAM',STRED)
                                         ,hor+10
                                         ,'NALEZEN 1 ZAZNAM');
                    {--------------------------}

                    {seznam pro vice nez 1}
                    if poc<>1 then
                    begin
                    {napise poradova cisla}
                    setcolor(white);
                    outtextxy(POSTEXT('1'+'/'+TOSTR(poc),414),
                              460,'1'+'/'+TOSTR(poc));

                    {inicializace}
                    key:=readkey;
                    vlp:=1;
                    pomuk:=OSOBA;

                    {prohledavani seznamu}
                    while key<>chr(13) do
                          begin
                          case key of
                          chr(75) : if vlp<>1 then
                                       begin
                                       SH_vlevo(OSOBA,pomuk,REC);
                                       {vypise vybraneho}
                                       CLEAN_OKNO;
                                       WRITE_LINES;
                                       SH_INF(REC);
                                       vlp:=vlp-1;
                                       end;
                          chr(77) :if vlp<>poc then
                                      begin
                                      SH_vpravo(OSOBA,pomuk,REC);
                                      {vypise vybraneho}
                                      CLEAN_OKNO;
                                      WRITE_LINES;
                                      SH_INF(REC);
                                      vlp:=vlp+1;
                                      end;
                          end;
                          {napise poradova cisla}
                          setcolor(white);
                          settextstyle(4,0,1);
                          outtextxy(POSTEXT(TOSTR(vlp)+'/'+TOSTR(poc),414),
                                    460,TOSTR(vlp)+'/'+TOSTR(poc));

                          key:=readkey;
                          end;
                          CLEAN_UI;
                          CLEAN_OKNO;
                          {vypise vybraneho}
                          WRITE_LINES;
                          SH_INF(REC);

                    end;
                    UKLID(OSOBA);
                    end;
        end
    end;

    end
    else begin
         {soubor nenalezen}
         CLEAN_OKNO;
         setcolor(red);
         settextstyle(4,0,1);
         outtextxy(POSTEXT('ZADNY SOUBOR K DISPOZICI',414),
                   240-(textheight('N')div 2),
                   'ZADNY SOUBOR K DISPOZICI');
         end;

    end;
2 : begin
    {uprava zaznamu}

    if (REC.JMENO<>'')then
    begin
    {najdeme cestu k zaznamu}
    SEARCH_ITEM(F,REC,pos,vys);
    pomrec:=REC;

    OUT_MENU;
    USE_OUT_MENU(REC,exec,true);
    CLEAN_UI;

    if exec then
    begin
    {kontrola zda je mozna uprava zaznamu}
    WRITE_HELPLIST_JM(REC.JMENO,JMSZ,pos,vys);

    if (not vys)and(pomrec.JMENO<>REC.JMENO) then
                    begin
                    {napise neuspesne ulozeni}
                    CLEAN_OKNO;
                    setcolor(red);
                    outtextxy(POSTEXT('CELEBRITA TOHOTO JMENA UZ EXISTUJE',414),
                              240-(textheight('N')div 2),
                              'CELEBRITA TOHOTO JMENA UZ EXISTUJE');
                    {nulovani polozek osoby}
                    with  REC do
                    begin
                    JMENO:='';
                    SEX:='';
                    ROK_NAR:='';
                    MISTO_NAR:='';
                    NAROD:='';
                    PRACE:='';
                    end;
                    end
               else begin
                    {uprava helplistu}
                    if pomrec.JMENO<>REC.JMENO then
                    MAZ_ZE_HELPLIST(REC.JMENO,pomrec.JMENO,pos);

                    {kompatibilni uprava atributu}
                    with REC do
                    begin
                    JMENO:=ORIZSTR(JMENO);
                    ROK_NAR:=ORIZSTR(ROK_NAR);
                    MISTO_NAR:=ORIZSTR(MISTO_NAR);
                    end;
                    {upravi zaznam v souboru}
                    assign(F,JMFILE);
                    reset(F);
                    seek(F,pos);
                    write(F,REC);
                    close(F);
                    {napise opraveny zaznam}
                    CLEAN_OKNO;
                    WRITE_LINES;
                    SH_INF(REC);
                    end;
    end;
    end
    else begin
         {neni co}
         CLEAN_OKNO;
         setcolor(red);
         settextstyle(4,0,1);
         outtextxy(POSTEXT('NENI CO UPRAVOVAT',414),
                   240-(textheight('N')div 2),
                   'NENI CO UPRAVOVAT');
         end;
    end;
3 : begin
    {mazani zaznamu}

    if (REC.JMENO<>'')then
    begin
    {najdeme cestu k zaznamu}
    SEARCH_ITEM(F,REC,pos,vys);
    pomrec:=REC;
    {vyhledame posledni polozku}
    assign(F,JMFILE);
    reset(F);
    filepoc:=filesize(F);

    seek(F,filesize(F)-1);
    read(F,REC);
    seek(F,filepos(F)-1);
    truncate(F);
    {premazani mazaneho poslednim zaznamem}
    if pos<>filepoc-1 then begin seek(F,pos);
                                 write(F,REC);
                           end;
    close(F);


    MAZ_ZE_HELPLIST(REC.JMENO,pomrec.JMENO,pos);

    {napise uspech}
    CLEAN_OKNO;
    setcolor(white);
    settextstyle(4,0,1);
    outtextxy(POSTEXT('ZAZNAM SMAZAN',414),
              240-(textheight('N')div 2),
              'ZAZNAM SMAZAN');
    end
    else begin
         {neni co}
         CLEAN_OKNO;
         setcolor(red);
         settextstyle(4,0,1);
         outtextxy(POSTEXT('NENI CO MAZAT',414),
                   240-(textheight('N')div 2),
                   'NENI CO MAZAT');
         end;
    end;
4 : begin
    {vytvori a ovlada seznam}
    CLEAN_UI;
    CLEAN_OKNO;
    {kontrola zda-li soubor existuje}
    assign(F,JMFILE);
    {$I-}
    reset(F);
    if IOresult<>0 then begin
                        {soubor neni}
                        setcolor(red);
                        settextstyle(4,0,1);
                        outtextxy(POSTEXT('SOUBOR NENALEZEN',414),
                                  240-(textheight('N')div 2),
                                  'SOUBOR NENALEZEN');
                        end
    {$I+}
    else
    {..pokud soubor existuje}
    begin
    close(F);
    PAGE:=1;
    {vytvoreni ukazatelu}
    COLLECT_SEZNAM(F,OSOBA,PAGE,exec);
    if exec then begin
                 {zjisti kolik je zaznamu}
                 assign(F,JMFILE);
                 reset(F);
                 filepoc:=filesize(F);
                 close(F);
                 {-----------------------}
                 {hlavicka}
                 WRITE_SEZNAM;
                 LINE_SEZNAM;
                 WRITE_JMENA_SEZNAM(OSOBA);
                 {---------}
                 {ukazatel se nastavi na zacatek seznamu}
                 pomuk:=OSOBA;
                 pos:=1;
                 REC:=pomuk^.os;
                 {oznaci se prvni polozka}
                 FIX_SEZNAM(pos,pomuk,PAGE);
                 {---------------------------------------}

                 {vypocita pocet stran}
                 PAGES:=filepoc div 41;
                 if (filepoc mod 41)<>0 then PAGES:=PAGES+1;
                 {-------------------}
                 STATIK_INFO_SEZNAM;
                 INFO_SEZNAM(TOSTR(PAGE),
                             TOSTR(PAGES),
                             TOSTR(pos),
                             TOSTR(filepoc));
                 {----------tady zacina interakce-------------}
                 key:=#0;
                 repeat
                 if key=#13 then begin
                                 {ceka na odezvu}
                                 key:=readkey;
                                 while (key<>#27) do key:=readkey;
                                 CALL_OKNO(P);
                                 end;
                 repeat
                 key:=readkey;
                 case key of
                 chr(72) : begin
                           if pos>((PAGE-1)*41)+1 then
                              begin
                           {nahoru}
                           {zvyrazni polozky vyse a posune v seznamu vlevo}
                              GUM_SEZNAM(pos,pomuk,PAGE);
                              pos:=pos-1;
                              SH_VLEVO(OSOBA,pomuk,REC);
                              FIX_SEZNAM(pos,pomuk,PAGE);
                              LINE_SEZNAM;
                              INFO_SEZNAM(TOSTR(PAGE),
                                          TOSTR(PAGES),
                                          TOSTR(pos),
                                          TOSTR(filepoc));
                              end
                                     else if PAGE>1 then
                              begin
                              {vrati se o stranku zpet}
                              PAGE:=PAGE-1;
                              UKLID(OSOBA);
                              COLLECT_SEZNAM(F,OSOBA,PAGE,exec);
                              {vypise se nova stranka}
                              CLEAN_OKNO;
                              WRITE_SEZNAM;
                              LINE_SEZNAM;
                              WRITE_JMENA_SEZNAM(OSOBA);
                              {zvyrazni se posledni polozka na strance}
                              pomuk:=OSOBA;
                              REC:=pomuk^.os;
                              for poc:=1 to 40 do SH_VPRAVO(OSOBA,pomuk,REC);
                              pos:=pos-1;
                              FIX_SEZNAM(pos,pomuk,PAGE);
                              {---------------------------------------}
                              INFO_SEZNAM(TOSTR(PAGE),
                                          TOSTR(PAGES),
                                          TOSTR(pos),
                                          TOSTR(filepoc));
                              end
                           end;
                 chr(80) : begin
                           if (pos<PAGE*41)and(pos<filepoc) then
                              begin
                           {dolu}
                           {zvyrazni polozky nize a posune v seznamu vpravo}
                              GUM_SEZNAM(pos,pomuk,PAGE);
                              pos:=pos+1;
                              SH_VPRAVO(OSOBA,pomuk,REC);
                              FIX_SEZNAM(pos,pomuk,PAGE);
                              LINE_SEZNAM;
                              INFO_SEZNAM(TOSTR(PAGE),
                                          TOSTR(PAGES),
                                          TOSTR(pos),
                                          TOSTR(filepoc));
                              end
                                     else if PAGE<PAGES then
                              begin
                              {postoupi se o stranku vpred}
                              PAGE:=PAGE+1;
                              UKLID(OSOBA);
                              COLLECT_SEZNAM(F,OSOBA,PAGE,exec);
                              {vypise se nova stranka}
                              CLEAN_OKNO;
                              WRITE_SEZNAM;
                              LINE_SEZNAM;
                              WRITE_JMENA_SEZNAM(OSOBA);
                              {zvyrazni se prvni polozka na strance}
                              pomuk:=OSOBA;
                              pos:=pos+1;
                              REC:=pomuk^.os;
                              FIX_SEZNAM(pos,pomuk,PAGE);
                              {---------------------------------------}
                              INFO_SEZNAM(TOSTR(PAGE),
                                          TOSTR(PAGES),
                                          TOSTR(pos),
                                          TOSTR(filepoc));
                              end
                           end
                 end;
                 until (key=#27) or (key=#13);
                 {zobrazi se osoba}
                 if key=#13 then
                    begin
                    {ulozeni obrazovky}
                    UCHOVAT_OKNO(P);
                    WRITE_LINES;
                    SH_INF(REC);
                    end;
                 {-------------------------------------------------------}
                 {konci seznam}
                 until key=#27;
                 {uvolni z pameti seznam}
                 UKLID(OSOBA);
                 CLEAN_OKNO;
                 CLEAN_UI;
                 {vymaze obsah REC}
                 with  REC do
                 begin
                 JMENO:='';
                 SEX:='';
                 ROK_NAR:='';
                 MISTO_NAR:='';
                 NAROD:='';
                 PRACE:='';
                 end;
                 end
            else begin
                 {zaznamy nejsou}
                 setcolor(red);
                 settextstyle(4,0,1);
                 outtextxy(POSTEXT('ZADNE ZAZNAMY',414),
                           240-(textheight('N')div 2),
                           'ZADNE ZAZNAMY');
                 end

    end
    end;
5 : begin
    CLEAN_UI;
    CLEAN_OKNO;
    HL_MENU(POCITEMS,PP);
    SH_AUTOR;
    CLEAN_OKNO;
    end;
POCITEMS-1
  : begin
    UCHOVAT_OKNO(P);
    control:=FINISH;
    if not control then begin
                        cleardevice;
                        WINDOW(POCITEMS);
                        HL_MENU(POCITEMS,PP);
                        CALL_OKNO(P);
                        end
    end
end;
until control;

cleardevice;
closegraph;
end.