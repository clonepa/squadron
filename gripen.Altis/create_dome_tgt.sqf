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
hint str (getpos taskTarget);

_task = [independent,["dometask"],["Blow up the Radar (Small).","Blow Dome",_mkrRandom],taskTarget,true,1,true] call BIS_fnc_taskCreate;

_taskTrg = createTrigger ["EmptyDetector", _mkrPosition, true];
_taskTrg setTriggerStatements ["!alive taskTarget", "['dometask','SUCCEEDED',true] call BIS_fnc_taskSetState", ""];