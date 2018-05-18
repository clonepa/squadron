#include "compositions.sqf";

_mission = selectRandom ["Dome", "ArtyHeavy", "ArtyLight"];

_mkrList = ["targetpos_01","targetpos_02","targetpos_03"];
_mkrRandom = selectRandom _mkrList;
_mkrPosition = (getMarkerPos _mkrRandom);

/* Original code, here for later use
//[_x, WEST, (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team")] call BIS_fnc_spawnGroup;
*/

_targetComp = 0; //Target composition init.
_targetObject = 0; //Specific object type(s) in composition to be destroyed
_targetCrewable = 0; //Specific object type(s) in composition to crew with AI
artyAmmo = 0; //If target is an artillery piece that sohuld be firing, define the ammo here.

switch (_mission) do {
	case "Dome": {
		_targetComp = comp_radarSmall;
		_targetObject = "Land_Radar_Small_F";
	};

	case "ArtyHeavy": {
		_targetComp = comp_artyHeavy;
		_targetObject = "O_MBT_02_Arty_F";
		_targetCrewable = "O_MBT_02_Arty_F";
		artyAmmo = "32Rnd_155mm_Mo_shells_O";
	};

	case "ArtyLight": {
		_targetComp = comp_artyLight;
		_targetObject = "O_Mortar_01_F";
		_targetCrewable = "O_Mortar_01_F";
		artyAmmo = "8Rnd_82mm_Mo_shells";
	};
};

_randomOrient = (random 360);
[_mkrPosition, _randomOrient, _targetComp] call BIS_fnc_ObjectsMapper;

taskTargets = (nearestObjects [_mkrPosition, [_targetObject], 50]);

if !(artyAmmo isEqualTo 0) then {
	artyTargetPos = [[[_mkrPosition,4050]],["water",[_mkrPosition,1000]]] call BIS_fnc_randomPos;
};

if !(_targetCrewable isEqualTo 0) then {
	private _crewableObjects = (nearestObjects [_mkrPosition, [_targetCrewable], 50]);
	{
		createVehicleCrew _x;
		group _x addVehicle _x;
		if !(artyAmmo isEqualTo 0) then {
			_x doArtilleryFire [artyTargetPos, artyAmmo, 1];
			_x addEventHandler ["Fired", {
				params ["_unit"];
				_unit setVehicleAmmo 1;
				_unit doArtilleryFire [artyTargetPos, artyAmmo, 1]}
			];
		};
	} forEach _crewableObjects;
};

_task = [independent,["strikemission"],["Blow up the target.","Strike Target",_mkrRandom],(taskTargets select 0),true,1,true] call BIS_fnc_taskCreate;

_taskTrg = createTrigger ["EmptyDetector", _mkrPosition, true];
_taskTrg setTriggerStatements ["({alive _x} count taskTargets) < 1", "['strikemission','SUCCEEDED',true] call BIS_fnc_taskSetState", ""];

_groupInterceptors = createGroup [east, true];

_mkrListInterceptor = ["interceptor_pos_01","interceptor_pos_02","interceptor_pos_03","interceptor_pos_04"];
_mkrRandomInterceptor = selectRandom _mkrListInterceptor;
_mkrPositionInterceptor = (getMarkerPos _mkrRandomInterceptor);

_rnd3 = ceil(random 3);
for [{_i=0}, {_i<(_rnd3)}, {_i = _i + 1}] do
{
	private _interceptorVeh = createVehicle ["O_Plane_Fighter_02_Stealth_F", _mkrPositionInterceptor, [], 100, "FLY"];
	createVehicleCrew _interceptorVeh;
	group _interceptorVeh addVehicle _interceptorVeh;
	[driver _interceptorVeh] join _groupInterceptors;

	private _pylons = ["","","","","","","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R77_x1","PylonMissile_Missile_AA_R77_x1","PylonMissile_Missile_AA_R77_INT_x1","PylonMissile_Missile_AA_R77_INT_x1","PylonMissile_Missile_AA_R77_INT_x1"];
	private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _interceptorVeh >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
	{ _interceptorVeh removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") } forEach getPylonMagazines _interceptorVeh;
	{ _interceptorVeh setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;
};

_wp = _groupInterceptors addWaypoint [getMarkerPos _mkrRandom, 0];
_wp setWaypointType "SAD";
_wp setWaypointCombatMode "RED";

hint str _rnd3;