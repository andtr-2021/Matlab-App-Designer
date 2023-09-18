%% Serial Communication 
s = serialport('COM14', 9600);
configureTerminator(s, "CR/LF");

%% Screen and Figure Setup 
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

%% Initialization
data = readline(s)
flush(s);

h2 = animatedline(app.UIAxesOfRollAngle, 'Color', 'b', 'LineWidth', 2, 'MaximumNumPoints', Inf); 

h3 = animatedline(app.UIAxesOfLiftForce, 'Color', 'b', 'LineWidth', 2, 'MaximumNumPoints', Inf);

h4 = animatedline(app.UIAxesOfThrottle1, 'Color', 'b', 'LineWidth', 2, 'MaximumNumPoints', Inf);

h5 = animatedline(app.UIAxesOfThrottle2, 'Color', 'b', 'LineWidth', 2, 'MaximumNumPoints', Inf);


time_start = 0;

%% Loop
while 1
    
    data = str2double(strsplit(readline(s), ','))
    
    %% Collect Data
    %{
    time = data(1) 
    roll = data(2)
    pitch = data(3)
    yaw = data(4)
    loadcell = data(5)
    throttle1 = data(6)
    throttle2 = data(7)
    %}
    
    time = data(1) 

    %% Display Data 
    
    app.timeValue.Text = num2str(data(1)); % time
   
    app.rollValue.Text = num2str(data(2)); % roll

    app.pitchValue.Text = num2str(data(3)); % pitch 

    app.yawValue.Text = num2str(data(4)); % yaw

    app.liftValue.Text = num2str(data(5)); % lift 

    app.throttleValue1.Text = num2str(data(6)); % throttle 1
    
    app.throttleValue2.Text = num2str(data(7)); % throttle 2
    
    %% IMU Orientaion 3D Rendering
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

        timeInSecond = data(1) / 1000                    

        % timeArr = [timeArr, timeInSecond];
        % rollAngleArr = [rollAngleArr, roll];
        % liftForceArr = [liftForceArr, loadcell];
        % throttleOneArr = [throttleOneArr, throttle1];
        % throttleTwoArr = [throttleTwoArr, throttle2];

        % clearpoints(h2);
        % clearpoints(h3);
        % clearpoints(h4);
        % clearpoints(h5);
        
        addpoints(h2, timeInSecond, data(2)); % roll
        addpoints(h3, timeInSecond, data(5)); % lift 
        addpoints(h4, timeInSecond, data(6)); % throttle 1
        addpoints(h5, timeInSecond, data(7)); % throttle 2
       

        drawnow;
    end
end