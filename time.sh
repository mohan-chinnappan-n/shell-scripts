currTime=$(date -u "+%s")

function get_os_type() {
    echo $(uname)
}

function to_utc_seconds() {
    local in_time="$1"
    local os_type=$(get_os_type)

    # date -j -f "%Y-%m-%d %H:%M:%S" "2022-8-24 18:00:00" "+%s"
    # 1661378400
    if (($os_type == "Darwin")); then
        echo $(TZ=UTC date -j -f "%Y-%m-%d %H:%M:%S" "$in_time" "+%s")
    else
        echo $(TZ=UTC date -d "$in_time" +%s)
    fi

}

demo="2023-08-14 10:00:00"

demoTime=$(to_utc_seconds "$demo")

echo "Current time: $currTime"
echo "Demo Time:$demoTime"

timeDiff="$((currTime - demoTime))"
echo "timeDiff: ${timeDiff}"
if [[ $timeDiff -lt 0 ]]; then
    echo "The deployments are blocked until UTC: $demo"
    exit 1
fi
