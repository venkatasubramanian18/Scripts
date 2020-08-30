#!/bin/bash -ex

# This script is for use with the DevOps Challenge of installing PostgreSQL 9.6 on to a provisioned AWS EC2 instance running Ubuntu.

# This script will perform the following steps:
# 1. Set variables such as $packages, $rfolder, $dfolder, $gitloc, $sysuser, $logfile, and $sqlscript
# 2. Install packages based off of $packages.
# 3. Create directory: /postgres and other required.
# 4. Create system user 'postgres'.
# 5. Pull PostgreSQL from Git depot and confirm it is correct: git clone git://git.postgresql.org/git/postgresql.git.
# 6. Install PostgreSQL. ensuring the data files are stored in $dataFolder.
# 7. Start the PostgreSQL service using the pg_ctl command.
# 8. Run create_hello.sql script.
# 9. Run '/postgres/bin/psql -c 'select * from hello;' -U user hello_postgres;' against newly created DB and test for succesful response.

# Section 1 - Variable Creation

echo "Creating variables for use throughout the PSQL installation process"
# $packages is an array containing the dependencies for PostgreSQL
packages=('git' 'gcc' 'tar' 'gzip' 'libreadline5' 'make' 'zlib1g' 'zlib1g-dev' 'flex' 'bison' 'perl' 'python3' 'tcl' 'gettext' 'odbc-postgresql' 'libreadline6-dev')
# $rfolder is the install directory for PostgreSQL
rfolder='/postgres'
# $dfolder is the root directory for various types of read-only data files
dfolder='/postgres/data'
# $gitloc is the location of the PosgreSQL git repo
gitloc='git://git.postgresql.org/git/postgresql.git'
# $sysuser is the system user for running PostgreSQL
sysuser='postgres'
# $scripts directory
scripts="/home/$USER/scripts"
# $sqlscript is the sql script for creating the PSQL user and creating a database.
sqlscript="$scripts/initial-table.sql"
# $logfile is the log file for this installation.
logfile='psqlinstall-log'

# Section 2 - Package Installation

# Ensures the server is up to date before proceeding.
echo "Updating server..."
sudo apt-get update -y >> $logfile

# This for-loop will pull all packages from the package array and install them using apt-get
echo "Installing PostgreSQL dependencies"
sudo apt-get install ${packages[@]} -y >> $logfile


# Section 3 - Create required directories

echo "Creating folders $dfolder..."
sudo mkdir -p $dfolder >> $logfile
sudo mkdir -p $scripts >> $logfile

# Section 4 - Create system user

#echo "Creating system user '$sysuser'"
#sudo adduser --system $sysuser >> $logfile

# Section 5 - Installing  PSQL

echo "installing PostgreSQL"
sudo apt-get install postgresql postgresql-contrib >> $logfile
sudo -u postgres psql
echo "\password"
echo "password"

# Section 7 - Start PSQL

echo "Wait for PostgreSQL to finish starting up..."
sleep 5


# Section 8 - initial-table.sql script is ran

# The initial-table.sql script is downloaded and ran to create the user, database, and populate the database.
echo "Downloading SQL script"
wget -P $scripts https://raw.githubusercontent.com/devopsbc01/Scripts/master/initial-table.sql

echo "Running script"
$rfolder/bin/psql -U postgres -f $sqlscript
