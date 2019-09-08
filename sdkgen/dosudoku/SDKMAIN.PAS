unit sdkmain;

interface
uses sdkdecl;

{vytvori novou mriz}
{aplikuje na zadani pouze ciste vyzarovaci algoritmy}
procedure CREATE_LATTICE_PRIMITIVE(var ITEM:T_lattice);

{resi vsechny mozne alternativy, maze zbytecne moznosti}
procedure CREATE_LATTICE_ONE(var ITEM:T_lattice;var VICERESENI,ESC:boolean);

{generuje sit pomoci jednoduchych algoritmu (primitive), pokud to vsak
 nestaci nahodne vybere odpovidajici cisla dokud neni mriz plna}
procedure CREATE_LATTICE(var ITEM:T_lattice);
          {parametrem je: item-upravovana mrizka}

{generuje zadani}
{zadani stredove soumerne}
procedure GEN_ZADANI(var ITEM2,ITEM:T_LATTICE;JAK:byte);
          {parametrem je: item-upravovana mrizka
                          ITEM2- pomocna mrizka urcujici zadani
                          JAK- obtiznost}

{inicializuje grafickou mrizku}
procedure INI_LATTICE_PRIMITIVE(var POMITEM:T_POMLATTICE;
                                brvtext,brvback:byte);
          {parametrem je: POMITEM- pole grafickych cisel
                          brvtext- barva cisel
                          brvback- barva pozadi cisel}


{prevede POMITEM do ITEM}
procedure TRANS_POM_TO_ITEM(POMITEM:T_POMLATTICE;var ITEM:T_LATTICE);
procedure TRANS_ITEM_TO_POM(var POMITEM:T_POMLATTICE;ITEM:T_LATTICE);
          {parametrem je: POMITEM- graficka mrizka
                          ITEM- skutecna upravovana mrizka}

{projde celou mriz a upravuje pravdepodobnosti}
{jednoduchy sken}
procedure LATTICE_TRAVERSAL_BASE(var ITEM:T_lattice;var exe:boolean);
{hleda na sobe zavisla duplikovana mista, jejiz pravdepodobnosti
 maze ostatnim zavislym mistum,je-li takovych mist stejne jako
 pravdepodobnosti}
procedure LATTICE_TRAVERSAL_DUPL(var ITEM:T_lattice;var exe:boolean);
{pokud je v neurcenem miste jedinecne cislo pro radek,sloupec,ci ctverec
 stava se jedinou moznosti}
procedure LATTICE_TRAVERSAL_RMND(var ITEM:T_lattice;var exe:boolean);
          {parametrem je: item-upravovana mrizka
                          exe-zda doslo k zmene}

procedure LATTICE_TRAVERSAL_AI(var ITEM:T_lattice;var exe:boolean);
          {parametrem je: item-upravovana mrizka
                          exe-zda doslo k zmene}

{tam kde to jde, nahodne zvoli pripustne cislo}
procedure RANDOM_NUMBER(var ITEM:T_lattice);
          {parametrem je: item-upravovana mrizka}

{pokud je mrizka vyplnena vraci true}
function FULL_LATTICE(item:T_lattice):boolean;
         {parametrem je: item-upravovana mrizka}
{zkontroluje spravnost vyplneni}
function CHECK_LATTICE(item:T_lattice):boolean;
         {parametrem je: item-upravovana mrizka}
{kopiruje itemy}
procedure COPYITEM(var xto,xfrom:T_LATTICE);
          {parametrem je: xto-kam
                          xfrom-odkud}

implementation
uses crt;

type T_aux_array=array[1..9] of 0..9;

{rovnou upravi polozku pro urcenou hodnotu v parametru}
procedure promaz(var item:T_lattice;sl:char;ra,co:byte);
                    var i:byte;
                    begin
                    for i:=2 to 9 do item[sl,ra,i]:=0;
                    item[sl,ra,1]:=co;
                    item[sl,ra,10]:=1;
                    end;
{upravuje vnitrni organizaci vyresene polozky}
          function remainder(var rm:T_item):boolean;
                    {parametrem je: rm-polozka mrizky}
                    var mezz:byte;
                    begin
                    if (rm[10]=1)then
                       begin
                       remainder:=true;
                       if (rm[1]=0) then
                          begin
                          mezz:=1;
                          while rm[mezz]=0 do mezz:=mezz+1;
                          rm[1]:=rm[mezz];
                          rm[mezz]:=0;
                          end;
                       end
                       else remainder:=false;
                    end;
{inicializuje mriz}
procedure ini(var item:T_lattice);
          var sl:char;
              ra,i:byte;
          begin
          for sl:='A' to 'I' do
              for ra:=1 to 9 do
                  begin
                  for i:=1 to 9 do item[sl,ra,i]:=i;
                  item[sl,ra,10]:=9;
                  end
          end;


