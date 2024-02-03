
# deltaDeploy.sh, mchinnappan, jan 2023

LN='-----------------------------------'
SX='====='
AR='<----'
LOGLINES=${1:-24}


echo $LN
echo "DELTA DEPLOYMENT"
echo $LN
echo "Make sure to perform these steps before running this script: "
echo "1. Checkout the branch 'git checkout <branchName>' "
echo $LN
echo "2. If required, peform  'git reset --hard' - This resets the current branch tip,"
echo  "and also deletes any changes in the working directory and staging area"
echo $LN
echo "3. You have done 'git pull' from the required branch"
echo $LN
echo $SX git log $SX 

echo "git log --pretty='format:%h|%an|%ae|%s' | head -n $LOGLINES"
git log --pretty='format:%h|%an|%ae|%s' | head -n $LOGLINES
echo $LN
echo $LN
echo -n "FROM (Enter SHA1 for this commit FROM which we need to the delta deployment, default: HEAD^): "
read -r FROM
FROM=${FROM:-"HEAD^"}
echo -n "TO (Enter SHA1 for this commit TO which we need to the delta deployment, default: HEAD): "
read -r TO
TO=${TO:-"HEAD"}

echo $LN $FROM to $TO $LN
echo $LN Preparing delta packages $LN
sfdx sgd:source:delta -f $FROM -t $TO  -o .  > _delta_.json
cat _delta_.json

SUCCESS=`sfdx mohanc:data:jq -f '.success' -i _delta_.json`
echo "${AR} SUCCESS: $SUCCESS"
#-------------------

if [ "$SUCCESS" = "false"   ]
then
  echo "Delta prep was not successful, exiting with error code 2!"
  exit 2
fi

#---- zip the delta files
zip -r deployment_files.zip package/* destructiveChanges/*
 


echo -n "Run TestClasses only? (Enter y/n, default: y): "
read -r RT
RT=${RT:-"y"}
if [ "$RT" = "y" ]
then
  RT=' --testlevel RunLocalTests  '
else
  RT=' ' 
fi
echo "${AR} testlevel $RT"

#-------------------
echo -n "Run deletion pre or post? (Enter pre or post, default: post): "
read -r PREPOST
PREPOST=${PREPOST:-"post"}

if [ "$PREPOST" = "pre" ]
then
  PREPOST='pre'
else
  PREPOST='post' 
fi
echo "${AR} pre/post: $PREPOST"
#-------------------

echo $LN Deploying delta packages $LN
echo sfdx force:source:deploy -x package/package.xml  --${PREPOST}destructivechanges destructiveChanges/destructiveChanges.xml $RT  -c --verbose --loglevel TRACE 
sfdx force:org:open   -p   lightning/setup/DeployStatus/home

#------ open the org ---
#sfdx force:org:open  -p   lightning/setup/DeployStatus/home

#sfdx force:source:deploy -x package/package.xml  --${PREPOST}destructivechanges destructiveChanges/destructiveChanges.xml $RT  -c --verbose --loglevel TRACE 
# echo sfdx force:mdapi:deploy -d destructiveChanges      -c --verbose --testlevel RunLocalTests --loglevel DEBUG --wait -1 