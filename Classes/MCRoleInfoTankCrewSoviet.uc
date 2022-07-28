//=============================================================================
// MCRoleInfoTankCrewSoviet
// Edited for the 29ID by Scovel
//=============================================================================
class MCRoleInfoTankCrewSoviet extends RORoleInfoSouthernInfantry
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
					PrimaryWeapons=(class'WinterWar.WWWeapon_TT33',class'WinterWar.WWWeapon_NagantRevolver')
		)}

	ClassIcon=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
	ClassIconLarge=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
}