{------------------------------------------------------------}
procedure LATTICE_TRAVERSAL_BASE(var ITEM:T_lattice;var exe:boolean);
          var sl,sl2,i:char;
              ra,ra2,l:byte;

          begin
          exe:=false;

          {projde vsechny polozky mrize}
          {prvni cast pruchodu-----------------------------------------}
          for ra:=1 to 9 do
              for sl:='A' to 'I' do

                  {- - - - - - - - - - - - -}
                  begin

                  {projde radek--------------------------------------------}
                  if ITEM[sl,ra,10]<>1 then
                  {pokud neni polozka urcena..}
                  for sl2:='A' to 'I' do
                      begin
                      if ITEM[sl2,ra,10]=1 then
                         if ITEM[sl,ra,ITEM[sl2,ra,1]]<>0 then
                            begin
                            ITEM[sl,ra,ITEM[sl2,ra,1]]:=0;
                            ITEM[sl,ra,10]:=ITEM[sl,ra,10]-1;
                            exe:=true;
                            if remainder(ITEM[sl,ra]) then break;
                            end;
                      end;

                  {projde sloupec-----------------------------------------}
                  if ITEM[sl,ra,10]<>1 then
                  {pokud neni polozka urcena..}
                  for ra2:=1 to 9 do
                      begin
                      if ITEM[sl,ra2,10]=1 then
                         if ITEM[sl,ra,ITEM[sl,ra2,1]]<>0 then
                            begin
                            ITEM[sl,ra,ITEM[sl,ra2,1]]:=0;
                            ITEM[sl,ra,10]:=ITEM[sl,ra,10]-1;
                            exe:=true;
                            if remainder(ITEM[sl,ra]) then break;
                            end;
                      end;

                  {projde ctverec------------------------------------------}
                  {najde spravny ctverec}
                  if ITEM[sl,ra,10]<>1 then
                  {pokud neni polozka urcena..}
                         begin
                  case ra of
                  1..3 : ra2:=1;
                  4..6 : ra2:=4;
                  7..9 : ra2:=7;
                  end;

                  case sl of
                  'A'..'C' : sl2:='A';
                  'D'..'F' : sl2:='D';
                  'G'..'I' : sl2:='G';
                  end;
                  {projde ho}
                  for l:=ra2 to ra2+2 do
                      begin
                      for i:=sl2 to chr(ord(sl2)+2) do
                          begin
                          if ITEM[i,l,10]=1 then
                             if ITEM[sl,ra,ITEM[i,l,1]]<>0 then
                                begin
                                ITEM[sl,ra,ITEM[i,l,1]]:=0;
                                ITEM[sl,ra,10]:=ITEM[sl,ra,10]-1;
                                exe:=true;
                                if remainder(ITEM[sl,ra]) then break;
                                end;
                          end;
                      if remainder(ITEM[sl,ra]) then break;
                      end;
                      end
                  end;
                  {- - - - - - - - - - - - -}
          end;

procedure LATTICE_TRAVERSAL_DUPL(var ITEM:T_lattice;var exe:boolean);
          var sl,sl2,i:char;
              ra,ra2,l,mezz,it,sk,k,yt:byte;
              pom:T_aux_array;

          {porovnava dve polozky zda jsou rovny}
          function compare_item(rm1,rm2:T_item):boolean;
                   var i:byte;
                       cnt:boolean;
                   {parametrem je: rm1,rm2-polozky
                   vysledkem je: True-rm1=rm2
                                 False-rm1<>rm2}
                   begin
                   cnt:=true;
                   i:=0;
                   while (cnt)and(i<9) do
                         begin
                         i:=i+1;
                         if rm1[i]<>rm2[i] then cnt:=false;
                         end;
                   compare_item:=cnt;
                   end;
          {maze cisla podle vzoru z kontrolovane polozky}
          procedure delnumbers(var rm,samp:T_item;var exe:boolean);
                    {parametrem je: rm-kontrolovana polozka
                                    samp-vzor}
                    var i:byte;
                    begin
                    i:=0;
                    while (not remainder(rm))and(i<9) do
                        begin
                        i:=i+1;
                        if samp[i]<>0 then
                           if rm[i]<>0 then begin
                                            rm[i]:=0;
                                            rm[10]:=rm[10]-1;
                                            if remainder(rm) then exe:=true;
                                            end;
                        end;
                    end;
          begin
          exe:=false;
          {druha cast pruchodu--------------------------------------}
          {rozhozeni radku do skupin}
          for ra:=1 to 9 do
              begin

                  sk:=1;
                  if item['A',ra,10]<>1 then pom[1]:=1
                                        else pom[1]:=0;
                  for sl2:='B' to 'I' do
                      begin
                      if item[sl2,ra,10]<>1 then
                         begin
                         it:=1;
                         while it<>ord(sl2)-64 do
                               begin
                               if pom[it]<>0 then
                               if compare_item
                                  (item[chr(64+it),ra],item[sl2,ra]) then
                                  begin
                                  pom[ord(sl2)-64]:=pom[it];
                                  break;
                                  end;
                               it:=it+1;
                               end;
                         if it=ord(sl2)-64 then begin sk:=sk+1;
                                                      pom[it]:=sk;
                                                end;
                         end
                                            else
                         pom[ord(sl2)-64]:=0;
                         end;

                  {promazani radku podle skupin}
                  for it:=1 to sk do
                      begin
                      mezz:=0;
                      for l:=1 to 9 do if pom[l]=it then mezz:=mezz+1;
                      l:=1;
                      while (pom[l]<>it)and(l<9) do l:=l+1;
                      if (item[chr(64+l),ra,10]=mezz)and(mezz>1) then
                         begin
                         for mezz:=1 to 9 do
                             if pom[mezz]<>it then
                                delnumbers
                                (item[chr(64+mezz),ra],item[chr(64+l),ra],exe);
                         end;
                      end;

              end;
          {rozhozeni sloupce do skupin}
          for sl:='A' to 'I' do
              begin

                  sk:=1;
                  if item[sl,1,10]<>1 then pom[1]:=1
                                        else pom[1]:=0;
                  for ra2:=2 to 9 do
                      begin
                      if item[sl,ra2,10]<>1 then
                         begin
                         it:=1;
                         while it<>ra2 do
                               begin
                               if pom[it]<>0 then
                               if compare_item
                                  (item[sl,it],item[sl,ra2]) then
                                  begin
                                  pom[ra2]:=pom[it];
                                  break;
                                  end;
                               it:=it+1;
                               end;
                         if it=ra2 then begin sk:=sk+1;
                                              pom[it]:=sk;
                                        end;
                         end
                                            else
                         pom[ra2]:=0;
                         end;

                  {promazani sloupce podle skupin}
                  for it:=1 to sk do
                      begin
                      mezz:=0;
                      for l:=1 to 9 do if pom[l]=it then mezz:=mezz+1;
                      l:=1;
                      while (pom[l]<>it)and(l<9) do l:=l+1;
                      if (item[sl,l,10]=mezz)and(mezz>1) then
                         begin
                         for mezz:=1 to 9 do
                             if pom[mezz]<>it then
                                delnumbers
                                (item[sl,mezz],item[sl,l],exe);
                         end;
                      end;

              end;
          {rozhozeni ctverce do skupin}
          for k:=1 to 9 do {-> velke ctverce}
              begin

              case k of
              1 : begin ra:=1; sl:='A' end;
              2 : begin ra:=1; sl:='D' end;
              3 : begin ra:=1; sl:='G' end;
              4 : begin ra:=4; sl:='A' end;
              5 : begin ra:=4; sl:='D' end;
              6 : begin ra:=4; sl:='G' end;
              7 : begin ra:=7; sl:='A' end;
              8 : begin ra:=7; sl:='D' end;
              9 : begin ra:=7; sl:='G' end;
              end;
                  sk:=1;
                  if item[sl,ra,10]<>1 then pom[1]:=1
                                        else pom[1]:=0;

                  for ra2:=ra to ra+2 do
                  for sl2:=sl to chr(ord(sl)+2) do
                   if (ra2<>ra)or(sl2<>sl) then
                      begin
                      l:=1;
                      it:=ra;
                      i:=sl;

                      while (it<ra2)or(i<sl2) do
                            begin l:=l+1;
                                  if i<chr(ord(sl)+2) then i:=succ(i)
                                                      else begin
                                                           i:=sl;
                                                           it:=it+1;
                                                           end;
                            end;
                      if item[sl2,ra2,10]<>1 then
                         begin
                         it:=ra;
                         i:=sl;
                         mezz:=1;
                         while (it<ra2)or(i<sl2) do
                               begin
                               if pom[mezz]<>0 then
                               if compare_item
                                  (item[i,it],item[sl2,ra2]) then
                                  begin

                                  pom[l]:=pom[mezz];
                                  break;
                                  end;

                               if i<chr(ord(sl)+2) then i:=succ(i)
                                                   else begin
                                                        i:=sl;
                                                        it:=it+1;
                                                        end;
                               mezz:=mezz+1;
                               end;
                         if mezz=l then begin sk:=sk+1;
                                              pom[l]:=sk;
                                        end;
                         end
                                            else
                         pom[l]:=0;
                         end;

                  {promazani ctverce podle skupin}
                  for it:=1 to sk do
                      begin
                      mezz:=0;
                      for l:=1 to 9 do if pom[l]=it then mezz:=mezz+1;
                      l:=1;
                      while (pom[l]<>it)and(l<9) do l:=l+1;
                      ra2:=ra;
                      sl2:=sl;
                      while l<>1 do begin l:=l-1;
                                    if sl2<chr(ord(sl)+2) then sl2:=succ(sl2)
                                                          else begin
                                                               sl2:=sl;
                                                               ra2:=ra2+1;
                                                               end;
                                    end;
                      if (item[sl2,ra2,10]=mezz)and(mezz>1) then
                         begin
                         i:=sl;
                         l:=ra;
                         for mezz:=1 to 9 do
                             begin
                             if pom[mezz]<>it then
                                delnumbers
                                (item[i,l],item[sl2,ra2],exe);
                             if mezz<9 then
                             if i<chr(ord(sl)+2) then i:=succ(i)
                                                 else begin
                                                      i:=sl;
                                                      l:=l+1;
                                                      end;
                             end;
                         end;
                      end;

              end;
          end;

