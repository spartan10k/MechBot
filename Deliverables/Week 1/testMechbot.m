m = Mechbot([pi/2;-pi/2;pi/2], [-pi/2;pi/2;-pi/2]);

[a1, b1] = calculations(m, 0);
compare1 = [m.a1*m.a2*m.a3 m.b1*m.b2*m.b3];
[a2, b2] = calculations(m, 1);
compare2 = [inv(m.a3)*inv(m.a2)*inv(m.a1) inv(m.a3)*inv(m.a2)*inv(m.a1)*m.b1*m.b2*m.b3];
[a3, b3] = calculations(m, 2);
compare3 = [inv(m.b3)*inv(m.b2)*inv(m.b1) inv(m.b3)*inv(m.b2)*inv(m.b1)*m.a1*m.a2*m.a3];

[atest, btest] = calculations(m, -1); %check for error in 2nd arg input

display(m);