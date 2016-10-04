%Started a class definition. It is by no means efficient and I am no Matlab 
%wiz so feel free to change stuff. I could not figure out how to get SE2 
%class to work in here so I rewrote certain functions of it in here. I did
%not want to just call SE2 incase later in the project we need to access
%the internal components of g.
%Since the displacements and number of configations is constant it should be fine.

%Basically the class takes in 2 vectors of 3 elements each.
%The elements consist of the unknown angles at the joints. The displacement of each
%frame is constant so I just programmed it in.
%The constructor inputs will be fk(left foot angles, right foot angles)
%starting from top to bottom of the leg.

%To call the function you first type 'g = fk(l,r)' where l and r are the 2 vectors. Then
%type 'waist(g)' and it returns the Left foot w.r.t. waist followed by the
%right foot. 

%I have included a script file on the drive the computes the frames using
%both the SE2 class and this classdef to show that the results are the
%same. My notation is written so that 'gHB' is B in H's Frame. 



classdef fk < handle
    properties (Access = protected)
        a1; a2; a3; 
        b1; b2; b3;
        Q1; Q2; Q3; 
        Q4;; Q5; Q6;
    end
    methods
        function g = fk(l,r)    % l is Left Foot angles/ r is Right Foot angles
             g.Q1 = eye(3); g.Q2 = eye(3);
             if (nargin == 0)
                g.a1 = eye(3);g.b1 = eye(3);
                g.a2 = eye(3);g.b2 = eye(3);
                g.a3 = eye(3);g.b3 = eye(3);   
             else
                % Left Side
                g.a1 = [cos(l(1)), -sin(l(1)), 9.4;... % Knee in Waist Frame
                    sin(l(1)), cos(l(1)), 0; 0, 0, 1];
                g.a2 = [cos(l(2)), -sin(l(2)), 12;...  % Ankle in Knee Frame
                    sin(l(2)), cos(l(2)), 0; 0, 0, 1];
                g.a3 = [cos(l(3)), -sin(l(3)), 6;...   % Foot in Ankle Frame
                    sin(l(3)), cos(l(3)), 0; 0, 0, 1];
                % Right Side
                g.b1 = [cos(r(1)), -sin(r(1)), 9.4;... % Knee in Waist Frame
                    sin(r(1)), cos(r(1)), 0; 0, 0, 1];
                g.b2 = [cos(r(2)), -sin(r(2)), 12;...  % Ankle in Knee Frame
                    sin(r(2)), cos(r(2)), 0; 0, 0, 1];
                g.b3 = [cos(r(3)), -sin(r(3)), 6;...   % Foot in Ankle Frame
                    sin(r(3)), cos(r(3)), 0; 0, 0, 1];
             end
        end
        
