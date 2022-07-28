Class MutCommands extends ROMutator
    config(MutCommands);

var ROMapInfo           ROMI;
var ROGameInfo          ROGI;
var MCPlayerController  MCPC;
var ROPlayerController  ROPC;
var bool                bCTFon;
var int                 CountDisabled, CountEnabled;

function PreBeginPlay()
{
    `log("[MutCommands] init");

    LoadObjectsInit();
    RemoveVolumes();
    RoleSetup();

    super.PreBeginPlay();
}

/* function NotifyLogin(Controller NewPlayer)
{
    MCPC = MCPlayerController(NewPlayer);

    if (MCPC == None)
    {
        `log("[MutCommands] Error replacing roles");
    }
    if (MCPC != None)
    {
        MCPC.ReplaceRoles();
        MCPC.ClientReplaceRoles();
    }

    super.NotifyLogin(NewPlayer);
} */

auto state StartUp
{
    function timer()
    {
        SetVicTeam();
    }
        
    Begin:
    SetTimer( 1, true );
}

function LoadObjectsInit()
{
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    /* ROMI.SharedContentReferences.Remove(0, ROMI.SharedContentReferences.Length);
	class'WorldInfo'.static.GetWorldInfo().ForceGarbageCollection(TRUE); */

    // Vanilla
	/* ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("ROGameContent.ROWeap_M2_HMG_Tripod_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("ROGameContent.ROWeap_DShK_HMG_Tripod_Content", class'Class'))); */
	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_AH1G_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_OH6_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Gunship_Content", class'Class')));

    // WinterWar
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T20_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T26_EarlyWar_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T28_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_HT130_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_53K_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_Vickers_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_AntiTankMine_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_AVS36_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Binoculars_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_DP28_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_F1Grenade_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Kasapanos_FactoryIssue_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Kasapanos_Improvised_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_KP31_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_L35_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_LahtiSaloranta_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Luger_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_M20_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_M32Grenade_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Maxim_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_MN27_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_MN38_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_MN91_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_MN9130_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_MN9130_Dyakonov_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_MN9130_Scoped_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Molotov_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_NagantRevolver_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_PPD34_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_QuadMaxims_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_RDG1_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_RGD33_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Satchel_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Skis_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_SVT38_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_TT33_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ParticleSystem>(DynamicLoadObject("WinterWar_FX.ParticleSystems.FX_VEH_Tank_C_Explosion", class'ParticleSystem')));

    // GOM
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("GOM3.GOMVehicle_M113_ACAV_ActualContent", class'Class')));

    // MutExtras
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_AH1G_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_OH6_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_UH1H_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_UH1H_Gunship_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M18_Claymore_Quad_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M18_SignalSmoke_Green_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M18_SignalSmoke_Purple_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M18_SignalSmoke_Red_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M18_SignalSmoke_Yellow_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M79_GrenadeLauncher_Level2", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M79_GrenadeLauncher_Level3", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M79_MemeLauncher_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_MG34_LMG_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_Molotov_Triad_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_RPG7_RocketLauncher_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_RPPG_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_Tripwire_Quad_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_VietSatchel_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_XM21Scoped_Rifle_Suppressed", class'Class')));  
}

