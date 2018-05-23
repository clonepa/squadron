while {true} do {
	sleep 15;

	if (eastMissions < 1) then {
		//[] remoteExec ["create_east_tgt.sqf", 2, false];
		execVM "create_east_tgt.sqf";
	};

	if (westMissions < 1) then {
		//[] remoteExec ["create_west_tgt.sqf", 2, false];
		execVM "create_west_tgt.sqf";
	};
};