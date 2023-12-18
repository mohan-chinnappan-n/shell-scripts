while true; do
    sudo lsof -i -P | grep LISTEN | grep 1717
    echo "--------------------------"
    sleep 5  # Adjust the sleep duration as needed
done