simulated function RoleSetup()
{
    local RORoleCount   NorthRoleCount, SouthRoleCount;
    local int           I;
    local bool          FoundNTank, FoundSTank;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    if (IsWWThere())
    {
        for (I=0; I < ROMI.NorthernRoles.length; I++)
        {
            if (instr(ROMI.NorthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                FoundNTank = true;
                `log("[MutCommands] Found NTank");
                break;
            }
        }
        for (I=0; I < ROMI.SouthernRoles.length; I++)
        {
            if (instr(ROMI.SouthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                FoundSTank = true;
                `log("[MutCommands] Found STank");
                break;
            }
        }

        if (!FoundNTank)
        {
            NorthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewFinnish';
            ROMI.NorthernRoles.additem(NorthRoleCount);
        }
        if (!FoundSTank)
        {
            SouthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewSoviet';
            ROMI.SouthernRoles.additem(SouthRoleCount);
        }
    }

    else if (IsGOMThere())
    {
        NorthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewNorth';
        ROMI.NorthernRoles.additem(NorthRoleCount);

        SouthRoleCount.RoleInfoClass = class'MCRoleInfoTankCrewSouth';
        ROMI.SouthernRoles.additem(SouthRoleCount);
    }
    else if (ROGameInfo(WorldInfo.Game).PlayerControllerClass == class'ROPlayerController')
    {
        ROGameInfo(WorldInfo.Game).PlayerControllerClass = class'MCPlayerController';
    }

    for (i = 0; i < ROMI.SouthernRoles.length; i++)
    {
        ROMI.SouthernRoles[i].Count = 255;
    }    
    for (i = 0; i < ROMI.NorthernRoles.length; i++)
    {
        ROMI.NorthernRoles[i].Count = 255;
    }
}

function RemoveVolumes()
{
    local ROVolumeNoArtillery ROVNA;

    if (CountDisabled == 0)
    {
        foreach AllActors(class'ROVolumeNoArtillery', ROVNA)
        {
            if (ROVNA.bEnabled == true) {ROVNA.SetEnabled(False); CountDisabled++;}
        }
        //`log ("Set "$CountDisabled$" ROVNA disabled");
    }
}

function SetVicTeam()
{
    local ROVehicle ROV;
    local string    Team;

    foreach DynamicActors(class'ROVehicle', ROV)
    {
        if (ROV.bDriving == true && ROV.Team != ROV.Driver.GetTeamNum() && !ROV.bDeadVehicle)
        {
            ROV.Team = ROV.Driver.GetTeamNum();
            `log("[MutCommands] Set "$ROV$" to team "$ROV.Driver.GetTeamNum());
            
            if (bCTFon)
            {
                if (ROV.Driver.GetTeamNum() == 0) {Team = "North";}
                else {Team = "South";}
                WorldInfo.Game.Broadcast(self, "The "$ROV$" was captured by the "$Team);
            }
        }
    }
}

function bool IsWWThere()
{
    local string WWName;
    WWName = class'Engine'.static.GetCurrentWorldInfo().GetMapName(true);
    if (InStr(WWName, "WW") != -1)
    {
        return true;
    }
    return false;
}

function bool IsGOMThere()
{
	local Mutator mut;
    ROGI = ROGameInfo(WorldInfo.Game);
    mut = ROGI.BaseMutator;

    for (mut = ROGI.BaseMutator; mut != none; mut = mut.NextMutator)
    {
        `log("[MutCommands] IsMutThere test "$string(mut.name));
        if(InStr(string(mut.name), "GOM",,true) != -1) 
        {
            return true;
        }
    }
    return false;
}

function PrivateMessage(PlayerController receiver, coerce string msg)
{
    receiver.TeamMessage(None, msg, '');
}

singular function Mutate(string MutateString, PlayerController PC) //no prefixes, also call super function!
{
    local array<string> Args;
    local string        command;
    local string        NVW, NVV;
    local string        PlayerName;

	ROGI = ROGameInfo(WorldInfo.Game);
    ROPC = ROPlayerController(PC);

    Args = SplitString(MutateString, " ", true);
    command = Caps(Args[0]);
    PlayerName = PC.PlayerReplicationInfo.PlayerName;
    
    Switch (Command)
    {
        case "GIVEWEAPON":
            GiveWeapon(PC, Args[1], NVW, false, 100);
            if (NVW == "True" )
            {
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" spawned a "$Args[1]);
                `log("[MutCommands] "$PlayerName$" spawned a "$Args[1]$"");
            }
            else if (NVW == "False")
            {
                `log("[MutCommands] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                PrivateMessage(PC, "Not a valid weapon name.");
            }
            break;

        case "GIVEWEAPONALL":
            GiveWeapon(PC, Args[1], NVW, true);
            if (NVW == "True")
            {
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" gave a "$Args[1]$" to everyone");
                `log("[MutCommands] "$PlayerName$" spawned a "$Args[1]$"");
            }
            else if (NVW == "False")
            {
                `log("[MutCommands] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                PrivateMessage(PC, "Not a valid weapon name.");
            }
            break;

        case "GIVEWEAPONNORTH":
            GiveWeapon(PC, Args[1], NVW, false, `AXIS_TEAM_INDEX);
            if (NVW == "True")
            {
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" gave a "$Args[1]$" to the north");
                `log("[MutCommands] "$PlayerName$" gave a "$Args[1]$" to the north");
            }
            else if (NVW == "False")
            {
                `log("[MutCommands] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                PrivateMessage(PC, "Not a valid weapon name.");
            }
            break;

        case "GIVEWEAPONSOUTH":
            GiveWeapon(PC, Args[1], NVW, false, `ALLIES_TEAM_INDEX);
            if (NVW == "True")
            {
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" gave a "$Args[1]$" to the south");
                `log("[MutCommands] "$PlayerName$" gave a "$Args[1]$" to the south");
            }
            else if (NVW == "False")
            {
                `log("[MutCommands] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                PrivateMessage(PC, "Not a valid weapon name.");
            }
            break;

        case "CLEARWEAPONS":
            ClearWeapons(PC, false, 100);
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" cleared their weapons");
            `log("[MutCommands] Clearing Weapons");
            break;

        case "CLEARWEAPONSALL":
            ClearWeapons(PC, true);
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" cleared all weapons");
            `log("[MutCommands] Clearing Weapons");
            break;

        case "CLEARWEAPONSNORTH":
            ClearWeapons(PC, false, `AXIS_TEAM_INDEX);
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" cleared north weapons");
            `log("[MutCommands] Clearing Weapons");
            break;

        case "CLEARWEAPONSSOUTH":
            ClearWeapons(PC, false, `ALLIES_TEAM_INDEX);
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" cleared south weapons");
            `log("[MutCommands] Clearing Weapons");
            break;
        
        case "SPAWNVEHICLE":
            SpawnVehicle(PC, Args[1], NVV);
            if (NVV == "True")
            {
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" spawned a "$Args[1]);
                `log("[MutCommands] "$PlayerName$" spawned a "$Args[1]$"");
            }
            else
            {
                `log("[MutCommands] Spawnvehicle failed! "$PlayerName$" tried to spawn a "$Args[1]);
                PrivateMessage(PC, "Not a valid vehicle name.");
            }
            break;

        case "CLEARVEHICLES":
            ClearVehicles();
            `log("[MutCommands] Clearing Vehicles");
            break;

        case "SetJumpZ":
            SetJumpZ(PC, float(Args[1]));
            `log("[MutCommands] SetJumpZ");
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set their JumpZ to "$Args[1]);
            break;

        case "SetGravity":
            SetGravity(PC, float(Args[1]));
            `log("[MutCommands] SetGravity");
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set gravity to "$Args[1]);
            break;

        case "SetSpeed":
            SetSpeed(PC, float(Args[1]), Args[2]);
            `log("[MutCommands] SetSpeed");
            if (Args[2] ~= "all")
            {
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set everyone's speed to "$Args[1]);
            }
            else
            {
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set their speed to "$Args[1]);
            }
            break;

        /* case "FLY":
            if (PC.bCheatFlying == false)
            {
                Fly();
                PC.Pawn.AirSpeed = PC.Pawn.Default.AirSpeed * 20;
                `log("[MutCommands] Fly");
            }
            else
            {
                Walk();
                PC.Pawn.AirSpeed = PC.Pawn.Default.AirSpeed;
                `log("[MutCommands] UnFly");
            }    
            break; */

        case "ChangeSize":
            ChangeSize(PC, float(Args[1]));
            `log("[MutCommands] ChangeSize");
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set their size to "$Args[1]);
            break;

        case "ADDBOTS":
            AddBots(int(Args[1]), int(Args[2]), bool(Args[3]));
            `log("[MutCommands] Added Bots");
            break;

        case "REMOVEBOTS":
            RemoveBots();
            `log("[MutCommands] Removed Bots");
            break;

        case "ALLAMMO":
            AllAmmo(PC);
            `log("[MutCommands] Infinite Ammo");
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" toggled AllAmmo");
            break;

        case "THIRDPERSON":
            MCamera(PC);
            WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" went thirdperson");
            break;

        case"FIRSTPERSON":
            MCamera(PC, true);
            break;

        case "CAPTURETHEFLAG":
            CTFToggle();
            break;

        case "CALLNAPALM":
            SpawnFireSupport(PC, 0);
            break;

        case "CALLCANBERRA":
            SpawnFireSupport(PC, 1);
            break;

        case "CALLAC47":
            SpawnFireSupport(PC, 2);
            break;

        case "CALLAA":
            SpawnFireSupport(PC, 3);
            break;

        case "CALLARTY":
            SpawnFireSupport(PC, 4);
            break;
    }
    super.Mutate(MutateString, PC);
}

