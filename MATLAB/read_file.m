%% Author: Alejandro Valencia
%% Centrifugal Compressor Design
%% Read file
%% Update: 24 July, 2020
%{
 % This function reads a file and stores the data values as an
 %  array
 %
 % The following are inputs:
 %
 %          filename: File that contains all the necessary
 %                    givens to design the compressor
%}

function inputs = read_file(filename)

    %% [A]:Open File
    fp     = fopen(filename, 'r');
    fspec  = '%f';
    
    %% [B]:Scan Text File
    inputs = textscan(fp, fspec, 'CommentStyle', '%');
    inputs = inputs{1};
    
    %% [C]:Close File
    fclose(fp);

end