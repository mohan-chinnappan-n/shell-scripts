
# Git Branch Merge

## Create Git Repo

```
~/proj1  >git init
Initialized empty Git repository in /Users/mchinnappan/proj1/.git/
~/proj1  (git)-[main]- >vi notes.md
~/proj1  (git)-[main]- >git add -A
~/proj1  (git)-[main]- >git commit -m init
[main (root-commit) d2fdd7b] init
 1 file changed, 2 insertions(+)
 create mode 100644 notes.md
~/proj1  (git)-[main]- >git log
commit d2fdd7b25355531e93dca4fcc6c5457d6596f7f8 (HEAD -> main)
Author: mohan chinnappan <mohan.chinnappan.n@gmail.com>
Date:   Tue May 16 09:29:44 2023 -0400

    init
```


## Create branch dev

```
~/proj1  (git)-[main]- >git branch dev

```

## List the branches

```
~/proj1  (git)-[main]- >git branch -a
  dev
* main
```

## Edit notes.md  in main branch

```
~/proj1  (git)-[main]- >vi notes.md
~/proj1  (git)-[main]- >git add -A
~/proj1  (git)-[main]- > cat notes.md
one
two

~/proj1  (git)-[main]- >git commit -m update_on_notes
[main 61fb145] update_on_notes
 1 file changed, 1 insertion(+)
```

## Checkout dev

```
 ~/proj1  (git)-[main]- >git checkout dev
Switched to branch 'dev'
~/proj1  (git)-[dev]- >cat notes.md
one

```


##  merge from main to dev

```
~/proj1  (git)-[dev]- >bash git-branch-merge.sh main dev
Already on 'dev'
Updating d2fdd7b..61fb145
Fast-forward
 notes.md | 1 +
 1 file changed, 1 insertion(+)
Merge completed successfully.
```

## Check merge

```
~/proj1  (git)-[dev]- >cat notes.md
one
two
```
