params ["_new", ""];

waitUntil {!isNull _new};
["RespawnVehicle", [getText (configFile >> "CfgVehicles" >> typeOf _new >> 'displayName'), "base"]] remoteExecCall ["bis_fnc_showNotification"];
_new execVM "scripts\cannon_autorearm.sqf";
