#!/bin/bash

latest_tags ()  {
    echo "Latest tags!"
    git describe --tags `git rev-list --tags --max-count=3`

    echo "Status"
    git status -uno
}

release () {

    echo "=> creating release $1"

    # Tag the current branch
    echo "Create first tag"
    git tag -a $1 -m "Release: $1"

    # Create changlog
    npx auto-changelog --commit-limit false --unreleased

    # Add the change log file:
    git add CHANGELOG.md

    # Commit changelog
    git commit -m "Release: $1"

    # push the changelog file.
    git push origin master

    # Delete tag
    git tag -d $1

    # Recreate tag
    git tag -a $1 -m "Release: $1"

    # push the tag
    git push origin $1

    # push to branch the CHANGELOG.md
    git push origin $2
}


dir=$(pwd)

echo "Working directory $dir"

latest_tags

echo "Type the relese number (eg: v2.0.1)"

read rel

if [ -z "$rel" ]
then
    echo "$rel is not a valid release!!"
    exit -1
fi

branch=$(git rev-parse --abbrev-ref HEAD)

if [ $branch != "master" ]
then
    echo "Warning !!! you are not in master branch."
    echo "Current branch $branch"
else
    echo "Did you run: >> git pull origin master? "
fi

echo "Proceed to create release $rel?"

echo "Continue Yes(y) or No(n)"

read accept

if [ $accept != "y" ]
then
    exit 0
fi



release $rel $branch
