
dedent() {
    local -n reference="$1"
    reference="$(echo "$reference" | sed 's/^[[:space:]]*//')"
}


text="this is line one
      this is line two
      this is line three\n"
dedent text
printf "$text"             # print to screen
printf "$text" > file.txt  # print to a file