%         function display(g)
% 
%             disp(g.a1); 
%             disp(g.a2);
%             disp(g.a3);
%             disp(g.Q);
% 
%         end 


    function g2 = calculations(g)
       %Calculating Left Foot in Waist Frame
       g1.Q1 = fk(); g2.Q1 = fk();  % Initializing
       mult1 = [g.a1(1:2,1:2)*g.a2(1:2,1:2), g.a1(1:2,3)+g.a1(1:2,1:2)*g.a2(1:2,3); 0, 0, 1];    % Ankle in Waist Frame
       g1.Q1= mult1;
       mult2 = [g1.Q1(1:2,1:2)*g.a3(1:2,1:2), g1.Q1(1:2,3)+g1.Q1(1:2,1:2)*g.a3(1:2,3); 0, 0, 1]; % Waist in Left Foot Frame
       g2.Q1 = mult2;
       
       %Calculating Right Foot in Waist Frame
       g1.Q2 = fk();g2.Q2 = fk();   % Initializing
       mult3 = [g.b1(1:2,1:2)*g.b2(1:2,1:2), g.b1(1:2,3)+g.b1(1:2,1:2)*g.b2(1:2,3); 0, 0, 1];   % Ankle in Waist Frame
       g1.Q2= mult3;
       mult4 = [g1.Q2(1:2,1:2)*g.b3(1:2,1:2), g1.Q2(1:2,3)+g1.Q2(1:2,1:2)*g.b3(1:2,3); 0, 0, 1]; % Waist in Right Foot Frame
       g2.Q2 = mult4;
       
       %Calculating Waist in Left Foot Frame
       g2.Q3 = fk();
       inverse_wL = [g2.Q1(1,1), g2.Q1(2,1), -g2.Q1(1,1)*g2.Q1(1,3)-g2.Q1(2,1)*g2.Q1(2,3);...   % Inverse of Left Foot in Waist Frame
            g2.Q1(1,2), g2.Q1(2,2), -g2.Q1(1,2)*g2.Q1(1,3)-g2.Q1(2,2)*g2.Q1(2,3); 0, 0, 1]; 
       g2.Q3 = inverse_wL;
       
       % Calculating Waist in Right Foot Frame
       g2.Q4 = fk();
       inverse_wR = [g2.Q2(1,1), g2.Q2(2,1), -g2.Q2(1,1)*g2.Q2(1,3)-g2.Q2(2,1)*g2.Q2(2,3);...   %Inverse of Right Foot in Waist Frame
            g2.Q2(1,2), g2.Q2(2,2), -g2.Q2(1,2)*g2.Q2(1,3)-g2.Q2(2,2)*g2.Q2(2,3); 0, 0, 1]; 
       g2.Q4 = inverse_wR;
      
       % I had trouble with the following section because this is a planar case and
       % we are looking at the bot from the side so I made the Left snd
       % Right foot overlap with different angle inputs. This works fine
       % w.r.t. the waist, but it does not work for Left Foot vs Right
       % Foot. There is no configuration showing the difference in
       % displacement between the two feet without going through the waist
       % and this causes the displacement between the two feet to remain
       % unchanged. 
       
       
       % Calculating Right Foot in Left Foot Frame
       g2.Q5 = fk();
       inverse_aL = [g.a3(1,1), g.a3(2,1), -g.a3(1,1)*g.a3(1,3)-g.a3(2,1)*g.a3(2,3);... %Inverse of Left Foot in Ankle Frame
            g.a3(1,2), g.a3(2,2), -g.a3(1,2)*g.a3(1,3)-g.a3(2,2)*g.a3(2,3); 0, 0, 1];
       mult6 = [inverse_aL(1:2,1:2)*g.b3(1:2,1:2), inverse_aL(1:2,3)+inverse_aL(1:2,1:2)*g.b3(1:2,3); 0, 0, 1]; % Left Foot in Right Foot Frame
       g2.Q5 = mult6;
       
       % Calculating Left Foot in Right Foot Frame
       g2.Q6 = fk();
       inverse_LR = [g2.Q5(1,1), g2.Q5(2,1), -g2.Q5(1,1)*g2.Q5(1,3)-g2.Q5(2,1)*g2.Q5(2,3);...   %Inverse of Left Right Foot in Left Foot Frame
            g2.Q5(1,2), g2.Q5(2,2), -g2.Q5(1,2)*g2.Q5(1,3)-g2.Q5(2,2)*g2.Q5(2,3); 0, 0, 1];
       g2.Q6 = inverse_LR;
    end
    
    %I could not figure out how to write functions in here using an SE2 
    %style config with only angles as inputs and to make independent g's so
    %I wrote a calculation function where I computed all of the forward
    %kinematics. This made it so that I could take the inverse of functions easier. 
    %It is by no means the most efficient method, but it does compute
    %things correctly because I checked it with the SE2 class
    
    %Waist as Origin Frame
    function waist(g)
       temp = calculations(g);
       disp('Left Foot in Waist Frame')
       disp(temp.Q1); % Displaying matrix
       
       disp('Right Foot in Waist Frame')
       disp(temp.Q2); % Displaying matrix
    end
    %Left Foot as Origin Frame
    function left(g)
        temp = calculations(g);
        disp('Waist in Left Foot Frame')
        disp(temp.Q3);
        disp('Right Foot in Left Foot Frame')
        disp(temp.Q5);
    end
    %Right Foot at Origin Frame
    function right(g)
        temp = calculations(g);
        disp('Waist in Right Foot Frame')
        disp(temp.Q4);
        disp('Left Foot in Right Foot Frame')
        disp(temp.Q6);
    end
    end
end