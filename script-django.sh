#!/bin/bash

# Colors
# 30 black
# 31 red
# 32 green
# 34 blue
# 35 magenta
# 36 cyan
# 37 light gray
# 90 dark gray
# 91 light red
# 92 light green
# 93 light yellow
# 94 light blue
# 95 light magenta
# 96 light cyan
# 97 white

# Styles
# 1 bold
# 5 blink
# 8 hidden

# Syntax
# echo -e "\e[CODEmTEXT\e[0m"

# Initial message
echo -e "\e[31mHello, with this script you can create your Django project quickly...\e[0m"
echo
base_dir=~/dev2021/

# Change to base directory
cd $base_dir

# Create new folder
echo To create the directory, we need a name...
read new_dir
echo

if [[ -d "$new_dir" ]]
then 
echo -e "\e[31m$new_dir exists on your filesystem\e[0m"
echo -e "\e[5mexit\e[0m"
exit
else
mkdir $new_dir
echo -e "\e[36mA new directory named $new_dir has been created\e[0m"
fi
echo

# Move to the new folder created
cd $new_dir
# Clone repo
echo -e "\e[31mEnter the path of the repository you want to clone\e[0m"
echo
read git_repo
git clone $git_repo
echo -e "\e[36mCloned repository\e[0m"
ls
echo

# Create and activate python virtual environment
python3 -m venv env
source env/bin/activate
echo -e "\e[36mCreated and activated the virtual environment\e[0m"
echo

# Move to the git repository
repo_dir_git="$(cut -d'/' -f2 <<<"$git_repo")"
repo_dir="$(cut -d'.' -f1 <<<"$repo_dir_git")"
cd $repo_dir

# Install Packages and save to requirements
echo -e "\e[31mInstalling Django and Rest framework\e[0m"
echo
pip install --upgrade django
echo -e "\e[36mDjango installed\e[0m"
echo
pip install --upgrade djangorestframework
echo -e "\e[36mDjango Rest Framework installed\e[0m"
echo
pip freeze > requirements.txt
echo -e "\e[36mRequirements created\e[0m"
echo

# Create Django Project
echo -e "\e[31mCreating project Django\e[0m"
django-admin startproject src
mv src backend
cd backend
echo -e "\e[36mProject created\e[0m"
echo

# Create Django App
echo -e "\e[31mCreating App Django\e[0m"
echo Choose the name of your app...
read app_name
python3 manage.py startapp $app_name
cd $app_name
touch urls.py
touch serializers.py
echo
echo -e "\e[36mThe application $app_name has been created\e[0m"
cd ..
echo

# Migrations
echo -e "\e[31mApplying migrations\e[0m"
python3 manage.py makemigrations
python3 manage.py migrate
echo -e "\e[36mMigrations completed\e[0m"
echo 

# Super User
echo -e "\e[31mCreating super user\e[0m"
python3 manage.py createsuperuser --email epc91@email.com --username epc91
echo -e "\e[36mSuper User created\e[0m"
echo
cd ..

# Commit and Push Repository
echo -e "\e[31mPushing the repository to git\e[0m"
git status
git add .
git commit -m "Init Project"
echo -e "\e[36mDone!\e[0m"
git push

# Desactivar el entorno virtual
deactivate

delete_dir() {
    echo -e "\e[31mDeleting the directory and all its contents\e[0m"
    cd $base_dir
    rm -rf $new_dir
    echo -e "\e[36mThe directory $new_dir has been removed\e[0m"
    ls
}
# Activate this line if you want to delete the repository locally
# delete_dir