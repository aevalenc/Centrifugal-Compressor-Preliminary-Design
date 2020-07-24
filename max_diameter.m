%% Authors: Alejandro Valencia, Shruthi Nandakumar
%% Centrifugal Compressor Design: Max Diameter
%% Start: 6 April, 2020
%% Update: 6 April, 2020

function [Dmax,sf] = max_diameter(material,w,Dhub,D2,varargin)

    %% [A]:Import Material Properties
    props = read_file(material);
    rho   = props(1);               % [kg/m^3] Density
    YS    = props(2);               % [Pa]     Tensile yield strength
    % G     = props(3);               % [Pa]     Shear yield strength
    nu    = props(4);               % []       Poissons ratio

    %% []:Max diameter
	ri   = Dhub / 4;								% Shaft diameter
	A    = 8 * YS / ((3 + nu) * rho * w^2);
    B    = ri.^2 * (1 - (1 + 3*nu) / (3 + nu));
    Dmax = 2 * sqrt(0.5 * (A - B));
	
	%% []:Disk Stress
	r2    = D2 / 2;  	% Exit radius
	sig_h = (3 + nu) / 8 * rho * w ^ 2 * (2 * r2 ^ 2 + ...
			ri ^ 2 *(1 - (1 + 3*nu) / (3 + nu)));
	o_h   = sig_h / 1000 / 1000; 						% [MPa]
	fprintf('Hoop stress: %0.1f[MPa]\n', o_h)
	
    %% Safety Factors
    sf   = Dmax / D2;
	sf_o = YS / sig_h;
	fprintf('Outer diameter safety factor: %0.2f\n', sf)
	fprintf('Stress safety factor: %0.2f[]\n', sf_o)

end








