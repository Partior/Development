function status=outfun_a(tm,val,flag,varargin)

persistent L incd %#ok<PSET>
global tmat_a gmmat itrcyc
if strcmp(flag,'init')
    load('takeoff_const.mat')
    tm=0;
elseif strcmp(flag,'done')
    return
end

Wt=val(1);
Vt=val(2);

nm=varargin{1};
ne=varargin{2};

% formulation of dV/dt
Lg=L(12-incd,0,Vt,nm*ne)*2/1.45;

%rectangular, find flight path angle
rdh=32.2*(Lg/Wt-1);
gm=atan2d(rdh,Vt);

itrcyc=itrcyc+1;
tmat_a(itrcyc)=tm(end);
% formulation of dV/dt
gmmat(itrcyc)=gm;


status=0;