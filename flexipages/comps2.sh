input=$1
numberRegions=$(cat "$input" | jq '.FlexiPage.flexiPageRegions' | jq 'length')
echo "=== number of Regions = $numberRegions ==="

for ((i = 0; i < numberRegions; i++)); do
    echo -n "$i: "
    cat "$input" | jq -c --argjson i "$i" '.FlexiPage.flexiPageRegions[$i].itemInstances | map(.mode, .name, .type) | join(", ")'
    echo   # Add a newline after printing the values
done
