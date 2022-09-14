class MCPlayerController extends ROPlayerController;

simulated function PreBeginPlay()
{
    super.PreBeginPlay();

    if (WorldInfo.NetMode == NM_Standalone || Role == ROLE_Authority)
    {
    	ReplaceRoles();
	}
}

simulated function ReplaceRoles()
{
    local ROMapInfo ROMI;
    local RORoleCount SRC, NRC;
	local int 					I;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

	if (ROMI != None)
    {
        SRC.RoleInfoClass = class'MCRoleInfoTankCrewSouth';
        NRC.RoleInfoClass = class'MCRoleInfoTankCrewNorth';
        SRC.Count = 255;
        NRC.Count = 255;

        ROMI.SouthernRoles.AddItem(SRC);
		ROMI.NorthernRoles.AddItem(NRC);

        //Infinite roles
        for (i = 0; i < ROMI.SouthernRoles.length; i++)
        {
            ROMI.SouthernRoles[i].Count = 255;
        }    
        for (i = 0; i < ROMI.NorthernRoles.length; i++)
        {
            ROMI.NorthernRoles[i].Count = 255;
        }

        /* switch (ROMI.SouthernForce)
        {
            case SFOR_USArmy:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouth';
            break;

            case SFOR_USMC:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouth';
            break;

            case SFOR_AusArmy:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouthAUS';
            break;

            case SFOR_ARVN:
                ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderSouthARVN';
            break;
        }
        ROMI.NorthernTeamLeader.roleinfo = none;
        ROMI.NorthernTeamLeader.roleinfo = new class'MCRoleInfoCommanderNorth'; */
    }
}

reliable client function ClientReplaceRoles()
{
    ReplaceRoles();
}