#include <amxmodx>

#define PLUGIN_NAME    "Win Music"
#define PLUGIN_VERSION "0.2"
#define PLUGIN_AUTHOR  "BenyVotka(Gharri.ir)"

new const g_szMusic[] = "music.wav"

public plugin_init()
{
    register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)

    register_event("SendAudio", "OnTeamWin", "a", "2&%!MRAD_terwin", "2&%!MRAD_ctwin")
}

public plugin_precache()
{
    precache_sound(g_szMusic)
}

public OnTeamWin()
{
    client_cmd(0, "spk sound/%s", g_szMusic)
}