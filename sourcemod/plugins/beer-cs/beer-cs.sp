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

public void OnPluginStart()
{
    HookEvent("player_death", EventPlayerDeath);
}

Handle frozenPlayers[MAXPLAYERS+1];

public void EventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int victim_id = event.GetInt("userid");
    int attacker_id = event.GetInt("attacker");

    int victim = GetClientOfUserId(victim_id);
    int attacker = GetClientOfUserId(attacker_id);

    
    
    char[] attackerName = GetClientName(attacker);
    
    SetEntPropFloat(attacker, Prop_Data, "m_flLaggedMovementValue", 0.0);
    PrintToChat(attacker, attackerName);

    if (frozenPlayers[attacker] != null) // If the player made a previous kill within 5 seconds, then we kill it and make a new timer for 5 sec.
    {
        KillTimer(UnfreezePlayer[attacker])
    }
    frozenPlayers[attacker] = CreateTimer(5.0, UnfreezePlayer, attacker);

}

public Action UnfreezePlayer(Handle timer, any attacker)
{
   // PrintToChatAll("%d kan nu bevæge dig igen", attacker);
    SetEntPropFloat(attacker, Prop_Data, "m_flLaggedMovementValue", 1.0);
    frozenPlayers[attacker] = null;
}
