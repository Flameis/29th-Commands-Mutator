//=============================================================================
// RORoleInfoNorthernGuerilla
//=============================================================================
// Default settings for the Vietnamese Guerilla (Rifleman) role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, Published by Scovel
//=============================================================================
class MCRoleInfoTankCrewNorth extends RORoleInfoNorthernInfantry
	HideDropDown;

defaultproperties
{
	RoleType=RORIT_Tank
	ClassTier=4
	ClassIndex=8
	bIsTankCommander=true

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGameContent.ROWeap_AK47_AssaultRifle_Type56_1'),
					SecondaryWeapons=(class'ROGame.ROWeap_TT33_Pistol',class'ROGame.ROWeap_PM_Pistol'),					
		)}

	ClassIcon=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
	ClassIconLarge=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
}