function GiveWeapon(PlayerController PC, string WeaponName, out string NameValid, optional bool bGiveAll, optional int TeamIndex)
{
	local ROInventoryManager        InvManager;
    local ROPawn                    ROP;

    NameValid = "True";

    if (PC != none)
    {
        if (bGiveAll)
        { 
            foreach worldinfo.allpawns(class'ROPawn', ROP)
            {
                InvManager = ROInventoryManager(ROP.InvManager);
                giveweapon2(InvManager, WeaponName, NameValid);
            }
        }   

        else if (TeamIndex == `AXIS_TEAM_INDEX)
        {
            foreach worldinfo.allpawns(class'ROPawn', ROP)
            {
                if (ROP.GetTeamNum() == `AXIS_TEAM_INDEX)
                {
                    InvManager = ROInventoryManager(ROP.InvManager);
                    giveweapon2(InvManager, WeaponName, NameValid);
                }
            }
        }

        else if (TeamIndex == `ALLIES_TEAM_INDEX)
        {
            foreach worldinfo.allpawns(class'ROPawn', ROP)
            {
                if (ROP.GetTeamNum() == `ALLIES_TEAM_INDEX)
                {
                    InvManager = ROInventoryManager(ROP.InvManager);
                    giveweapon2(InvManager, WeaponName, NameValid);
                }
            }
        }

        else if (TeamIndex == 100)
        {
            InvManager = ROInventoryManager(PC.Pawn.InvManager);
            giveweapon2(InvManager, WeaponName, NameValid);
        }
    }
    else
    {
        `log("[MutCommands] Error: GW PlayerController is none!");
    }
}

function giveweapon2(ROInventoryManager InvManager, string WeaponName, out string NameValid)
{
    switch (WeaponName)
    {
        `include(MutCommands\Classes\WeaponNames.uci)
    }
}

