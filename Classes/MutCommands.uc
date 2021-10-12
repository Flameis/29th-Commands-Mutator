Class MutCommands extends ROMutator
    config(MutCommands);

var ROMapInfo           ROMI;
var ROGameInfo          ROGI;
var ROPlayerController  ROPC;
var string              PlayerName;
var array<string>       Args;
var string              command;

function PreBeginPlay()
{
    `log("MutCommands init");

    LoadObjects();

    super.PreBeginPlay();
}

function PostBeginPlay()
{
    LoadObjects();

    super.PostBeginPlay();
}

simulated function ModifyPreLogin(string Options, string Address, out string ErrorMessage)
{
    LoadObjects();

    super.ModifyPreLogin(Options, Address, ErrorMessage);
}

function LoadObjects()
{
    `log("Loading Objects...");

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    DynamicLoadObject("ROGameContent.ROHeli_AH1G_Content", class'Class');
    DynamicLoadObject("ROGameContent.ROHeli_OH6_Content", class'Class');
    DynamicLoadObject("ROGameContent.ROHeli_UH1H_Content", class'Class');
    DynamicLoadObject("ROGameContent.ROHeli_UH1H_Gunship_Content", class'Class');
    DynamicLoadObject("GOM3.GOMVehicle_M113_ACAV_ActualContent", class'Class');
    //DynamicLoadObject("GOM4.GOMVehicle_M113_ACAV_ActualContent", class'Class');
    //DynamicLoadObject("GOM4.GOMVehicle_M113_APC_ARVN", class'Class');
    //DynamicLoadObject("GOM4.GOMVehicle_M151_MUTT_US", class'Class');
    //DynamicLoadObject("GOM4.GOMVehicle_T34_ActualContent", class'ROVehicle');
    DynamicLoadObject("WinterWar.WWVehicle_T20_ActualContent", class'ROVehicle');
    DynamicLoadObject("WinterWar.WWVehicle_T26_EarlyWar_ActualContent", class'ROVehicle');
    DynamicLoadObject("WinterWar.WWVehicle_T28_ActualContent", class'ROVehicle');
    DynamicLoadObject("WinterWar.WWVehicle_HT130_ActualContent", class'ROVehicle');
    DynamicLoadObject("WinterWar.WWVehicle_53K_ActualContent", class'ROVehicle');
    DynamicLoadObject("WinterWar.WWVehicle_Vickers_ActualContent", class'ROVehicle');

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

function PrivateMessage(PlayerController receiver, coerce string msg)
{
    receiver.TeamMessage(None, msg, '');
}

function Mutate(string MutateString, PlayerController PC) //no prefixes, also call super function!
{
    local string NameValid;

        Args = SplitString(MutateString, " ", true);
        command = Caps(Args[0]);
        PlayerName = PC.PlayerReplicationInfo.PlayerName;
        
            Switch (Command)
            {
                case "GIVEWEAPON":
                GiveWeapon(PC, Args[1], NameValid);

                if (NameValid != "False")
                {
                    WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" spawned a "$Args[1]);
                    `log("[MutCommands] "$PlayerName$" spawned a "$Args[1]$"");
                }
                else
                {
                    `log("[MutCommands] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                    PrivateMessage(PC, "Not a valid weapon name.");
                }

                break;
                
                case "SPAWNVEHICLE":
                SpawnVehicle(PC, Args[1], NameValid);

                if (NameValid != "False")
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
                `log("Clearing Vehicles");
                break;

                //case "SLOMO":
                //Slomo(float(Args[1]));
                //`log("Slomo");
                //break;

                case "SetJumpZ":
                SetJumpZ(PC, float(Args[1]));
                `log("SetJumpZ");
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set their JumpZ to "$Args[1]);
                break;

                case "SetGravity":
                SetGravity(PC, float(Args[1]));
                `log("SetGravity");
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set gravity to "$Args[1]);
                break;

                case "SetSpeed":
                SetSpeed(PC, float(Args[1]));
                `log("SetSpeed");
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set their speed to "$Args[1]);
                break;

                case "ChangeSize":
                ChangeSize(PC, float(Args[1]));
                `log("ChangeSize");
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" set their size to "$Args[1]);
                break;

                case "ADDBOTS":
                AddBots(int(Args[1]), int(Args[2]), bool(Args[3]));
                `log("Added Bots");
                break;

                case "REMOVEBOTS":
                RemoveBots();
                `log("Removed Bots");
                break;

                case "ALLAMMO":
                AllAmmo(PC);
                `log("Infinite Ammo");
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" toggled AllAmmo");
                break;
            }


    super.Mutate(MutateString, PC);
}

function ClearVehicles()
{
	local ROVehicle ROV;

	foreach WorldInfo.AllPawns(class'ROVehicle', ROV)
	{
		if( !ROV.bDriving )
            ROV.ShutDown();
			ROV.Destroy();
	}
}

/*function Slomo( float F )
{
    while (ROGameInfo(WorldInfo.Game).bRoundHasBegun && WorldInfo.TimeDilation != F)
    {
        if (0.25 <= F && F <= 4)
	    {
	        WorldInfo.Game.SetGameSpeed(F);
        }
        else
        {
            WorldInfo.Game.SetGameSpeed(1);
            `log("Error");
        }
    }

    while (!ROGameInfo(WorldInfo.Game).bRoundHasBegun && WorldInfo.TimeDilation != 1)
    {
	    WorldInfo.Game.SetGameSpeed(1);
    }
}*/

