///////////////////////////
//   Rebel Information   //
///////////////////////////

["name", "FFI"] call _fnc_saveToTemplate;

["flag", "Flag_FIA_F"] call _fnc_saveToTemplate;
["flagTexture", "\x\A3A\addons\core\Templates\Templates\IFA\marker_ffi.paa"] call _fnc_saveToTemplate;
["flagMarkerType", "a3a_flag_FFI"] call _fnc_saveToTemplate;

//////////////////////////
//  Mission/HQ Objects  //
//////////////////////////

// All of bellow are optional overrides.
["diveGear", [""]] call _fnc_saveToTemplate;
["flyGear", ["U_LIB_US_Bomber_Pilot", "U_LIB_GER_LW_pilot"]] call _fnc_saveToTemplate;
["vehiclesCivSupply", ["LIB_OpelBlitz_Ambulance_w"]] call _fnc_saveToTemplate;

["surrenderCrate", "LIB_BasicWeaponsBox_GER"] call _fnc_saveToTemplate; //WIP

//////////////////////////
//       Vehicles       //
//////////////////////////

["vehiclesBasic", ["LIB_Willys_MB"]] call _fnc_saveToTemplate;
["vehiclesLightUnarmed", ["LIB_GazM1_FFI"]] call _fnc_saveToTemplate;
["vehiclesLightArmed", ["LIB_UK_Willys_MB_M1919"]] call _fnc_saveToTemplate;
["vehiclesTruck", ["LIB_CIV_FFI_CitC4_5"]] call _fnc_saveToTemplate;
["vehiclesAT", ["LIB_Zis5v_61K"]] call _fnc_saveToTemplate;
["vehiclesAA", []] call _fnc_saveToTemplate;

["vehiclesBoat", ["LIB_LCM3_Armed"]] call _fnc_saveToTemplate;

["vehiclesPlane", ["LIB_C47_RAF"]] call _fnc_saveToTemplate;
["vehiclesMedical", ["LIB_OpelBlitz_Ambulance_w"]] call _fnc_saveToTemplate;

["vehiclesCivCar", ["LIB_GazM1_dirty"]] call _fnc_saveToTemplate;
["vehiclesCivTruck", ["LIB_CIV_FFI_CitC4_2"]] call _fnc_saveToTemplate;
["vehiclesCivHeli", []] call _fnc_saveToTemplate;
["vehiclesCivBoat", ["B_Boat_Transport_01_F"]] call _fnc_saveToTemplate;
["vehiclesCivPlane", []] call _fnc_saveToTemplate;

["staticMGs", ["LIB_MG34_Lafette_Deployed"]] call _fnc_saveToTemplate;
["staticAT", ["LIB_Zis3"]] call _fnc_saveToTemplate;
["staticAA", ["LIB_FlaK_30"]] call _fnc_saveToTemplate;
["staticMortars", ["LIB_M2_60"]] call _fnc_saveToTemplate;
["staticMortarMagHE", "LIB_8Rnd_60mmHE_M2"] call _fnc_saveToTemplate;
["staticMortarMagSmoke", ""] call _fnc_saveToTemplate;

["mineAT", ""] call _fnc_saveToTemplate;
["mineAPERS", ""] call _fnc_saveToTemplate;

["breachingExplosivesAPC", [["LIB_Ladung_Big_MINE_mag", 1], ["LIB_Ladung_Small_MINE_mag", 1]]] call _fnc_saveToTemplate;
["breachingExplosivesTank", [["LIB_US_TNT_4pound_mag", 1], ["LIB_Ladung_Big_MINE_mag", 2]]] call _fnc_saveToTemplate;

//Enter #include "Modset_Reb_Vehicle_Attributes.sqf" here

///////////////////////////
//  Rebel Starting Gear  //
///////////////////////////

private _initialRebelEquipment = [
"LIB_WaltherPPK", "LIB_7Rnd_765x17_PPK",
"LIB_M1895", "LIB_7Rnd_762x38",
"LIB_FLARE_PISTOL", "LIB_1Rnd_flare_white",
"V_LIB_SOV_RA_Belt", "V_LIB_UK_P37_Crew", 
["LIB_Ladung_Small_MINE_mag", 10],
"B_LIB_US_Bandoleer",
"LIB_Binocular_GER"
];