function ClearWeapons(PlayerController PC, bool GiveAll, optional int TeamIndex)
{
    local array<ROWeapon>       WeaponsToRemove;
    local ROWeapon              Weapon;
    local ROInventoryManager    ROIM;
    local ROPawn                ROP;

    if (GiveAll)
    { 
        foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            ROIM = ROInventoryManager(ROP.InvManager);
            ROIM.GetWeaponList(WeaponsToRemove);

            foreach WeaponsToRemove(Weapon)
            {
                ROIM.RemoveFromInventory(Weapon);
                `log("Removed "$Weapon);
            }
        }
    }   

    else if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            if (ROP.GetTeamNum() == `AXIS_TEAM_INDEX)
            {
                ROIM = ROInventoryManager(ROP.InvManager);
                ROIM.GetWeaponList(WeaponsToRemove);

                foreach WeaponsToRemove(Weapon)
                {
                    ROIM.RemoveFromInventory(Weapon);
                    `log("Removed "$Weapon);
                }
            }
        }
    }

    else if (TeamIndex == `ALLIES_TEAM_INDEX)
    {
        foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            if (ROP.GetTeamNum() == `ALLIES_TEAM_INDEX)
            {
                ROIM = ROInventoryManager(ROP.InvManager);
                ROIM.GetWeaponList(WeaponsToRemove);

                foreach WeaponsToRemove(Weapon)
                {
                    ROIM.RemoveFromInventory(Weapon);
                    `log("Removed "$Weapon);
                }
            }
        }
    }

    else if (TeamIndex == 100)
    {
        ROIM = ROInventoryManager(PC.Pawn.InvManager);
        ROIM.GetWeaponList(WeaponsToRemove);

        foreach WeaponsToRemove(Weapon)
        {
            ROIM.RemoveFromInventory(Weapon);
            `log("Removed "$Weapon);
        }
    }
}

function SpawnVehicle(PlayerController PC, string VehicleName, out string NameValid)
{
	local vector                    CamLoc, StartShot, EndShot, X, Y, Z;
	local rotator                   CamRot;
    local class<ROVehicle>          Vehicle, Skis;
	//local class<ROVehicle>          Cobra, Loach, Huey, Bushranger, ACCobra, ACLoach, ACHuey, ACBushranger, BlueHuey, GreenHuey, GreenBushranger, M113ACAV, T20, T26, T28, HT130, ATGun, Vickers, Skis, T34, T54, MUTT, M113ARVN;
	local ROVehicle                 ROHelo;
    local ROPawn                    ROP;

    Skis = class'WinterWar.WWVehicle_Skis_ActualContent';
    NameValid = "True";
    ROP = ROPawn(PC.Pawn);
    // Do ray check and grab actor
	PC.GetPlayerViewPoint(CamLoc, CamRot);
	GetAxes(CamRot, X, Y, Z );
	StartShot   = CamLoc;
	EndShot     = StartShot + (400.0 * X) + (200 * Z);

	switch (VehicleName)
    {
        // Vanilla
        case "Cobra":
        Vehicle = class'ROGameContent.ROHeli_AH1G_Content';
        break;

        case "Loach":
        Vehicle = class'ROGameContent.ROHeli_OH6_Content';
        break;

        case "Huey":
        Vehicle = class'ROGameContent.ROHeli_UH1H_Content';
        break;

        case "Bushranger":
        Vehicle = class'ROGameContent.ROHeli_UH1H_Gunship_Content';
        break;

        // MutExtras
        case "ACCobra":
        Vehicle = class'MutExtras.ACHeli_AH1G_Content';
        break;

        case "ACLoach":
        Vehicle = class'MutExtras.ACHeli_OH6_Content';
        break;
        
        case "ACHuey":
        Vehicle = class'MutExtras.ACHeli_UH1H_Content';
        break;

        case "ACBushranger":
        Vehicle = class'MutExtras.ACHeli_UH1H_Gunship_Content';
        break;

        // Green Army Men
        case "BlueHuey":
        Vehicle = class'GreenMenMod.GMHeli_Blue_UH1H';
        break;

        case "GreenHuey":
        Vehicle = class'GreenMenMod.GMHeli_Green_UH1H';
        break;

        case "GreenBushranger":
        Vehicle = class'GreenMenMod.GMHeli_Green_UH1H_Gunship_Content';
        break;

        //GOM 4
        case "M113ACAV":
        Vehicle = class'GOM3.GOMVehicle_M113_ACAV_ActualContent';
        break;

        case "MUTT":
		Vehicle = class'GOM4.GOMVehicle_M151_MUTT_US';
        break;

        case "T34":
		Vehicle = class'GOM4.GOMVehicle_T34_ActualContent';
        break;

        case "M113ARVN":
		Vehicle = class'GOM4.GOMVehicle_M113_APC_ARVN';
        break;
        
        case "T54":
		Vehicle = class'GOM4.GOMVehicle_T54';
        break;

        //Winter War
        case "T20":
		Vehicle = class'WinterWar.WWVehicle_T20_ActualContent';
        break;

        case "T26":
		Vehicle = class'WinterWar.WWVehicle_T26_EarlyWar_ActualContent';
        break;

        case "T28":
		Vehicle = class'WinterWar.WWVehicle_T28_ActualContent';
        break;

        case "HT130":
		Vehicle = class'WinterWar.WWVehicle_HT130_ActualContent';
        break;

        case "ATGun":
		Vehicle = class'WinterWar.WWVehicle_53K_ActualContent';
        break;

        case "Vickers":
		Vehicle = class'WinterWar.WWVehicle_Vickers_ActualContent';
        break;

        case "Skis":
		ROHelo = Spawn(Skis, , , EndShot, camrot);
        ROHelo.bTeamLocked = false;
        ROHelo.TryToDrive(ROP);
        break;

        default:
        NameValid = "False";
        break;
    }

    ROHelo = Spawn(Vehicle, , , EndShot, camrot);
    ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
    ROHelo.bTeamLocked = false;
}

function ClearVehicles()
{
	local ROVehicle ROV;

	foreach WorldInfo.AllActors(class'ROVehicle', ROV)
	{
		if( !ROV.bDriving )
            ROV.ShutDown();
			ROV.Destroy();
	}
}

function SetJumpZ(PlayerController PC, float F )
{
        if (0.5 <= F && F <= 10)
	    {
	        PC.Pawn.JumpZ = F;
        }
        else
        {
            PC.Pawn.JumpZ = 1;
            // `log("Error");
        }
}

function SetGravity(PlayerController PC, float F )
{
        if (-1000 <= F && F <= 1000)
	    {
            WorldInfo.WorldGravityZ = WorldInfo.Default.WorldGravityZ * F;
        }
        else
        {
            WorldInfo.WorldGravityZ = WorldInfo.Default.WorldGravityZ;
            // `log("Error");
        }
}

function SetSpeed(PlayerController PC, float F, string S)
{
    if (S ~= "all")
    {
        ForEach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (0.5 <= F && F <= 20)
            {
                PC.Pawn.GroundSpeed =   PC.Pawn.Default.GroundSpeed * F;
	            PC.Pawn.WaterSpeed =    PC.Pawn.Default.WaterSpeed * F;
                PC.Pawn.AirSpeed =      PC.Pawn.Default.AirSpeed * F;
                PC.Pawn.LadderSpeed =   PC.Pawn.Default.LadderSpeed * F;
            }
            else
            {
                PC.Pawn.GroundSpeed =   PC.Pawn.Default.GroundSpeed;
	            PC.Pawn.WaterSpeed =    PC.Pawn.Default.WaterSpeed;
                PC.Pawn.AirSpeed =      PC.Pawn.Default.AirSpeed;
                PC.Pawn.LadderSpeed =   PC.Pawn.Default.LadderSpeed;
                // `log("Error");
            }
        }
    }
    if (0.1 <= F && F <= 20)
	{
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed * F;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed * F;
        PC.Pawn.AirSpeed = PC.Pawn.Default.AirSpeed * F;
        PC.Pawn.LadderSpeed = PC.Pawn.Default.LadderSpeed * F;
    }
    else
    {
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed;
        PC.Pawn.AirSpeed = PC.Pawn.Default.AirSpeed;
        PC.Pawn.LadderSpeed = PC.Pawn.Default.LadderSpeed;
        // `log("Error");
    }
}

