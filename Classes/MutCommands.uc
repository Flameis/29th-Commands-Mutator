Class MutCommands extends ROMutator
    config(MutCommands);

var ROMapInfo           ROMI;
var ROGameInfo          ROGI;
var MutCommandsPC       MCPC;
var string              PlayerName;
var array<string>       Args;
var string              command;

function PreBeginPlay()
{
    `log("MutCommands init");

    MCPC.LoadObjects();

    super.PreBeginPlay();
}

function NotifyLogin(Controller NewPlayer)
{
    MCPC = ACPlayerController(NewPlayer);

    if (MCPC == None)
    {
        `log("Error replacing roles");
        return;
    }

    MCPC.ClientLoadObjects();
    MCPC.ReplaceRoles();
    MCPC.ClientReplaceRoles();

    super.NotifyLogin(NewPlayer);
}

auto state StartUp
{
    function timer()
    {
        RemoveVolumes();
    }
        
    Begin:
    SetTimer( 10, true );
}

function PrivateMessage(PlayerController receiver, coerce string msg)
{
    receiver.TeamMessage(None, msg, '');
}

function RemoveVolumes()
{
    local ROVolumeNoArtillery ROVNA;
    local ROVolumeSpawnProtection ROVSP;
    local int count;

    foreach allactors(class'ROVolumeNoArtillery', ROVNA)
    {
    ROVNA.SetEnabled( False );
    ++Count;
    }
    foreach allactors(class'ROVolumeSpawnProtection', ROVSP)
    {
    ROVSP.SetEnabled( False );
    ++Count;
    }

    `log ("Removed "$Count$" Volumes" );
}

function Mutate(string MutateString, PlayerController PC) //no prefixes, also call super function!
{
        local array<string> Args;
        local string        command;
        local string NameValid;

        Args = SplitString(MutateString, " ", true);
        command = Caps(Args[0]);
        PlayerName = PC.PlayerReplicationInfo.PlayerName;
        
            Switch (Command)
            {
                case "GIVEWEAPON":
                GiveWeapon(PC, Args[1], NameValid, false);
                if (NameValid != "False")
                {
                    WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" spawned a "$Args[1]);
                    `log("[29th Extras] "$PlayerName$" spawned a "$Args[1]$"");
                }
                else
                {
                    `log("[29th Extras] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                    PrivateMessage(PC, "Not a valid weapon name.");
                }
                break;

                case "GIVEWEAPONALL":
                GiveWeapon(PC, Args[1], NameValid, true);
                if (NameValid != "False")
                {
                    WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" gave a "$Args[1]$" to everyone");
                    `log("[29th Extras] "$PlayerName$" spawned a "$Args[1]$"");
                }
                else
                {
                    `log("[29th Extras] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                    PrivateMessage(PC, "Not a valid weapon name.");
                }
                break;

                case "GIVEWEAPONNORTH":
                GiveWeapon(PC, Args[1], NameValid, false, `AXIS_TEAM_INDEX);
                if (NameValid != "False")
                {
                    WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" gave a "$Args[1]$" to the north");
                    `log("[29th Extras] "$PlayerName$" gave a "$Args[1]$" to the north");
                }
                else
                {
                    `log("[29th Extras] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                    PrivateMessage(PC, "Not a valid weapon name.");
                }
                break;

                case "GIVEWEAPONSOUTH":
                GiveWeapon(PC, Args[1], NameValid, false, `ALLIES_TEAM_INDEX);
                if (NameValid != "False")
                {
                    WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" gave a "$Args[1]$" to the south");
                    `log("[29th Extras] "$PlayerName$" gave a "$Args[1]$" to the south");
                }
                else
                {
                    `log("[29th Extras] Giveweapon failed! "$PlayerName$" tried to spawn a "$Args[1]);
                    PrivateMessage(PC, "Not a valid weapon name.");
                }
                break;
                
                case "SPAWNVEHICLE":
                SpawnVehicle(PC, Args[1], NameValid);
                if (NameValid != "False")
                {
                    WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" spawned a "$Args[1]);
                    `log("[29th Extras] "$PlayerName$" spawned a "$Args[1]$"");
                }
                else
                {
                    `log("[29th Extras] Spawnvehicle failed! "$PlayerName$" tried to spawn a "$Args[1]);
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
                WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" set their JumpZ to "$Args[1]);
                break;

                case "SetGravity":
                SetGravity(PC, float(Args[1]));
                `log("SetGravity");
                WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" set gravity to "$Args[1]);
                break;

                case "SetSpeed":
                SetSpeed(PC, float(Args[1]));
                `log("SetSpeed");
                WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" set their speed to "$Args[1]);
                break;

                case "ChangeSize":
                ChangeSize(PC, float(Args[1]));
                `log("ChangeSize");
                WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" set their size to "$Args[1]);
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
                WorldInfo.Game.Broadcast(self, "[29th Extras] "$PlayerName$" toggled AllAmmo");
                break;
            }


    super.Mutate(MutateString, PC);
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
    //local class<ROVehicle>          T54;
    //local class<ROVehicle>          MUTT;
    //local class<ROVehicle>          M113ARVN;
    //local class<ROVehicle>          M113;
	local ROVehicle ROHelo;

    NameValid = "true";

    // Do ray check and grab actor
	PC.GetPlayerViewPoint(CamLoc, CamRot);
	GetAxes(CamRot, X, Y, Z );
	StartShot   = CamLoc;
	EndShot     = StartShot + (450.0 * X) + (300 * Z);

	`include(29th-Commands-Mutator\Classes\VehicleNames.uci)
}

function GiveWeapon(PlayerController PC, string WeaponName, out string NameValid, bool GiveAll, optional int TeamIndex)
{
	local ROInventoryManager    InvManager;
    local ROPawn                ROP;

    ROP = ROPawn(MCPC.Pawn);
    InvManager = ROInventoryManager(PC.Pawn.InvManager);

    NameValid = "True";

    if (GiveAll)
    { 
    foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            InvManager = ROInventoryManager(ROP.InvManager);

            switch (WeaponName)
            {
            `include(29th-Commands-Mutator\Classes\WeaponNames.uci)     
            }
        }
    }   

    else if (TeamIndex == `AXIS_TEAM_INDEX)
    {
    foreach worldinfo.allpawns(class'ROPawn', ROP)
        {
            if (ROP.GetTeamNum() == `AXIS_TEAM_INDEX)
            {
                switch (WeaponName)
                {
                `include(29th-Commands-Mutator\Classes\WeaponNames.uci)     
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
                switch (WeaponName)
                {
                `include(29th-Commands-Mutator\Classes\WeaponNames.uci)     
                }
            }
        }
    }    

    else
    {
    switch (WeaponName)
        {
        `include(29th-Commands-Mutator\Classes\WeaponNames.uci)     
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

    else
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

function Camera(playercontroller PC, optional bool First = false)
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