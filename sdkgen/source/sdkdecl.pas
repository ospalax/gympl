unit sdkdecl;

interface
uses crt,dos;

const attcoll='data\txt\attcoll.txt';
      attmuch='data\txt\attmuch.txt';
      attless='data\txt\attless.txt';
      attesc='data\txt\attesc.txt';
      attnon='data\txt\attnon.txt';
      annemp='data\txt\annemp.txt';
      annerr='data\txt\annerr.txt';
      anncon='data\txt\anncon.txt';
      annnic='data\txt\annnic.txt';
      annnic2='data\txt\annnic2.txt';
		annsave='data\txt\annsave.txt';
		annunsave='data\txt\annunsave.txt';
		filerr='data\txt\filerr.txt';
		daterr='data\txt\daterr.txt';
		inf='data\txt\inf.txt';
		
      readme='data\readme.txt';
      
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