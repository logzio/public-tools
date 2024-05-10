#!/bin/bash

# Define the list of IPs for each region
westeurope=(
    "104.40.212.94"
    "104.40.225.1"
    "104.40.184.123"
    "13.73.162.156"
    "35.157.100.82"
    "35.157.19.97"
    "52.57.23.254"
    "52.57.24.166"
)

westus2=(
    "20.9.175.118"
    "20.9.174.176"
    "20.230.208.201"
    "20.236.24.184"
    "107.22.168.224"
    "3.214.18.103"
    "3.81.182.79"
    "34.196.246.79"
    "34.198.165.82"
    "34.198.180.160"
    "34.198.249.114"
    "34.198.80.79"
    "34.199.22.38"
    "34.199.36.125"
    "34.236.219.188"
    "34.238.54.86"
    "44.209.43.33"
    "50.16.72.19"
    "52.20.49.54"
    "52.21.71.179"
    "54.210.40.1"
    "54.82.127.215"
)

# On Mac, "timeout" is not installed by default, in which case we can't use it
if type timeout >/dev/null 2>&1; then
    timeout="timeout 1"
else
    timeout=""
fi

# Function to check the response of each IP
check_ip() {
    local ip=$1
    local port=$2

    echo -n "$ip... "
    local response=$($timeout bash -c "</dev/tcp/$ip/$port" >/dev/null 2>&1 && echo 1 || echo 0)

    if [ "$response" -eq 1 ]; then
        echo "✓"
        return 0
    else
        echo "Timed out!"
        return 1
    fi
}

# Check if region argument is provided
if [[ "$1" == "westeurope" ]]; then
    region_ips=("${westeurope[@]}")
elif [[ "$1" == "westus2" ]]; then
    region_ips=("${westus2[@]}")
else
    echo "Invalid region argument. Please specify either 'westeurope' or 'westus2'."
    exit 1
fi

# Check if all IPs were successful
all_successful=true
problematic_ips=()

# Set the port
if [ $# -eq 2 ]; then
    port=$2
else
    port=8071 # Default value
fi

echo "Starting the validation (using port $port)..."

for ip in "${region_ips[@]}"; do
    if ! check_ip $ip $port; then
        all_successful=false
        problematic_ips+=("$ip")
    fi
done

# Print result
if $all_successful; then
    echo "                                                          "
    echo "   █████╗ ██╗     ██╗         ███████╗███████╗████████╗██╗"
    echo "  ██╔══██╗██║     ██║         ██╔════╝██╔════╝╚══██╔══╝██║"
    echo "  ███████║██║     ██║         ███████╗█████╗     ██║   ██║"
    echo "  ██╔══██║██║     ██║         ╚════██║██╔══╝     ██║   ╚═╝"
    echo "  ██║  ██║███████╗███████╗    ███████║███████╗   ██║   ██╗"
    echo "  ╚═╝  ╚═╝╚══════╝╚══════╝    ╚══════╝╚══════╝   ╚═╝   ╚═╝"
    echo "                                                          "
else
    echo "                                         "
    echo "███████╗██████╗ ██████╗  ██████╗ ██████╗ "
    echo "██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔══██╗"
    echo "█████╗  ██████╔╝██████╔╝██║   ██║██████╔╝"
    echo "██╔══╝  ██╔══██╗██╔══██╗██║   ██║██╔══██╗"
    echo "███████╗██║  ██║██║  ██║╚██████╔╝██║  ██║"
    echo "╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
    echo "                                         "
    echo "Unreachable IPs:"
    for ip in "${problematic_ips[@]}"; do
        echo "- $ip"
    done
fi

