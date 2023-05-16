merge_branches() {
  local branch1="$1"
  local branch2="$2"
  
  # Validate branch names
  if ! git rev-parse --quiet --verify "$branch1" >/dev/null; then
    echo "Error: Branch '$branch1' does not exist."
    return 1
  fi
  
  if ! git rev-parse --quiet --verify "$branch2" >/dev/null; then
    echo "Error: Branch '$branch2' does not exist."
    return 1
  fi
  
  # Checkout branch2
  git checkout "$branch2"
  
  # Merge branch1 into branch2
  git merge "$branch1"
  
  # Check if merge was successful
  if [ $? -eq 0 ]; then
    echo "Merge completed successfully."
  else
    echo "Error: Merge failed."
    return 1
  fi
}

merge_branches $1 $2

