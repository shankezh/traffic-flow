This project is used for individual disseration.
To siplified say, this project achieves general solution for numerical solution of LWR with Riamann problem form, fundamental diagram for mixed traffic flow with platoon intensity (consider CACC, ACC and IDM models).

The files structures:
-general: the general solution for numerical soultion of LWR
--LDformula: subfile, density condition
--WAVE: subfile, records the shockwave or refaction wave and interaction points
--getColorByDensity: subfile, color mapping
-FDs: fundamental diagram for mixed traffic flow

![image](https://github.com/user-attachments/assets/70dfc7b0-990b-4567-be2d-17251162221b)

How to start for general solution:
for example, the initial condition as below:
k(0, x) = 0.1,  0<x<1
          0.5,  1<x<2
          0.3,  2<x<3
          0.5,  3<x<4
          0.7,  4<x<5
          0.9,  5<x<6 
## refill below code to match initial condition ##
ldfor = LDFormula();
ldfor.insert(0.1, "inf", 1);
ldfor.insert(0.5, 1, 2);
ldfor.insert(0.3, 2, 3);
ldfor.insert(0.5, 3, 4);
ldfor.insert(0.7, 4, 5);
ldfor.insert(0.9, 5, "inf");

## run scrpit directly general.m

How to start for fundamental diagram
the fundamental diagram is achieved in the FDs.m, that include many different conditions for FD, so please attention %% symbols, it shows different conditons

![image](https://github.com/user-attachments/assets/a5f9852d-4b01-4111-b7a4-ffaedb0a8f46)
