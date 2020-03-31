
%% CONNECT INSTRUMENTS
delete(instrfind)
clear;

force_gauge = serial ('COM6');
force_gauge.Baudrate = 115200;
fopen(force_gauge);

step_motor = serial('COM7');
fopen(step_motor);
step_motor.RecordDetail = 'Verbose';
record(step_motor)

%% USER INPUT VARIABLES
alarm_force = 25; % Force (N) to trigger the alarm
approach_velocity = 1 % enter approach velocity in mm/s
retract_velocity = 2 % enter retract velocity in mm/s
start_position = 115000 % IMPORTANT start position in pulses
distance = 15 % distance to move in mm
reading delay = 0.25; % time between collected data points.. 0.25 = 4 reading/s
%% INITIZIALIZATION
retract_velocity_pulse = retract_velocity*566;
retract_distance_pulse = distance*566;
paused = false;
pause_time = 0;
pause_target = 0;
retract = true;
test_done = false;

data = zeros (10,1);
count = 1;

fprintf(step_motor, 'TA 0.1');
fprintf(step_motor, 'TD 0.1');

%% TEST LOOP
while(running_test)

% record force
fprintf(force_gauge,char('?',13,10));
resp = fscanf(force_gauge);
current_force = str2double(resp(1:end-3));

data(count) = current force;
count = count+1;

% alarms
if current_force > alarm_force % alarm function that quits the program to save the force gauge
test_done=true
fprintf(step_motor,'ABORT');
pause (0.01);
fprintf(step_motor, 'DIS -20000');
fprintf(step_motor, 'MI');
disp ('ERROR: FORCE OVERLOAD. RETRACTING AND QUITTING')
pause (20);
delete(instrfind)
end

if current_force<(-1*alarm_force)
test_done=true
fprintf(step_motor,'ABORT');
pause(0.01);
fprintf(step_motor, 'DIS 1000');
fprintf(step_motor, 'MI');
disp ('ERROR: NEGATIVE FORCE OVERLOAD. PUSHING AND QUITTING')
delete(instrfind);
end
%--

% test states. add additional states such as approach and dwell for more
% complex testing

if ~paused && retract
disp ('Pulling Surfaces Apart')
pause (0.01);
fprintf(step_motor, 'VS %s\n', num2str(retract_velocity_pulse));
pause (0.01);
fprintf(step_motor, 'VR %s\n', num2str(retract_velocity_pulse));
pause (0.01);
fprintf(step_motor, 'MA %s\n', num2str(start_position - retract_distance_pulse ) )

pause_target = (4+ double(distance)/double(retract_velocity))
retract=false;
paused=true;
test_done=true;

elseif ~paused && test_done
running_test = false;

elseif paused
pause_time = pause_time+1;
if pause_time >=pause target
paused=false;
pause_time=0;
end
end
pause(reading_delay);
end
%% POST TEST DATA WRITING
writematrix(data, ['data/',datestr(now,'mm-dd-yyyy-HHMM'), 'testname.csv')];
disp('TEST DONE')