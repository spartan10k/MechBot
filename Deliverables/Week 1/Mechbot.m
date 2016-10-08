%================================== Mechbot ==================================
%
%  class Mechbot
%
%  bot = Mechbot(waist, rfoot, lfoot)
%
%
%  This is currently a planar implementation of making calculations about
%  the mechbot's kinematics.
%
%================================== Mechbot ==================================
classdef Mechbot < handle


properties (Access = public)%Not protected, but I didn't know any other solution.
  a1, a2, a3; 
  b1; b2; b3;
  d1; d2; d3;
  d4; d5; d6;
  
end

%
%========================= Public Member Methods =========================
%

methods 

  %-------------------------------- Mechbot --------------------------------
  %
  %  Constructor for the class, parameters given are angles for 
  %
  function bot = Mechbot(L, R) 
  %L and R are 3x1 vectors containing angles of the waist-knee,
  %knee-ankle, and ankle-foot frame changes.
    d1 = [9.4;0]; d2 = [12;0]; d3 = [6;0];
    d4 = [9.4;0]; d5 = [12;0]; d6 = [6;0];
  if (nargin == 0)
    bot.a1 = SE2(d1, 0);  %waist to left knee
    bot.a2 = SE2(d2, 0);   %left knee to left ankle
    bot.a3 = SE2(d3, 0);    %left ankle to left foot
    bot.b1 = SE2(d4, 0);  %waist to right knee
    bot.b2 = SE2(d5, 0);   %right knee to right ankle
    bot.b3 = SE2(d6, 0);    %right ankle to right foot

  else
    bot.a1 = SE2(d1, L(1));   %waist to left knee
    bot.a2 = SE2(d2, L(2));    %left knee to left ankle
    bot.a3 = SE2(d3, L(3));     %left ankle to left foot
    bot.b1 = SE2(d4, R(1));   %waist to right knee
    bot.b2 = SE2(d5, R(2));    %right knee to right ankle
    bot.b3 = SE2(d6, R(3));     %right ankle to right foot

  end

  end
  
  function [config1, config2] = calculations(bot, k)
      while(k < 0 || k > 2)                                 %Verify correct k parameter
          prompt = 'Input an integer value between 0 and 2: ';
          k = input(prompt);
      end
      if (k == 0)                                           %check if waist origin
          config1 = bot.a1*bot.a2*bot.a3;                   %waist-left foot
          config2 = bot.b1*bot.b2*bot.b3;                   %waist-right foot
      elseif (k == 1)                                       %check if left foot origin
          config1 = inv(bot.a3)*inv(bot.a2)*inv(bot.a1);    %left foot-waist
          config2 = config1*bot.b1*bot.b2*bot.b3;           %left-foot-right foot
      elseif (k == 2)                                       %check if right-foot origin
          config1 = inv(bot.b3)*inv(bot.b2)*inv(bot.b1);    %right foot-waist
          config2 = config1*bot.a1*bot.a2*bot.a3;           %left-foot-right foot
      end
  end
  
  function display(bot)
      hold on
      xLeft = zeros(4,1);   %x coordinates for left leg
      xLeft(2) = getLength(bot.a1)*cos(getRotationAngle(bot.a1)); 
      xLeft(3) = xLeft(2)+12*cos(getRotationAngle(bot.a2));
      xLeft(4) = xLeft(3)+6*cos(getRotationAngle(bot.a3));
      yLeft = zeros(4,1);   %y coordinates for left leg
      yLeft(2) = 9.4*sin(getRotationAngle(bot.a1)); 
      yLeft(3) = yLeft(2)+12*sin(getRotationAngle(bot.a2));
      yLeft(4) = yLeft(3)+6*sin(getRotationAngle(bot.a3));
      xRight = zeros(4,1);  %x coordinates for right leg
      xRight(2) = 9.4*cos(getRotationAngle(bot.b1));
      xRight(3) = xRight(2)+12*cos(getRotationAngle(bot.b2)); 
      xRight(4) = xRight(3)+6*cos(getRotationAngle(bot.b3));
      yRight = zeros(4,1);  %y coordinates for right leg
      yRight(2) = 9.4*sin(getRotationAngle(bot.b1));
      yRight(3) = yRight(2)+12*sin(getRotationAngle(bot.b2)); 
      yRight(4) = yRight(3)+6*sin(getRotationAngle(bot.b3));
      plot(xLeft, yLeft,'b','LineWidth',2);
      plot(xRight, yRight,'r','LineWidth',2);
      hold off
%Note that this is a crude representation of the planar model. The region
%should technically be rotated by 90 degrees due to the actual orientation
%of the mechbot, but I'm certain this can be rectified. Please edit if you
%can fix this or have any optimztion you can implement. 
  end
  
  %------------------------- getLength -------------------------
  %
  %  Get the link length of the frame/object.
  %
  %
  function Lx = getLength(x)
      Lx = x.getTransition();
%       if (x(5) == 'a')
%           
%         if (x(6) == '1')
%             Lx = d1(1);
%         elseif(x(6) == '2')
%             Lx = d2(2);
%         elseif(x(6) == '3')
%             Lx = d3(3);
%         end
%         
%       else
%           if(x(6) == '4')
%              Lx = d4(4);
%            elseif(x(6) == '5')
%              Lx = d5(5)
%            elseif(x(6) == '6')
%              Lx = d6(6);
%           end
%       end
   end  
end

end