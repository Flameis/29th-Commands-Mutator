class MCPlayerController extends ROPlayerController;

var ROMapInfo                   ROMI;

simulated function PreBeginPlay()
{
    super.PreBeginPlay();

    ReplaceRoles();
}

simulated function PostBeginPlay()
{
    local RORoleCount RORC;

    `log("ACPlayerController.PostBeginPlay()");

    super.PostBeginPlay();

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    ForEach ROMI.NorthernRoles(RORC)
    {
        `log("RoleInfoClass = " $ RORC.RoleInfoClass);
    }

    ForEach ROMI.SouthernRoles(RORC)
    {
        `log("RoleInfoClass = " $ RORC.RoleInfoClass);
    }
}

simulated function ReplaceRoles()
{
    local RORoleCount           NorthRoleCount, SouthRoleCount1, SouthRoleCount2, SouthRoleCount3;
    local class<RORoleInfo>     SouthTL;
    local bool                  FoundPilot;
    local int                   i;
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    if (ROMI != None)
    {
        `log ("Replacing Roles");

        switch (ROMI.SouthernForce)
        {
            case SFOR_USArmy:
            case SFOR_USMC:
                SouthTL = class'MCRoleInfoCommanderSouth';       
            break;

            case SFOR_AusArmy:
                SouthTL = class'MCRoleInfoCommanderSouthAUS';
            break;

            case SFOR_ARVN:
                SouthTL = class'MCRoleInfoCommanderSouthARVN';
            break;
        }

        ROMI.SouthernTeamLeader.roleinfo = none;
        ROMI.SouthernTeamLeader.roleinfo = new SouthTL;

        ROMI.NorthernTeamLeader.roleinfo = none;
        ROMI.NorthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderNorth';;

        SouthRoleCount3.RoleInfoClass = class'MCRoleInfoTankCrewSouth';
		SouthRoleCount3.Count = 255;
        ROMI.SouthernRoles.additem(SouthRoleCount3);

        NorthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewNorth';
		NorthRoleCount.Count = 255;
        ROMI.NorthernRoles.additem(NorthRoleCount);

        for (I=0; I < ROMI.SouthernRoles.length; I++)
        {
			if (instr(ROMI.SouthernRoles[I].RoleInfoClass.Name, "Pilot",, true) != -1)
            {
                FoundPilot = true;
				break;
            }
        }

        if (FoundPilot)
        {
            switch (ROMI.SouthernForce)
            {
                case SFOR_USArmy:
                case SFOR_USMC:
                    SouthRoleCount1.RoleInfoClass = class'RORoleInfoSouthernPilot';
                    SouthRoleCount2.RoleInfoClass = class'RORoleInfoSouthernTransportPilot';  
                break;

                case SFOR_AusArmy:
                    SouthRoleCount1.RoleInfoClass = class'RORoleInfoSouthernPilotAUS';
                    SouthRoleCount2.RoleInfoClass = class'RORoleInfoSouthernTransportPilotAUS';
                break;

                case SFOR_ARVN:
                    SouthRoleCount1.RoleInfoClass = class'RORoleInfoSouthernPilotARVN';
                    SouthRoleCount2.RoleInfoClass = class'RORoleInfoSouthernTransportPilotARVN';
                break;
            }
        }

        SouthRoleCount1.Count = 255;
        ROMI.SouthernRoles.additem(SouthRoleCount1);

        SouthRoleCount2.Count = 255;
        ROMI.SouthernRoles.additem(SouthRoleCount2);
    }
}