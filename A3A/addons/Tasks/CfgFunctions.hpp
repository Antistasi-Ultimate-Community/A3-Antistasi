class CfgFunctions {
    class ADDON {
        class Core {
            file = QPATHTOFOLDER(Core);
            class genTaskID {};
            class getSettings { postInit = 1; };
            class requestTask {};
            class runTask {};
            class updateTaskState {};
        };

        class Helpers { // task helper functions  |  Common functionality used by tasks or the params getters
            file = QPATHTOFOLDER(Helpers);
            class minutesFromNow {};
            class nearFriendlyMarkers {};
            class nearHostileMarkers {};
        };
        class Params { // params getter functions for the tasks  |  returns false if failed, otherwise params array
            file = QPATHTOFOLDER(Params);
            class testTask_p {};
        };
        class Tasks { // task  |  Passed task HM to store task instructions into
            file = QPATHTOFOLDER(Tasks);
            class testTask {};
        };

        //Legacy missions
        class LegacyParams {
            file = QPATHTOFOLDER(Params\LegacyParams);
            class AS_Official_p {};
        };
        class LegacyTasks {
            file = QPATHTOFOLDER(Tasks\LegacyTasks);
            class AS_Official {};
        };
    };
};