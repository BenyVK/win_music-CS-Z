# Win Music

**Version:** 0.2
**Author:** BenyVotka ([Gharri.ir](https://gharri.ir))
**Platform:** AMX Mod X (Counter-Strike 1.6 / Condition Zero)
**Repository:** [github.com/BenyVK/win_music-CS-Z](https://github.com/BenyVK/win_music-CS-Z)

Plays a custom sound or music file to all players whenever a team wins the round.

---

## Features

- Plays a custom `.wav` file to **every connected player** when the Terrorists or Counter-Terrorists win a round
- Automatically precaches the sound so clients can download it from the server
- Tiny, dependency-free, and easy to modify

---

## How It Works

The plugin hooks the engine `SendAudio` event, which the game sends at the end of a round to announce the winner. It listens for the two round-win voice messages:

| Message | Meaning |
|---|---|
| `%!MRAD_terwin` | Terrorists win |
| `%!MRAD_ctwin`  | Counter-Terrorists win |

When either message fires, the plugin runs `client_cmd(0, "spk sound/music.wav")`, which makes every client play the file locally (`0` means "all players").

---

## Requirements

- A Half-Life / Counter-Strike 1.6 dedicated server
- [AMX Mod X](https://www.amxmodx.org/) 1.8.2 or newer
- A sound file named `music.wav` (or any name you configure, see below)

---

## Installation

0. Get the source:
   ```
   git clone https://github.com/BenyVK/win_music-CS-Z.git
   ```
1. **Compile** the plugin (see [Compiling](#compiling)) to get `win_music.amxx`.
2. Copy the compiled file to your server:
   ```
   cstrike/addons/amxmodx/plugins/win_music.amxx
   ```
3. Put your sound file in the server's sound folder:
   ```
   cstrike/sound/music.wav
   ```
4. Open `cstrike/addons/amxmodx/configs/plugins.ini` and add a line:
   ```
   win_music.amxx
   ```
5. Restart the server or change the map.

---

## Compiling

### Option 1: Local compiler

1. Save the source as `win_music.sma` in:
   ```
   cstrike/addons/amxmodx/scripting/
   ```
2. Open a terminal in that folder and run:

   **Windows**
   ```
   amxxpc.exe win_music.sma
   ```
   Or drag `win_music.sma` onto `compile.exe`.

   **Linux**
   ```
   ./amxxpc win_music.sma
   ```
3. The compiled `win_music.amxx` will appear in the `compiled/` folder (or next to the source, depending on your setup).

### Option 2: Online compiler

Upload `win_music.sma` to the [AMX Mod X web compiler](https://www.amxmodx.org/webcompiler.cgi) and download the resulting `.amxx` file.

---

## Configuration

To use a different file, edit this line in the source and recompile:

```pawn
new const g_szMusic[] = "music.wav"
```

The path is relative to the `sound/` folder. For example, `"win/round.wav"` refers to `cstrike/sound/win/round.wav`.

---

## Sound File Tips

GoldSrc is picky about audio. For best compatibility:

- Format: **WAV (PCM)**
- Channels: **mono**
- Bit depth: **16-bit** (8-bit also works)
- Sample rate: **22050 Hz** or **11025 Hz**

Files that don't meet these requirements may fail to play on some clients. Keep the file short; long tracks increase download time for new players.

> **Note:** Only `.wav` files work with `precache_sound` and `spk`. For MP3, you would need a different approach (`mp3 play`) and manual distribution of the file.

---

## Distributing the File to Players

Because the plugin precaches the sound, clients will download it automatically on connect if your server allows downloads:

```
sv_allowdownload 1
sv_allowupload 1
```

For faster downloads on larger files, set up **FastDL** with `sv_downloadurl`.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| Plugin doesn't appear in `amx_plugins` | Check that `win_music.amxx` is listed in `plugins.ini` and located in `addons/amxmodx/plugins/` |
| Server error: *Failed to precache sound* | The file is missing or the path/name in `g_szMusic` is wrong |
| No sound for players | Check the WAV format (see tips above) and that the client has downloaded the file |
| Sound plays together with the default "Terrorists Win" voice | This is expected; the default radio message is not blocked by this plugin |
| Plugin status shows `bad load` | Recompile with the AMX Mod X version installed on your server |

---

## Source Overview

```pawn
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
```

- `plugin_init`: registers the plugin and the round-win event
- `plugin_precache`: precaches the sound file before the map loads
- `OnTeamWin`: plays the sound to all players

---

## Changelog

- **0.2**: Added author credit and cleanup
- **0.1**: Initial release

---

## Credits

Created by **BenyVotka** ([Gharri.ir](https://gharri.ir)).

Bug reports and suggestions: [open an issue](https://github.com/BenyVK/win_music-CS-Z/issues).