/* function Fly(PlayerController PC)
{
    if ((PC.Pawn != None) && PC.bCheatFlying == false)
	{
        PC.Pawn.CheatFly();
		PC.ClientMessage("You feel much lighter");
		PC.bCheatFlying = true;
		PC.Outer.GotoState('PlayerFlying');
	}
	else if (PC.Pawn != None)
	{
        PC.Pawn.CheatWalk();
        PC.bCheatFlying = false;
		PC.Restart(false);
	}
} */

function ChangeSize(PlayerController PC, float F )
{
    if (0.1 <= F && F <= 50)
	{
        PC.Pawn.CylinderComponent.SetCylinderSize(PC.Pawn.CylinderComponent.CollisionRadius * F / 2, PC.Pawn.CylinderComponent.CollisionHeight * F);
	    PC.Pawn.SetDrawScale(F);
	    PC.Pawn.SetLocation(PC.Pawn.Location);
    }
    else
    {
        PC.Pawn.CylinderComponent.SetCylinderSize(PC.Pawn.Default.CylinderComponent.CollisionRadius, PC.Pawn.Default.CylinderComponent.CollisionHeight);
	    PC.Pawn.SetDrawScale(1);
	    PC.Pawn.SetLocation(PC.Pawn.Location);
        // `log("Error");
    }
}

