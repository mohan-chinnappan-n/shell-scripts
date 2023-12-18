while true; do
    sudo lsof -i -P | grep LISTEN
    sleep 5  # Adjust the sleep duration as needed
done
