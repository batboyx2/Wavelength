// F3 - JIP Add Reinforcement Options Action
// Credits: Written by Bismarck
// ====================================================================================

params ["_ftl","_ar","_aar","_rat","_side"];
private ["_found","_i"];
_found = false;
_i = 0;

while {!_found} do {
	_i = _i + 1;
	_found = call compile format["isNil 'grpJIP_%1'",_i];
};

call compile format["grpJIP_%1 = createGroup %2",_i,_side];
_uFTL	= call compile format["unitJIP_%1_1 = grpJIP_%1 createUnit ['B_Soldier_TL_F', getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_1",_i];
_uAR	= call compile format["unitJIP_%1_2 = grpJIP_%1 createUnit ['B_soldier_AR_F', getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_2",_i];
_uAAR	= call compile format["unitJIP_%1_3 = grpJIP_%1 createUnit ['B_Soldier_AAR_F', getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_3",_i];
_uRAT	= call compile format["unitJIP_%1_4 = grpJIP_%1 createUnit ['B_Soldier_LAT_F', getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_4",_i];

[
	[
		[_i,_uFTL,_uAR,_uAAR,_uRAT],
		{
			(_this select 1) setVehicleVarName format["unitJIP_%1_1",(_this select 0)]; (_this select 1) call compile format["unitJIP_%1_1 = _this",(_this select 0)];
			(_this select 2) setVehicleVarName format["unitJIP_%1_2",(_this select 0)]; (_this select 2) call compile format["unitJIP_%1_2 = _this",(_this select 0)];
			(_this select 3) setVehicleVarName format["unitJIP_%1_3",(_this select 0)]; (_this select 3) call compile format["unitJIP_%1_3 = _this",(_this select 0)];
			(_this select 4) setVehicleVarName format["unitJIP_%1_4",(_this select 0)]; (_this select 4) call compile format["unitJIP_%1_4 = _this",(_this select 0)];
		}
	],
	"BIS_fnc_spawn",
	true
] call BIS_fnc_MP;

call compile format["grpJIP_%1 selectLeader unitJIP_%1_1",_i];

[[[_i], {_cam = player; f_cam_forcedExit = true; closeDialog 1; call F_fnc_RemoveHandlers; call compile format["selectPlayer unitJIP_%1_1",_this select 0]; _cam cameraEffect ["Terminate","back"]; deleteVehicle _cam; f_cam_VirtualCreated = false;}],"BIS_fnc_spawn",_ftl] call BIS_fnc_MP;
[[[_i], {_cam = player; f_cam_forcedExit = true; closeDialog 1; call F_fnc_RemoveHandlers; call compile format["selectPlayer unitJIP_%1_2",_this select 0]; _cam cameraEffect ["Terminate","back"]; deleteVehicle _cam; f_cam_VirtualCreated = false;}],"BIS_fnc_spawn",_ar] call BIS_fnc_MP;
[[[_i], {_cam = player; f_cam_forcedExit = true; closeDialog 1; call F_fnc_RemoveHandlers; call compile format["selectPlayer unitJIP_%1_3",_this select 0]; _cam cameraEffect ["Terminate","back"]; deleteVehicle _cam; f_cam_VirtualCreated = false;}],"BIS_fnc_spawn",_aar] call BIS_fnc_MP;
[[[_i], {_cam = player; f_cam_forcedExit = true; closeDialog 1; call F_fnc_RemoveHandlers; call compile format["selectPlayer unitJIP_%1_4",_this select 0]; _cam cameraEffect ["Terminate","back"]; deleteVehicle _cam; f_cam_VirtualCreated = false;}],"BIS_fnc_spawn",_rat] call BIS_fnc_MP;