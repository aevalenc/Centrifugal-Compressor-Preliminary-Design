%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Start: 26 March, 2020
%% Update: 28 March, 2020
%{
 % This function calculates an outlet blade height and density that
 % 	satisfies continuity by iterating on the efficiency. Once the 
 % 	efficiency has converged, the function stops and returns the 
 % 	aforementioned values along with the thermodynamic properties at the 
 % 	outlet. The efficiency is corrected by calculating various losses.
 %
 % The following are inputs:
 %
 %          inlet : Structure containing inlet quantities
 %          outlet: Structure containing outlet quantities
 %          l_eul : Eulerian work based on baseline efficiency
 %          itrmx : Max iterations
 %          tol   : Tolerance
 %
 % The following are outputs:
 %
 %          outlet: Structure containing all the thermofluid properties at
 % 					the outlet
 %          beta1 : The geometic flow angles at the inlet
 %              Nb: Number of blades
%}

function [outlet,beta1,Nb] = optimize_mass_flow(inlet, outlet, l_eul, itrmx, tol)

    global mdot TT1 Rh cp y mu eps rgh ki

    %% []:Initalize
    % Assume an isentropic process for the rotor to begin the iteration
    %   process. This process is to converge to the real pressure at the
    %   outlet of the compressor.
    eta_0 = 1;
    D1    = inlet.D1;
    D2    = outlet.D2;
    U2    = outlet.U2;
    V2    = outlet.V2;
    W2    = outlet.W2;

    for itr = 1:itrmx

        %% [A]:Total & Static Temperature
        TT2is = TT1 + l_eul * eta_0 / cp;       % [K] Total temperature
        T2is  = TT2is - V2.mag^2 / (2*cp);      % [K] Static temperature

        % Mach Numbers
        M2is  = V2.mag / sqrt(y * Rh * T2is);   % [] Absolute Mach number

        %% [B]:Isentropic Outlet Pressure
        P2  = inlet.P1 * (T2is / inlet.T1) ^ (ki);  % [Pa] Static pressure
        PT2 = P2 * (1 + (y-1)/2 * M2is^2) ^ (ki); % [Pa] Total pressure


        %% [C]:Density & Blade Height
        rho2 = P2 / (Rh * T2is);                % [kg/m^3]
        b2   = mdot / (rho2 * pi * D2 * V2.rad);% [m]


        %% [D]:Check Stability
        rbD = b2 / (D2/2);                      % [] Blade to outlet diameter ratio


        %% [E]:Average Beta
        % To calculate the average flow deflection use the midspan inlet
        %  relative angle
        beta_avg = (W2.ang + inlet.W1.mid.ang) / 2; % [deg]


        %% [F]:Number of Blades
        % Before continuing we define the solidity. Theory and practice tell
        %  us to keep 1/solidity = 0.4. For the number of blades we round up
        %  and add 1 blade to minimize the blade loading. The pitch and chord
        %  are also calculated.
        oi = 0.4;                                               % []  Inverse of solidity
        Nb = 2 * pi * cosd(beta_avg) / (oi * log(D2/D1.mid));   % []  Number of blades
        Nb = ceil(Nb) + 1;                                      % []  No. of blades rounded up
        s  = pi * D2 / Nb;                                      % [m] Pitch
        % ch = s / oi;                                            % [m] Chord


        %% [G]:Slip Factor & Freestream Velocity
        muslip = 1 - 0.63 * pi / Nb;            % []
        V2.inf = (1 - muslip) * U2 + V2.tan;    % [m/s] Absolute
        W2.inf = V2.inf - U2;                   % [m/s] Relative


        %% [H]:Geometric Outlet Angle
        beta2_geo = atand(W2.inf / W2.rad);


        %% [I]:Calculate Losses
        %% [I.1]:Geometric Inlet Angle
        % We first analyze the losses due to having a difference in the
        %  geometrical outlet angle and the fluid outlet angle. Here we 
		% 	need the thickness of our blade that is assumed for now.
        th    = 0.002; 	% [m] Thickness of our blade
		beta1 = geometric_inlet_angle(inlet,Nb,th);
        in    = (beta1.hub - inlet.W1.hub.ang);
        dhin  = (inlet.W1.hub.mag * sind(in)) ^ 2 / 2;

        %% [I.2]:Tip Clearance Losses
        % From paper provided by Gaetani we found the following relation to
        %   calculate tip losses. The tip clearance was also found via
        %   other papers to be roughly 2% of the exit blade height
        if eps == 0
            eps = 0.02 * b2;
        end
        dhcl = 0.6 * eps / b2 * V2.tan * sqrt( 4*pi/(b2*Nb) * ...
            ceil((D1.tip^2/4 - D1.hub^2/4)/((D2/2 - D1.tip/2)*(1 + rho2 / inlet.rho1))) * ...
            V2.tan * inlet.V1.mid.axl ...
        );


        %% [I.3]:Blade Losses
        L      = (D2/2 - D1.mid/2) / cosd(beta_avg);            % [m]     Hydraulic Length
        W1.avg = (inlet.W1.hub.mag + inlet.W1.mid.mag ...
               + inlet.W1.tip.mag)/3;                           % [m/s]   Average relative inlet velocity
        D      = 1 - W2.mag/W1.avg ...
               + (pi * D2 * V2.tan) / (2 * Nb * L * W1.avg) ...
               + 0.1 * (D1.tip/2 - D1.hub/2 + b2) / ...
                 (D2/2 - D1.tip/2) * (1 + W2.mag/W1.avg);       % []      Diffusion Factor
        dhdiff = 0.05 * D^2 * U2^2;                             % [J/kgK] Change in enthalpy


        %% [I.4]:Frictional Losses
        % We first calculate our outlet perimeter and area. Remember that the
        %   outlet of a centrifugal machine is rectangular. With these two
        %   quantities we define our hydraulic diameter which will be used to
        %   determine our flow regime via Reynolds number.
        S2    = pi * D2 * b2;                   % [m^2] Outlet flow area
        Per2  = Nb * (2*b2 + 2*s);              % [m]   Outlet flow perimeter
        D_hyd = 4 * S2 / Per2;                  % [m]   Hydraulic diameter
        Re    = rho2 * W2.mag * D_hyd / mu;     % []    Reynolds number

        % Enthalpy increase
        rel_e  = rgh / D_hyd;                   % [] Relative roughness
        cfm    = moody(Re,rel_e);               % [] Call moody diagram
        cf     = cfm + 0.0015;                  % [] Adjusted friction coefficient
        dhfric = 4 * (cf * L * W2.mag^2) / (2*D_hyd);


        %% [J]:Calculate New Efficiency
        sumdh = dhdiff + dhfric + dhcl + dhin;  % [J/kgK] Sum of enthalpy losses
        eta_n = (l_eul - sumdh) / l_eul;        % []      New efficiency
        RES   = abs(eta_n - eta_0)/eta_0;       % []      Residual

        % fprintf('Iteration: %d | Residual: %0.4f\n', itr, RES)

        if RES < tol
            fprintf('Outlet calculations converged in %d iterations w/ residual %0.6f\n', itr,RES)
            break
        end

        %% [K]:New Total Enthalpy Change & Eulerian Work
        his_n = l_eul * eta_n;          % [J/kg] New isentropic work
        eta_0 = eta_n;                  % []     Set new efficiency to old

    end

    %% [L]:Output
    outlet.beta2_geo = beta2_geo;   % [deg]     Geometrical flow angle
    outlet.T2is   = T2is;           % [K]       Static isentropic temperature
    outlet.TT2is  = TT2is;          % [K]       Total isentropic temperature
    outlet.P2     = P2;             % [Pa]      Static real pressure
    outlet.PT2    = PT2;            % [Pa]      Total real pressure
    outlet.eta    = eta_n;          % []        Final efficiency
    outlet.M2is   = M2is;           % []        Absolute isentropic Mach number
    outlet.rbD    = rbD;            % []        Blade to diameter ratio
    outlet.b2     = b2;             % []        Blade height
    outlet.rho2   = rho2;           % [kg/m^3]  Density
    outlet.L      = L;              % [m]       Mean length
    outlet.his_n  = his_n;          % [J/kg]    New isentropic work
    outlet.dhdiff = dhdiff;         % [J/kg]    Diffusion losses
    outlet.dhin   = dhin;           % [J/kg]    Incidence losses
    outlet.D      = D;              % []        Gaetani diffusion factor
    outlet.S2     = S2;             % [m^2]     Exit area
    outlet.in     = in;             % [deg]     Incidence angle
    outlet.muslip = muslip;         % []        Slip factor
    outlet.V2     = V2;
    outlet.W2     = W2;

end





































%         his_n = U2 * V2.tan * eta_n;    % [J/kgK]
%         l_eul = his_n;
