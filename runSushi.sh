
sushi  -s -o .



if [[ $? -eq 0 ]]
then


#echo "Create the mapping file for ActNowReview"
#localscripts/makeLMMapping.js ActNowReview

# echo "Add fullUrl to example bundles"
# localscripts/addFullUrlToBundle.js

# echo "Creating Profiles and extensions summary pages..."
#  ../scripts/makeProfilesAndExtensions.js cs-lim

# echo "Making terminology summary"   # will copy into IG input folder
# ../scripts/makeTerminologySummary.js cs-lim

echo




else 
echo
echo
echo "There were errors, so the other scripts weren't run..."
fi

