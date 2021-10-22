//=============================================================================
// RORoleInfoSouthernCommander
//=============================================================================
// Default settings for the American Commander role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class MCRoleInfoCommanderNorth extends RORoleInfoNorthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Commander
	ClassTier=4
	ClassIndex=10
	bIsTeamLeader=true
	bBotSelectable = false

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle',class'ROGame.ROWeap_SKS_Rifle'),
					SecondaryWeapons=(class'ROGame.ROWeap_TT33_Pistol',class'ROGame.ROWeap_PM_Pistol'),
					OtherItems=(class'ROGame.ROWeap_Type67_Grenade',class'ROGame.ROWeap_PunjiTrap',class'ROItem_Binoculars')
	)}
		
	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_commander'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_commander'
}
