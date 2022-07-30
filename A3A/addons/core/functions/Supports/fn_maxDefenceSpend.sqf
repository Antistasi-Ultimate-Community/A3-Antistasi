/*
Maintainer: John Jordan
    Return free defence resources to spend against given position & target

Environment: Server, scheduled

Arguments:
    <SIDE> Side using the resources, must be occupants or invaders
    <OBJECT> or <SIDE> Target object or side to target
    <POSITION> or <STRING> Position of support caller, or a marker to defend/retake
    <SCALAR> Optional, additional cap relative to max location spend (Default: 1.0)

Return Value:
    <NUMBER> Free defence resources to spend. 

Examples:
    [Occupants, teamPlayer, "outpost_3"] call A3A_fnc_maxDefenceSpend;
    [Invaders, _enemyTank, getPosATL _spottingUnit] call A3A_fnc_maxDefenceSpend;
*/

#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params ["_side", "_target", "_callPos", ["_maxResMod", 1]];
private _targetSide = if (_target isEqualType objNull) then { side group _target } else { _target };

private _curResources = [A3A_resourcesDefenceInv, A3A_resourcesDefenceOcc] select (_side == Occupants);
private _maxResources = A3A_balanceResourceRate * 10 * ([1, A3A_invaderBalanceMul] select (_side == Invaders));
if (gameMode == 1) then {
    // Other enemy can use 30-55% of max, rebels 60-85%, depending on aggro. Resource rate/max are also increased by aggro in initSupports
    private _aggro = [aggressionInvaders, aggressionOccupants] select (_side == Occupants);
    if (_targetSide != teamPlayer) exitWith { _maxResources = _maxResources * (0.3 + (100-_aggro)/400) };
    _maxResources = _maxResources * (0.6 + _aggro/400);
};
Debug_2("Current resources %1, max resources %2", _curResources, _maxResources);
if (_curResources < 0) exitWith { 0 };


// If target is air, use a global spend limit and only consider anti-air spends
if (_target isEqualType objNull and {_target isKindOf "Air"}) exitWith
{
    // TODO: should we consider aircraft type here?
    // ideally want to prevent supports being spammed against unarmed aircraft
    // but this might need to be the concern of the airspace manager

    // TODO: Might need to constrain this with the strike list so that you don't get multiple supports sent against one aircraft

    private _isArmed = typeOf _target in (FactionGet(all, "vehiclesHelisLightAttack") + FactionGet(all, "vehiclesHelisAttack") + FactionGet(all, "vehiclesPlanesCAS") + FactionGet(all, "vehiclesPlanesAA"));
    private _maxAASpend = _maxResources * ([0.1, 0.4] select _isArmed);
    private _curAASpend = 0;
    {
        _x params ["_spSide", "_spCallPos", "_spTargPos", "_spRes", "_spTime"];
        if (_spSide != _side) then { continue };
        if (_spTargPos isEqualType []) then { continue };       // non-position targpos means called against aircraft

        // Falloff resource spend over one hour
        private _res = linearConversion [_spTime, (_spTime)+3600, time, _spRes, 0, true];
        _curAASpend = _curAASpend + _res;

    } forEach A3A_supportSpends;

    Debug_2("Cur AA spend %1, max AA spend %2", _curAASpend, _maxAASpend);
    _curResources min (_maxAASpend - _curAASpend);
};


