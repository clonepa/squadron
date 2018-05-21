params ["_veh"];

hint str _veh;

private ["_amt", "_per"];
_amt = 100;
_per = 5;
private ["_cannon", "_current", "_maxAmmo"];


_cannon = ((weapons _veh) select {
  (_x find "Cannon" > -1) or (_x find "Gun" > -1)
}) select 0;
_maxAmmo = _veh ammo _cannon;

while {alive _veh} do {
  _current = _veh ammo _cannon;
  if (_current < _maxAmmo) then {
    [_veh, [_cannon, _current + _amt]] remoteExec ["setAmmo", _veh];
    [_veh, "rearm"] remoteExec ["say2D", driver _veh];
  } else {
    waitUntil {(_veh ammo _cannon) < _maxAmmo};
  };
  sleep _per;
};
