#include "framework.pl".

#const max_step=2.

%% ----- Sys Vars Def -------
%% Template: sys_var(VarName).
%% --------------------------
%% system variable definition for both exogenous and endogenous ones
sys_var(moving).
sys_var(doorLocked).
sys_var(sensorHigh).

%% requirement definition
req_decl(g1d3; g1d3d1; g1d3d2).

%% req_vars(name, sys_vars(var_i, ...))
req_vars(g1d3, sys_vars(moving, doorLocked)).
req_vars(g1d3d1, sys_vars(sensorHigh, moving)).
req_vars(g1d3d2, sys_vars(doorLocked, sensorHigh)).

req_parent_of(g1d3, g1d3d1).
req_parent_of(g1d3, g1d3d2).
	
%% %% G1.3: DoorsLockedWhenMoving
-holds(g1d3, I) :- step(I), sys_status(moving, true, I), sys_status(doorLocked, false, I).

%% %% G1.3.1: SensorHighWhenMoving
-holds(g1d3d1, I) :- step(I), sys_status(moving, true, I), sys_status(sensorHigh, false, I).

%% %% G1.3.2: DoorsLockedWhenSensorHigh
-holds(g1d3d2, I) :- step(I), sys_status(sensorHigh, true, I), sys_status(doorLocked, false, I).


%% ----- Event Def -------
%% Template: 
%% event(Event, I) :- precond.
%% postcond(_, I+1) :- occur(Event, I).
%% --------------------------
event(set_moving, I) :- step(I).
status_trans(sys_status(moving, true, I+1)) :- step(I), step(I+1), occurs(set_moving, I).

event(unset_moving, I) :- step(I).
status_trans(sys_status(moving, false, I+1)) :- step(I), step(I+1), occurs(unset_moving, I).

event(set_doorLocked, I) :- step(I).
status_trans(sys_status(doorLocked, true, I+1)) :- step(I), step(I+1), occurs(set_doorLocked, I).
event(unset_doorLocked, I) :- step(I).
status_trans(sys_status(doorLocked, false, I+1)) :- step(I), step(I+1), occurs(unset_doorLocked, I).

event(set_sensorHigh, I) :- step(I).
status_trans(sys_status(sensorHigh, true, I+1)) :- step(I), step(I+1), occurs(set_sensorHigh, I).
event(unset_sensorHigh, I) :- step(I).
status_trans(sys_status(sensorHigh, false, I+1)) :- step(I), step(I+1), occurs(unset_sensorHigh, I).

%% %% encoding domain
%% -brokenWire :- sensorHigh.
%% sensor2Wire :- sensorHigh.
%% sensorOn :- sensorHigh.

%% sensorHigh :- moving, -brokenWire, sensorOn, sensor2Wire.

%% :- maintain(g1d3).

%% ----- Init -------
%% configuration to show what predicates in output
sys_status(moving, false, 0).
sys_status(doorLocked, false, 0).
sys_status(sensorHigh, true, 0).

#show occurs/2.
#show -holds/2.
%% #show sys_status/3.
%% #show eval/1.
%% #show status_trans/1.
%% #show req/2.


%% ----- check Def -------
show_trace :- -holds(X, I), req(X, goal), step(I).
:- not show_trace.

%% exvar(sensorHigh).

