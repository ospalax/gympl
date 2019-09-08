unit sdkdecl;

interface
uses crt,dos;

const attcoll='data\attcoll.txt';
      attmuch='data\attmuch.txt';
      attless='data\attless.txt';
      attesc='data\attesc.txt';
      attnon='data\attnon.txt';
      annemp='data\annemp.txt';
      annerr='data\annerr.txt';
      anncon='data\anncon.txt';
      annnic='data\annnic.txt';
      annnic2='data\annnic2.txt';

      inf='data\inf.txt';
      brvzadback=lightblue;
      brvzadtext=white;
      brvresback=white;
      brvrestext=black;
type T_item=array[1..10] of byte;
     T_lattice=array['A'..'I']of array[1..9] of T_item;
     T_POMitem=array[1..3] of byte;
                  {1-cislo
                   2-barva cisla
                   3-barva pozadi cisla}
     T_POMLATTICE=array['A'..'I']of array[1..9] of T_POMitem;

var ITEM,ITEM2,SECITEM:T_lattice;
    pomitem:T_POMLATTICE;
    VICERESENI:boolean;
    VOLBA:byte;

procedure delay(time:longint);

implementation

procedure delay(time:longint);
          var h,h2,h3,m,m2,s,s2,ms,ms2:word;
              i:longint;
          begin
          gettime(h,m,s,ms);

          ms2:=(time+ms) mod 100;
          if ((time+ms) div 100)>0 then time:=time+100;

          s2:=((time div 100)+s)mod 60;
          if (((time div 100)+s)div 60)>0 then time:=time+6000;

          m2:=((time div 6000)+m)mod 60;
          if (((time div 6000)+m)div 60)>0 then time:=time+360000;

          h2:=((time div 360000)+h)mod 24;

          repeat
          gettime(h,m,s,ms);
          if h2<h then h3:=h2+24
                  else h3:=h2;
          until (h>h3)or((h=h2)and((m>m2)or(m=m2)
                and((s>s2)or((s=s2)and((ms>ms2)or(ms=ms2))))));
          end;

begin
end.