#!/bin/bash

# Define the functions to call

#applicationDeployment
function applicationDeployment {
  echo ""
  echo -e "\033[1mPrerequisite:\033[0m"
  echo " 1. Make sure that you have installed kubctl and is configured with the up and running eks cluster."
  echo " 2. Make sure that you have installed aws-cli and configured it."
  echo " 3. Make sure that domain mapping is done properly."
  echo ""

  echo -n "If above requirements meet, Enter(yes):"
  read user_continue_action_appDeployment
  if [ "$user_continue_action_appDeployment" == "yes" ]; then
      cd .. 
      cd kubernetes
      ./kubectl-apply.sh
      cd ..
      cd terraform
  else 
      echo "Thank you, user!"
  fi
}

#AWS
function aws {
    echo "You selected AWS"
    # Add code here to execute the action for aws
    echo "Initiating the aws action...."
    while true; do
      echo ""
      echo "Setting up aws configuration which will be used be terraform"
      echo -n "Provide aws access key:"
      read aws_access_key
      echo -n "Provide aws secret key:"
      read aws_secret_key
      export AWS_ACCESS_KEY_ID=$aws_access_key
      export AWS_SECRET_ACCESS_KEY=$aws_secret_key
      echo ""
      echo -e "\033[1;33mProvided aws configuration\033[0m"
      echo "aws access key:"${AWS_ACCESS_KEY_ID}
      echo "aws secret key:"${AWS_SECRET_ACCESS_KEY}
      echo -n "Ensure that your aws configuration are correct, if you agree Enter(yes):"
      read user_confirmation

      # convert user input to lowercase
      user_confirmation=$(echo "$user_confirmation" | tr '[:upper:]' '[:lower:]')
      if [[ "$user_confirmation" == "yes" ]]; then
          break
      fi
    done
    echo ""
    echo -e "\033[1;32mAws credentials are set!\033[0m"
    echo ""
    echo -n "Continue with the WDI deployment, if you agree Enter(yes):"
    read user_continue_action
    if [ "$user_continue_action" == "yes" ]; then
    echo "Deploying the WDI in our AWS cloud....."
        # List of directories to process
        directories=(
        "./infra"
        # "./EBS"
        # "./Web-UI"
        )

        # Loop through each directory and execute command
        for dir in "${directories[@]}"
        do
            if [ -d "$dir" ]; then
                echo "Processing directory: $dir"
                cd "$dir" || exit
                # Execute your command here
                echo "Initiating terrafrom in $dir"
                terraform init
                echo "Auto applying terraform in $dir"
                terraform apply -auto-approve
                cd ..
            else
                echo "Directory $dir does not exist"
            fi
        done
      echo ""
      echo -e "\033[1m\033[32mInfrastructure was deployed successfully!\U0001F63B\033[0m"
      echo ""
    else 
        echo ""
        echo -e "Looks like you have already deployed the WDI, Thank you!\U0001F431"
        echo ""
    fi

    echo -n "Do you want to contiune with the application Deployment, if you agree Enter(yes):"
    read  appDepolyment; 

    if [ "$appDepolyment" == "yes" ]; then
      applicationDeployment
    else 
      echo "Thank you, user!"
    fi

}

function azure {
    echo "You selected AZURE"
    # Add code here to execute the action for azure
    echo -e "we are not supporting azure as of now, please come back later!\U0001F600"
}

function gcp {
    echo "You selected GCP"
    # Add code here to execute the action for gcp
    echo -e "we are not supporting gcp as of now, please come back later!\U0001F600"
}

############################ SCRIPT STARTS ##########################

# Check if figlet is installed
if ! which figlet > /dev/null; then
    # Install figlet
    sudo apt-get -y install figlet
fi


# Define the options
options=("1. AWS" "2. AZURE" "3. GCP")

# Initialize variables
selected=0
num_options=${#options[@]}

# Clear the screen
# clear

# Loop until the user selects an option
while true; do
  # Display the options 
  figlet -f slant "AutoDeploy" 
  echo "Select the cloud provider"
  for (( i=0; i<$num_options; i++ )); do
    if [ $i -eq $selected ]; then
      echo -e "\033[1;32m> ${options[$i]}\033[0m"
    else
      echo "  ${options[$i]}"
    fi
  done

  # Get input from the user
  read -s -n 1 key
  case "$key" in
    "A") # Up arrow
      ((selected--))
      if [ $selected -lt 0 ]; then
        selected=$((num_options-1))
      fi
      ;;
    "B") # Down arrow
      ((selected++))
      if [ $selected -ge $num_options ]; then
        selected=0
      fi
      ;;
    "") # Enter key
      break
      ;;
  esac

  # Clear the screen
  clear
done

# Display the selected option
# echo "You selected: ${options[$selected]}"

# Execute different actions based on the selected option
if [ $selected -eq 0 ]; then
  aws
  # Add code here to execute the action for aws
elif [ $selected -eq 1 ]; then
  azure
  # Add code here to execute the action for azure
elif [ $selected -eq 2 ]; then
  gcp
  # Add code here to execute the action for 
else
  echo "Invalid selection"
fi



