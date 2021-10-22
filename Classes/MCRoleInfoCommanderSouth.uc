//=============================================================================
// RORoleInfoSouthernCommander
//=============================================================================
// Default settings for the American Commander role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class MCRoleInfoCommanderSouth extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Commander
	ClassTier=4
	ClassIndex=10
	bIsTeamLeader=true
	bBotSelectable = false

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M14_Rifle',class'ROGame.ROWeap_XM177E1_Carbine_Late'),
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol',class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol'),
					OtherItems=(class'ROGame.ROWeap_M18_SignalSmoke',class'ROGame.ROItem_BinocularsUS',class'ROGame.ROWeap_M61_GrenadeDouble'),					
		)}
		
	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_commander'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_commander'
}
