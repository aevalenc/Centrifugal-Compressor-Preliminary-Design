# Centrifugal-Compressor-Preliminary-Design
A preliminary design code for centrifugal compressors

This MATLAB code was written for a school project. Using some basic thermodynamic and fluid mechanics concepts, a design process was developed for a centrifugal compressor. 

The code assumes the following knowns at the design stage
  1. Inlet total pressure
  2. Inlet total temperature
  3. Operating mass flow rate
  4. Desired pressure ratio
  
Exducer diameter and rotational speed are determined by the Balje or Cordier diagram are arguments in the main function file. Once the working fluid is specified and an initial guesss for the end to end efficiency is provided, the code iterates until a design converges. A rudimentary stress analysis is in the works so a material is still required to run the code but will not affect the design.

In addition to the prescibed knowns a few more parameters must be defined.
  1. Surface roughness
  2. Tip clearance
  3. Hub diameter
  
All of these values are specificied in an input text file, inputs.txt.

Example function execution

Ds  = 4;            % Specific Diameter
Oms = 0.6;          % Specific Speed
eta = 0.8;          % Guess end to end efficiency
fluid = 'air.txt';  % Working fluid
mat = 'Steel';      % Compressor material

design = main('Preliminary', Ds, Oms, eta, fluid, mat);
