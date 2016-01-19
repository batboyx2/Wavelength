// F3 - Respawn INIT
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// Only run this for players
if (isDedicated) exitWith{};

// ====================================================================================

// MAKE SURE THE PLAYER INITIALIZES PROPERLY
if (!isDedicated && (isNull player)) then
{
    waitUntil {sleep 0.1; !isNull player};
};

// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

private ["_unit","_corpse","_found"];

// ====================================================================================

// SETUP KEY VARIABLES
// The Respawn eventhandler passes two parameters: the unit a player has respawned in and the corpse of the old unit.

_unit = _this select 0;
_corpse = _this select 1;
_isjip = (isNull _corpse);

// Exit if the unit doesn't exist, also exit if safestart is still enabled
if (isNil "_unit") exitWith {};
if (isNil "PABST_ADMIN_SAFESTART_public_isSafe" || {PABST_ADMIN_SAFESTART_public_isSafe}) exitWith {};

// ====================================================================================

// CHECK FOR GLOBAL VARIABLES
// Check if the global variables have been initialized, if not, do so with the default values.
/*
if (isNil "f_var_JIP_FirstMenu") then {f_var_JIP_FirstMenu = false};
if (isNil "f_var_JIP_GearMenu") then {f_var_JIP_GearMenu = true};
if (isNil "f_var_JIP_RemoveCorpse") then {f_var_JIP_RemoveCorpse = false};

// ===================================================================================

// CHECK FOR FIRST TIME SPAWN
// If no corpse exists the player is spawned for the first time. By default, he won't get the JIP menu in that case.

if (!f_var_JIP_FirstMenu && isNull _corpse) exitWith {};

// ====================================================================================

// CHECK FOR GEAR
// If gear selection is disabled and the unit uses the loadout assigned by the F3 assign Gear component or it's default loadout.

if (!f_var_JIP_GearMenu) then {
	if (typeName (_unit getVariable "f_var_assignGear") == typeName "") then {
		_loadout = (_unit getVariable "f_var_assignGear");
		[_loadout,player] call f_fnc_assignGear;
	};
};

// ====================================================================================

// ADD JIP MENU TO PLAYER
// Check if player already has the JIP Menu. If not, add it.

if (isNil "F3_JIP_reinforcementOptionsAction") then {
	[player] execVM "f\JIP\f_JIP_addReinforcementOptionsAction.sqf";
};

// ====================================================================================

// REMOVE CORPSE
// If activated and respawn is allowed, the old corpse will be sink into the ground and is then removed from the game

if (typeof _unit != "seagull" && {f_var_JIP_RemoveCorpse && !isNull _corpse}) then {
	_corpse spawn {
		hideBody _this;
		sleep 60;
		deleteVehicle _this;
	};
};
*/

//hide player unit and make invulnerable for the moment
/*
[_unit] join grpNull;
[[_unit, {_this hideObjectGlobal true; waitUntil {sleep 1; isPlayer _this}; _this hideObjectGlobal false}],"BIS_fnc_spawn",false] call BIS_fnc_MP;
[[_unit, {_this allowDamage false; waitUntil {sleep 1; isPlayer _this}; _this allowDamage true;}],"BIS_fnc_spawn",true] call BIS_fnc_MP;
*/


fnc_checkJipArray = {
	//I put this code in a function to make things a little neater down below
	params ["_unit"];
	private ["_found","_index"];
	_found = false;
	_index = -1;
	{
		if ((getPlayerUID _unit) == (_x select 0)) then {
			_found = true;
			_index = f_gv_storedRespawnsArray find _x;
		};
	} forEach f_gv_storedRespawnsArray;
	
	[_found,_index]
};

fnc_specInit = {
	params ["_found","_index","_unit"];
	if (!_found) then {
		_ya = [_unit] call fnc_checkJipArray;
		_found = _ya select 0;
		_index = _ya select 1;
	};
	_resNum = (f_gv_storedRespawnsArray select _index) select 1;
	_lastResTime = (f_gv_storedRespawnsArray select _index) select 2;
	if (_resNum <= f_param_maxSpawns) then {
		hint "yall motherfuckers need to wait for jesus";
		waitUntil {sleep 1; time > (_lastResTime + (60 * f_param_reinforceCooldown))};
		hint "jesus is here yo";
		//dialog button added and stuff here
		//[player, objNull, objNull, objNull, side] execVM "f\JIP\f_reinforceFT.sqf";
		f_gv_respawnablePlayersArray = f_gv_respawnablePlayersArray + [_unit]; //list of all the spectator logics controlled by players which are allowed to be reinforcements
	};
};

_found = [_unit] call fnc_checkJipArray;	//[foundBoolean, indexFoundAt]

[_unit,_corpse,_unit,0,true] call f_fnc_CamInit;

if (f_param_maxSpawns == 0) then {
	//reinforcements disabled
	if (f_param_jipEnabled == 1) then {
		//jip enabled, reinforcements disabled
		if (_isjip && !_found) then {
			f_gv_storedRespawnsArray set [_found select 1, [(getPlayerUID _unit), 1, time]];
			publicVariable "f_gv_storedRespawnsArray";	//broadcast new value to all clients
			[false,-1,_unit] spawn fnc_specInit;
		};
	};
} else {
	//reinforcements enabled
	if !(_isjip) then {
		//set values for f_gv_storedRespawnsArray depending on whether or not an entry already exists
		if (_found select 0) then {
			//is already in array, increment # of respawns by one and set time of death latest to now
			f_gv_storedRespawnsArray set [_found select 1, [(getPlayerUID _unit), ((f_gv_storedRespawnsArray select (_found select 1)) select 1) + 1, time]];
			publicVariable "f_gv_storedRespawnsArray";	//broadcast new value to all clients
		} else {
			//is not already in array, set # of respawns to one (first respawn) and set time of latest death to now
			f_gv_storedRespawnsArray = f_gv_storedRespawnsArray + [[(getPlayerUID _unit), 1, time]];
			publicVariable "f_gv_storedRespawnsArray";	//broadcast new value to all clients
		};
	} else {
		//create new entry for jip player if it does not already exist...
		
		//do not need case for _found == true, because this is a jip and not a respawn, we don't need to change the value if it already exists
		if !(_found select 0) then {
			//is not already in array, set # of respawns to zero and time of last death to zero (ignored)
			f_gv_storedRespawnsArray = f_gv_storedRespawnsArray + [[(getPlayerUID _unit), 0, 0]];
			publicVariable "f_gv_storedRespawnsArray";	//broadcast new value to all clients
		};
	};
	(_found + [_unit]) spawn fnc_specInit;
};



