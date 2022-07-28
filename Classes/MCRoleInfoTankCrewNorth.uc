//=============================================================================
// MCRoleInfoTankCrewNorth
// Edited for the 29th by Scovel
//=============================================================================
class MCRoleInfoTankCrewNorth extends RORoleInfoNorthernInfantry
	HideDropDown;

defaultproperties
{
	RoleType=RORIT_Tank
	ClassTier=4
	ClassIndex=8
	bIsTankCommander=true
	bBotSelectable = false

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGameContent.ROWeap_AK47_AssaultRifle_Type56_1'),
					SecondaryWeapons=(class'ROGame.ROWeap_TT33_Pistol',class'ROGame.ROWeap_PM_Pistol'),					
		)}

	ClassIcon=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
	ClassIconLarge=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
}
