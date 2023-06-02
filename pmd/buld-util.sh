#!/bin/bash
##------------------------------------
# Build util script for delta deployment
##------------------------------------

##--- logic ----

# - 1. check for the demo events, if there is a demo going on, stop the deployment
# - 2. Perform PMD scan
# - 3. Prepare for Delta deployment
# - 4. Deplyment
##---------------------

#----- GLOBAls
_PREFIX='===='

#----- PMD variables ----
#----- configure the following to meet your needs ----
#------ Refer: https://github.com/mohan-chinnappan-n/cli-dx/blob/master/mdapi/pmd-codescan.md ----

#RULESET="codeQuality/pmd/apexRuleset.xml"
RULESET="/Users/mchinnappan/.pmd/apex_ruleset.xml"

MSG="Number of P1 and P2 issues are"
THRESHOLD=3
#CODE="src/sales/channel-fundamentals/main/default/classes"
CODE="force-app/main/default/classes"

#PMD_PATH="codeQuality/pmd/pmd-bin-6.47.0/bin"
PMD_PATH="/Users/mchinnappan/node-pmd/pmd-bin-6.47.0/bin"

#PMD_OUTPUT=${PMD_PATH}/results.csv
PMD_OUTPUT=/tmp/results.csv

#----------------------------------

#----- delta deployment variables ----

DELTA_IGNORE_FILE="/Users/mchinnappan/.delta/ignore.txt"
DELTA_OUT_FILE="/tmp/delta_out.json"

#------------------------------------
#  util print message funtion
#-----------------------------------
function print_msg() {
    local msg=$1
    echo -e "\033[34m$_PREFIX $msg $_PREFIX\033[0m"
}

function print_err() {
    local msg=$1
    echo -e "\033[31m$_PREFIX $msg $_PREFIX\033[0m"
}

function print_info() {
    local msg=$1
    echo -e "\033[32m$_PREFIX $msg $_PREFIX\033[0m"

}

#------------------------------------
#   convert time to utc seconds
#     Darwin and Linux supported
#-----------------------------------

function get_os_type() {
    echo $(uname)
}

#------------------------------------
#   convert time to utc seconds
# .    Darwin and Linux supported
#-----------------------------------

function to_utc_seconds() {
    local in_time="$1"

    # date -j -f "%Y-%m-%d %H:%M:%S" "2022-8-24 18:00:00" "+%s"
    # 1661378400
    if ((get_os_type == "Darwin")); then
        echo $(date -j -f "%Y-%m-%d %H:%M:%S" "$in_time" "+%s")
    else
        echo $(date -d "$in_time" +%s)
    fi

}

#------------------------------------
#   handle PMD scan errors
#-----------------------------------

function handle_pmd_errors() {
    # query the results using SQL

    if ((get_os_type == "Darwin")); then
     print_msg "Showing the the code issues in the datatable; opens up in web browser..."
     cat ${PMD_OUTPUT} | pbcopy ; open "https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=csv"
    fi

    echo "SELECT COUNT(*) AS CNT   FROM CSV(\"${PMD_OUTPUT}\", {headers:true}) WHERE Priority < ${THRESHOLD}" >/tmp/q.sql
    cat /tmp/q.sql
    sfdx mohanc:data:query:sql -q /tmp/q.sql >/tmp/out.json
    cat /tmp/out.json
    # check for the errors
    nerrors=$(sfdx mohanc:data:jq -f '.[].CNT' -i /tmp/out.json)
    print_msg "nerrors: $nerrors"

    if [ "$nerrors" != 0 ]; then
        print_err "$MSG:  $nerrors. Stopping the deployment!"
        return $nerrors
    else
        return 0
    fi

}

#------------------------------------
#   perform PMD scan
#-----------------------------------

function pmd_scan() {
    print_msg "ApexCodePath for PMD Scan: $CODE"
    
    ${PMD_PATH}/pmd-run.sh pmd -R $RULESET -d $CODE -f csv >${PMD_OUTPUT}
    nerrors=$(wc -l ${PMD_OUTPUT})
    if [[ $nerrors != 0 ]]; then
        print_msg "PMD Errors output line count: $nerrors"
        if handle_pmd_errors; then
            print_info "No PMD errors, continuing the deployment..."
        else
            print_err "PMD has errors!, can't continue!"
            return 1
        fi
    fi

}

