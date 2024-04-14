#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo -e "\033[36mThis script must be run as root.\033[0m"
  exit 1
fi

# Check for required dependencies
dependencies=(curl jq)
missing_deps=()

for dep in "${dependencies[@]}"; do
  if ! type "$dep" &>/dev/null; then
    missing_deps+=("$dep")
  fi
done

# Function to suggest how to install missing dependencies
suggest_installation() {
  local os_type="$(uname -s)"
  case "$os_type" in
    Darwin)
      echo "brew install ${1}"
      ;;
    Linux)
      if [[ -f /etc/debian_version ]]; then
        echo "sudo apt-get install ${1} -y"
      elif [[ -f /etc/redhat-release ]]; then
        echo "sudo yum install ${1} -y"
      fi
      ;;
    *)
      echo "echo 'Your operating system is not supported by this script's automatic dependency installation guide.'"
      ;;
  esac
}

if [ ${#missing_deps[@]} -ne 0 ]; then
  echo -e "\033[36mYou need to install the following to use the shell pilot script: ${missing_deps[*]}.\033[0m"
  for dep in "${missing_deps[@]}"; do
    echo -n "Would you like to install ${dep}? (y/n): "
    read answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      install_command=$(suggest_installation "$dep")
      echo "Installing ${dep}..."
      eval "$install_command"
    else
      echo "${dep} installation skipped."
    fi
  done
fi

echo "==> All required dependencies are installed or skipped by the user."

# Define the installation path
INSTALL_PATH="/usr/local/bin"

# Define URLs for the script and configuration file
SHELL_PILOT_SCRIPT_URL="https://raw.githubusercontent.com/reid41/shell-pilot/main/s-pilot"
SHELL_PILOT_COMMON_URL="https://raw.githubusercontent.com/reid41/shell-pilot/main/spilot_common.sh"

# Function to download shell-pilot scripts with retries
shell_pilot_download_script() {
    local url="$1"
    local path="$2"
    local retries=3

    while [ $retries -gt 0 ]; do
        curl -sS "$url" -o "$path"
        if [ $? -eq 0 ]; then
            echo "$path downloaded successfully."
            return 0
        else
            echo "Failed to download $path, retrying..."
            retries=$((retries - 1))
            sleep 1
        fi
    done

    echo "Failed to download $path."
    return 1
}

# Download the s-pilot script
shell_pilot_download_script "$SHELL_PILOT_SCRIPT_URL" "${INSTALL_PATH}/s-pilot" || exit 1

# Download the configuration file spilot_common.sh
shell_pilot_download_script "$SHELL_PILOT_COMMON_URL" "${INSTALL_PATH}/spilot_common.sh" || exit 1

# Optionally, set execute permissions
chmod +x "${INSTALL_PATH}/s-pilot"
chmod +x "${INSTALL_PATH}/spilot_common.sh"

echo "==> Shell Pilot installation completed."

# Function to add environment variables to the user's shell profile
add_to_profile() {
  local profile_path=$1
  echo "export OPENAI_KEY=$key" >> "$profile_path"
  if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    echo 'export PATH=$PATH:/usr/local/bin' >> "$profile_path"
  fi
  echo "OpenAI key and PATH were added to $profile_path"
  source "$profile_path"
}

# Function to validate the OpenAI key installation
validate_installation() {
  if [[ "$OPENAI_KEY" != "$key" ]]; then
    echo "Failed to set OPENAI_KEY correctly."
    return 1
  fi

  if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    echo "Failed to add /usr/local/bin to PATH."
    return 1
  fi

  echo "Verification successful: OPENAI_KEY and PATH are correctly set."
  return 0
}

echo "==> The script will add the OPENAI_KEY environment variable to your shell profile and add /usr/local/bin to your PATH."
read -p "==> Would you like to continue? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "Please enter your OpenAI API key: " key

  # Determine which shell profile is present and add the OpenAI key
  if [ -f ~/.zprofile ]; then
    add_to_profile ~/.zprofile
  elif [ -f ~/.zshrc ]; then
    add_to_profile ~/.zshrc
  elif [ -f ~/.bash_profile ]; then
    add_to_profile ~/.bash_profile
  elif [ -f ~/.profile ]; then
    add_to_profile ~/.profile
  else
    echo "Could not find a known shell profile. Please manually add: export OPENAI_KEY=$key"
  fi

  # Verify the installation
  if validate_installation; then
    echo "Installation complete."
  else
    echo "Installation failed. Please check the errors above. Proceeding with additional settings."
  fi
else
  echo "Installation aborted. Please follow the manual installation instructions if you wish to proceed later."
  echo "https://github.com/reid41/shell-pilot/tree/main#manual-installation"
fi

# Function to check and append OLLAMA_SERVER_IP to the specified configuration file
add_ollama_ip() {
  local config_file=$1

  # Check if the OLLAMA_SERVER_IP variable already exists in the configuration file
  if grep -q "OLLAMA_SERVER_IP=" "$config_file"; then
    local existing_ip=$(grep "OLLAMA_SERVER_IP=" "$config_file" | cut -d'=' -f2)
    if [[ $existing_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "OLLAMA_SERVER_IP is already set to a valid IP address: $existing_ip"
      return 0
    else
      echo "Error: OLLAMA_SERVER_IP is set but not valid: $existing_ip"
      return 1
    fi
  else
    # The variable does not exist, prompt user for input
    while true; do
      read -p "Enter the OLLAMA server IP address: " ip_address
      if [[ $ip_address =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "OLLAMA_SERVER_IP=$ip_address" >> "$config_file"
        echo "OLLAMA_SERVER_IP added to $config_file"
        break
      else
        echo "Error: Invalid IP address entered. Please enter a valid IP address."
      fi
    done
  fi
}

# Specify the configuration file path
CONFIG_FILE="${INSTALL_PATH}/spilot_common.sh"

# Check and append OLLAMA_SERVER_IP
if add_ollama_ip "$CONFIG_FILE"; then
  echo "Operation successful."
else
  echo "Operation failed. Please check the errors above."
fi







 







