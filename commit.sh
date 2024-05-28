#!/bin/bash

#check if there is a dev description
dev_desc="null"
if [ $# -eq 1 ]; then
    dev_desc=("$@")
fi

#check if the .csv file exsist
file_name=$(ls *.csv)
if [ -z $file_name ]; then
    echo ERROR: No csv File
    exit -1
fi

message=""
found=0
#run through the rows of the csv file
while IFS=, read -r ID Desc Branch Developer Priorty URL
do
    #check the branch name
    if [ $Branch == $(git branch --show-current) ]; then
        found=1
        #build the commit message
        if [ $dev_desc == "null" ]; then
            message=$ID:$(date "+%Y-%m-%d %H:%M:%S"):$Branch:$Developer:$Priorty:$Desc
        else
             message=$ID:$(date "+%Y-%m-%d %H:%M:%S"):$Branch:$Developer:$Priorty:$Desc:"$dev_desc"
        fi

        #add changes to staging area
        git add .

        #commit changes
        git commit -m "$message"

        #push to github 
        if ! git push $URL $Branch; then
            echo "Error: Failed to push to Github"
        fi

    fi
done < $file_name

if [ $found -eq 0 ]; then
    echo $Branch branch not found in $file_name
fi
