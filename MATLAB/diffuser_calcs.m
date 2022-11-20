%% Authors: Alejandro Valencia, Shruthi Nandakumar
%% Centrifugal Compressor Preliminary Design
%% Diffuser Calculations
%% Update: 24 July, 2020
%{
 % This function calculates the thermodynamic quantities of the wedge
 % 	diffuser. Theory tells us that max efficiency occurs at a divergence
 % 	angle (2 times theta) between 8 and 10 degrees.
 %
 % The following is the input:
 %
 % 		design: Current design with vanless diffuser
 %
 % The following is the output
 %
 % 		result: Final design with wedge diffuser
%}

function result = diffuser_calcs(design)

    global y Rh cp TT1 PT1 k

    %% []:Grab Required Values From Design
    b3    = design.vldiff.b3;       % [m]      Outlet blade height
    TT3   = design.vldiff.TT3;      % [K]      Outlet real total temperature
    T3    = design.vldiff.T3;       % [K]      Outlet real static temperature
    P3    = design.vldiff.P3;     % [Pa]     Outlet real pressure
    PT3   = design.vldiff.PT3;    % [Pa]     Outlet total pressure


    %% []:Choose Values
    % We start the diffuser design process by choosing certain geometric
    %   parameters. Aungier, in his book, has a table of various diffuser
	% 	specifications. For packaging's sake, the smallest length to width
	%	ratio was chosen with a divergence angle between 8 and 10 degrees.
	% 	In addition, the coefficient of pressure recovery is given for 
	% 	this diffuser. The aspect ratio was taken to be 1 for simplicity.
    LWR   = 8.43;       % []    Length to width ratio for the vaned diffuser
    theta = 9.49 / 2;   % [deg] Half total divergence angle
    AS    = 1;          % []    Channel aspect ratio
    prc   = 0.62;       % []    Pressure recovery coefficient
    eta_d = 0.87;       % []    Diffuser efficiency corresponding to a 2theta = 8 [deg]


    %% []:Thermodynamic Values
    % Because the diffuser is a stationary flow passage there is no work
    %   done to the fluid. Thus, the total temperature remains constant
    %   resulting in:
    %
    %       h03 = h04
    %       TT3 = TT4
    TT4  = TT3;                         % [K]  Total temperature
    P4   = prc * (PT3 - P3) + P3;       % [Pa] Static pressure
    T4is = T3 * (P4 / P3) ^ k;          % [K]  Isentropic static temperature
    T4   = T3 + (T4is - T3) / eta_d;    % [K]  Real static temperature
    rho4 = P4 / (Rh * T4);              % [kg/m^3] Density


    %% [.1]:Losses
    % Looking at a Mollier diagram for points 3 to 4, we notice that the
    %   difference in enthalpy is given by the real value minus the
    %   isentropic one. Thus, our enthalpy loss is given by:
    %
    %       dhloss = h4 - h4is
    % -OR-
    %       dhloss = cp(T4 - T4is)
    dhloss = cp * (T4 - T4is);          % [J/kg] Enthaply drop


    %% [.2]:Continue with remaining thermodynamic values
    TT4is = TT4 - dhloss/cp;            % [K]  Isentropic total temperature
    PT4   = P4 * (TT4is/T4)^(y/(y-1));  % [Pa] Total pressure


    %% []:Velocity
    % Velocity at the outlet can be derived from the total temperature. The
    %   total temperature is the sum of the static temperature plus
    %   V^2/(2cp)
    V4 = sqrt(2 * cp * (TT4 - T4));
    M4 = V4 / sqrt(y * Rh * T4);


    %% []:Final End to End Efficiency
    % Calculate total isentropic enthalpy change [J/kg], then divide by the
    %   Eulerian work of our compressor
    Be     = PT4 / PT1;
    htis   = cp * TT1 * (Be ^ k - 1);
    eta_tt = htis / design.comp.l_eul;

    fprintf('End to end pressure ratio: %0.3f | End to end efficiency: %0.3f\n', Be, eta_tt)

    %% []:Output
    design.diff.T4     = T4;            % [K]      Real static temperature
    design.diff.T4is   = T4is;          % [K]      Isentropic static temperature
    design.diff.TT4    = TT4;           % [K]      Real total temperature
    design.diff.TT4is  = TT4is;         % [K]      Isentropic total tempertature
    design.diff.P4     = P4;            % [Pa]     Static pressure
    design.diff.PT4    = PT4;           % [Pa]     Total pressure
    design.diff.V4     = V4;            % [m/s]    Outlet velocity
    design.diff.M4     = M4;            % []       Absolute Mach number
    design.diff.rho4   = rho4;          % [kg/m^3] Density
    design.diff.Nb     = 6;             % []       Number of diffuser channels
    design.diff.dhloss = dhloss;        % [J/kg]   Enthalpy loss
    design.diff.htis   = htis;          % [J/kg]   End to end enthalpy change
    design.diff.eta_tt = eta_tt;        % []       End to end efficiency
    design.diff.LWR    = LWR;           % []       Diffuser channel length to width ratio
    design.diff.dvang  = 2 * theta;     % [deg]    Total divergence angle
    design.diff.W      = AS * b3;       % [m]      Diffuser channel width
    design.diff.Be     = Be;            % []       End to end pressure ratio

    result = design;


end
