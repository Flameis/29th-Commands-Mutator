class MCPlayerController extends ROPlayerController;

var ROMapInfo                   ROMI;

simulated function PreBeginPlay()
{
    super.PreBeginPlay();

    if (WorldInfo.NetMode == NM_Standalone || Role == ROLE_Authority)
    {
        ReplaceRoles();
    }
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

simulated function ReceivedGameClass(class<GameInfo> GameClass)
{
    super.ReceivedGameClass(GameClass);

    ReplaceRoles();
}

simulated function ReplaceRoles()
{
    local RORoleCount NorthRoleCount, SouthRoleCount1, SouthRoleCount2, SouthRoleCount3;
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    if (ROMI != None)
    {
        `log ("Replacing Roles");

        SouthRoleCount3.RoleInfoClass = class'MCRoleInfoTankCrewSouth';
		SouthRoleCount3.Count = 255;
        ROMI.SouthernRoles.additem(SouthRoleCount3);

        NorthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewNorth';
		NorthRoleCount.Count = 255;
        ROMI.NorthernRoles.additem(NorthRoleCount);

        switch (ROMI.SouthernForce)
        {
            case SFOR_USArmy:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouth';

                SouthRoleCount1.RoleInfoClass = class'RORoleInfoSouthernPilot';
		        SouthRoleCount1.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount1);

                SouthRoleCount2.RoleInfoClass = class'RORoleInfoSouthernTransportPilot';
		        SouthRoleCount2.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount2);
            break;

            case SFOR_USMC:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouth';

                SouthRoleCount1.RoleInfoClass = class'RORoleInfoSouthernPilot';
		        SouthRoleCount1.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount1);

                SouthRoleCount2.RoleInfoClass = class'RORoleInfoSouthernTransportPilot';
		        SouthRoleCount2.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount2);
            break;

            case SFOR_AusArmy:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouthAUS';

                SouthRoleCount1.RoleInfoClass = class'RORoleInfoSouthernPilotAUS';
		        SouthRoleCount1.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount1);

                SouthRoleCount2.RoleInfoClass = class'RORoleInfoSouthernTransportPilotAUS';
		        SouthRoleCount2.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount2);
            break;

            case SFOR_ARVN:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouthARVN';

                SouthRoleCount1.RoleInfoClass = class'RORoleInfoSouthernPilotARVN';
		        SouthRoleCount1.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount1);

                SouthRoleCount2.RoleInfoClass = class'RORoleInfoSouthernTransportPilotARVN';
		        SouthRoleCount2.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount2);
            break;
        }
        
        switch (ROMI.NorthernForce)
        {
            case NFOR_NVA:
                ROMI.NorthernTeamLeader.roleinfo = none;
                ROMI.NorthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderNorth';
            break;

            case NFOR_NLF:
                ROMI.NorthernTeamLeader.roleinfo = none;
                ROMI.NorthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderNorth';
            break;
        }
    }
}

reliable client function ClientReplaceRoles()
{
    ReplaceRoles();
}