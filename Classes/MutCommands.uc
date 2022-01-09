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
    `log("MutCommands init");

    if (ROGameInfo(WorldInfo.Game).PlayerControllerClass == class'ROPlayerController')
    {
        ROGameInfo(WorldInfo.Game).PlayerControllerClass = class'MCPlayerController';
    }
    /*else
    {
        ROMI = ROMapInfo(WorldInfo.GetMapInfo());
        ROMI.SouthernRoles[8].Count = 255;
    }*/

    LoadObjectsInit();

    super.PreBeginPlay();
}

function NotifyLogin(Controller NewPlayer)
{
    MCPC = MCPlayerController(NewPlayer);

    if (MCPC == None)
    {
        `log("Error replacing roles");
    }
    if (MCPC != None)
    {
        MCPC.ReplaceRoles();
        MCPC.ClientReplaceRoles();
    }

    super.NotifyLogin(NewPlayer);
}

auto state StartUp
{
    function timer()
    {
        RemoveVolumes();
    }
    function timer2()
    {
        SetVicTeam();
    }
        
    Begin:
    SetTimer( 20, true );
    SetTimer( 1, true, 'timer2');
}

function bool bisPC()
{
    if (ROGameInfo(WorldInfo.Game).PlayerControllerClass == class'MCPlayerController')
    {
        return true;
    }
    else {return false;}
}

function SetVicTeam()
{
    local ROVehicle ROV;
    //local ROVehicleTank ROVT;
    local string    Team;
    //local ROVWeap_TankTurret TurretGunClass;

    foreach DynamicActors(class'ROVehicle', ROV)
    {
        if (ROV.bDriving == true && ROV.Team != ROV.Driver.GetTeamNum() && !ROV.bDeadVehicle)
        {
        ROV.Team = ROV.Driver.GetTeamNum();
        `log("Set "$ROV$" to team "$ROV.Driver.GetTeamNum());
            
            if (bCTFon)
            {
                if (ROV.Driver.GetTeamNum() == 0) {Team = "North";}
                else {Team = "South";}
                WorldInfo.Game.Broadcast(self, "The "$ROV$" was captured by the "$Team);
            }
  
            /*if (ROV.Seats[ROV.GetGunnerSeatIndex()].StoragePawn == none)
            {
            ROVT = ROVehicleTank(ROV);
            TurretGunClass = (ROVT.seats[ROVT.GetGunnerSeatIndex()].ROVWeap_TankTurret(ROVT.seats[ROVT.GetGunnerSeatIndex()].gunclass));
                if ( TurretGunClass != None )
                {
                TurretGunClass.ServerSetMainGunProjIndex(TurretGunClass.MAINGUN_AP_INDEX);
                }
            }*/
        }
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

function LoadObjectsInit()
{
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    ROMI.SharedContentReferences.Remove(0, ROMI.SharedContentReferences.Length);
	class'WorldInfo'.static.GetWorldInfo().ForceGarbageCollection(TRUE);

	ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("ROGameContent.ROWeap_M2_HMG_Tripod_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("ROGameContent.ROWeap_DShK_HMG_Tripod_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_AH1G_Content", class'Class')));
	ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_OH6_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("ROGameContent.ROHeli_UH1H_Gunship_Content", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T20_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T26_EarlyWar_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_T28_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_HT130_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_53K_ActualContent", class'Class')));
    ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("WinterWar.WWVehicle_Vickers_ActualContent", class'Class')));
    //ROMI.SharedContentReferences.AddItem(class<ROVehicle>(DynamicLoadObject("GOM3.GOMVehicle_M113_ACAV_ActualContent", class'Class')));
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
                `log("Clearing Weapons");
                break;

                case "CLEARWEAPONSALL":
                ClearWeapons(PC, true);
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" cleared all weapons");
                `log("Clearing Weapons");
                break;

                case "CLEARWEAPONSNORTH":
                ClearWeapons(PC, false, `AXIS_TEAM_INDEX);
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" cleared north weapons");
                `log("Clearing Weapons");
                break;

                case "CLEARWEAPONSSOUTH":
                ClearWeapons(PC, false, `ALLIES_TEAM_INDEX);
                WorldInfo.Game.Broadcast(self, "[MutCommands] "$PlayerName$" cleared south weapons");
                `log("Clearing Weapons");
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
                `log("Clearing Vehicles");
                break;

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
                
                /* case "LOADGOM":
                LoadGOMObjects();
                WorldInfo.Game.Broadcast(self, "[MutCommands] Loaded GOM");
                break;

                case "LOADWW":
                LoadWinterWarObjects();
                WorldInfo.Game.Broadcast(self, "[MutCommands] Loaded Winter War");
                break; */
            }
    super.Mutate(MutateString, PC);
}

