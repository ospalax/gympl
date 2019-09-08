unit sdkdat;

interface
uses sdkdecl;

type T_LoadBug=(OK, NOFILE, BADAT);

{ulozi stav}
procedure vytvor(name:string;usdk,hsdk:T_lattice; user:T_PomLattice);

{nacte stav}
function nacti(name:string;var usdk,hsdk:T_lattice; user:T_PomLattice): T_LoadBug;

{smaze stav}
procedure smaz(name:string);

implementation
uses dos;
const dir='data\sdk\';
type sdk=record
         title:string;
         zadani:T_lattice;
         reseni:T_lattice;
			user:T_POMLATTICE;
         end;

procedure vytvor(name:string;usdk,hsdk:T_lattice; user:T_PomLattice);
          var f:file of sdk;
              pom:sdk;
          begin
          assign(f,dir+name+'.sdk');
          rewrite(f);
          pom.title:=name;
          pom.zadani:=usdk;
          pom.reseni:=hsdk;
			 pom.user:=user;
          write(f,pom);
          close(f);
          end;

function nacti(name:string;var usdk,hsdk:T_lattice; user:T_PomLattice):T_LoadBug;
          var f:file of sdk;
              pom:sdk;
				  Result:T_LoadBug;
          begin
			 Result:=OK;
			 
			 {$I-}
          assign(f,dir+name+'.sdk');
          reset(f);
          {$I+}
          if IOresult=0 then begin
				 {$I-}
             read(f,pom);
				 {$I+}
				 if IOresult=0 then begin
					name:=pom.title;
					usdk:=pom.zadani;
					hsdk:=pom.reseni;
					user:=pom.user
				 end else Result:=BADAT;
             close(f);
          end else Result:=NOFILE;
			
			 nacti:=Result;
          end;

procedure smaz(name:string);
          var f:file of sdk;
          begin
          assign(f,dir+name+'.sdk');
          {$I-}erase(f);{$I+}
          end;

begin
end.