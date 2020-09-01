#!/bin/sh

WORKDIR=/home/caleb/dotfiles
pushd $WORKDIR

LOGFILE=$WORKDIR/dotfiles-update.log
ORIGIN=$(git remote get-url origin | sed "s/https:\/\///g")

source $WORKDIR/.GITHUB_KEY
# Now GITHUB_KEY is the auth token

CHANGES=$(git status --porcelain=v1 2>/dev/null | wc -l)

function hasChanged(){
    notify-send "Pushing dotfile changes to github..."
    echo "Changes since last run, pushing..."
    git add .
    COMMIT_MSG="Auto-update: $CHANGES files changed."
    git commit -m "$COMMIT_MSG"
    echo https://calebccff:$GITHUB_KEY@$ORIGIN
    git push -u https://calebccff:$GITHUB_KEY@$ORIGIN master 2>&1 >> $LOGFILE
}

[[ $CHANGES -gt 0 ]] && hasChanged

popd