#------------------------------------
#  check for any demo is scheduled
#-----------------------------------

function check_for_demo() {
    local demo_file=$1
    local os_type=$2

    print_msg "Demo file: $demo_file"

    if [ -z ${demo_file} ]; then
        print_info "File: ${demo_file}  does not exist. By passing demo check... "
        return 0
    fi

    cat ${demo_file}

    while read demo; do

        print_msg "demo: $demo $os_type"

        #get the current date/time in seconds (epoch time)
        currTime=$(date -u "+%s")

        print_msg "currtime ${currTime}"
        #convert the utc demo time into seconds (epoch time)
        demoTime=$(to_utc_seconds "$demo")
        print_msg "demoTime: ${demoTime}"

        #find the difference in times
        timeDiff="$((currTime - demoTime))"
        print_msg "timeDiff: ${timeDiff}"

        if [[ $timeDiff -lt 0 ]]; then
            print_err "The deployments are blocked until $demo!"
            return 1
        fi

    done <$demo_file
}

#------------------------------------
#  prepre for delta deployment
#-----------------------------------

function prep_delta_deploy() {
    local from=$1
    local to=$2
    local ignoreFile=$3
    local outfile=$4

    local ignoreFileFlag=''

    if [ ${ignoreFile} = 'NONE' ]; then
        ignoreFileFlag=''
    else
        ignoreFileFlag="-i ${ignoreFile}"
    fi

    print_msg "running: sfdx sgd:source:delta -f $from -t $to  ${ignoreFileFlag} -o .  > ${outfile}"
    sfdx sgd:source:delta -f $from -t $to ${ignoreFileFlag} -o . >${outfile}
    print_msg "Exit status: $? "
    cat ${outfile}
    prep_detla_deploy_status_success=$(sfdx mohanc:data:jq -f '.success' -i ${outfile})
    if [ "$prep_detla_deploy_status_success" == "true" ]; then
        print_msg "Delta deployment prep is success, continuing the deployment..."
        return 0
    else
        print_msg "Delta deployment prep failed!"
        cat ${outfile}
        return 1
    fi

}

#------------------------------------
#   main driver function for build
#-----------------------------------
#-------- delta build ------