function AddBots(int Num, optional int NewTeam = -1, optional bool bNoForceAdd)
{
	local ROAIController ROBot;
    local ROPlayerReplicationInfo ROPRI;
	local byte ChosenTeam;
	local byte SuggestedTeam;
	// do not add bots during server travel
    ROGI = ROGameInfo(WorldInfo.Game);

	if( ROGI.bLevelChange )
	{
		return;
	}

	while ( Num > 0 && ROGI.NumBots + ROGI.NumPlayers < ROGI.MaxPlayers )
	{
		// Create a new Controller for this Bot
	    ROBot = Spawn(ROGI.AIControllerClass);
        ROPRI = ROPlayerReplicationInfo(ROBot.PlayerReplicationInfo);

		// Assign the bot a Player ID
		ROBot.PlayerReplicationInfo.PlayerID = ROGI.CurrentID++;

		// Suggest a team to put the AI on
		if ( ROGI.bBalanceTeams || NewTeam == -1 )
		{
			if ( ROGI.GameReplicationInfo.Teams[`AXIS_TEAM_INDEX].Size - ROGI.GameReplicationInfo.Teams[`ALLIES_TEAM_INDEX].Size <= 0
				&& ROGI.BotCapableNorthernRolesAvailable() )
			{
				SuggestedTeam = `AXIS_TEAM_INDEX;
			}
			else if( ROGI.BotCapableSouthernRolesAvailable() )
			{
				SuggestedTeam = `ALLIES_TEAM_INDEX;
			}
			// If there are no roles available on either team, don't allow this to go any further
			else
			{
				ROBot.Destroy();
				return;
			}
		}
		else if (ROGI.BotCapableNorthernRolesAvailable() || ROGI.BotCapableSouthernRolesAvailable())
		{
			SuggestedTeam = NewTeam;
		}
		else
		{
			ROBot.Destroy();
			return;
		}

		// Put the new Bot on the Team that needs it
		ChosenTeam = ROGI.PickTeam(SuggestedTeam, ROBot);
		// Set the bot name based on team
		ROGI.ChangeName(ROBot, ROGI.GetDefaultBotName(ROBot, ChosenTeam, ROTeamInfo(ROGI.GameReplicationInfo.Teams[ChosenTeam]).NumBots + 1), false);

		ROGI.JoinTeam(ROBot, ChosenTeam);

		ROBot.SetTeam(ROBot.PlayerReplicationInfo.Team.TeamIndex);

		// Have the bot choose its role
		if( !ROBot.ChooseRole() )
		{
			ROBot.Destroy();
			continue;
		}
        if (ROPRI.ClassIndex == 11 || ROPRI.ClassIndex == 8)
        {
            if (ROBot.PlayerReplicationInfo.Team.TeamIndex == `AXIS_TEAM_INDEX)
            {
                ROPRI.SelectRoleByClass(ROBot, class'RORoleInfoNorthernRifleman');
            }
            else
            {
                ROPRI.SelectRoleByClass(ROBot, class'RORoleInfoSouthernRifleman');
            }   
        }

		ROBot.ChooseSquad();

		if ( ROTeamInfo(ROBot.PlayerReplicationInfo.Team) != none && ROTeamInfo(ROBot.PlayerReplicationInfo.Team).ReinforcementsRemaining > 0 )
		{
			// Spawn a Pawn for the new Bot Controller
			ROGI.RestartPlayer(ROBot);
		}

		if ( ROGI.bInRoundStartScreen )
		{
			ROBot.AISuspended();
		}

		// Note that we've added another Bot
		if( !bNoForceAdd )
		ROGI.DesiredPlayerCount++;
	    ROGI.NumBots++;
		Num--;
		ROGI.UpdateGameSettingsCounts();
	}
}

function RemoveBots()
{
    local ROAIController ROB;
    foreach allactors(class'ROAIController', ROB)
    {
        ROB.ShutDown();
        ROB.Destroy();
        ROB.Pawn.ShutDown();
        ROB.Pawn.Destroy();
    }
}

function AllAmmo(PlayerController PC)
{
	ROInventoryManager(PC.Pawn.InvManager).AllAmmo(true);
	ROInventoryManager(PC.Pawn.InvManager).bInfiniteAmmo = true;
	ROInventoryManager(PC.Pawn.InvManager).DisableClientAmmoTracking();
}

function MCamera(playercontroller PC, optional bool First = false)
{
    if (First)
	{
		PC.SetCameraMode('FirstPerson');
	}
	else
	{
		PC.SetCameraMode('ThirdPerson');
	}
}

/*function LoadGOMObjects()
{
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("GOM3.GOMVehicle_M113_ACAV_ActualContent", class'Class')));
}

function LoadWinterWarObjects()
{
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Maxim_ActualContent", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_QuadMaxims_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T20_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T26_EarlyWar_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T28_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_HT130_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_53K_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_Vickers_ActualContent", class'Class')));
}*/

function CTFToggle()
{
    if (!bCTFon)
    {
    WorldInfo.Game.Broadcast(self, "[MutCommands] Capture the flag mode is now on");
    bCTFon = !bCTFon;
    }
    else
    {
    WorldInfo.Game.Broadcast(self, "[MutCommands] Capture the flag mode is now off");
    bCTFon = !bCTFon;
    }
}

function SpawnFireSupport(PlayerController PC, int SupportIndex)
{
    switch (SupportIndex)
    {
        case 0:
        DoTestNapalmStrike(PC);
        break;

        case 1:
        DoTestCanberraStrike(PC);
        break;

        case 2:
        DoGunshipTestOrbit(PC);
        break;

        case 3:
        ServerTestAntiAir(PC);
        break;

        case 4:
        DoTestArtyStrike(PC);
        break;

        default:
        `log ("[MutCommands] SpawnFireSupport failed");
        break;
    }
}

reliable private server function DoTestNapalmStrike(PlayerController PC, optional bool bLockX, optional bool bLockY)
{
	local vector TargetLocation, SpawnLocation;
	local class<RONapalmStrikeAircraft> AircraftClass;
	local RONapalmStrikeAircraft Aircraft;
	local ROTeamInfo ROTI;

	if ( ROPlayerReplicationInfo(PC.PlayerReplicationInfo) == none ||
		 ROPlayerReplicationInfo(PC.PlayerReplicationInfo).RoleInfo == none ||
		 PC.Pawn == none )
	{
		return;
	}
    
    ROPC = ROPlayerController(PC);
	ROTI = ROTeamInfo(PC.PlayerReplicationInfo.Team);

	if ( ROTI != none )
	{
		ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
	}

	if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
		TargetLocation = ROTI.ArtyStrikeLocation;
	else
		TargetLocation = PC.Pawn.Location;

	ROMI = ROMapInfo(WorldInfo.GetMapInfo());

	if( ROMI != none && ROMI.SouthernForce == SFOR_ARVN )
		AircraftClass = class'RONapalmStrikeAircraftARVN';
	else
		AircraftClass = class'RONapalmStrikeAircraft';

	SpawnLocation = ROPC.GetBestAircraftSpawnLoc(TargetLocation, ROMapInfo(WorldInfo.GetMapInfo()).NapalmStrikeHeightOffset, AircraftClass);
	TargetLocation.Z = SpawnLocation.Z;

	Aircraft = Spawn(AircraftClass,self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

	if ( Aircraft == none )
	{
		`log("[MutCommands] Error Spawning Support Aircraft");
	}
	else
	{
		if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
			Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
		else
			Aircraft.TargetLocation = PC.Pawn.Location;

		Aircraft.SetDropPoint();
	}

	ROPC.KillsWithCurrentNapalm = 0; // Reset Napalm Kills as We call it in!!!
}

reliable private server function DoTestCanberraStrike(PlayerController PC, optional vector2D StrikeDir)
{
	local vector TargetLocation, SpawnLocation;
	local ROCarpetBomberAircraft Aircraft;
	local ROTeamInfo ROTI;

	if ( ROPlayerReplicationInfo(PC.PlayerReplicationInfo) == none ||
		 ROPlayerReplicationInfo(PC.PlayerReplicationInfo).RoleInfo == none ||
		 PC.Pawn == none )
	{
		return;
	}

    ROPC = ROPlayerController(PC);
	ROTI = ROTeamInfo(PC.PlayerReplicationInfo.Team);

	if ( ROTI != none )
	{
		ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
	}

	if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
		TargetLocation = ROTI.ArtyStrikeLocation;
	else
		TargetLocation = PC.Pawn.Location;

	SpawnLocation = ROPC.GetSupportAircraftSpawnLoc(TargetLocation, class'ROCarpetBomberAircraft', StrikeDir);

	if( ROMapInfo(WorldInfo.GetMapInfo()).bUseNapalmHeightOffsetForAll )
		SpawnLocation.Z += ROMapInfo(WorldInfo.GetMapInfo()).NapalmStrikeHeightOffset;
	else
		SpawnLocation.Z += ROMapInfo(WorldInfo.GetMapInfo()).CarpetBomberHeightOffset;

	TargetLocation.Z = SpawnLocation.Z;

	Aircraft = Spawn(class'ROCarpetBomberAircraft',self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

	if ( Aircraft == none )
	{
		`log("[MutCommands] Error Spawning Support Aircraft");
	}
	else
	{
		if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
			Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
		else
			Aircraft.TargetLocation = PC.Pawn.Location;

		Aircraft.SetDropPoint();
		Aircraft.SetOffset(1);
	}

	Aircraft = Spawn(class'ROCarpetBomberAircraft',self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

	if ( Aircraft == none )
	{
		`log("[MutCommands] Error Spawning Support Aircraft");
	}
	else
	{
		if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
			Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
		else
			Aircraft.TargetLocation = PC.Pawn.Location;

		Aircraft.InboundDelay += 1;
		Aircraft.SetDropPoint();
		Aircraft.SetOffset(2);
	}
}

reliable private server function DoGunshipTestOrbit(PlayerController PC)
{
	local vector TargetLocation, SpawnLocation;
	local ROGunshipAircraft Aircraft;
	local ROTeamInfo ROTI;

	if ( ROPlayerReplicationInfo(PC.PlayerReplicationInfo) == none ||
		 ROPlayerReplicationInfo(PC.PlayerReplicationInfo).RoleInfo == none ||
		 PC.Pawn == none )
	{
		return;
	}

    ROPC = ROPlayerController(PC);
	ROTI = ROTeamInfo(PC.PlayerReplicationInfo.Team);

	if ( ROTI != none )
	{
		ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
	}

	if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
		TargetLocation = ROTI.ArtyStrikeLocation;
	else
		TargetLocation = PC.Pawn.Location;

	SpawnLocation = ROPC.GetBestAircraftSpawnLoc(TargetLocation, class'ROGunshipAircraft'.default.Altitude, class'ROGunshipAircraft');
	TargetLocation.Z = SpawnLocation.Z;

	Aircraft = Spawn(class'ROGunshipAircraft',self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

	if ( Aircraft == none )
	{
		`log("[MutCommands] Error Spawning Support Aircraft");
	}
	else
	{
		if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
			Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
		else
			Aircraft.TargetLocation = PC.Pawn.Location;

		Aircraft.CalculateOrbit();
	}
}

reliable private server function ServerTestAntiAir(PlayerController PC)
{
	if ( ROPlayerReplicationInfo(PC.PlayerReplicationInfo) == none ||
		 ROPlayerReplicationInfo(PC.PlayerReplicationInfo).RoleInfo == none ||
		 PC.Pawn == none )
	{
		return;
	}
    ROPC = ROPlayerController(PC);

	Spawn(class'ROSAMSpawner', self,, ROPC.GetSAMSpawnLoc());
}

private function DoTestArtyStrike(PlayerController PC)
{
	local vector SpawnLocation, MyGravity;
	local ROArtillerySpawner Spawner;
	local Controller C;
	local ROTeamInfo ROTI;

	ROTI = ROTeamInfo(PC.PlayerReplicationInfo.Team);

	MyGravity.X = 0.0;
	MyGravity.Y = 0.0;
	MyGravity.Z = PhysicsVolume.GetGravityZ();

	if ( ROTI != none )
	{
		ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
	}

	SpawnLocation = ROTI.SavedArtilleryCoords;
	SpawnLocation.Z = ROGameReplicationInfo(WorldInfo.GRI).ArtySpawn.Z;

	Spawner = Spawn(class'ROArtillerySpawner',self,, SpawnLocation, rotator(MyGravity));

	if ( Spawner == none )
	{
		`log("[MutCommands] Error Spawning Artillery Shell Spawner ");
	}
	else
	{
		Spawner.OriginalArtyLocation = ROTI.SavedArtilleryCoords;
	}

	foreach WorldInfo.AllControllers(class'Controller', C)
	{
  		if ( PlayerController(C) != none && PlayerController(C).GetTeamNum() == GetTeamNum() )
  		{
  			PlayerController(C).ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_ArtilleryStrike);
  		}
  	}
}

defaultproperties
{
    bCTFon = false
    CountEnabled = 0
}