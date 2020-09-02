echo "Update the package list..."
sudo apt update
echo "Upgrade installed packages..."
sudo apt upgrade -y
echo "Install necessary packages to minimal Ubuntu system..."
sudo apt install -y fish wget bzip2 curl git gcc g++ python3-dev build-essential vim nano rsync
sudo apt clean
sudo apt autoremove -y
echo "Install miniconda..."
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
chmod +x miniconda.sh
./miniconda.sh -b -p $HOME/miniconda3
echo "Init bash for miniconda..."
echo ". $HOME/miniconda3/etc/profile.d/conda.sh" >> ~/.profile
source ~/.profile
conda init bash
source ~/.profile
rm miniconda.sh
echo "Create conda environment for Deep Learning..."
echo "name: wildfire-dl
channels:
  - pytorch
  - anaconda
  - conda-forge
  - defaults
dependencies:
  - black=19.10b0
  - cudatoolkit=10.2.89
  - flake8=3.8.3
  - h5netcdf=0.8.1
  - imbalanced-learn=0.7.0
  - ipython=7.13.0
  - jupyter=1.0.0
  - jupyterlab=2.1.5
  - matplotlib=3.2.2
  - notebook=6.0.3
  - numpy=1.18.1
  - pandas=1.0.3
  - pip=20.0.2
  - plac=0.9.6
  - pre-commit=2.5.1
  - python=3.7.7
  - pytorch=1.6.0
  - regionmask=0.5.0
  - scikit-image=0.16.2
  - scipy=1.4.1
  - sphinx=3.1.1
  - tensorboard=2.2.2
  - torchvision=0.7.0
  - pip:
    - gsutil==4.52
    - netcdf4==1.5.3
    - pytorch-lightning==0.9.0
    - sphinx-autoapi==1.4.0
    - wandb==0.8.36" >> ~/environment.yml
conda env create --file environment.yml
echo "Clean up conda..."
conda clean -a -y
rm environment.yml
echo "Downloading FWI Forcings to ~/data/fwi-forcings/..."
mkdir data
conda activate wildfire-dl 
cd data
mkdir fwi-forcings
gsutil -m cp gs://deepfwi-forcings/*201904* fwi-forcings/
gsutil -m cp gs://deepfwi-forcings/*201905* fwi-forcings/
gsutil -m cp gs://deepfwi-forcings/*201906* fwi-forcings/
gsutil -m cp gs://deepfwi-forcings/*201907* fwi-forcings/
gsutil -m cp gs://deepfwi-forcings/*201908* fwi-forcings/
gsutil -m cp gs://deepfwi-forcings/*201909* fwi-forcings/
echo "Rebooting system. Please login again after some time..."
sleep 5; sudo reboot -h now