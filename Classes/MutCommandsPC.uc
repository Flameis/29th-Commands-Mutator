class MutCommandsPC extends ROPlayerController;

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
    local RORoleCount NorthRoleCount, SouthRoleCount;
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    if (ROMI != None)
    {
        `log ("Replacing Roles");

        switch (ROMI.SouthernForce)
        {
            case SFOR_USArmy:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouth';

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernPilot';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernTransportPilot';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);
            break;

            case SFOR_USMC:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouth';

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernPilot';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernTransportPilot';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);
            break;

            case SFOR_AusArmy:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouthAUS';

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernPilotAUS';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernTransportPilotAUS';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);
            break;

            case SFOR_ARVN:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouthARVN';

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernPilotARVN';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);

                SouthRoleCount.RoleInfoClass = class'RORoleInfoSouthernTransportPilotARVN';
		        SouthRoleCount.Count = 255;
                ROMI.SouthernRoles.additem(SouthRoleCount);
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

        SouthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewSouth';
		SouthRoleCount.Count = 255;
        ROMI.SouthernRoles.additem(SouthRoleCount);

        NorthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewNorth';
		NorthRoleCount.Count = 255;
        ROMI.NorthernRoles.additem(NorthRoleCount);
    }
}

reliable client function ClientReplaceRoles()
{
    ReplaceRoles();
}