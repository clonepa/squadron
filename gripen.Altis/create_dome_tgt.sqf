#include "compositions.sqf";

_mkrList = ["domepos_01","domepos_02","domepos_03"];
_mkrRandom = selectRandom _mkrList;
_mkrPosition = (getMarkerPos _mkrRandom);
/*_dome = "Land_Radar_Small_F" createVehicle _mkrPosition;
_dome SetPos _mkrPosition; //absolutely set it to position of marker*/

/* Original code, here for later use due to randomization/batch potential
{
	_randomCamp = (selectRandom [comp_camp1tent, comp_bunkers, comp_camp2tent]);
	_randomOrient = (random 360);
	[_x, _randomOrient, _randomcamp] call BIS_fnc_ObjectsMapper;
	//[_x, WEST, (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team")] call BIS_fnc_spawnGroup;
	if (_randomCamp isEqualTo comp_bunkers) then {
		_turretM2 = (nearestObject [_x,"RHS_M2StaticMG_USMC_WD"]);
		_turretTOW = (nearestObject [_x,"RHS_TOW_TRIPOD_USMC_WD"]);
		createVehicleCrew _turretM2; createVehicleCrew _turretTOW;
	};
} forEach [_campPos1,_campPos2,_campPos3];*/

_randomOrient = (random 360);
[_mkrPosition, _randomOrient, comp_radarSmall] call BIS_fnc_ObjectsMapper;

taskTarget = (nearestObject [_mkrPosition,"Land_Radar_Small_F"]);

_task = [independent,["dometask"],["Blow up the Radar (Small).","Blow Dome",_mkrRandom],taskTarget,true,1,true] call BIS_fnc_taskCreate;

_taskTrg = createTrigger ["EmptyDetector", _mkrPosition, true];
_taskTrg setTriggerStatements ["!alive taskTarget", "['dometask','SUCCEEDED',true] call BIS_fnc_taskSetState", ""];

_groupInterceptors = createGroup [east, true];

_mkrListInterceptor = ["interceptor_pos_01","interceptor_pos_02","interceptor_pos_03","interceptor_pos_04"];
_mkrRandomInterceptor = selectRandom _mkrListInterceptor;
_mkrPositionInterceptor = (getMarkerPos _mkrRandomInterceptor);

_rnd3 = ceil(random 4);
for [{_i=0}, {_i<(_rnd3 + 1)}, {_i = _i + 1}] do
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

hint "????";