function build_delta() {
    local branch=$1 #GIT_BRANCH
    local from=$2   #GIT_PREVIOUS_SUCCESSFUL_COMMI
    local to=$3     #$(git rev-parse $branch)
    local un=$4
    local demo_file=$5
    local preOrPost=$6
    local RT=$7
    DELTA_IGNORE_FILE=$8
    local checkOnly=$9

    local os_type=$(get_os_type)

    print_msg "OS Type: $os_type"

    print_msg "Inputs:"

    print_msg "branch: ${branch}"
    print_msg "from SHA1: ${from}"
    print_msg "to SHA1: ${to}"
    print_msg "username: ${un}"

    print_msg "demo_file: ${demo_file}"
    print_msg "run test class: ${RT}"
    print_msg "preOrPost: ${preOrPost}"
    print_msg "checkOnly: ${checkOnly}"
    print_msg "deltaIgnoreFile: ${DELTA_IGNORE_FILE}"

    print_msg "================="

    #check if there is even anything to push to the orgs
    if [[ "$to" == "$from" ]]; then
        echo "There are no delta changes to commit, exiting..."
        exit 1
    fi

    print_msg "Useranme:  $username"
    print_msg "demo file:  $demo_file"

    #----- by passing demo if it is 'NONE'
    if [ "${demo_file}" = "NONE" ]; then
        print_msg " By passing demo check... "
    else
        if check_for_demo "$demo_file" "$os_type"; then
            print_msg "Going to deploy..."
        else
            print_msg "Deployment is blocked due to demo schedule"
        fi
    fi

    #--- PMD
    if [ "${apexClassPath}" = "NONE" ]; then
        print_msg " By passing PMD scan..."
    else
        if pmd_scan; then
            print_msg "After PMD Scan, Continuing the deployment..."
        else
            print_msg "After PMD Scan, Stopping the deployment..."
            return 1
        fi
    fi

    #--- delta deployment prep
    if prep_delta_deploy $from $to "${DELTA_IGNORE_FILE}" "${DELTA_OUT_FILE}"; then
        print_msg "After delta deployment prep, Continuing the deployment..."
    else
        print_msg "After delta deployment prep errors, Stopping the deployment..."
        return 1
    fi

    #--- now deploy
    print_msg "Run this command:"
    print_info """ 
=============RUN for Plain output==================
sfdx force:source:deploy -x package/package.xml  -u ${un}  --${preOrPost}destructivechanges destructiveChanges/destructiveChanges.xml ${RT}    ${checkOnly}  --loglevel TRACE 
=============RUN for JSON output==================
sfdx force:source:deploy -x package/package.xml  -u ${un}  --${preOrPost}destructivechanges destructiveChanges/destructiveChanges.xml ${RT}    ${checkOnly}  --loglevel TRACE --json > /tmp/_build-results.json
=============RUN for JSON output==================
==== View the componentSuccesses and componentFailures ===
sfdx mohanc:data:jq -i  /tmp/_build-results.json -f '.result.details.componentSuccesses' | pbcopy ; open \"https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=json\" 
sfdx mohanc:data:jq -i  /tmp/_build-results.json -f '.result.details.componentFailures' | pbcopy ; open \"https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=json\" 
==================================================
         """
    #sfdx force:source:deploy -x package/package.xml  -u "${un}" \ --${preOrPost}destructivechanges destructiveChanges/destructiveChanges.xml \  "${RT}" --json "${checkOnly}" \ --loglevel TRACE     
    #print_msg "exit status: $?"

}

#-------- complete full build ------
function build_full() {
    local un=$1
    local srcFolder=$2
    local demo_file=$3
    local RT=$4
    local checkOnly=$5
    local apexClassPath=$6

    local os_type=$(get_os_type)

    print_msg "OS Type: $os_type"

    print_msg "Inputs:"

    print_msg "username: ${un}"
    print_msg "srcFolder: ${srcFolder}"
    print_msg "demo_file: ${demo_file}"
    print_msg "run test class: ${RT}"
    print_msg "checkOnly: ${checkOnly}"
    print_msg "apexClassPath: ${apexClassPath}"

    print_msg "================="

    #----- by passing demo if it is 'NONE'
    if [ "${demo_file}" = "NONE" ]; then
        print_msg " By passing demo check... "
    else
        if check_for_demo "$demo_file" "$os_type"; then
            print_msg "Going to deploy..."
        else
            print_msg "Deployment is blocked due to demo schedule"
        fi
    fi

    #--- PMD
    if [ "${apexClassPath}" = "NONE" ]; then
        print_msg " By passing PMD scan..."
    else
        if pmd_scan; then
            print_msg "After PMD Scan, Continuing the deployment..."
        else
            print_msg "After PMD Scan, Stopping the deployment..."
            return 1
        fi
    fi
    #--- now deploy

     print_msg "Run this command:"

         print_info """ 
=============RUN for Plain output==================
sfdx force:source:deploy -p "${srcFolder}" -u ${un} $RT   ${checkOnly} 
=============RUN for JSON output==================
sfdx force:source:deploy -p "${srcFolder}" -u ${un} $RT   ${checkOnly} --json > /tmp/_build-results.json
=============RUN for JSON output==================
==== View the componentSuccesses and componentFailures ===
sfdx mohanc:data:jq -i  /tmp/_build-results.json -f '.result.details.componentSuccesses' | pbcopy ; open \"https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=json\" 
sfdx mohanc:data:jq -i  /tmp/_build-results.json -f '.result.details.componentFailures' | pbcopy ; open \"https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=json\" 
==================================================

     """ 
    

}