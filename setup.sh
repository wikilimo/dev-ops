echo "This script is not idempotent. It is to be run only once at setup"
echo "Things are sure to break if this is run a second time"
read -p "Press enter if you understand and wish to continue"

echo "Update the package list..."
sudo apt update
echo "Upgrade installed packages..."
read -p "Press enter to continue"
sudo apt upgrade -y
echo "Install necessary packages to minimal Ubuntu system..."
read -p "Press enter to continue"
sudo apt install -y fish wget bzip2 curl git gcc g++ python3-dev build-essential vim nano rsync htop tree screen libatlas-base-dev libboost-all-dev
sudo apt clean
sudo apt autoremove -y

echo "Install miniconda..."
read -p "Press enter to continue"
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
chmod +x miniconda.sh
./miniconda.sh -b -p $HOME/miniconda3
echo "Init bash for miniconda..."
echo ". $HOME/miniconda3/etc/profile.d/conda.sh" >> ~/.profile
source ~/.profile
conda init bash
conda init fish
source ~/.profile
source ~/.bashrc
rm miniconda.sh

echo "Update Miniconda"
read -p "Press enter to continue"
conda update conda -q -y
conda clean -a -y -q

echo "Add a swap file"
read -p "Press enter to continue"
echo "Enter swap value in GB as such: 10G for 10 GB swap area"
read swapvalue
sudo fallocate -l $swapvalue /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# verify
sudo swapon --show
echo "This doesn't update fstab for persisting swap across system reboots."
echo "Add the following at the end of /etc/fstab"
echo "/swapfile swap swap defaults 0 0"


echo "Installing GPU Drivers"
read -p "Press enter to continue"
curl -O https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt update
sudo apt install -y cuda

echo "Rebooting system in 5s. Please login again after some time..."
sleep 5; sudo reboot -h now