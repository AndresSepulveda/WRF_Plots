clear all
close all
clc

load datos_sep2009_bm.mat

mag=datosW.mag;

%  1) NCEP1   
%  2) NCEP2   
%  3) CFSR-01 
%  4) CFSR-02 
%  5) CFSR-03 
%  6) FLN28-01
%  7) FLN28-02
%  8) FLN28-03
%  9) FLN59-01
% 10) FLN59-02
% 11) FLN59-03
% 12) BWK

% x=mag(:,[1,2,end] );

x=mag(:,[3,6,end] );

[Q q p]=tc(x)