procedure LATTICE_TRAVERSAL_RMND(var ITEM:T_lattice;var exe:boolean);
          var pom:array[1..9] of 0..10;
              ra,ra2,i,mezz,k,l:byte;
              sl,sl2:char;
              cnt:boolean;

          begin
          {0-cislo jeste nebylo
           10-cislo jiz byt nemuze}
          {projde radek}
          for ra:=1 to 9 do
              begin
              for ra2:=1 to 9 do pom[ra2]:=0;
              {urceni jedinecneho cisla}
              for sl:='A' to 'I' do
              if item[sl,ra,10]<>1 then
                 begin
                 for i:=1 to 9 do if item[sl,ra,i]<>0 then
                                     if pom[i]=0 then pom[i]:=i
                                        else if pom[i]<>10 then pom[i]:=10;
                 end
                 else pom[item[sl,ra,1]]:=10;
              {zvyrazneni cisla}
              for i:=1 to 9 do
                 if (pom[i]<>0)and(pom[i]<>10) then
                 begin
                 mezz:=pom[i];
                 for sl:='A' to 'I' do
                     begin
                     for ra2:=1 to 9 do if item[sl,ra,ra2]=mezz then
                                           begin
                                           promaz(item,sl,ra,mezz);
                                           exe:=true;
                                           break;
                                           end;
                     if item[sl,ra,1]=mezz then break;
                     end;
                 end;
              end;


          {projde sloupec}
          for sl:='A' to 'I' do
              begin
              for ra:=1 to 9 do pom[ra]:=0;
              {urceni jedinecneho cisla}
              for ra:=1 to 9 do
              if item[sl,ra,10]<>1 then
                 begin
                 for i:=1 to 9 do if item[sl,ra,i]<>0 then
                                     if pom[i]=0 then pom[i]:=i
                                        else if pom[i]<>10 then pom[i]:=10;
                 end
                 else pom[item[sl,ra,1]]:=10;
              {zvyrazneni cisla}
              for i:=1 to 9 do if (pom[i]<>0)and(pom[i]<>10) then
                 begin
                 mezz:=pom[i];
                 for ra:=1 to 9 do
                     begin
                     for ra2:=1 to 9 do if item[sl,ra,ra2]=mezz then
                                           begin
                                           promaz(item,sl,ra,mezz);
                                           exe:=true;
                                           break;
                                           end;
                     if item[sl,ra,1]=mezz then break;
                     end;
                 end;
              end;


          {projde ctverec}
          for k:=1 to 9 do {-> velke ctverce}
              begin
              for ra:=1 to 9 do pom[ra]:=0;
              case k of
              1 : begin ra:=1; sl:='A' end;
              2 : begin ra:=1; sl:='D' end;
              3 : begin ra:=1; sl:='G' end;
              4 : begin ra:=4; sl:='A' end;
              5 : begin ra:=4; sl:='D' end;
              6 : begin ra:=4; sl:='G' end;
              7 : begin ra:=7; sl:='A' end;
              8 : begin ra:=7; sl:='D' end;
              9 : begin ra:=7; sl:='G' end;
              end;
              {urceni jedinecneho cisla}
              for ra2:=ra to ra+2 do
              for sl2:=sl to chr(ord(sl)+2) do
              if item[sl2,ra2,10]<>1 then
                 begin
                 for i:=1 to 9 do if item[sl2,ra2,i]<>0 then
                                     if pom[i]=0 then pom[i]:=i
                                        else if pom[i]<>10 then pom[i]:=10;
                 end
                 else pom[item[sl2,ra2,1]]:=10;
              {zvyrazneni cisla}
              for i:=1 to 9 do if (pom[i]<>0)and(pom[i]<>10) then
                 begin

                 mezz:=pom[i];
                 for ra2:=ra to ra+2 do
                 begin
                 for sl2:=sl to chr(ord(sl)+2) do
                       begin
                       for l:=1 to 9 do if item[sl2,ra2,l]=mezz then
                                           begin
                                           promaz(item,sl2,ra2,mezz);
                                           exe:=true;
                                           break;
                                           end;
                       if item[sl2,ra2,1]=mezz then break;
                       end;
                 if item[sl2,ra2,1]=mezz then break;
                 end;
                 end;
              end;

          end;

