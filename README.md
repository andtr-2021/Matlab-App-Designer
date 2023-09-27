# Matlab-App-Designer

To set up the seriaml communitcatoin betwen the Matlab App and the microcontroller (MCU), we need to configure the port and the baurd rate:
- s = serialport('COM14', 9600);
- configureTerminator(s, "CR/LF"); // terminated by a CR/LF sequence.
- data = readline(s); // readline funciton to read data from the mcu.
- flush(s); // clear the previous reading

Then in the while loop, configure the readline funciton to read the data:

- data = str2double(strsplit(s , ',')); // seperate the data by the deliminator - comma
- data = data(1) // time 
- data = data(2) // loadcell data
- app.loadcellValue.Text = double2str(data(2)) // display the data on matlab's label

To plot a line graph:

- h2 = animatedline(app.UIAxesOfRollAngle, 'Color', 'b', 'LineWidth', 2, 'MaximumNumPoints', Inf);
- addpoints(h2, timeInSecond, data(2)); % roll

To make a 3D rendering grah for the IMU orientation:
- 1. Create a pop up window for the 3D graph:
 screen_property = get(0,'screensize');
h = figure('outerposition', ...
    [0, screen_property(4)/2, ...
    screen_property(3)/2, screen_property(4)/2]);
grid on; hold on;

O  = [0,0,0]';
e1 = [0,0,1]';
e2 = [1,0,0]';
e3 = [0,1,0]';

p1 = plot3(  [O(1), e1(1)], ...
    [O(2), e1(2)], ...
    [O(3), e1(3)], ...
    'LineWidth',2,'Color','r');
p2 = plot3(  [O(1), e2(1)], ...
    [O(2), e2(2)], ...
    [O(3), e2(3)], ...
    'LineWidth',2,'Color','g');
p3 = plot3(  [O(1), e3(1)], ...
    [O(2), e3(2)], ...
    [O(3), e3(3)], ...
    'LineWidth',2,'Color','b');
p4 = plot3(  [O(1), -e2(1)], ...
    [O(2), e2(2)], ...
    [O(3),-e2(3)], ...
    'LineWidth',2,'Color','b');

% patch([0, 1, 0],[0, 0, 1],[0, 0, 0],'r', 'alpha')
grid on;
view(-30,30); axis equal
xlabel('y','FontSize',16);
ylabel('z','FontSize',16);
zlabel('x','FontSize',16);
xlim([-1,1]);
ylim([-1,1]);
zlim([-1,1]);

