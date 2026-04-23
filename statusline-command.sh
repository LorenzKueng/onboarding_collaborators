#!/bin/bash
input=$(cat)

# Parse all fields via Python, one per line
parsed=$(echo "$input" | python -c "
import sys, json, datetime
d = json.load(sys.stdin)
model      = d.get('model', {}).get('display_name', '')
cw         = d.get('context_window', {})
ctx_used   = cw.get('used_percentage', '')
rl         = d.get('rate_limits', {}).get('five_hour', {})
rate_used  = rl.get('used_percentage', '')
resets_at  = rl.get('resets_at', '')
resets_str = datetime.datetime.fromtimestamp(resets_at).strftime('%H:%M') if resets_at else ''
print(model)
print(ctx_used)
print(rate_used)
print(resets_str)
" 2>/dev/null)

model=$(echo "$parsed"      | sed -n '1p')
ctx_used=$(echo "$parsed"   | sed -n '2p')
rate_used=$(echo "$parsed"  | sed -n '3p')
rate_resets=$(echo "$parsed" | sed -n '4p')

# Build status line
if [ -n "$ctx_used" ] && [ -n "$rate_used" ] && [ -n "$rate_resets" ]; then
  printf "%s | Context: %.0f%% used | Session: %.0f%% used (resets %s)" \
    "$model" "$ctx_used" "$rate_used" "$rate_resets"
elif [ -n "$ctx_used" ]; then
  printf "%s | Context: %.0f%% used" "$model" "$ctx_used"
else
  printf "%s" "$model"
fi
