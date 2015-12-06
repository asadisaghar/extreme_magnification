% distfunc.m
% Note: Filled beam distances

function[value] = distfunc(z,Omega_M,Omega_Lambda)

value=1./sqrt(Omega_M.*(1+z).^3 - (Omega_M+Omega_Lambda-1).*(1+z).^2 + Omega_Lambda);
