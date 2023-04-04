#!/usr/bin/env bash
# Script to process sharing debugging for list of users got out of soql query
#  Creates svg file showing the permissions assigned to the the users, one file per user
# mchinnappan

title="Sharing debug info for the user"
usage="Usage: process_sharing_debug.sh <orgUsername>"
echo -e "\033[32m${title}\033[0m"
htmlout='debug.html'
htmlout2='debug2.html'
[ -e ${htmlout} ] && rm ${htmlout}
[ -e ${htmlout2} ] && rm ${htmlout2}


if [ $# -lt 1 ]; then
 echo -e "\033[34m${usage}\033[0m"
 exit 1
fi

echo """
 <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css'/> 
 <h3> Sharing Debug Info </h3>
 <div class='row'> <div class='col'> 
    <ul class='list-group'>
"""  >> ${htmlout}

query="https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/soql/user.soql"
uname=$1
users=`sfdx mohanc:data:query -u ${uname} -q ${query} | cut -f '3' -d ',' | sed 's/"//g' `
for user in ${users}; do
	echo "=== Processing user: ${user}... ==="
	cleaned_user=$(sed 's/@/AT/g' <<< "$user")
	line="<li class='list-group-item'><a href=\"${cleaned_user}.svg\">${user}</a></li>" 
	echo ${line} >>  ${htmlout}
        sfdx mohanc:sharing:debug -u ${uname} -n ${user}
done
echo """ </ul>
  </div>
  <div class='col'> 
    <img  width='800' id='view'/>
  </div> 
 </div>
  <script>
	  const items = document.getElementsByClassName('list-group-item');
	  const viewEle = document.getElementById('view');
	  for (const item of items) {
	    item.addEventListener('click', e => {
	      e.preventDefault();
	      viewEle.src = e.target.href;
	    })
	  }
</script>""" >>  ${htmlout}
open ${htmlout}
