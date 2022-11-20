%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Vaneless Diffuser Calculations
%% Update: 24 July, 2020
%{
 % This function takes a current compressor design and calculates the
 % 	necessary quantities for a vanless diffuser. For the purposes of this
 % 	code, point 2 refers to the outlet of the compressor / inlet of the
 % 	vaneless diffuser and point 3 refers to the outlet of the said 
 % 	diffuser.
 %
 % The following are the inputs:
 %
 % 		design: Current design structure
 % 		 itrmx: Max iterations for loop
 % 		   tol: Tolerance
 %
 % The following is the output
 %
 % 		result: Design with added vaneless diffuser structure
%}

function result = vaneless_diffuser_calcs(design, itrmx, tol)

    global y Rh mu cp mdot

    %% []:Grab Required Values From Design
    rho2  = design.outlet.rho2;     % [kg/m^3] Outlet density
    V2    = design.outlet.V2;       % [m/s]    Outlet velocity
    b2    = design.comp.b2;         % [m]      Outlet blade height
    D2    = design.comp.D2;         % [m]      Outlet diameter
    TT2   = design.outlet.TT2;      % [K]      Outlet real total temperature
    T2    = design.outlet.T2;       % [K]      Outlet real static temperature
    P2    = design.outlet.P2;       % [Pa]     Outlet real pressure


    %% []:Calculate Vanless Diffuser Diameter
    % We assume a ratio between the outlet diameter and the vaneless
    %   diffuser. In addition, we assume that the blade height will remain
    %   the same, i.e. b3 = b2.
    D3D2 = 1.2;
    D3   = D3D2 * D2;
    b3   = b2;


    %% []:Setup Density Loop
    % In this iterative loop, we initialize the average density and the
    %   average velocity with the compressor outlet conditions. As a
    %   result, set rho3 and V3 to rho2 and V2 respectively to begin the
    %   optimization process. Note that since the diffuser is basically a
    %   stator and no work is done. TT3 will equal TT2.
    TT3  = TT2;                                       	% [K]      Total Temperature
    rho3 = rho2;                                      	% [kg/m^3] Density
    V3   = V2;                                        	% [m/s]    Velocity
    Dhyd = (4 * pi * D3 * b3) / (2 * (pi * D3 + b3)); 	% [m]      Hydraulic Diameter
   
    for itr = 1:itrmx

        %% []:Calculate Average Quantities
        rho_avg = (rho2 + rho3) / 2;            % [kg/m^3] Average density
        V_avg   = (V3.mag + V2.mag) / 2;        % [m/s]    Average velocity
        Re_avg  = rho_avg * Dhyd * V_avg / mu;  % []       Average Reynolds number


        %% []:Calculate Friction Coefficient
        k  = 0.02;                              % [] Experimental constant
        cf = k * (1.8 * 10^5 / Re_avg);         % [] Friction coefficient


        %% []:Vanless Diffuser Outlet Velocity
        den = (D3D2 + cf/2 * pi * rho2 * V2.tan * D3 * (D3-D2)/mdot);
        V3.tan = V2.tan / den;                  % [m/s] Tangential component
        V3.rad = mdot / (pi * D3 * b3 * rho3);  % [m/s] Radial component
        V3.mag = sqrt(V3.tan^2 + V3.rad^2);     % [m/s] Outlet velocity magnitude
        V3.ang = atand(V3.tan / V3.rad);        % [m/s] Outlet angle


        %% []:Thermodynamic Values
        T3 = TT3 - V3.mag^2 / (2*cp);
        M3 = V3.mag / sqrt(y*Rh*T3);


        %% []:Calculate Losses
        num = cf * D2/2 * (1 - (1/D3D2)^1.5) * V2.mag^2;
        den = 1.5 * b2 * cosd(V2.ang);
        dh  = num / den;


        %% []:Calculate Isentropic Values
        TT3is = TT3 - dh/cp;
        T3is  = TT3is - V3.mag^2 / (2*cp);
        PT3 = P2 * (TT3is/T2)^(y/(y-1));
        P3  = PT3 / (1 + (y-1)/2 * M3^2)^(y/(y-1));


        %% []:Calculate Outlet Density
        rho3_n = P3 / (Rh*T3);


        %% []:Calculate Residual
        RES = abs(rho3 - rho3_n) / rho3;
        % fprintf('Iteration: %d | Residual: %0.3f\n', itr, RES)

        if RES < tol
            fprintf('Vanless Diffuser calcs converged: Iterations: %d | Final residual: %0.6f\n', itr, RES)
            break
        elseif itr == itrmx
            fprintf('Max iterations reached\n')
        end
        rho3 = rho3_n;

    end

    %% []:Output
    design.vldiff.D3    = D3;       % [m]      Outlet diameter
    design.vldiff.V3    = V3;       % [m/s]    Outlet velocity
    design.vldiff.PT3 = PT3;    % [Pa]     Isentropic total pressure
    design.vldiff.P3  = P3;     % [Pa]     Isentropic static pressure
    design.vldiff.TT3is = TT3is;    % [K]      Isentropic total temperature
    design.vldiff.TT3   = TT3;      % [K]      Real total temperature
    design.vldiff.T3    = T3;       % [K]      Real static temperature
    design.vldiff.T3is  = T3is;       % [K]      Real static temperature
    design.vldiff.cf    = cf;       % []       Friction coefficent
    design.vldiff.rho3  = rho3;     % [kg/m^3] Density
    design.vldiff.M3    = M3;       % []       Real absoulte Mach number
    design.vldiff.dh    = dh;       % [J/kg]   Enthalpy losses
    design.vldiff.b3    = b3;       % [m]      "Blade height"

    result = design;


end
