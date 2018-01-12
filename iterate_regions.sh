#/bin/sh

#####################################################
#This is a really simple script to pull a listing of#
#regions from AWS then crawl through each region and#
#run the check-all-vpcs.sh script. It creates a new #
#directory with a timestamped name and creates sub  #
#directories for each region.                       #
#####################################################

#Set date and create a new file for regions
today=`date +%Y-%m-%d`
region_dir="regions_$today"
region_file="regions_$today.txt"

mkdir $region_dir
cd $region_dir

#List all of the EC2 regions
aws ec2 describe-regions | jq '.Regions[] .RegionName' -r > $region_file

while read region; do
  #Create a directory for and change to the region
  echo "Checking region: $region..."
  mkdir $region
  cd $region
  aws configure set region $region

  #Invoke the security groups audit script for the region
  ../../check-all-vpcs.sh

  cd ..
done < $region_file
