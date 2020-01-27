
%Optimization Test




%% find 0 point manually?

%% configure pressure properties

%fprintf (pneumatics,'<PSP,20>');
%fprintf (pneumatics,'<NSP,-20>');

%% start recording

%% Assign Initial Channel State
disp ('Setting valves to initial state');
% close all ouput valves
for i=0:7
    fprintf (pneumatics, '<VO,%d,0>',i');
end

% close all input valves
for i=0:2
    fprintf (pneumatics, '<VI,%d,0>',i');
end

%open received initial input valves
fprintf (pneumatics, '<VI,%d,1>', initialstate);
%open received initial output valves
fprintf (pneumatics, '<VO,%d,1>', onvalve);

pause(5);

%% move surfaces together
disp('Moving Surfaces together');
 fprintf(step_motor, 'TA 0.1'); % acceleration time (s)
 fprintf(step_motor, 'TD 0.1'); % de-accerleration time (s)
 fprintf(step_motor, 'VS %s \n',num2str(approachrate)); % starting velocity (56 = 10um/s)
 fprintf(step_motor, 'VR %s \n',num2str(approachrate)); % running velocity
 %fprintf(step_motor, 'VR 1000');
%fprintf(step_motor, 'VS 1000');
 fprintf(step_motor, 'DIS 5000'); % distance to travel
 fprintf(step_motor, 'MI'); % start motion

pause (5000/approachrate);

disp ('Surfaces are now together');
pause(1);
%% Set Channels to Test State
disp('Setting Channels to Test State');

% close all ouput valves
for i=0:7
    fprintf (pneumatics, '<VO,%d,0>',i');
end
% close all input valves
for i=0:2
    fprintf (pneumatics, '<VI,%d,0>',i');
end

%open received test input valves
fprintf (pneumatics, '<VI,%d,1>', teststate);
%open received test output valves
fprintf (pneumatics, '<VO,%d,1>', onvalve);

pause (dwelltime);

%% pull surfaces apart
disp ('Pulling surfaces apart');
fprintf(step_motor, 'TA 0.1'); % acceleration time (s)
fprintf(step_motor, 'TD 0.1'); % de-accerleration time (s)
fprintf(step_motor, 'VR %s \n',num2str(retractrate));
fprintf(step_motor, 'VS %s \n',num2str(retractrate));
%fprintf(step_motor, 'VR 1000');
%fprintf(step_motor, 'VS 1000');
fprintf(step_motor, 'DIS -5000'); % distance to travel
fprintf(step_motor, 'MI'); % start motion
pause (5000/retractrate);
disp('Test done!')

