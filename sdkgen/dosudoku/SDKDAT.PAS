unit sdkdat;

interface
uses sdkdecl;

{ulozi stav}
procedure vytvor(name:string;usdk,hsdk:T_lattice);

{nacte stav}
procedure nacti(name:string;var usdk,hsdk:T_lattice);

{smaze stav}
procedure smaz(name:string);

implementation
uses dos;
const dir='data\sdk\';
type sdk=record
         title:string;
         zadani:T_lattice;
         reseni:T_lattice;
         end;

procedure vytvor(name:string;usdk,hsdk:T_lattice);
          var f:file of sdk;
              pom:sdk;
          begin
          assign(f,dir+name+'.sdk');
          rewrite(f);
          pom.title:=name;
          pom.zadani:=usdk;
          pom.reseni:=hsdk;
          write(f,pom);
          close(f);
          end;

procedure nacti(name:string;var usdk,hsdk:T_lattice);
          var f:file of sdk;
              pom:sdk;
          begin
          assign(f,dir+name+'.sdk');
          {$I-}
          reset(f);
          {$I+}
          if IOresult=0 then
             begin
             read(f,pom);
             name:=pom.title;
             usdk:=pom.zadani;
             hsdk:=pom.reseni;
             close(f);
             end;
          end;

procedure smaz(name:string);
          var f:file of sdk;
          begin
          assign(f,dir+name+'.sdk');
          {$I-}erase(f);{$I+}
          end;

begin
end.