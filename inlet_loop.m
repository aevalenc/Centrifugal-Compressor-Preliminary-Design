%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Inlet Iteration Loop
%% Update: 24 July, 2020
%{
 % This function takes initial design parameters and calculates the inlet
 % 	tip diameter minimizing the relative velocity function. This comes 
 % 	from the fact that for a centrifugal compressor we want to minimize 
 % 	the relative Mach number to avoid shock waves and flow separation. 
 % 	Once a tip diameter is found the density is caluclated. This is an 
 % 	iterative process where the goal is to find a tip diameter that 
 % 	matches the density based on our given inlet operating conditions.
 %
 %       The following are inputs:
 %
 %           rho0  : Initial density guess
 %           Dhub  : Hub diameter
 %           itermx: Max iterations
 %           tol   : Tolerance
 %           monitor_residual: String either 'yes' or 'no'
 %
 %       The following are outputs:
 %
 %           result: Structure containing the thermofluid properties at 
 % 					 the inlet after converging to the inlet density
 %
 % In order to optimize the tip diameter we begin by choosing a hub
 %   diameter. The optimal tip diameter will be found by minimizing the
 %   relative velocity function (yet to be defined). Recall our golden
 %   vector equation.
 %
 %       V = U + W                               Eq.(1)
 %
 % V in this case is assumed to be axial (very typical). Thus resulting in
 %   the following velocity diagram and equation assuming clockwise
 %   rotation.
 %
 %                               Utip                             axial
 %                            --------->^                           ^
 %                            \         |                           |
 %                             \        |                           |
 %                              \       |                           |------->
 %                               \      |                           tangential
 %                                \     |
 %                       W1tip     \    | V1tip = V1atip = V1
 %                                  \   |
 %                                   \  |
 %                                    \ |
 %                                     \|
 %
 %              W1tip^2 = Utip^2 + V1tip^2      Eq.(2)
 %
 % We can express the translation velocity at the hub in terms of the tip
 %  diameter. The expression for V1tip we obtain through the mass flow rate.
 %  The inlet absolute velocity is given by
 %
 %      V1tip = mdot / (rho * S1)               Eq.(3)
 %
 % Where S1 is the inlet flow area. This can be expressed in terms of our
 %  diameters.
 %
 %      S1 = pi/4 * (Dtip^2 - Dhub^2)           Eq.(4)
 %
 % The translational velocity is simply given by
 %
 %      Utip = w * Dtip / 2                     Eq.(5)
 %
 % Substituting all these expressions into Eq.(2) we derive our relative
 % 	velocity function
 %
 %      W1tip^2 = w^2 * Dtip^2/4 + (mdot / (rho * pi/4 * (Dtip^2 - Dhub^2)))
%}

function result = inlet_loop(rho0, Dhub, w, D2, itrmx, tol)

    global mdot PT1 TT1 cp Rh y

    %% []:Optimization Loop
    for itr = 1:itrmx

        %% [A]:Minimize Inlet Tip Diameter
        Dtip = tip_diameter(mdot, rho0, Dhub, D2, w);    % [m]

        %% [B]:Calculate Flow Inlet Area & Absolute Velocity
        S1     = pi/4 * (Dtip^2 - Dhub^2);      % [m^2]
        V1.mag = mdot / (rho0 * S1);            % [m/s]
        V1.ang = 0;
        V1.axl = V1.mag;
        V1.tan = 0;

        %% [C]:Static Temperature
        T1 = TT1 - V1.mag^2 / (2 * cp); % [K]

        %% [D]:Mach number
        M1 = V1.mag/sqrt(y*Rh*T1);      % []

        %% [E]:Static Pressure
        P1 = PT1 / (1 + (y-1)/2 * M1^2)^(y/(y-1)); % [Pa]

        %% [F]:Recalculate Density
        rho = P1 / (Rh * T1);           %[kg/m^3]

        %% [G]:Check for Convergence
        RES = abs(rho - rho0) / rho0;

        % if strcmp(monitor_residual,'yes') == 1
        %    fprintf('Iteration: %d | Residual %0.6f\n', itr, RES)
        % end

        if RES < tol
            fprintf('Minimization problem converged in %d iterations w/ residual: %0.6f\n', itr,RES)
            break
        elseif RES > 1e6
            fprintf('WARNING solution diverging')
            break
        end

        %% [H]:Reset Density
        rho0 = rho;

    end

    rho1 = P1 / (Rh * T1);


    %% [I]:Output
    result.Dtip   = Dtip; % [m]   Tip diameter
    result.T1     = T1;   % [K]   Static Temperature
    result.M1     = M1;   % []    Absolute Mach number
    result.P1     = P1;   % [Pa]  Static Pressure
    result.V1.mid = V1;   % [m/s] Absolute velocity
    result.S1     = S1;   % [m^2] Inlet flow area
    result.rho1   = rho1;

end
