#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params ["_group", "_position", "_radius"];

private _units = units _group;

if (count _units == 0) exitwith {};

if (isNil {_group getVariable "PATCOM_Garrison_buildings"}) then {
    _group setVariable ["PATCOM_Garrison_buildings", []];
};
private _garrisonedBuildings = [];
_garrisonedBuildings = _group getVariable ["PATCOM_Garrison_buildings", []];

_group lockWP true;

private _buildings = [];
_buildings = nearestObjects [_position, keys PATCOM_Garrison_Positions, _radius];

if (count _buildings == 0) then {
    _buildings = [_position, floor(_radius/2)] call A3A_fnc_patrolEnterableBuildings;
};

{
    if (count _units == 0) exitWith {};

    private _building = _x;
    private _class = typeOf _building;
    private _buildingIsEmpty = true;
    {
        if ((_x getVariable ["PATCOM_Garrison_buildings", []]) find _building != -1) exitWith {
            _buildingIsEmpty = false;
        };
    } forEach A3A_Patrol_Controlled_AI;

	if (_buildingIsEmpty) then {
    	private _buildingPositions = [];

    	if (_class in PATCOM_Garrison_Positions) then {
        	{
            	private _buildingPos = _building buildingPos _x;
            	if !(_buildingPos isEqualTo [0,0,0]) then {
            	    _buildingPositions pushBack _buildingPos;
            	};
        	} forEach (PATCOM_Garrison_Positions get _class);
    	} else {
            _buildingPositions = _building buildingPos -1;
    	};

    	{
            if (count _units == 0) exitWith {};

            _garrisonedBuildings pushBackUnique _building;

            private _unit = _units select 0;
            private _position = _x;
            _unit setposATL _position;
			_unit setdir ((_unit getRelDir _building)-180);
            _unit disableAI "PATH";

			dostop _unit;

            _units deleteAt 0;
        } foreach _buildingPositions;
	};
} forEach _buildings;
