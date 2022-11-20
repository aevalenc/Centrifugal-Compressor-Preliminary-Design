%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Remaining Inlet Calculations
%% Update: 24 July, 2020
%{
 % This function takes initial design parameters and calculates the 
 % 	remaining inlet values.
 %
 % The following are inputs:
 %
 %           inlet: Structure containing the inlet values after the 
 % 				   minimization problem
 %              D1: Structure containing the diameters (hub, mid, tip) for
 %                  the inlet 
 %               w: Rotational Speed
 %
 % The following are outputs:
 %
 %           result: Structure containing the thermofluid properties at the
 %                   inlet
%}

function inlet = inlet_calcs(inlet, D1, w)    

    global y Rh cp TT1 PT1

    %% []: Extract Structures for Ease
    V1 = inlet.V1;

    %% [E]:Remaining Inlet Quantites
    %% [E.2]:Velocity Components, Magnitude, & Angle
    % We have calculated V1 @ the tip. Then assuming a free vortex
    %   method, the hub and tip velocity triangles can be
    %   caluclated.
    %% [E.2.1]:Translational Velocity
    U1.tip = w * D1.tip/2;                          % [m/s]
    U1.mid = w * D1.mid/2;                          % [m/s]
    U1.hub = w * D1.hub/2;                          % [m/s]

    % Relative Velocity Components & Magnitude
    W1.hub.tan = inlet.V1.mid.tan - U1.hub; W1.hub.axl = inlet.V1.mid.axl;    % [m/s]
    W1.hub.mag = sqrt(W1.hub.tan^2 + W1.hub.axl^2);    % [m/s]

    W1.mid.tan = inlet.V1.mid.tan - U1.mid; W1.mid.axl = inlet.V1.mid.axl;    % [m/s]
    W1.mid.mag = sqrt(W1.mid.tan^2 + W1.mid.axl^2);    % [m/s]

    W1.tip.tan = inlet.V1.mid.tan - U1.tip; W1.tip.axl = inlet.V1.mid.axl;    % [m/s]
    W1.tip.mag = sqrt(W1.tip.tan^2 + W1.tip.axl^2);    % [m/s]

    % Relative Velocity Angle
    %  The relative velocity angle is measured from the axial direction. Simply
    %  use MATLAB's function atand().
    W1.hub.ang = atand(W1.hub.tan/W1.hub.axl);    % [deg]
    W1.mid.ang = atand(W1.mid.tan/W1.mid.axl);    % [deg]
    W1.tip.ang = atand(W1.tip.tan/W1.tip.axl);    % [deg]

    %% []:Mach Numbers
    a1 = sqrt(y * Rh * inlet.T1); % [m/s]: Speed of sound

    % Absolute Mach Number
    M1.mid = V1.mid.mag / a1;

    % Relative Mach Number
    M1w.hub = W1.hub.mag / a1;
    M1w.mid = W1.mid.mag / a1;
    M1w.tip = W1.tip.mag / a1;

    %% []:Temperature at Midspan
    T1 = TT1 - V1.mid.mag ^ 2 / (2*cp);

    %% [I]:Output
    inlet.a1   = a1;        % [m/s] Speed of sound
    inlet.V1   = V1;        % [m/s] Absolute velocity
    inlet.M1   = M1;        % []    Absolute Mach number
    inlet.W1   = W1;        % [m/s] Relative velocity
    inlet.M1w  = M1w;       % []    Relative Mach number
    inlet.U1   = U1;        % []    Peripheral speed
    inlet.D1   = D1;        % [m]   Inlet diameters
    inlet.T1   = T1;        % [K]   Midspan temperature
    inlet.TT1  = TT1;       % [K]   Total temperature
    inlet.PT1  = PT1;       % [Pa]  Total pressure


end