function SetJumpZ(PlayerController PC, float F )
{
        if (0.5 <= F && F <= 10)
	    {
	        PC.Pawn.JumpZ = F;
        }
        else
        {
            PC.Pawn.JumpZ = 1;
            `log("Error");
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
            `log("Error");
        }
}

function SetSpeed(PlayerController PC, float F )
{
    if (0.5 <= F && F <= 5)
	{
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed * F;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed * F;
    }
    else
    {
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed;
        `log("Error");
    }
}

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
        `log("Error");
    }
}

function AddBots(int Num, optional int NewTeam = -1, optional bool bNoForceAdd)
{
	local ROAIController ROBot;
	local byte ChosenTeam;
	local byte SuggestedTeam;
	// GRIP BEGIN
	local ROPlayerReplicationInfo ROPRI;
	// GRIP END
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

		ROBot.ChooseSquad();

		// GRIP BEGIN
		// Remove. Debugging purpose only.
		ROPRI = ROPlayerReplicationInfo(ROBot.PlayerReplicationInfo);
		if( ROPRI.RoleInfo.bIsTankCommander )
		{
			ROGI.ChangeName(ROBot, ROPRI.GetHumanReadableName()$" (TankAI)", false);
		}
		// GRIP END

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

function SpawnObject(PlayerController PC, string S)
{
    //For spawning barricades maybe?
}

function SpawnVehicle(PlayerController PC, string VehicleName, out string NameValid)
{
	local vector                    CamLoc, StartShot, EndShot, X, Y, Z;
	local rotator                   CamRot;
	local class<ROVehicle>          Cobra;
    local class<ROVehicle>          Loach;
    local class<ROVehicle>          Huey;
    local class<ROVehicle>          Bushranger;
    local class<ROVehicle>          M113ACAV;
    local class<ROVehicle>          T20;
    local class<ROVehicle>          T26;
    local class<ROVehicle>          T28;
    local class<ROVehicle>          HT130;
    local class<ROVehicle>          ATGun;
    local class<ROVehicle>          Vickers;
    //local class<ROVehicle>          T34;
    //local class<ROVehicle>          MUTT;
    //local class<ROVehicle>          M113ARVN;
    //local class<ROVehicle>          M113;
	local ROVehicle ROHelo;

    NameValid = "true";

    // Do ray check and grab actor
	ROPC.GetPlayerViewPoint(CamLoc, CamRot);
	GetAxes(CamRot, X, Y, Z );
	StartShot   = PC.Pawn.Location;
	EndShot     = StartShot + (450.0 * X) + (300 * Z);

	Cobra = class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_AH1G_Content", class'Class'));
    Loach = class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_OH6_Content", class'Class'));
    Huey = class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Content", class'Class'));
    Bushranger = class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Gunship_Content", class'Class'));
    M113ACAV = class<ROVehicle>(DynamicLoadObject("GOM3.GOMVehicle_M113_ACAV_ActualContent", class'Class'));
    //M113ACAV = class<ROVehicle>(DynamicLoadObject("GOM4.GOMVehicle_M113_ACAV_ActualContent", class'Class'));
    //MUTT = class<ROVehicle>(DynamicLoadObject("GOM4.GOMVehicle_M151_MUTT_US", class'Class'));
    //T34 = class<ROVehicle>(DynamicLoadObject("GOM4.GOMVehicle_T34_ActualContent", class'Class'));
    //M113ARVN = class<ROVehicle>(DynamicLoadObject("GOM4.GOMVehicle_M113_APC_ARVN", class'Class'));
    T20 = class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T20_ActualContent", class'Class'));
    T26 = class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T26_EarlyWar_ActualContent", class'Class'));
    T28 = class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T28_ActualContent", class'Class'));
    HT130 = class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_HT130_ActualContent", class'Class'));
    ATGun = class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_53K_ActualContent", class'Class'));
    Vickers = class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_Vickers_ActualContent", class'Class'));
    //M113 = class<ROVehicle>(DynamicLoadObject("AmmoCrate.ACVehicle_M113_APC_Content", class'Class'));

    switch (VehicleName)
    {
        // Vanilla
        case "Cobra":
        ROHelo = Spawn(Cobra, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "Loach":
        ROHelo = Spawn(Loach, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "Huey":
        ROHelo = Spawn(Huey, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "Bushranger":
        ROHelo = Spawn(Bushranger, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        //GOM 4
        case "M113ACAV":
        ROHelo = Spawn(M113ACAV, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        /*case "MUTT":
		ROHelo = Spawn(MUTT, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "T34":
		ROHelo = Spawn(T34, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "M113ARVN":
		ROHelo = Spawn(M113ARVN, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;*/

        //Winter War
        case "T20":
		ROHelo = Spawn(T20, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "T26":
		ROHelo = Spawn(T26, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "T28":
		ROHelo = Spawn(T28, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "HT130":
		ROHelo = Spawn(HT130, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "ATGun":
		ROHelo = Spawn(ATGun, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        case "Vickers":
		ROHelo = Spawn(VICKERS, , , EndShot);
		ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
        break;

        default:
        NameValid = "False";
        break;
    }
}

function GiveWeapon(PlayerController PC, string WeaponName, out string NameValid)
{
	local ROInventoryManager InvManager;

	InvManager = ROInventoryManager(PC.Pawn.InvManager);   
    NameValid = "True";  

        switch (WeaponName)
        {
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Vanilla

            case "BHP":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_BHP_Pistol_Content", false, true);

            break;

            case "DSHK":
            InvManager.LoadAndCreateInventory("ROGameContent.ROItem_PlaceableHMG_Content", false, true);

            break;

            case "AKM":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_AK47_AssaultRifle_AKM", false, true);

            break;

            case "C4":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_C4_Explosive_Content", false, true);

            break;

            case "F1":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_F1_SMG_Content", false, true);

            break;

            case "FOUGASSE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_Fougasse_Mine_Content", false, true);

            break;

            case "IZH43":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_IZH43_Shotgun_Content", false, true);

            break;

            case "K50M":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_K50M_SMG_Content", false, true);

            break;

            case "L1A1":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_L1A1_Rifle_Content", false, true);

            break;

            case "L2A1":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_L2A1_LMG_Content", false, true);

            break;

            case "M1CARBINE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1_Carbine_30rd", false, true);

            break;

            case "M14":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M14_Rifle_Content", false, true);

            break;

            case "M1630RND":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M16A1_AssaultRifle_30rd", false, true);

            break;

            case "TYPE56":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_AK47_AssaultRifle_Type56", false, true);

            break;

            case "M16":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M16A1_AssaultRifle_Content", false, true);

            break;

            case "CLAYMORE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M18_Claymore_Content", false, true);

            break;

            case "M18SMOKE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M18_SignalSmoke_Purple", false, true);

            break;

            case "M1911":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1911_Pistol_Content", false, true);

            break;

            case "REVOLVER":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1917_Pistol_Content", false, true);

            break;

            case "BAR":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1918_BAR_Content", false, true);

            break;

            case "M1919":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1919A6_LMG_Content", false, true);

            break;

            case "TYPE56-1":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_AK47_AssaultRifle_Type56_1", false, true);

            break;

            case "THOMPSON":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1A1_SMG_Content", false, true);

            break;

            case "M1DGARAND":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1DGarand_SniperRifle_Content", false, true);

            break;

            case "M1GARAND":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M1Garand_Rifle_Content", false, true);

            break;

            case "M2CARBINE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M2_Carbine_Content", false, true);

            break;

            case "WP":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M34_WP_Content", false, true);

            break;

            case "DUCKBILL":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M37_Shotgun_Duckbill", false, true);

            break;

            case "STAKEOUT":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M37_Shotgun_Stakeout", false, true);

            break;

            case "TRENCH":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M37_Shotgun_Trench", false, true);

            break;

            case "M40":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M40Scoped_Rifle_Content", false, true);

            break;

            case "M60":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M60_GPMG_Level2", false, true);

            break;

            case "M61":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M61_Grenade_Content", false, true);

            break;

            case "M61QUAD":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M61_Grenade_ContentQuad", false, true);

            break;

            case "M79":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M79_GrenadeLauncher_Content", false, true);

            break;

            case "M79BUCKSHOT":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M79_GrenadeLauncher_Level2", false, true);

            break;

            case "M79SMOKE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M79_GrenadeLauncher_Level3", false, true);

            break;

            case "M8SMOKE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M8_Smoke_Content", false, true);

            break;

            case "FLAMETHROWER":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_M9_Flamethrower_Content", false, true);

            break;

            case "MAS49":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MAS49_Rifle_Content", false, true);

            break;

            case "MAS49GRENADE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MAS49_Rifle_Grenade_Content", false, true);

            break;

            case "MAS49SNIPER":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MAS49Scoped_Rifle_Content", false, true);

            break;

            case "MAT49":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MAT49_SMG_Content", false, true);

            break;

            case "MD82":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MD82_Mine_Content", false, true);

            break;

            case "MOSIN":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MN9130_Rifle_Content", false, true);

            break;

            case "MOSINSNIPER":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MN9130Scoped_Rifle_Content", false, true);

            break;

            case "MOLOTOV":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_Molotov_Content", false, true);

            break;

            case "MP40":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_MP40_SMG_Content", false, true);

            break;

            case "OWEN":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_Owen_SMG_Content", false, true);

            break;

            case "MAKAROV":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_PM_Pistol_Content", false, true);

            break;

            case "PPSH":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_PPSH41_SMG_Content", false, true);

            break;

            case "PPSHDRUM":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_PPSH41_SMG_Drum", false, true);

            break;

            case "RDG1SMOKE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_RDG1_Smoke_Content", false, true);

            break;

            case "RP46":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_RP46_LMG_Content", false, true);

            break;

            case "RPD":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_RPD_LMG_200rd", false, true);

            break;

            case "RPG7":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_RPG7_RocketLauncher_Content", false, true);

            break;

            case "PUNJI":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_PunjiTrap_Content", false, true);

            break;
    
            case "SKS":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_SKS_Rifle_Content", false, true);

            break;
        
            case "SVD":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_SVDScoped_Rifle_Content", false, true);

            break;

            case "TRIPWIRE":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_TripwireTrap_Content", false, true);

            break;

            case "TT33":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_TT33_Pistol_Content", false, true);

            break;

            case "TYPE67":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_Type67_Grenade_Content", false, true);

            break;

            case "XM17730RND":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_XM177E1_Carbine_30rd", false, true);

            break;

            case "XM177":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_XM177E1_Carbine_Content", false, true);

            break;

            case "XM21SNIPER":
            InvManager.LoadAndCreateInventory("ROGameContent.ROWeap_XM21Scoped_Rifle_Level2", false, true);

            break;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// MutCommands

            case "USAMMO":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACItem_USAmmoCrate_Content", false, true);
            
            break;

            case "VCAMMO":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACItem_VCAmmoCrate_Content", false, true);

            break;

            case "MG34":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_MG34_LMG_Content", false, true);

            break;

            case "M79WP":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_M79_GrenadeLauncher_Level3", false, true);

            break;

            case "MEME":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_M79_MemeLauncher_Content", false, true);

            break;
            
            case "SATCHEL":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_VietSatchel_Content", false, true);
    
            break;

            case "XM21SILENCED":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_XM21Scoped_Rifle_Suppressed", false, true);

            break;

            case "M18YELLOW":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_M18_SignalSmoke_Yellow_Content", false, true);

            break;

            case "M18RED":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_M18_SignalSmoke_Red_Content", false, true);

            break;

            case "M18PURPLE":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_M18_SignalSmoke_Purple_Content", false, true);

            break;

            case "M18GREEN":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_M18_SignalSmoke_Green_Content", false, true);

            break;

            case "MKB42":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_MKb42_AssaultRifle_Content", false, true);

            break;

            case "CIWS":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_CIWS_Content", false, true);

            break;

            case "RPPG":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACWeap_RPPG_Content", false, true);

            break;

            case "SALUTE":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACSaluteHands", false, true);

            break;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Winter War

            case "ATMINE":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_AntiTankMine_ActualContent", false, true);

            break;

            case "AVS36":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_AVS36_ActualContent", false, true);

            break;

            case "F1GRENADE":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_F1Grenade_ActualContent", false, true);

            break;

            case "KASAPANOS":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_Kasapanos_FactoryIssue_ActualContent", false, true);

            break;

            case "KASAPANOS2":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_Kasapanos_Improvised_ActualContent", false, true);

            break;

            case "KP31":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_KP31_ActualContent", false, true);

            break;

            case "L35":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_L35_ActualContent", false, true);

            break;

            case "LAHTI":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_LahtiSaloranta_ActualContent", false, true);

            break;

            case "LUGER":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_Luger_ActualContent", false, true);

            break;

            case "M20":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_M20_ActualContent", false, true);

            break;

            case "M32":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_M32Grenade_ActualContent", false, true);

            break;

            case "MN27":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_MN27_ActualContent", false, true);

            break;

            case "MN38":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_MN38_ActualContent", false, true);

            break;

            case "MN91":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_MN91_ActualContent", false, true);

            break;

            case "MN9130":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_MN9130_ActualContent", false, true);

            break;

            case "MN9130D":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_MN9130_Dyakonov_ActualContent", false, true);

            break;

            case "MN9130SCOPED":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_MN9130_Scoped_ActualContent", false, true);

            break;

            case "WWMOLOTOV":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_Molotov_ActualContent", false, true);

            break;

            case "NAGANT":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_NagantRevolver_ActualContent", false, true);

            break;

            case "PPD34":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_PPD34_ActualContent", false, true);

            break;

            case "WWRDG1":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_RDG1_ActualContent", false, true);

            break;

            case "RGD33":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_RGD33_ActualContent", false, true);

            break;

            case "WWSATCHEL":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_Satchel_ActualContent", false, true);

            break;

            case "SKIS":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_Skis_ActualContent", false, true);

            break;

            case "SVT38":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_SVT38_ActualContent", false, true);

            break;

            case "WWTT33":
            InvManager.LoadAndCreateInventory("WinterWar.WWWeapon_TT33_ActualContent", false, true);

            break;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// GOM 4

            case "38BODYGUARD":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_38Bodyguard_ActualContent", false, true);

            break;

            case "BARSHOTGUN":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_BarShotgun_ActualContent", false, true);

            break;

            case "M4BAYO":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Bayonet_M4_ActualContent", false, true);

            break;

            case "M5BAYO":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Bayonet_M5_ActualContent", false, true);

            break;

            case "M7BAYO":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Bayonet_M7_ActualContent", false, true);

            break;

            case "BOWIE":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_BowieKnife_ActualContent", false, true);

            break;

            case "CROSSBOW":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Crossbow_ActualContent", false, true);

            break;

            case "DP27":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_DP27", false, true);

            break;

            case "DPM":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_DPM", false, true);

            break;

            case "GOMK50M":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_K50M_ActualContent", false, true);

            break;

            case "KABAR":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Kabar_ActualContent", false, true);

            break;

            case "KAR98":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Kar98k_ActualContent", false, true);

            break;

            case "GOMTRENCH":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M12_ActualContent", false, true);

            break;

            case "GOMM14":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M14_ActualContent", false, true);

            break;

            case "M16SCOPED":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M16A1_Scoped_ActualContent", false, true);

            break;

            case "M16UVC":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M16A1_UVC", false, true);

            break;

            case "M1897":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M1897_ActualContent", false, true);

            break;

            case "M18RR":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M18_Recoilless_ActualContent", false, true);

            break;

            case "GOM1911":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M1911A1_ActualContent", false, true);

            break;

            case "STOCKLESSM1A1":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M1A1_Stockless", false, true);

            break;

            case "GARANDNADE":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M7RifleGrenade_ActualContent", false, true);

            break;

            case "ITHACA":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M37_ActualContent", false, true);

            break;

            case "ITHACARIOT":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M37_Riot", false, true);

            break;

            case "M44CARBINE":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_M44_Carbine_ActualContent", false, true);

            break;

            case "GOMMG34":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_MG34_Belt", false, true);

            break;

            case "MAC10":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_MAC10_ActualContent", false, true);

            break;

            case "MAC10SILENCED":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_MAC10_Silenced", false, true);

            break;

            case "P38":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_P38_ActualContent", false, true);

            break;

            case "PPS":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_PPS_ActualContent", false, true);

            break;

            case "RPDSAWNOFF":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_RPD_SawnOff_ActualContent", false, true);

            break;

            case "RPG2":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_RPG2_ActualContent", false, true);

            break;

            case "GOMSKS":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_SKS_ActualContent", false, true);

            break;

            case "GOMSVD":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_SVD_ActualContent", false, true);

            break;

            case "STEVENS":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Stevens_ActualContent", false, true);

            break;

            case "STONER63":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Stoner63A_ActualContent", false, true);

            break;

            case "TYPE67QUAD":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_Type67_Quad", false, true);

            break;

            case "UZI":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_UZI_ActualContent", false, true);

            break;

            case "VCGRENADE":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_VCGrenade_ActualContent", false, true);

            break;

            case "VZ23":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_VZ23", false, true);

            break;

            case "VZ25":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_VZ25", false, true);

            break;

            case "VZ58":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_VZ58_ActualContent", false, true);

            break;

            case "VZ61":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_VZ61_ActualContent", false, true);

            break;

            case "XM177E2":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_XM177E2", false, true);

            break;

            case "XM177E230RND":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_XM177E2_30", false, true);

            break;

            case "VCGRENADE":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_VCGrenade_ActualContent", false, true);

            break;

            case "VCGRENADE":
            InvManager.LoadAndCreateInventory("GOM4.GOMWeapon_VCGrenade_ActualContent", false, true);

            break;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// GOM 3

            /*case "RPG2":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_RPG2_ActualContent", false, true);

            break;

            case "RPDSAWNOFF":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_RPD_SawnOff_ActualContent", false, true);

            break;

            case "PPS43":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_PPS_ActualContent", false, true);

            break;

            case "M38CARBINE":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_M38_Carbine_ActualContent", false, true);

            break;

            case "M7RIFLENADE":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_M7RifleGrenade_ActualContent", false, true);

            break;

            case "KAR98K":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_Kar98k_ActualContent", false, true);

            break;

            case "BOWIE":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_BowieKnife_ActualContent", false, true);

            break;

            case "GOMCARBINE":
            InvManager.LoadAndCreateInventory("GOM3.GOMWeapon_M1_Carbine_ActualContent", false, true);

            break;*/
            
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Testing            
                
            /*case "MG34HMG":
            InvManager.LoadAndCreateInventory("AmmoCrate.ACItem_PlaceableHMG_MG34_Content", false, true);

            break;*/
            
            default:
            NameValid = "False";
            break;
        }
}