%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Geometric Inlet Angle
%% Update: 24 July, 2020
%{
 % This function calculates the inlet geometric angle based on zero
 % 	incidence losses.
 %
 % The following are inputs:
 %
 % 		inlet: Inlet structure
 % 		   Nb: Number of blades
 % 		   th: Blade thickness
 %
 % The following is the output:
 %
 % 		beta_geo: Structure containing the geometric inlet angles
%}

function beta_geo = geometric_inlet_angle(inlet,Nb,th)

	D1 = struct2array(inlet.D1);
	beta_flow = [inlet.W1.hub.ang, inlet.W1.mid.ang, inlet.W1.tip.ang];	

    %% [A]:Inlet Area
    SAC = pi * D1 - Nb * th; % [m]
    
    %% [B]:Optimal Area
    S = pi * D1;  % [m]
    
    %% [C]:Calculate Geometric Inlet Angle
    beta_geo = atand( SAC/S * tand(beta_flow) );    % [deg]
	beta_geo = table2struct(array2table(beta_geo));
	beta_geo = cell2struct( struct2cell(beta_geo), {'hub', 'mid', 'tip'});
    

end

