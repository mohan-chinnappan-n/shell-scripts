input=$1
numberRegions=$(cat "$input" | jq '.FlexiPage.flexiPageRegions' | jq 'length')
echo "=== number of Regions = $numberRegions ==="

for ((i = 0; i < numberRegions; i++)); do
    echo -n "$i: "
    cat "$input" | jq -c --argjson i "$i" '
        if .FlexiPage.flexiPageRegions[$i].itemInstances then
            .FlexiPage.flexiPageRegions[$i].itemInstances | map(.mode, .name, .type) | join(", ")
        else
            "mode, name, type not available"
        end
    '
    echo   # Add a newline after printing the values
done
