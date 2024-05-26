#!/bin/bash

#check if there is a dev description
dev_desc="null"
if [ $# -eq 1 ]; then
    dev_desc=$1
fi

#check if the .csv file exsist
file_name=$(ls *.csv)
if [ -z $file_name ]; then
    echo ERROR: No csv File
    exit -1
fi

message=""
#run through the rows of the csv file
while IFS=, read -r ID Desc Branch Developer Priorty URL
do
    #check the branch name
    if [ $Branch == $(git branch --show-current) ]; then

        #build the commit message
        if [ $dev_desc == "null" ]; then
            message=$ID:$(date "+%Y-%m-%d %H:%M:%S"):$Branch:$Developer:$Priorty:$Desc
        else
             message=$ID:$(date "+%Y-%m-%d %H:%M:%S"):$Branch:$Developer:$Priorty:$Desc:$dev_desc
        fi

        #add changes to staging area
        git add .

        #commit changes
        git commit -m "$message"

        #push to github 
        git push $URL $Branch

    fi
done < $file_name

