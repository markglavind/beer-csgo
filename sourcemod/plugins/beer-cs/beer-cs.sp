#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo =
{
    name = "øl-cs",
    author = "Mark Glavind",
    description = "Port of the famous øl-cs mod made for cs 1.6",
    version = "0.1",
    url = "nobelnet.dk"
}

enum WeaponIds
{
	weapon_none,
	weapon_deagle,
	weapon_elite,
	weapon_fiveseven,
	weapon_glock,
	weapon_p228,
	weapon_usp,
	weapon_ak47,
	weapon_aug,
	weapon_awp,
	weapon_famas,
	weapon_g3sg1,
	weapon_galil,
	weapon_galilar,
	weapon_m249,
	weapon_m3,
	weapon_m4a1,
	weapon_mac10,
	weapon_mp5navy,
	weapon_p90,
	weapon_scout,
	weapon_sg550,
	weapon_sg552,
	weapon_tmp,
	weapon_ump45,
	weapon_xm1014,
	weapon_bizon,
	weapon_mag7,
	weapon_negev,
	weapon_sawedoff,
	weapon_tec9,
	weapon_taser,
	weapon_hkp2000,
	weapon_mp7,
	weapon_mp9,
	weapon_nova,
	weapon_p250,
	weapon_scar17,
	weapon_scar20,
	weapon_sg556,
	weapon_ssg08,
	weapon_knifegg,
	weapon_knife,
	weapon_flashbang,
	weapon_hegrenade,
	weapon_smokegrenade,
	weapon_molotov,
	weapon_decoy,
	weapon_incgrenade,
	weapon_c4
};


public void OnPluginStart()
{
    HookEvent("player_death", EventPlayerDeath);
}

Handle frozenPlayers[MAXPLAYERS+1];

public void EventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int victimId = event.GetInt("userid");
    int attackerId = event.GetInt("attacker");

    char weaponIdString[64];
    event.GetString("weapon_itemid", weaponIdString, sizeof(weaponIdString));
    int weaponId;
    StringToInt(weaponIdString, weaponId);
    
    if (weaponId == weapon_knife)
    {
        PauseGame();
    }

    int victim = GetClientOfUserId(victimId);
    int attacker = GetClientOfUserId(attackerId);

    char attackerName[MAX_NAME_LENGTH+1];
    
     GetClientName(attacker, attackerName, sizeof(attackerName));
    
    SetEntPropFloat(attacker, Prop_Data, "m_flLaggedMovementValue", 0.0);
    PrintToChat(attacker, attackerName);

    if (frozenPlayers[attacker] != null) // If the player made a previous kill within 5 seconds, then we kill it and make a new timer for 5 sec.
    {
        KillTimer(frozenPlayers[attacker]);
    }
    frozenPlayers[attacker] = CreateTimer(5.0, UnfreezePlayer, attacker);

}

public Action UnfreezePlayer(Handle timer, any attacker)
{
   // PrintToChatAll("%d kan nu bevæge dig igen", attacker);
    SetEntPropFloat(attacker, Prop_Data, "m_flLaggedMovementValue", 1.0);
    frozenPlayers[attacker] = null;
}


public void PauseGame() {
    ServerCommand("pause");
}

public void UnpauseGame() {
    ServerCommand("unpause");
}
