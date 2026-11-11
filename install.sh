#!/bin/bash
# Link larp into ~/.local/bin and ~/.claude/skills, add the Omarchy menu rows and the keybinding.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.local/bin ~/.claude/skills
for f in "$here"/bin/*; do ln -sfn "$f" ~/.local/bin/"$(basename "$f")"; done
ln -sfn "$here/skill" ~/.claude/skills/larp
mkdir -p "$(xdg-user-dir VIDEOS 2>/dev/null || echo ~/Videos)/larp"

menu=~/.config/omarchy/extensions/omarchy-menu.jsonc
if ! grep -q 'trigger.capture.larp' "$menu"; then
  cp "$menu" "$menu.bak.$(date +%s)"
  # Insert the rows before the closing brace of the top-level object.
  python3 - "$menu" "$here/omarchy/menu-rows.jsonc" <<'EOF'
import sys
menu, rows = sys.argv[1], open(sys.argv[2]).read()
text = open(menu).read()
i = text.rstrip().rfind("}")
open(menu, "w").write(text[:i] + rows + text[i:])
EOF
fi

binds=~/.config/hypr/bindings.lua
if ! grep -q 'larp menu' "$binds"; then
  cp "$binds" "$binds.bak.$(date +%s)"
  printf '\n-- larp work clips menu (source: %s)\no.bind("SUPER + SHIFT + R", "Work clips", "larp menu")\n' "$here" >>"$binds"
fi

hyprctl reload >/dev/null && hyprctl configerrors
echo "larp installed"
