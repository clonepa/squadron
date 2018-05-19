params ["", "_new"];

["RespawnVehicle", [getText (configFile >> "CfgVehicles" >> typeOf _new >> 'displayName'), "base"]] remoteExecCall ["bis_fnc_showNotification"];
