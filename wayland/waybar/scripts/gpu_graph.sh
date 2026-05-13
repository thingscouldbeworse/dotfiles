#!/bin/bash

# 1. Capture JSON
raw_json=$(intel_gpu_top -J -s 100 -n 1)

# 2. Parse and Generate Graph
echo "$raw_json" | python3 -c "
import sys, json

CHARS = ' ▂▃▄▅▆▇█' # Note: added a leading space for 0%

try:
    data = json.load(sys.stdin)
    stats = data[0] if isinstance(data, list) else data
    engines = stats.get('engines', {})
    
    # Calculate usage
    total_busy = sum(
        float(engines[e].get('busy', 0)) 
        for e in engines if isinstance(engines[e], dict)
    )
    val = min(100, max(0, int(total_busy)))
    
    # Bar character logic: (percentage * (len - 1)) / 100
    char_idx = int((val * (len(CHARS) - 1)) / 100)
    graph_char = CHARS[char_idx]
    
    # Waybar JSON output
    # 'text' combines the graph and the number
    print(json.dumps({
        'text': f'{graph_char} {val}%',
        'percentage': val
    }))
except Exception:
    print(json.dumps({'text': '  0%', 'percentage': 0}))
"