// For ground targets, spend limit depends on markers near caller
private _maxSpend = _maxResources;
private _maxSpendLoc = _maxResources;
if (_callPos isEqualType "") then
{
    // If target is a marker, just return the location's maximum
    private _mrkIndex = A3A_supportMarkerTypes findif { _callPos == _x#0 };     // lookup marker name
    _callPos = markerPos _callPos;
    if (_mrkIndex == -1) exitWith {
        Error_1("Unknown support marker: %1", _target);
        _maxSpend = _maxSpend * 0.15;
    };
    private _mrkType = A3A_supportMarkerTypes select _mrkIndex;
    _maxSpend = _maxSpend * (_mrkType#3);     // * _mrkType#4;            // location type multiplier * time-based random
    _maxSpendLoc = _maxSpend * _maxResMod;
    Debug_1("Marker max spend %1", _maxSpend);
}
else 
{
    // Target is position
    // Friendly markers near caller increase max resource spend
    // Enemy markers near target reduce max spend
    private _targPos = [getPosATL _target, _callPos] select (_target isEqualType west);
    private _closeMrk = A3A_supportMarkersXYI inAreaArray [_callPos, 1000, 1000];
    private _defMul = 0.15;
    private _defSub = 0;
    {
        private _mrkType = A3A_supportMarkerTypes select (_x#2);
        if (sidesX getVariable (_mrkType#0) != _side) then {        // enemy marker
            private _dist = _x distance2d _targPos;
            _defSub = _defSub max (_mrkType#3 * (1 - _dist / 500));
        } else {                                                      // friendly marker
            private _dist = _x distance2d _callPos;
            _defMul = _defMul max (_mrkType#3 * (1 - _dist / 1000));
        };
    } forEach _closeMrk;
    _maxSpend = _maxSpend * (_defMul - _defSub);
    _maxSpendLoc = _maxSpend * _maxResMod;
    Debug_3("Maxspend %1 from defmul %2 and defsub %3", _maxSpend, _defMul, _defSub);


    // Prevent overreacting to threats: recentDamage + enemyStr - friendlyStr
    // Recent damage, generated by AIReactOnKill & AIVehInit stuff?
    private _recentDamage = [_side, _callPos, 300] call A3A_fnc_getRecentDamage;        // should this be related to marker size? hmm

    // Accumulate base strength of nearby enemies
    private _enemyStr = 0;
    private _nearEnemies = units _targetSide inAreaArray [_callPos, 500, 500];
    if (_target isEqualType objNull) then { _nearEnemies pushBackUnique gunner vehicle _target };     // add target, in case it's shooting from long range
    {
        if !(_x call A3A_fnc_canFight) then { continue };
        if (vehicle _x isKindOf "Air") then { continue };
        _enemyStr = _enemyStr + ([10, 30] select isPlayer _x);          // TODO: parameterize player multiplier
        if (vehicle _x != _x and {_x == gunner vehicle _x}) then {
            _enemyStr = _enemyStr + (A3A_groundVehicleThreat getOrDefault [typeOf vehicle _x, 0]);
        };
    } forEach _nearEnemies;

    // counter with friendly unit strength
    private _friendStr = 0;
    private _nearFriends = units _side inAreaArray [_callPos, 500, 500];
    {
        if !(_x call A3A_fnc_canFight) then { continue };
        if (vehicle _x isKindOf "Air") then { continue };
        if (_x getVariable ["A3A_resPool", ""] isEqualTo "defence") then { continue };      // accounted for in supportSpends
        _friendStr = _friendStr + 10;
        // Don't include friendly statics atm because they're not remanned and not registered in recentDamage if gunner killed 
        //if (vehicle _x != _x and {_x == gunner vehicle _x}) then {
        //    _friendStr = _friendStr + (A3A_groundVehicleThreat getOrDefault [typeOf vehicle _x, 0]);
        //};
    } forEach _nearFriends;

    Debug_3("Recent damage %1, enemy strength %2, friend strength %3", _recentDamage, _enemyStr, _friendStr);
    _maxSpend = _maxSpend min 2*(2*_recentDamage + _enemyStr - _friendStr);
};
if (_maxSpend <= 0) exitWith { 0 };


// Determine how much we've already spent to support the target & caller positions
private _callPosSpend = 0;
private _targPosSpend = 0;
{
    // [side, type, callpos, targpos, resources, start time]
    _x params ["_spSide", "_spCallPos", "_spTargPos", "_spRes", "_spTime"];
    if (_spSide != _side) then { continue };
    if !(_spTargPos isEqualType []) then { continue };                // anti-air spend

    // Falloff resource spend over one hour
    private _res = linearConversion [_spTime, (_spTime)+3600, time, _spRes, 0, true];

    // Falloff resource spend to 0 at 500m distance
    private _callDist = _spCallPos distance2d _callPos;
    _callPosSpend = _callPosSpend + linearConversion [0, 500, _callDist, _res, 0, true];

    if (_target isEqualType west) then { continue };
    private _targDist = _spTargPos distance2d _target;
    _targPosSpend = _targPosSpend + linearConversion [0, 500, _targDist, _res, 0, true];

} forEach A3A_supportSpends;

Debug_4("Callpos spend %1, targpos spend %2, max spend %3, max loc %4", _callPosSpend, _targPosSpend, _maxSpend, _maxSpendLoc);

_maxSpend = _maxSpend - (_callPosSpend max _targPosSpend);      // reduce by what's already been spent
_curResources min _maxSpend min _maxSpendLoc;