procedure LATTICE_TRAVERSAL_AI(var ITEM:T_lattice;var exe:boolean);
          var ra,num,sq,i:byte;
              sl,sl2,l:char;
              emp:boolean;
          begin
          exe:=false;

          {po sloupcich---------------------------------------------}
          for sl:='A' to 'I' do
            {prochazi vsechny typy kandidatu}
            for num:=1 to 9 do
             begin

             {pruchod sloupce cleneno po ctverci}
             for sq:=1 to 3 do
              begin
              ra:=1+((sq-1)*3);
              {hleda num cislo v sloupci v tomto ctverci}
              while ((ITEM[sl,ra,10]=1)or(ITEM[sl,ra,num]=0))
                    and(ra<(sq*3)) do ra:=succ(ra);
              {pokud je nalezen kandidat}
              if ITEM[sl,ra,10]>1 then
              if ITEM[sl,ra,num]=num then
                 begin
                 {emp znamena ze ve ctverci uz neni nas kandidat bez akt.radku}
                 emp:=true;
                 {prochazi ctverec}
                 for l:=chr(ord(sl)-(((ord(sl)-64)-1)mod 3))
                     to chr( ord(sl)-(((ord(sl)-64)-1)mod 3)+2 ) do
                   {mineme nas sloupec}
                   if l<>sl then
                      begin
                      {hleda kandidata a doufa ze nenajde}
                      {pokud je nalezen nema smysl pokracovat}
                      for i:=1+((sq-1)*3) to 1+((sq-1)*3)+2 do
                             if ITEM[l,i,num]=num then
                                begin
                                emp:=false;
                                break;
                                end;
                      if not emp then break;
                      end;
                 {ted projde prave ten aktualni sloupec}
                 if emp then
                    begin
                    {budeme promazavat sloupec}
                    for i:=1 to 9 do
                        {vynechame ctverec}
                        if (i<1+((sq-1)*3))
                           or(i>1+((sq-1)*3)+2) then
                           begin
                           {smazeme kandidata}
                           if ITEM[sl,i,10]>1 then
                            if ITEM[sl,i,num]=num then
                               begin
                               ITEM[sl,i,num]:=0;
                               ITEM[sl,i,10]:=ITEM[sl,i,10]-1;
                               exe:=true;
                               remainder(ITEM[sl,i]);
                               end
                           end;
                    if exe then exit;
                    end
                    else
                    begin
                    {zjistime zda je sloupec prazdny a pokud ano promazeme
                     ctverec}
                    for i:=1 to 9 do
                        begin
                        {vynechame ctverec}
                        if (i<1+((sq-1)*3))
                           or(i>1+((sq-1)*3)+2) then
                           begin
                           {pokud je kandidat pak konec}
                           if ITEM[sl,i,10]>1 then
                            if ITEM[sl,i,num]=num then
                               begin
                               emp:=true;
                               break;
                               end;
                           end;
                        end;
                    {pokud neni kandidat}
                    if not emp then
                       begin
                  {promazeme ctverec}
                  for l:=chr(ord(sl)-(((ord(sl)-64)-1)mod 3))
                      to chr(ord(sl)-(((ord(sl)-64)-1)mod 3)+2) do
                   {mineme nas sloupec}
                   if l<>sl then
                      begin
                      {nyni zkoumame ctverec cely a mazeme kandidaty}
                      for i:=1+((sq-1)*3) to 1+((sq-1)*3)+2 do
                          if ITEM[l,i,num]=num then
                             begin
                             ITEM[l,i,num]:=0;
                             ITEM[l,i,10]:=ITEM[l,i,10]-1;
                             exe:=true;
                             remainder(ITEM[l,i]);
                             end;
                      end;
                       if exe then exit;
                       end;
                    end;
                 end;
              end;
             {---------------------------------}
             end;

          {po radcich---------------------------------------------}
          for ra:=1 to 9 do
            {prochazi vsechny typy kandidatu}
            for num:=1 to 9 do
             begin

             {pruchod radku cleneno po ctverci}
             for sq:=1 to 3 do
              begin
              sl:=chr(65+((sq-1)*3));
              {hleda num cislo na radku v tomto ctverci}
              while ((ITEM[sl,ra,10]=1)or(ITEM[sl,ra,num]=0))
                    and(sl<chr(65+(sq*3)-1)) do sl:=succ(sl);
              {pokud je nalezen kandidat}
              if ITEM[sl,ra,10]>1 then
              if ITEM[sl,ra,num]=num then
                 begin
                 {emp znamena ze ve ctverci uz neni nas kandidat bez akt.radku}
                 emp:=true;
                 {prochazi ctverec}
                 for i:=ra-((ra-1)mod 3) to (ra-((ra-1)mod 3))+2 do
                   {mineme nas radek}
                   if i<>ra then
                      begin
                      {hleda kandidata a doufa ze nenajde}
                      {pokud je nalezen nema smysl pokracovat}
                      for sl2:=chr(65+((sq-1)*3)) to chr(65+(sq*3)-1) do
                             if ITEM[sl2,i,num]=num then
                                begin
                                emp:=false;
                                break;
                                end;
                      if not emp then break;
                      end;
                 {ted projde prave ten aktualni radek}
                 if emp then
                    begin
                    {budeme promazavat radek}
                    for sl2:='A' to 'I' do
                        {vynechame ctverec}
                        if (sl2<chr(65+((sq-1)*3)))
                           or(sl2>chr(65+(sq*3)-1)) then
                           begin
                           {smazeme kandidata}
                           if ITEM[sl2,ra,10]>1 then
                            if ITEM[sl2,ra,num]=num then
                               begin
                               ITEM[sl2,ra,num]:=0;
                               ITEM[sl2,ra,10]:=ITEM[sl2,ra,10]-1;
                               exe:=true;
                               remainder(ITEM[sl2,ra]);
                               end
                           end;
                    if exe then exit;
                    end
                    else
                    begin
                    {zjistime zda je radek prazdny a pokud ano promazeme
                     ctverec}
                    for sl2:='A' to 'I' do
                        begin
                        {vynechame ctverec}
                        if (sl2<chr(65+((sq-1)*3)))
                           or(sl2>chr(65+(sq*3)-1)) then
                           begin
                           {pokud je kandidat pak konec}
                           if ITEM[sl2,ra,10]>1 then
                            if ITEM[sl2,ra,num]=num then
                               begin
                               emp:=true;
                               break;
                               end;
                           end;
                        end;
                    {pokud neni kandidat}
                    if not emp then
                       begin
                  {promazeme ctverec}
                  for i:=ra-((ra-1)mod 3) to (ra-((ra-1)mod 3))+2 do
                   {mineme nas radek}
                   if i<>ra then
                      begin
                      {nyni zkoumame ctverec cely a mazeme kandidaty}
                      for sl2:=chr(65+((sq-1)*3)) to chr(65+((sq-1)*3)+2) do
                          if ITEM[sl2,i,num]=num then
                             begin
                             ITEM[sl2,i,num]:=0;
                             ITEM[sl2,i,10]:=ITEM[sl2,i,10]-1;
                             exe:=true;
                             remainder(ITEM[sl2,i]);
                             end;
                      end;
                       if exe then exit;
                       end;
                    end;
                 end;
              end;
             {---------------------------------}

             end;

          {----------------------------------------------------------------}
          end;
{----------------------------------------------------------------------------}
procedure RANDOM_NUMBER(var ITEM:T_lattice);
          var sl:char;
              ra,i,mpocet,ipocet:byte;
              cnt:boolean;

          begin
          mpocet:=0;
          for ra:=1 to 9 do
              for sl:='A' to 'I' do
              if ITEM[sl,ra,10]<>1 then mpocet:=mpocet+1;
          randomize;
          mpocet:=random(mpocet)+1;
          ra:=0;
          sl:='I';
          for i:=1 to mpocet do
              repeat
                if sl<'I' then sl:=succ(sl)
                          else begin
                               sl:='A';
                               ra:=ra+1;
                               end;
              until ITEM[sl,ra,10]<>1;
          ipocet:=0;
          for i:=1 to 9 do if ITEM[sl,ra,i]<>0 then ipocet:=ipocet+1;
          ipocet:=random(ipocet)+1;
          mpocet:=0;
          for i:=1 to ipocet do
              repeat
              mpocet:=mpocet+1;
              until ITEM[sl,ra,mpocet]<>0;

          promaz(item,sl,ra,item[sl,ra,mpocet]);
          end;
{------------------------------------------------------------}
{----------------------Zjisti zda je vyplnena-------------------------}
function FULL_LATTICE(item:T_lattice):boolean;
         var cnt:boolean;
             ra:byte;
             sl:char;
         begin
         cnt:=true;

         ra:=1;
         sl:=pred('A');
         while (cnt)and((ra<>9)or(sl<>'I')) do
               begin
               if sl<'I' then sl:=succ(sl)
                         else begin
                              sl:='A';
                              ra:=ra+1;
                              end;
               if item[sl,ra,10]>1 then cnt:=false;
               end;
         FULL_LATTICE:=cnt;
         end;
{---------------------------------------------------------------------}
{----------------------Zjisti zda je vyplnena mriz spravna------------}
function CHECK_LATTICE(item:T_lattice):boolean;
         var pom:T_aux_array;
             cnt:boolean;
             ra,ra2,i,k:byte;
             sl,sl2:char;
         begin
         cnt:=true;
         {projde radky}
         ra:=1;
         while (cnt)and(ra<=9) do
               begin
               for i:=1 to 9 do pom[i]:=i;
               sl:='A';
               while (cnt)and(sl<='I') do
                     begin

                     if item[sl,ra,10]=1 then
                     if pom[item[sl,ra,1]]<>0 then pom[item[sl,ra,1]]:=0
                                              else cnt:=false;
                     sl:=succ(sl);
                     end;
               ra:=ra+1;
               end;

         {projde sloupce}
         sl:='A';
         while (cnt)and(sl<='I') do
               begin
               for i:=1 to 9 do pom[i]:=i;
               ra:=1;
               while (cnt)and(ra<=9) do
                     begin
                     if item[sl,ra,10]=1 then
                     if pom[item[sl,ra,1]]<>0 then pom[item[sl,ra,1]]:=0
                                              else cnt:=false;
                     ra:=ra+1;
                     end;
               sl:=succ(sl);
               end;
         {projde ctverce}
         if cnt then
         for k:=1 to 9 do {-> velke ctverce}
              begin

              case k of
              1 : begin ra:=1; sl:='A' end;
              2 : begin ra:=1; sl:='D' end;
              3 : begin ra:=1; sl:='G' end;
              4 : begin ra:=4; sl:='A' end;
              5 : begin ra:=4; sl:='D' end;
              6 : begin ra:=4; sl:='G' end;
              7 : begin ra:=7; sl:='A' end;
              8 : begin ra:=7; sl:='D' end;
              9 : begin ra:=7; sl:='G' end;
              end;

              for i:=1 to 9 do pom[i]:=i;

              for ra2:=ra to ra+2 do
                  begin
                  for sl2:=sl to chr(ord(sl)+2) do
                      begin
                      if item[sl2,ra2,10]=1 then
                      if pom[item[sl2,ra2,1]]<>0 then pom[item[sl2,ra2,1]]:=0
                                                 else begin cnt:=false;
                                                            break;
                                                      end;
                      end;
                  if not cnt then break;
                  end;
              if not cnt then break;
              end;
         CHECK_LATTICE:=cnt;
         end;

