//=============================================================================
// MCRoleInfoTankCrewFinnish
// Edited for the 29ID by Scovel
//=============================================================================
class MCRoleInfoTankCrewFinnish extends RORoleInfoNorthernInfantry
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
					PrimaryWeapons=(class'WinterWar.WWWeapon_L35',class'WinterWar.WWWeapon_Luger'),
					SecondaryWeapons=()
		)}

	ClassIcon=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
	ClassIconLarge=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
}
