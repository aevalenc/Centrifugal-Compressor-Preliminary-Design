%% Author: Alejandro Valencia
%% Centrifugal Compressor Preliminary Design
%% Calculate Coefficient of Friction
%% Update: 24 July, 2020
%{
 % This function uses Newton's method to solve for the Colebrook equation 
 % 	in order to calculate the friction coefficient for a specific Reynolds
 %  number and relative roughness
 %
 % The following are the inputs:
 %
 % 		   Re: Reynolds number
 % 		rel_e: relative roughness
 %
 % The following are the outputs:
 %
 % 			f: coefficient of friction
%}

function f = moody(Re,rel_e,varargin)

    % Setting a maximum iteration and a tolerance is an option. If the user
    %   does not specify any values the function will set a default.
    if nargin == 2
        itrmx = 3;
        tol   = 1e-6;
        monit = 'no';
    else
        itrmx = varargin{1};
        tol   = varargin{2};
        monit = varargin{3};
    end
    
    %% [A]:Determine Flow Regime
    if Re <= 2300
        
        %% Laminar Flow
        f = 64 / Re;
        
    elseif Re < 4000
        
        %% Transitional Phase
        fprintf('WARNING flow is in the transitional phase. Cannot accurately calculate friction coefficient')
        f = 0;
    else
        %% Fully Turbulent
        %% [B]:Define Parameters
        A = rel_e / 3.7;
        B = 2.51 / Re;
        
        %% [C]:Set Initial Guess
        % Newton's method is an iterative one so we need to set an initial
        %  guess. In 1983, S. E. Haaland developed an explicit relationship
        %  to approximate the friction coefficient.
        x0 = -1.8 * log10((6.9/Re) + A^1.11);
        
        %% [D]:Define Functions
        y  = @(x) x + 2 * log10(A + B*x);
        yp = @(x) 1 + 2 * B/log(10) / (A + B*x);
        
        %% [E]:Iterate
        for itr = 1:itrmx
            xn  = x0 - y(x0)/yp(x0);
            RES = abs(xn - x0);
            
            if strcmp(monit,'yes') == 1
                fprintf('Iteration: %d | Residual: %0.6f\n', itr, RES)
            end
            
            if RES < tol && strcmp(monit,'yes') == 1
                fprintf('\nSolution converged in %d iterations\n',itr)
                break
            elseif RES > 1e6
                fprintf('WARNING solution diverging\n')
                break
            end
            
            x0 = xn;
            
        end
        
        f = 1 / x0^2;
    
    end
    
   


end







