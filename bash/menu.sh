PS3="Choose an animal: "
options=(cat dog mouse chair cow bird apple)
select menu in "${options[@]}";
do
  echo -e "\nyou picked $menu ($REPLY)"
  if [[ $menu == "chair" || $menu == "apple" ]]; then
    echo -e "$menu is not an animal\n"
  else
    echo "$menu is an animal"
    break;
  fi
done
