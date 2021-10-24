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

simulated function LoadObjects()
{
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    ROMI.SharedContentReferences.Remove(0, ROMI.SharedContentReferences.Length);
	class'WorldInfo'.static.GetWorldInfo().ForceGarbageCollection(TRUE);
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Maxim_ActualContent", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_QuadMaxims_ActualContent", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("ROGameContent.ROWeap_M2_HMG_Tripod_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("ROGameContent.ROWeap_DShK_HMG_Tripod_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_AH1G_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_OH6_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Gunship_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("GOM3.GOMVehicle_M113_ACAV_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T20_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T26_EarlyWar_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T28_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_HT130_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_53K_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_Vickers_ActualContent", class'Class')));
}

reliable client function ClientLoadObjects()
{
    LoadObjects();
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