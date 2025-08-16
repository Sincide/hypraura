# SkogsLjus – hypraura

SkogsLjus is an Arch Linux Wayland desktop tuned for AMD hardware and infused with dynamic Scandinavian ambience.

## Quick Start
```bash
git clone https://gitlab.com/USER/hypraura.git
cd hypraura
chmod +x install.sh uninstall.sh
./install.sh   # pick Hyprland (default) or Niri
reboot
```

## Design Story
*Generative auroras meet pragmatic workflow.* Every session renders a live GLSL sky, recolours your apps from the current wallpaper, and shifts mood with the weather over Stockholm. Swedish input layout (`se`) is set at the compositor level while keeping the interface in English.

## Theming Pipeline
```
wallpaper → mood-engine → wallust → templates → apps
```
`mood-engine` blends the extracted wallust palette with time-of-day and local weather. The resulting `palette.json` drives template rendering for Waybar, terminals, GTK, Kvantum and more.

## Story Mode
Define daily scenes in `config/scenes.yaml`. A systemd timer rotates wallpaper, mood preset and motion level. Use `scripts/scene list` and `scripts/scene apply <name>` to explore.

## Shader Auras
`mpvpaper` runs the real‑time *SkogsLjus Aurora* shader stack. Audio levels from PipeWire modulate ribbon intensity while `bokeh.frag` sprinkles subtle particles. `scripts/run-mpvpaper` controls the service and falls back to `swww` with a prerendered loop if GPU load is high.

## Performance Knobs
- `mood.yml` tunes polling intervals and weather provider
- `scenes.yaml` sets motion levels per scene
- `scripts/diagnostics` prints FPS, sensors and service states

## Troubleshooting
1. **NVIDIA hardware**: the installer exits early with instructions.
2. **Theme mismatch**: run `scripts/mood-engine && scripts/theme-apply`.
3. **Wallpaper stuck**: use `scripts/choose-wallpaper`.
4. **Switch compositor**: re-run `install.sh` and select the other option.

## Acceptance Checklist
- [ ] AMD CPU/GPU detected
- [ ] Swedish keyboard active in compositor
- [ ] Waybar shows per‑workspace auras
- [ ] `mood-engine` generates `palette.json`
- [ ] Auroras shimmer with audio

## Post-Install Notes
- Change wallpaper: `scripts/choose-wallpaper`
- Regenerate theme: `scripts/mood-engine && scripts/theme-apply`
- Toggle Story Mode: `systemctl --user enable --now scenes.timer`
- Update compositor choice: re-run `install.sh`
- Keybinds live in `stow/hypr` or `stow/niri`

Happy hacking under the SkogsLjus!