if (A3A_hasTFAR) then {_initialRebelEquipment append ["tf_microdagr","tf_anprc154"]};
if (A3A_hasTFAR && startWithLongRangeRadio) then {_initialRebelEquipment append ["tf_anprc155","tf_anprc155_coyote"]};
if (A3A_hasTFARBeta) then {_initialRebelEquipment append ["TFAR_microdagr","TFAR_anprc154"]};
if (A3A_hasTFARBeta && startWithLongRangeRadio) then {_initialRebelEquipment append ["TFAR_anprc155","TFAR_anprc155_coyote"]};
["initialRebelEquipment", _initialRebelEquipment] call _fnc_saveToTemplate;


private _rebUniforms = [
"U_LIB_CIV_Citizen_1",
"U_LIB_CIV_Citizen_2",
"U_LIB_CIV_Citizen_3",
"U_LIB_CIV_Citizen_4",
"U_LIB_CIV_Citizen_5",
"U_LIB_CIV_Citizen_6",
"U_LIB_CIV_Citizen_7",
"U_LIB_CIV_Citizen_8",
"U_LIB_CIV_Villager_1",
"U_LIB_CIV_Villager_2",
"U_LIB_CIV_Villager_3",
"U_LIB_CIV_Villager_4",
"U_LIB_CIV_Woodlander_1",
"U_LIB_CIV_Woodlander_2",
"U_LIB_CIV_Woodlander_3",
"U_LIB_CIV_Woodlander_4"
];          //Uniforms given to Normal Rebels

["uniforms", _rebUniforms] call _fnc_saveToTemplate;         //These Items get added to the Arsenal

["headgear", ["H_LIB_CIV_Villager_Cap_1","H_LIB_CIV_Villager_Cap_2","H_LIB_CIV_Villager_Cap_3","H_LIB_CIV_Villager_Cap_4"]] call _fnc_saveToTemplate;          //Headgear used by Rebell Ai until you have Armored Headgear.

/////////////////////
///  Identities   ///
/////////////////////

//Faces and Voices given to Rebell AI
["faces", ["LivonianHead_6","WhiteHead_01","WhiteHead_02","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08","WhiteHead_12","WhiteHead_15","WhiteHead_18"]] call _fnc_saveToTemplate;
["voices", ["Male01FRE","Male02FRE","Male03FRE"]] call _fnc_saveToTemplate;
"RussianMen" call _fnc_saveNames;

//////////////////////////
//       Loadouts       //
//////////////////////////
private _loadoutData = call _fnc_createLoadoutData;
_loadoutData set ["maps", ["ItemMap"]];
_loadoutData set ["watches", ["ItemWatch"]];
_loadoutData set ["compasses", ["ItemCompass"]];
_loadoutData set ["binoculars", ["Binocular"]];

_loadoutData set ["uniforms", _rebUniforms];

_loadoutData set ["facewear", []];

_loadoutData set ["items_medical_basic", ["BASIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_standard", ["STANDARD"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_medic", ["MEDIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_miscEssentials", [] call A3A_fnc_itemset_miscEssentials];

////////////////////////
//  Rebel Unit Types  //
///////////////////////.

private _squadLeaderTemplate = {
    ["uniforms"] call _fnc_setUniform;
    ["facewear"] call _fnc_setFacewear;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["binoculars"] call _fnc_addBinoculars;
};

private _riflemanTemplate = {
    ["uniforms"] call _fnc_setUniform;
    ["facewear"] call _fnc_setFacewear;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
};

private _prefix = "militia";
private _unitTypes = [
    ["Petros", _squadLeaderTemplate],
    ["SquadLeader", _squadLeaderTemplate],
    ["Rifleman", _riflemanTemplate],
    ["staticCrew", _riflemanTemplate],
    ["Medic", _riflemanTemplate, [["medic", true]]],
    ["Engineer", _riflemanTemplate, [["engineer", true]]],
    ["ExplosivesExpert", _riflemanTemplate, [["explosiveSpecialist", true]]],
    ["Grenadier", _riflemanTemplate],
    ["LAT", _riflemanTemplate],
    ["AT", _riflemanTemplate],
    ["AA", _riflemanTemplate],
    ["MachineGunner", _riflemanTemplate],
    ["Marksman", _riflemanTemplate],
    ["Sniper", _riflemanTemplate],
    ["Unarmed", _riflemanTemplate]
];

[_prefix, _unitTypes, _loadoutData] call _fnc_generateAndSaveUnitsToTemplate;
