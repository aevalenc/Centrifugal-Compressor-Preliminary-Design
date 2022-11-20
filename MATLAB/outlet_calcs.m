%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Outlet Velocity Triangles
%% Update: 24 July, 2020
%{
 % Recall that we do not know any of our flow angles at the exit of the 
 % 	impeller. So the outlet absolute flow angle is assumed
 % 	to fix the velocity triangle.
 %
 % The following are inputs:
 %
 % 			alpha2: Absolute outlet flow angle
 % 			 l_eul: Eulerian work
 % 			  	U2: Outer peripheral speed
 %
 % The following are outputs
 %
 % 			outlet: Structure containing velocity components and Non-
 % 					isentropic temperature
%}

function outlet = outlet_calcs(alpha2, l_eul, U2)

    global Rh cp TT1 y

    %% []:Velocity Triangles
    % Absolute Velocity
    V2.ang = alpha2;                    % [deg] Angle
    V2.tan = l_eul / U2;                % [m/s] Tangential component
    V2.mag = V2.tan / sind(alpha2);     % [m/s] Magnitude
    V2.rad = V2.mag * cosd(alpha2);     % [m/s] Radial component

    % Relative Velocity
    W2.tan = V2.tan - U2;               % [m/s] Tangential component
    W2.rad = V2.rad;                    % [m/s] Radial component
    W2.ang = atand(W2.tan / W2.rad);      % [deg] Angle
    W2.mag = sqrt(W2.tan^2 + W2.rad^2); % [m/s] Magnitude

    % Total & Static Temperature
    % These are the real values of the temperature considering a non-
    %   isentropic process. The irreversibility is included in the
    %   end to end efficiency assumed at the beginning of the
    %   calculations
    TT2 = TT1 + l_eul / cp;             % [K] Total temperature
    T2  = TT2 - V2.mag^2 / (2*cp);      % [K] Static temperature

    % Mach Numbers
    outlet.M2  = V2.mag / sqrt(y * Rh * T2);    % [] Absolute Mach number
    outlet.M2u = U2 / sqrt(y * Rh * T2);        % [] Peripheral Mach number
    outlet.M2w = W2.mag / sqrt(y * Rh * T2);    % [] Relative Mach number

    %% []:Output
    outlet.U2  = U2;
    outlet.V2  = V2;
    outlet.W2  = W2;
    outlet.TT2 = TT2;
    outlet.T2  = T2;

end
