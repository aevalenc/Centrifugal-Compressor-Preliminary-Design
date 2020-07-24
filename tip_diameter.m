%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Minimization function
%% Update: 24 July, 2020
%{
 % This function takes initial design parameters and calculates the inlet
 %  tip diameter minimizing the relative velocity function. This comes 
 % 	from the fact that for a centrifugal compressor we want to minimize 
 % 	the relative Mach number. MATLAB's built in optimization function 
 % 	fmincon is utilized.
 %
 %      The following are inputs:
 %
 %          mdot  : The inlet mass flow rate
 %          rho   : Inlet density
 %          Dhub  : Hub diameter
 %          w     : rotational speed
 %          Dlimit: Max diameter limit
 %
 %      The following are outputs:
 %
 %          Dtip: Inlet tip diameter
%}

function Dtip = tip_diameter(mdot, rho, Dhub, D2, w)

    %% [A]:Define Function to be Minimized
    func = @(Dtip) w^2 * Dtip^2/4 + (mdot / (rho * pi/4 * (Dtip^2 - Dhub^2)))^2;
    
    %% [B]:Initial guess
    D0 = Dhub + 0.001;

    %% [C]:Inequality Constraints
    A = [];
    b = [];

    %% [D]:Equality Constraints
    Aeq = [];
    beq = [];

    %% [E]:Upper & Lower bounds
    lb = 0.5 * D2;
    ub = 0.7 * D2;

    %% [F]:Solve for Minimum
    options = optimset('Display','off');
    Dtip = fmincon(func, D0, A, b, Aeq, beq, lb, ub,[],options);

end
