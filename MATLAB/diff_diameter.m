%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Wedge Diffuser Diameter
%% Update: 24 July, 2020
%{
 % This function calculates the vaned diffuser diameter. This function is
 %  based on the assumption that the outlet angle of the vanless diffuser
 %  is the angle of the suction side of the diffuser wedge.
%}

function result = diff_diameter(design)

    global alp r th w

    %% [A]:Givens
    % Grab the necessary values from the design
    alp = design.vldiff.V3.ang;         % [deg] Vanless diffuser outlet angle
    r   = design.vldiff.D3 / 2;         % [m]   Vanless diffuser radius
    th  = design.diff.dvang / 2;        % [deg] Half the divergence angle
    w   = design.vldiff.b3;             % [m]   Diffuser channel width
    LWR = design.diff.LWR;              % []    Diffuser channel length to width ratio

    %% [B]:Solve Geometry
    % The known values provide a fully constrained problem.
    %       Equations                   Variables
    % -----------------------       -------------------
    % (1) Law of cosines                x(1) = x
    % (2) Law of sines                  x(2) = y
    % (3) Law of sines                  x(3) = gamma
    % (4) Angles of triangle            x(4) = delta
    % (5) Angles of triangle            x(5) = beta
    % (6) Angles of line                x(6) = epsilon

    o  = 90 - th;
    f1 = @(x) x(1)^2 + x(2)^2 - 2*x(1)*x(2)*cosd(x(4)) - w^2;
    f2 = @(x) w * sind(x(3)) / sind(x(4)) - x(1);
    f3 = @(x) sind(x(5)) / sind(x(6)) * r - x(2);
    f4 = @(x) x(3) + x(4) + o - 180;
    f5 = @(x) x(4) + x(6) + alp - 180;
    f6 = @(x) 2*x(6) + x(5) - 180;

    % System of equaitons
    fsys = @(x) [f1(x), f2(x), f3(x), f4(x), f5(x), f6(x)];
    x0 = ones(1,6);
    options = optimset('Display','off');
    x = fsolve(fsys,x0,options);

    %% [C]:Calculate Remaining Geometric Values
    d  = LWR * w;               % [m] Diffuser channel length
    h  = d / cosd(th);          % [m] Diffuser channel length projected
    L  = x(1) + h;              % [m] Total length of suction side
    cp = L * sind(alp);         % [m] Length suction side to radial direction
    e  = cosd(alp) * L;         % [m] Length from cp to radial direction

    R  = sqrt(cp^2 + (r+e)^2);  % [m] Radius of vaned diffuser

    %% [D]:Output
    design.diff.D4 = 2*R;
    design.diff.D2tD4 = design.diff.D4 / design.comp.D2;
    result = design;

end
