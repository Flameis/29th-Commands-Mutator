Class MutCommands extends ROMutator
    config(MutCommands);

var ROMapInfo           ROMI;
var ROGameInfo          ROGI;
var MCPlayerController  MCPC;
var ROPlayerController  ROPC;
var bool                bCTFon;
var int                 CountDisabled;

simulated function PreBeginPlay()
{
    if (!IsWWThere() && !IsMutThere("GOM") && !IsMutThere("Extras"))
    {
        ROGameInfo(WorldInfo.Game).PlayerControllerClass = class'MCPlayerController';
    }

    super.PreBeginPlay();
}

simulated function NotifyLogin(Controller NewPlayer)
{
    local MCPCDummy DummyPC;

    if (IsWWThere())
    {
        DummyPC = Spawn(class'MCPCDummy', NewPlayer);
        DummyPC.ReplaceRoles(true, false);
        DummyPC.ClientReplaceRoles(true, false);
        DummyPC.Destroy();
    }
    else if (IsMutThere("GOM"))
    {
        DummyPC = Spawn(class'MCPCDummy', NewPlayer);
        DummyPC.ReplaceRoles(false, true);
        DummyPC.ClientReplaceRoles(false, true);
        DummyPC.Destroy();
    }
    else
    {
        DummyPC = Spawn(class'MCPCDummy', NewPlayer);
        DummyPC.ReplaceRoles(false, true);
        DummyPC.ClientReplaceRoles(false, true);
        DummyPC.Destroy();
        //MCPlayerController(NewPlayer).ReplaceRoles();
        //MCPlayerController(NewPlayer).ClientReplaceRoles();
    }

    super.NotifyLogin(NewPlayer);
}

auto state StartUp
{
    function timer()
    {
        SetVicTeam();
    }

    function timer2()
    {
        LoadObjectsInit();
    }
        
    Begin:
    SetTimer( 1, true );
    SetTimer( 5, false,  'timer2' );
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

function bool IsMutThere(string Mutator)
{
	local Mutator mut;

    mut = ROGameInfo(WorldInfo.Game).BaseMutator;

    for (mut = ROGameInfo(WorldInfo.Game).BaseMutator; mut != none; mut = mut.NextMutator)
    {
        // `log("[MutCommands] IsMutThere test "$string(mut.name));
        if(InStr(string(mut.name), Mutator,,true) != -1) 
        {
            return true;
        }
    }
    return false;
}

simulated function LoadObjectsInit()
{
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_AH1G_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_OH6_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Gunship_Content", class'Class')));

    // MutExtras
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_AH1G_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_OH6_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_UH1H_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("MutExtras.ACHeli_UH1H_Gunship_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("MutExtras.ACWeap_M18_Claymore_Quad_Content", class'Class')));
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
    ROMI.SharedContentReferences.AddItem(class<ParticleSystem>(DynamicLoadObject("WinterWar_FX.ParticleSystems.FX_VEH_Tank_C_Explosion", class'Class')));

    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("GOM3.GOMVehicle_M113_ACAV_ActualContent", class'Class')));
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

        case "FIRSTPERSON":
            MCamera(PC, true);
            break;

        case "CAPTURETHEFLAG":
            CTFToggle();
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
                // `log("Removed "$Weapon);
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
                    // `log("Removed "$Weapon);
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
                    // `log("Removed "$Weapon);
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
            // `log("Removed "$Weapon);
        }
    }
}

function SpawnVehicle(PlayerController PC, string VehicleName, out string NameValid)
{
	local vector                    CamLoc, StartShot, EndShot, X, Y, Z;
	local rotator                   CamRot;
    local class<ROVehicle>          Vehicle, Skis;
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

function giveweapon2(ROInventoryManager InvManager, string WeaponName, out string NameValid)
{
    switch (WeaponName)
    {
        `include(MutCommands\Classes\WeaponNames.uci)
    }
}

defaultproperties
{
    bCTFon = false
}