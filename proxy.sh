#!/bin/bash

# #############################################################################
# A script to set and unset proxy settings, with optional user authentication.
#
# Usage:
#   To set proxy (no auth):       source proxy.sh on
#   To set proxy (with auth):     source proxy.sh on <username> [password]
#   To unset the proxy:           source proxy.sh off
#   To check status:              source proxy.sh status
#
# IMPORTANT: You MUST use the 'source' command (or '.') for this to work.
# #############################################################################

# --- Configuration ---
PROXY_HOST="100.64.0.1"
PROXY_PORT="10810"

# --- Functions ---

# Function to set the proxy
set_proxy() {
    local username="$1"
    local password="$2"
    local http_auth_str=""
    local socks_auth_str=""

    # Check if a username was provided
    if [[ -n "$username" ]]; then
        # If a username is provided but a password is not, prompt for it securely
        if [[ -z "$password" ]]; then
            read -s -p "Enter password for user '$username': " password
            echo
        fi
        # Prepare the authentication string for the URL
        # NOTE: This does not handle special characters in username/password.
        # For that, URL encoding would be needed.
        http_auth_str="${username}:${password}@"
        socks_auth_str="${username}:${password}@"
    fi

    local http_proxy_url="http://${http_auth_str}${PROXY_HOST}:${PROXY_PORT}"
    local socks_proxy_url="socks5h://${socks_auth_str}${PROXY_HOST}:${PROXY_PORT}"
    
    echo "✅ Setting proxy..."

    # Set both lowercase and uppercase for maximum compatibility
    export http_proxy="${http_proxy_url}"
    export https_proxy="${http_proxy_url}"
    export all_proxy="${socks_proxy_url}"

    export HTTP_PROXY="${http_proxy_url}"
    export HTTPS_PROXY="${http_proxy_url}"
    export ALL_PROXY="${socks_proxy_url}"

    echo "Proxy has been set."
    # Show the status, but hide the password for security
    echo "Proxy URL (credentials hidden): http://<user>:<pass>@${PROXY_HOST}:${PROXY_PORT}"
}

# Function to unset the proxy
unset_proxy() {
    echo "❌ Unsetting proxy..."

    unset http_proxy
    unset https_proxy
    unset all_proxy

    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset ALL_PROXY
    
    echo "Proxy has been unset."
}

# Function to display the current proxy status
show_proxy_status() {
    echo "🔎 Current proxy status:"
    echo "--------------------------"
    # The sed command hides the user:pass part for security
    echo "http_proxy    : $(echo ${http_proxy:-Not Set} | sed -E 's|//.*@|//<user>:<pass>@|')"
    echo "https_proxy   : $(echo ${https_proxy:-Not Set} | sed -E 's|//.*@|//<user>:<pass>@|')"
    echo "all_proxy     : $(echo ${all_proxy:-Not Set} | sed -E 's|//.*@|//<user>:<pass>@|')"
    echo "--------------------------"
}


# --- Main Logic ---

# Check the first argument passed to the script
case "$1" in
    on)
        # Pass the username ($2) and password ($3) to the function
        set_proxy "$2" "$3"
        ;;
    off)
        unset_proxy
        ;;
    status)
        show_proxy_status
        ;;
    *)
        echo "Usage: source $0 {on|off|status} [username] [password]"
        ;;
esac