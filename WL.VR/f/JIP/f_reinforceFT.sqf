// F3 - JIP Add Reinforcement Options Action
// Credits: Written by Bismarck
// ====================================================================================

params ["_ftl","_ar","_aar","_rat","_side"];
private ["_found","_w","_e","_g","_uNum","_i"];

_found = false;
_i = 0;
/*
if (isNil "_side") then {
	_w = 0; _e = 0; _g = 0;
	{
		switch (side _x) do {
			case west:			{_w = _w + 1};
			case east:			{_e = _e + 1};
			case resistance	{_g = _g + 1};
		};
	} forEach playableUnits;
	if (_w > _e) then {
		if (_g > _w) then {
			_side = resistance;
		} else {
			_side = west;
		};
	} else {
		if (_g > _e) then {
			_side = resistance;
		};
	};
};
*/
while {!_found} do {
	_i = _i + 1;
	_found = call compile format["isNil 'grpJIP_%1'",_i];
};

{f_gv_respawnablePlayersArray = f_gv_respawnablePlayersArray - [_x]} forEach [_ftl,_ar,_aar,_rat];	//remove old spectator logics from list of respawnable players

call compile format["grpJIP_%1 = createGroup %2",_i,_side];

_sideString = switch (_side) do {
	case west:			{"B"};
	case east:			{"O"};
	case resistance:	{"I"};
};

_uFTL	= call compile format["unitJIP_%1_1 = grpJIP_%1 createUnit [%2_Soldier_TL_F, getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_1",_i,_sideString];
_uAR	= call compile format["unitJIP_%1_2 = grpJIP_%1 createUnit [%2_soldier_AR_F, getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_2",_i,_sideString];
_uAAR	= call compile format["unitJIP_%1_3 = grpJIP_%1 createUnit [%2_Soldier_AAR_F, getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_3",_i,_sideString];
_uRAT	= call compile format["unitJIP_%1_4 = grpJIP_%1 createUnit [%2_Soldier_LAT_F, getMarkerPos 'respawn', [], 0, 'NONE']; unitJIP_%1_4",_i,_sideString];

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
_uNum = 1;
{
	[
		[
			[_i,_uNum],
			{
				_cam = player;
				{[_x] call hyp_fnc_traceFireRemove} forEach allUnits;
				f_cam_forcedExit = true;
				closeDialog 1;
				call F_fnc_RemoveHandlers;
				call compile format["selectPlayer unitJIP_%1_%2",_this select 0, _this select 1];
				_cam cameraEffect ["Terminate","back"];
				deleteVehicle _cam;
				f_cam_VirtualCreated = false;
			}
		],
		"BIS_fnc_spawn",
		_x
	] call BIS_fnc_MP;
	_uNum = _uNum + 1;
} forEach [_ftl,_ar,_aar,_rat];