function GiveWeapon(PlayerController PC, string WeaponName, out string NameValid, bool bGiveAll, optional int TeamIndex)
{
	local ROInventoryManager        InvManager;
    local ROPawn                    ROP;

    NameValid = "True";

    if (bGiveAll)
    { 
    foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            InvManager = ROInventoryManager(ROP.InvManager);
            if (bisPC())
            {
                switch (WeaponName)
                {
                `include(MutCommands\Classes\WeaponNamesVanilla.uci)
                }
            }
            switch (WeaponName)
            {
            `include(MutCommands\Classes\WeaponNames.uci)     
            }
        }
    }   

    else if (TeamIndex == 100)
    {
    InvManager = ROInventoryManager(PC.Pawn.InvManager);
        if (bisPC())
        {
            switch (WeaponName)
            {
            `include(MutCommands\Classes\WeaponNamesVanilla.uci)
            }
        }
        switch (WeaponName)
        {
        `include(MutCommands\Classes\WeaponNames.uci)     
        }
    }    

    else {giveweapon2(PC, WeaponName, NameValid, bGiveAll, TeamIndex);}
}

function giveweapon2(PlayerController PC, string WeaponName, out string NameValid, bool bGiveAll, optional int TeamIndex)
{
    local ROInventoryManager        InvManager;
    local ROPawn                    ROP;

    NameValid = "True";

    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
    foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            InvManager = ROInventoryManager(ROP.InvManager);
            if (ROP.GetTeamNum() == `AXIS_TEAM_INDEX)
            {
                if (bisPC())
                {
                    switch (WeaponName)
                    {
                    `include(MutCommands\Classes\WeaponNamesVanilla.uci)
                    }
                }
                switch (WeaponName)
                {
                `include(MutCommands\Classes\WeaponNames.uci)     
                }
            }
        }
    } 

    else if (TeamIndex == `ALLIES_TEAM_INDEX)
    {
    foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            InvManager = ROInventoryManager(ROP.InvManager);
            if (ROP.GetTeamNum() == `ALLIES_TEAM_INDEX)
            {
                if (bisPC())
                {
                    switch (WeaponName)
                    {
                    `include(MutCommands\Classes\WeaponNamesVanilla.uci)
                    }
                }
                switch (WeaponName)
                {
                `include(MutCommands\Classes\WeaponNames.uci)     
                }
            }
        }
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
	local class<ROVehicle>          Cobra;
    local class<ROVehicle>          Loach;
    local class<ROVehicle>          Huey;
    local class<ROVehicle>          Bushranger;
    //local class<ROVehicle>          M113ACAV;
    local class<ROVehicle>          T20;
    local class<ROVehicle>          T26;
    local class<ROVehicle>          T28;
    local class<ROVehicle>          HT130;
    local class<ROVehicle>          ATGun;
    local class<ROVehicle>          Vickers;
    local class<ROVehicle>          Skis;
    //local class<ROVehicle>          T34;
    //local class<ROVehicle>          T54;
    //local class<ROVehicle>          MUTT;
    //local class<ROVehicle>          M113ARVN;
    //local class<ROVehicle>          M113;
	local ROVehicle                 ROHelo;
    local ROPawn                    ROP;
    //local class<ROVWeap_TankTurret> TurretGunClass;

    NameValid = "True";

    ROP = ROPawn(PC.Pawn);
    // Do ray check and grab actor
	PC.GetPlayerViewPoint(CamLoc, CamRot);
	GetAxes(CamRot, X, Y, Z );
	StartShot   = CamLoc;
	EndShot     = StartShot + (400.0 * X) + (200 * Z);

	`include(MutCommands\Classes\VehicleNames.uci)

    ROHelo.Mesh.AddImpulse(vect(0,0,1), ROHelo.Location);
    ROHelo.bTeamLocked = false;
    ROHelo.Team = 2;
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

function SetSpeed(PlayerController PC, float F )
{
    if (0.1 <= F && F <= 5)
	{
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed * F;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed * F;
    }
    else
    {
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed;
        // `log("Error");
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
        // `log("Error");
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
        `log ("SpawnFireSupport failed");
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
		`log("Error Spawning Support Aircraft");
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
		`log("Error Spawning Support Aircraft");
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
		`log("Error Spawning Support Aircraft");
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
		`log("Error Spawning Support Aircraft");
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
		`log("Error Spawning Artillery Shell Spawner ");
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