{-------------------prevede POMITEM do ITEM a naopak------------------}
procedure TRANS_POM_TO_ITEM(POMITEM:T_POMLATTICE;var ITEM:T_LATTICE);
          var ra:byte;
              sl:char;
          begin
          ini(ITEM);

          for ra:=1 to 9 do
              for sl:='A' to 'I' do
              begin
              if POMITEM[sl,ra,1]<>0 then
              promaz(ITEM,sl,ra,POMITEM[sl,ra,1])
              end;

          end;

procedure TRANS_ITEM_TO_POM(var POMITEM:T_POMLATTICE;ITEM:T_LATTICE);
          var ra:byte;
              sl:char;
          begin
          for ra:=1 to 9 do
              for sl:='A' to 'I' do
              begin
              if ITEM[sl,ra,10]=1 then begin
                                       POMITEM[sl,ra,1]:=ITEM[sl,ra,1];
                                       POMITEM[sl,ra,2]:=brvzadtext;
                                       POMITEM[sl,ra,3]:=brvzadback;
                                       end;
              end;

          end;

{---------------------------------------------------------------------}
{inicializuje grafickou mrizku}
procedure INI_LATTICE_PRIMITIVE(var POMITEM:T_POMLATTICE;
                                brvtext,brvback:byte);
          var sl:char;
              ra:byte;
          begin
          for ra:=1 to 9 do
              for sl:='A' to 'I' do
                  begin
                  POMITEM[sl,ra,1]:=0;
                  POMITEM[sl,ra,2]:=brvtext;
                  POMITEM[sl,ra,3]:=brvback;
                  end;

          end;
{------------------Dotvori mriz---------------------------------------}

