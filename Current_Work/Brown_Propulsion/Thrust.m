function Tfunc=Thrust(V,h,P,pT,varargin)
%% FUNCION Thrust()
%
% Provide a more robust output for thrust with regards to the
% multi-propeller system that the DEP setup will include, i.e. different
% powered propeller configurations
%
% [Tfunc] = thrust(V,h,P)
% V,h,P are standard input variables:
%   V velocity, ft/sec
%   h altitude, ft
%   P power, ft-lb/sec
%   pT thrust curve for various types of props, currently defined by thrust_curve.m
%
% [Tfunc] = thrust(...,Name,Value)
% using name/value pairs, alter from the default setting of the thrust
% function.
%
% Name/Value input settings:
% -  'config'
% 'cruise' or 'takeoff', meaning only the two cruise props (at 1/2 Pa
% each) or all eight props (at 1/8 Pa each), defaults to 'cruise'
% -  'num'
% 0, 2, 4 or 6, default to 6. Determines the number of active takeoff
% propellors (if config = 'takeoff'). Takeoff motors are limited to 1/8 Pa,
% and the cruise motors are allocated any remaining Pa left over (up to max
% 1/2 Pa)

%% Variable Argument Classification
if nargin>4
    if floor((nargin-4)/2)~=(nargin-4)/2
        error('Improper Name/Value Pairings')
    else
        for itr=1:(nargin-4)/2
            nm{itr}=varargin(itr*2-1);
            vl{itr}=varargin(itr*2);
        end
    end
end

%% Name/Value Settings
% Set Defaults firct
confg='cruise'; % default to output thrust is in the cruise conditions
nn=6;   % default takeoff num is all six takeoff engines
global m_effect
global alt_effect
global Mt
global Rmax

% Test for chagnes to default
for itr=1:length(nm)
    switch char(nm{itr})
        case 'config'
            confg=char(vl{itr});
        case 'num'
            nn=vl{itr};
        otherwise
            error('Did not Recognize Name/Value setting')
    end
end

%% Determine Thrust
switch char(confg)
    case 'cruise'
        Tfunc=...
            pT{1}(V,P/2)*2*m_effect(Mt(V,h,Rmax(1)))*...
            alt_effect(h);
        
    case 'takeoff'
        Tfunc=...
            (pT{1}(V,P/2*(1-1/8*nn))*2*m_effect(Mt(V,h,Rmax(1)))+...
            pT{2}(V,P/8)*nn*m_effect(Mt(V,h,Rmax(2))))*...
            alt_effect(h);
end

