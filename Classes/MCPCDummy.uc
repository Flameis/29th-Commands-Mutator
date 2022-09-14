class MCPCDummy extends Actor;

simulated function ReplaceRoles(bool WW, bool GOM)
{
    local ROMapInfo ROMI;
    local RORoleCount SRC, NRC;
    local array<RORoleCount> RORCAN, RORCAS;
	local int 					I;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    RORCAN = ROMI.NorthernRoles;
    RORCAS = ROMI.SouthernRoles;

    ROMI.NorthernRoles.Length = 0;
    ROMI.SouthernRoles.Length = 0;
    ROMI.NorthernRoles.Length = RORCAN.Length;
    ROMI.SouthernRoles.Length = RORCAS.Length;

    ROMI.NorthernRoles = RORCAN;
    ROMI.SouthernRoles = RORCAS;


	if (WW == true)
    {
        SRC.RoleInfoClass = class'MCRoleInfoTankCrewSoviet';
        NRC.RoleInfoClass = class'MCRoleInfoTankCrewFinnish';
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
    }
    else if (GOM == true)
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

        /* for (i = 0; i < ROMI.SouthernRoles.length; i++)
        {
            if (instr(ROMI.SouthernRoles[i].RoleInfoClass.name, "Commander",, true) != -1)
            {
                ROMI.SouthernRoles[i].RoleInfoClass = Class'MCRoleInfoCommanderSouth';
                //ROMI.SouthernTeamLeader.roleinfo = none;
                ROMI.SouthernTeamLeader.roleinfo = new Class'MCRoleInfoCommanderSouth';
                break;
            }
        }
        for (i = 0; i < ROMI.NorthernRoles.length; i++)
        {
            if (instr(ROMI.NorthernRoles[i].RoleInfoClass.name, "Commander",, true) != -1)
            {
                ROMI.NorthernRoles[i].RoleInfoClass = Class'MCRoleInfoCommanderNorth';
                //ROMI.NorthernTeamLeader.roleinfo = none;
                ROMI.NorthernTeamLeader.roleinfo = new Class'MCRoleInfoCommanderNorth';
                break;
            }
        } */
    }
    else
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

        for (i = 0; i < ROMI.SouthernRoles.length; i++)
        {
            if (instr(ROMI.SouthernRoles[i].RoleInfoClass.name, "Commander",, true) != -1)
            {
                ROMI.SouthernRoles[i].Count = 0;
		        ROMI.SouthernTeamLeader.roleinfo = none;
                switch (ROMI.SouthernForce)
                {
                    case SFOR_USArmy:
                    case SFOR_USMC:
                        ROMI.SouthernRoles[i].RoleInfoClass = Class'MCRoleInfoCommanderSouth';
                    break;

                    case SFOR_ARVN:
                        ROMI.SouthernRoles[i].RoleInfoClass =  Class'MCRoleInfoCommanderSouthARVN';
                    break;

                    case SFOR_AusArmy:
                        ROMI.SouthernRoles[i].RoleInfoClass =  Class'MCRoleInfoCommanderSouthAUS';
                    break;
                }
                ROMI.SouthernTeamLeader.roleinfo = new ROMI.SouthernRoles[i].RoleInfoClass;
                break;
            }
        }
        for (i = 0; i < ROMI.NorthernRoles.length; i++)
        {
            if (instr(ROMI.NorthernRoles[i].RoleInfoClass.name, "Commander",, true) != -1)
            {
                ROMI.NorthernRoles[i].Count = 0;
                ROMI.NorthernTeamLeader.roleinfo = none;
                ROMI.NorthernRoles[i].RoleInfoClass = Class'MCRoleInfoCommanderNorth';
                ROMI.NorthernTeamLeader.roleinfo = new ROMI.NorthernRoles[i].RoleInfoClass;
                break;
            }
        }
    }
}

reliable client function ClientReplaceRoles(bool WW, bool GOM)
{
    ReplaceRoles(WW, GOM);
}