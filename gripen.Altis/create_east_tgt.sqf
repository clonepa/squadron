_opfor_tgts = [];

{
	if (((side _x) == east) && (((getPos _x) select 0) > 16000) && (vehicle _x != _x)) then {
		_opfor_tgts pushBackUnique (vehicle _x);
	};
} forEach allUnits;

sleep 1;

if !(isNil "eastMissionIncrement") then {
	eastMissionIncrement = eastMissionIncrement + 1;
} else {
	eastMissionIncrement = 1;
};

taskName = "supportmission_" + (str eastMissionIncrement);

taskTarget = selectRandom _opfor_tgts;

_task = [independent,[taskName],["Blow up the target.","Air Support",""],taskTarget,true,1,true] call BIS_fnc_taskCreate;

_taskTrg = createTrigger ["EmptyDetector", getPos taskTarget, true];
_taskTrg setTriggerStatements ["!alive taskTarget", "[taskName,'SUCCEEDED',true] call BIS_fnc_taskSetState", ""];

hint format ["Target: %1 \nPosition: %2 \nTask Name: %3 \n\nPotential List: %4", str taskTarget, str getPos taskTarget, str taskName, str _opfor_tgts]; //debug
