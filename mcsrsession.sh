#!/usr/bin/env bash
DIR="$HOME"
WORKSPACE=6
KEEP_OPEN_CMD='exec bash'

PROGS=(
  "Ninjabrain::java -jar ~/Documents/mcsr/Ninjabrain-Bot-1.5.2.jar"
  "Xeyesee::xeyesee"
  "NBTrackr::nbtrackr"
  "Resetti::resetti magic"
)

missing=()

# switch to workspace 2 so new terminals open there
i3-msg workspace "$WORKSPACE" >/dev/null

for entry in "${PROGS[@]}"; do
  label="${entry%%::*}"
  cmd="${entry#*::}"
  exe="${cmd%% *}"

  if ! command -v "$exe" >/dev/null 2>&1; then
    missing+=("$label ($exe)")
    continue
  fi

  gnome-terminal -- bash -c "cd '$DIR'; $cmd; $KEEP_OPEN_CMD" &
  sleep 0.3
done

if [ "${#missing[@]}" -ne 0 ]; then
  summary="Missing programs:\n"
  for m in "${missing[@]}"; do summary+="- $m\n"; done
  gnome-terminal -- bash -c "printf '%b' \"$summary\"; $KEEP_OPEN_CMD" &
fi

# optionally return to workspace 1
sleep 0.2
i3-msg workspace 1 >/dev/null

