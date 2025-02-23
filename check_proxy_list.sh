#!/bin/bash

# Input file containing the list of proxies
PROXY_FILE="proxies.txt"
# Output file for working proxies
WORKING_PROXIES="working_proxies.txt"

# Clear the output file before writing
> "$WORKING_PROXIES"

# Loop through each proxy in the list
while IFS= read -r proxy; do
    echo "Testing $proxy..."
    
    # Temporarily update proxychains.conf
    echo -e "strict_chain\nproxy_dns\n[ProxyList]\n$proxy" > /etc/proxychains.conf
    
    # Test the proxy with proxychains
    if proxychains -q curl -I -m 10 https://www.google.com &>/dev/null; then
        echo "$proxy" >> "$WORKING_PROXIES"
        echo "$proxy is working!"
    else
        echo "$proxy failed."
    fi

done < "$PROXY_FILE"

echo "✅ Working proxies saved in $WORKING_PROXIES"
