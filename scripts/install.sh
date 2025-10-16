#!/bin/bash
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

echo -e "***********************************************************************"
echo -e "* This script will try to install Decidim on this machine.            *"
echo -e "* Take into account that it will ask for some information that        *"
echo -e "* you will have to provide. Also it will take care of installing      *"
echo -e "* all necessary dependencies, such as *docker*, *git*, etc.           *"
echo -e "*                                                                     *"
echo -e "* You will be guided throughout the script and will be able to        *"
echo -e "* stop it and restart it if necessary.                                *"
echo -e "*                                                                     *"
echo -e "* It's not in a production-ready state. There's not guarantee         *"
echo -e "* and it's up to you to take care of your systems.                    *"
echo -e "*                                                                     *"
echo -e "***********************************************************************"

REPOSITORY_PATH="$HOME/decidim"

set -e

trap "You can re-run this script to restart the installation", ERR

if command -v git; then
  echo "Git is installed. $(git --version)"
else
  sudo apt update
  sudo apt install -y git curl
  sudo apt clean
fi

echo "Downloading decidim-docker repository to "
if [ ! -d $REPOSITORY_PATH ]; then
  git clone -b feat/decidim_install https://github.com/decidim/docker.git $REPOSITORY_PATH
fi

cd $REPOSITORY_PATH

echo "Checking the OS version"
source $REPOSITORY_PATH/scripts/dependencies/os_version.sh

# Check if docker is installed, if not install it
echo "Checking if docker is installed. If not install it."
source $REPOSITORY_PATH/scripts/dependencies/check_docker.sh

# Checking which Decidim version does the user want
echo "Checking the Decidim version to use."
source $REPOSITORY_PATH/scripts/dependencies/decidim_version.sh

# Open necessary ports
echo "Openning necessary server ports."
source $REPOSITORY_PATH/scripts/dependencies/open_ports.sh

# Build environment variables
echo "Asking for necessary variables."
source $REPOSITORY_PATH/scripts/dependencies/build_env.sh

# Start decidim
echo "Starging Decidim..."
source $REPOSITORY_PATH/scripts/up.sh
