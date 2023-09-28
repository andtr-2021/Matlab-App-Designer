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

Create a pop up window for the 3D graph:
```
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
```
Input Roll and Pitch angle into the graph:
```
 if (time-time_start) >= 20

        time_start = time;

        th1 = 0;
        th2 = data(2); % roll
        th3 = data(3); % pitch
       
        R1 = [  cosd(th1), -sind(th1), 0;
            sind(th1),  cosd(th1), 0;
            0, 0, 1];
        R2 = [  1, 0, 0;
            0, cosd(th2), -sind(th2);
            0, sind(th2),  cosd(th2)];
        R3 = [  cosd(th3), 0, sind(th3);
            0, 1, 0;
            -sind(th3), 0, cosd(th3)];

        e1_pr = R3*R2*R1*e1;
        e2_pr = R3*R2*R1*e2;
        e3_pr = R3*R2*R1*e3;
        
        set(p1, 'XData', [O(1), e1_pr(1)], ...
            'YData', [O(2), e1_pr(2)], ...
            'ZData', [O(3), e1_pr(3)])
        set(p2, 'XData', [O(1), e2_pr(1)], ...
            'YData', [O(2), e2_pr(2)], ...
            'ZData', [O(3), e2_pr(3)])
        set(p3, 'XData', [O(1), e3_pr(1)], ...
            'YData', [O(2), e3_pr(2)], ...
            'ZData', [O(3), e3_pr(3)])
        set(p4, 'XData', [O(1), -e2_pr(1)], ...
            'YData', [O(2), e2_pr(2)], ...
            'ZData', [O(3), -e2_pr(3)])
```

