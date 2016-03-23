function status=outfun(tm,y,flag,varargin)

persistent mu L T D %#ok<PSET>
global Tmat Drmat Dgmat tmat itrcyc
if strcmp(flag,'init')
    load('takeoff_const.mat')
    tm=0;
elseif strcmp(flag,'done')
    return
end

Wt=y(1,end);
Vt=y(2,end);

nm=varargin{1};
ne=varargin{2};

itrcyc=itrcyc+1;
tmat(itrcyc)=tm(end);
% formulation of dV/dt
Lmat=L(0,0,Vt,ne);
Drmat(itrcyc)=max(0,mu*(Wt-Lmat)); % rolling resistance
Tmat(itrcyc)=T(Vt,0,0,nm*ne);
Dgmat(itrcyc)=D(0,0,Vt,ne); % air drag resistance

status=0;