procedure CREATE_LATTICE(var ITEM:T_lattice);
          var exe:boolean;
              pom_item:array['A'..'I',1..9] of byte;

          procedure INS_POM_ITEM(x:T_LATTICE);
                    var i:byte;
                        l:char;
                    begin
                    for i:=1 to 9 do
                        for l:='A' to 'I' do
                            if x[l,i,10]=1 then pom_item[l,i]:=x[l,i,1]
                                           else pom_item[l,i]:=0;
                    end;
          procedure COPITEM(var x:T_LATTICE);
                    var i:byte;
                        l:char;
                    begin
                    ini(x);
                    for i:=1 to 9 do
                        for l:='A' to 'I' do
                        if pom_item[l,i]<>0
                           then promaz(x,l,i,pom_item[l,i]);

                    end;
          begin

          INS_POM_ITEM(ITEM);

          repeat

          COPITEM(ITEM);

          while not full_lattice(item) do
                begin

                CREATE_LATTICE_PRIMITIVE(ITEM);

                if not full_lattice(item) then RANDOM_NUMBER(ITEM);
                end;

          until CHECK_LATTICE(ITEM);
          end;

procedure CREATE_LATTICE_PRIMITIVE(var ITEM:T_lattice);
          var exe:boolean;

          begin

                exe:=true;
                repeat
                      while exe do lattice_traversal_base(item,exe);

                      lattice_traversal_dupl(item,exe);

                      if exe then continue;

                      lattice_traversal_rmnd(item,exe);

                      if exe then continue;

                      lattice_traversal_ai(item,exe);

                until not exe;

          end;
{kopiruje itemy------------------------------------------------}
          procedure COPYITEM(var xto,xfrom:T_LATTICE);
                    var i,pom:byte;
                        l:char;
                    begin
                    for i:=1 to 9 do
                        for l:='A' to 'I' do
                            for pom:=1 to 10 do
                            xto[l,i,pom]:=xfrom[l,i,pom];

                    end;
{maze zbytecne moznosti-----------------------------------------------------}
procedure CREATE_LATTICE_ONE(var ITEM:T_lattice;var VICERESENI,ESC:boolean);
          var INVERS_ITEM:T_LATTICE; {z nej se maze pouze zbytecne moznosti}
              RADIC_ITEM:array['A'..'I',1..9] of byte;
              TRANS_ITEM,HELP_ITEM:T_LATTICE;
              {slouzi jen k docasnemu stavu programu}
              IGNORE_LIST:array['A'..'I',1..9,1..9] of byte;

              ara,ai,ra,i:byte;
              asl,sl,key:char;
              UF:boolean;

          {najde nejblizsi neurcene cislo a urci jej pomoci RADIC_ITEM
           coz je poradove cislo moznosti}
          procedure SEARCH_PLACE(var x1:T_LATTICE;x2:T_LATTICE);
                    var ra,i,l:byte;
                        sl:char;

                    begin
                    ra:=1;
                    sl:='A';
                    while x1[sl,ra,10]=1 do
                          begin
                          if sl<'I' then sl:=succ(sl)
                                    else begin
                                         sl:='A';
                                         ra:=ra+1;
                                         end;

                          end;


                    l:=0;
                    for i:=1 to RADIC_ITEM[sl,ra] do
                        begin
                        l:=l+1;
                        while x2[sl,ra,l]=0 do l:=l+1;
                        end;

                    promaz(x1,sl,ra,x2[sl,ra,l]);
                    end;

          {vraci true pokud jsou vycerpany vsechny moznosti}
          function VYBRANO(x:T_LATTICE):boolean;
                   var ra:byte;
                       sl:char;
                       cnt:boolean;
                   begin
                    ra:=1;
                    sl:='A';
                    cnt:=true;

                    while (cnt)and(ra<10) do
                          begin
                          if x[sl,ra,10]>1 then
                          if x[sl,ra,10]<>RADIC_ITEM[sl,ra] then
                                                            begin
                                                            cnt:=false;
                                                            break;
                                                            end;

                          if sl<'I' then sl:=succ(sl)
                                    else begin
                                         sl:='A';
                                         ra:=ra+1;
                                         end;
                          end;

                   VYBRANO:=cnt;
                   end;

          {navysuje RADICE_ITEMU a tedy nabizi dalsi moznost}
          procedure NEXT_POSS(var sl:char;var ra:byte;x:T_LATTICE);
                    begin

                     repeat
                      {iterace dolu}
                      if sl>'A' then sl:=pred(sl)
                                else begin
                                     sl:='I';
                                     ra:=ra-1;
                                     end;

                     until x[sl,ra,10]>1;

                     if RADIC_ITEM[sl,ra]<x[sl,ra,10] then
                        RADIC_ITEM[sl,ra]:=RADIC_ITEM[sl,ra]+1
                     else begin
                          RADIC_ITEM[sl,ra]:=1;
                          NEXT_POSS(sl,ra,x);
                          end;
                    end;

          {doplnuje mrizku podle radice_itemu}
          procedure DOPLN(var x:T_LATTICE);
                    var ra,i,l:byte;
                        sl:char;
                    begin
                    for ra:=1 to 9 do
                        for sl:='A' to 'I' do
                        if x[sl,ra,10]>1 then
                         begin
                         l:=0;
                         for i:=1 to RADIC_ITEM[sl,ra] do
                             begin
                             l:=l+1;
                             while x[sl,ra,l]=0 do l:=l+1;
                             end;
                         {pise stav pred promazanim do HELP_ITEMU}
                         for i:=1 to 10 do HELP_ITEM[sl,ra,i]:=x[sl,ra,i];

                         promaz(x,sl,ra,x[sl,ra,l]);

                         CREATE_LATTICE_PRIMITIVE(x);
                         end;

                    end;

          {specialni inicializace HELP_ITEMU}
          procedure SPECINI(var x:T_LATTICE);
                    var ra:byte;
                        sl:char;
                    begin
                    for ra:=1 to 9 do
                        for sl:='A' to 'I' do
                            x[sl,ra,10]:=1;
                    end;
          {inicializace IGNORE_LISTU}
          procedure INI2;
                    var ra,i:byte;
                        sl:char;
                    begin
                    for ra:=1 to 9 do
                    for sl:='A' to 'I' do
                    for i:=1 to 9 do IGNORE_LIST[sl,ra,i]:=0;
                    end;
          {prenasi cisla do IGNORE_LISTU}
          procedure TRANS_IGNORE(x1,x2:T_LATTICE);
                    var ra,i:byte;
                        sl:char;
                    begin
                    for ra:=1 to 9 do
                    for sl:='A' to 'I' do
                    if x2[sl,ra,10]>1 then
                    IGNORE_LIST[sl,ra,x1[sl,ra,1]]:=x1[sl,ra,1];
                    end;
          begin
          {uschovani prvotnich supramoznosti------------------------------}
          CREATE_LATTICE_PRIMITIVE(ITEM);
          COPYITEM(INVERS_ITEM,ITEM);

          key:=#13;
          {---------------------------------------------------------------}
          {prochazi vsechna neurcena supracisla a jejich moznosti
           pokud pro urcitou moznost neni reseni je smazana
           de facto tedy hleda zbytecne moznosti---------}
          if not FULL_LATTICE(ITEM) then
          begin
          INI2;

          for ara:=1 to 9 do
              for asl:='A' to 'I' do

              if ITEM[asl,ara,10]>1 then
              for ai:=1 to 9 do
              if ITEM[asl,ara,ai]<>0 then
              if IGNORE_LIST[asl,ara,ai]=0 then {tahle podminka je docasna}
                  begin
                  promaz(ITEM,asl,ara,ITEM[asl,ara,ai]);
                  CREATE_LATTICE_PRIMITIVE(ITEM);
                  COPYITEM(TRANS_ITEM,ITEM);

                  {inicializace-----------------------}
                  SPECINI(HELP_ITEM);
                  UF:=false;

                  for ra:=1 to 9 do
                      for sl:='A' to 'I' do
                          if ITEM[sl,ra,10]>1 then
                             RADIC_ITEM[sl,ra]:=1

                             {else RADIC_ITEM[sl,ra]:=0 {smaz};
                  {-----------------------------------}

                  {opakuje se dokud nevyplytvame vsechny moznosti}
                  repeat
                  {pro rychle ukonceni}
                  if ESC then
                     if keypressed then
                        begin
                        key:=readkey;
                        if key=#27 then
                           begin
                           COPYITEM(ITEM,INVERS_ITEM);
                           exit;
                           end
                        end;

                  DOPLN(ITEM);

                  {kontrola zda je zkoumana moznost vyuzita
!!!!!!!!!!!!!!!!!  POKUD ANO MUZEME PRAVE ZDE POCITAT VSECHNA RESENI !!!!!!}

                  if CHECK_LATTICE(ITEM) then begin
                                              UF:=true;
                                              TRANS_IGNORE(ITEM,INVERS_ITEM);
                                              {UF je jen docasna cast podminky}
                                              break;
                                              end;

                  {navraceni mrizky do puvodniho stavu tesne po asl,ara}
                  COPYITEM(ITEM,TRANS_ITEM);
                  {----------------------------------------------------}

                  {uprava RADICE_ITEMU aby ukazoval na nasledujici moznosti}
                  if not VYBRANO(HELP_ITEM) then
                     begin
                     ra:=10;
                     sl:='A';
                     NEXT_POSS(sl,ra,HELP_ITEM);
                     end
                     else break;

                  SPECINI(HELP_ITEM);
                  {--------------------------------------------------------}
                  {tato podminka neprozkouma vsechny moznosti,
                   ted je ale dobra}
                  until false;

                  {je-li moznost zbytecna smaze se}
                  if not UF then
                     begin
                     INVERS_ITEM[asl,ara,ai]:=0;
                     INVERS_ITEM[asl,ara,10]:=INVERS_ITEM[asl,ara,10]-1;
                     REMAINDER(INVERS_ITEM[asl,ara]);
                     CREATE_LATTICE_PRIMITIVE(INVERS_ITEM);
                     end;

                  {priprava na dalsi cykl------------------------------}
                  COPYITEM(ITEM,INVERS_ITEM);
                  {----------------------------------------------------}
                  end;
          {urci zda je jedine reseni nebo vice}
          if FULL_LATTICE(ITEM) then VICERESENI:=false
                                else VICERESENI:=true;
          end
          else VICERESENI:=false;
          {---------------------------------------------------------------}
          if ESC then
             if key<>#27 then ESC:=false;
          end;
{---------------------------------------------------------------------}
{----------------generuje zadani--------------------------------------}
procedure GEN_ZADANI(var ITEM2,ITEM:T_LATTICE;JAK:byte);
          var poc,pocstred,kolik,i,pom,pos,l,VOLBY,ra:byte;
              sl:char;

              polevol:array[1..36] of boolean;
              pom_item,pom_item2:T_lattice;

          procedure TM(var co:T_ITEM);
                    var i:byte;
                    begin
                    for i:=1 to 9 do co[i]:=i;
                    co[10]:=9;
                    end;
          begin
          INI(ITEM);
          CREATE_LATTICE(ITEM);


          randomize;
          case JAK of
          {lehke 45}
          1 : kolik:=45;
          {stredne tezke 35}
          2 : kolik:=35;
          {tezke 25-30}
          3 : kolik:=25;
          end;

          {urceni poctu cislic----------------------}
          poc:=kolik;

          if poc<41 then pocstred:=random(6)
                    else pocstred:=random(45-(poc-1))+(poc-40);

          pom:=poc-pocstred;

          if (pom mod 2)<>0 then
             begin
             if pocstred=5 then pocstred:=pocstred-1
                           else pocstred:=pocstred+1;
             end;
          poc:=poc-pocstred;

          poc:=poc div 2; {pocet poloviny cisel bez stredu}
          {------------------------------------------------------------------}


          COPYITEM(ITEM2,ITEM);
          {rozhazovani cisel-------------------------------}
          pom:=9-pocstred;
          if (pocstred mod 2)=0 then
             begin
             TM(ITEM2['E',5]);
             pom:=pom-1;
             end;

          randomize;
          {soumerne rozhodi prostredni radek}
          for i:=1 to pom div 2 do
              begin
              pos:=random(4)+1;
              while ITEM2[chr(pos+64),5,10]<>1 do pos:=random(4)+1;

              TM(ITEM2[chr(pos+64),5]);
              TM(ITEM2[chr(74-pos),5]);
              end;

          {inicializace}
          pom:=36-poc;
          VOLBY:=36;
          for i:=1 to 36 do polevol[i]:=true;

          {hleda vhodne zadani-----------------------------------------}
          while (pom<>0)and(VOLBY<>0) do
                begin
                COPYITEM(POM_ITEM,ITEM2);
                {urceni poradoveho cisla}
                pos:=random(VOLBY)+1;
                l:=0;
                i:=0;
                ra:=1;
                while l<>pos do
                      begin
                      if polevol[ra] then l:=l+1
                                     else i:=i+1;
                      ra:=ra+1;
                      end;
                pos:=pos+i;

                VOLBY:=VOLBY-1;
                polevol[pos]:=false;
                {-----------------------}
                {mystifikovani}
                ra:=pos div 9;
                if (pos mod 9)<>0 then ra:=ra+1;
                if (pos mod 9)<>0 then sl:=chr(64+(pos mod 9))
                                  else sl:='I';
                TM(ITEM2[sl,ra]);
                TM(ITEM2[chr(74-(ord(sl)-64)),10-ra]);
                {-------------}
                {kontrola zda je resitelne}
                copyitem(pom_item2,item2);
                CREATE_LATTICE_PRIMITIVE(pom_item2);
                if (not FULL_LATTICE(pom_item2))or
                   (not CHECK_LATTICE(pom_item2))
                   then
                   begin
                   copyitem(ITEM2,pom_item);
                   end
                   else pom:=pom-1;
                end;
          end;

{---------------------------------------------------------------------------}
begin
end.