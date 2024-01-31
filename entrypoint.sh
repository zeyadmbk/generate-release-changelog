#!/bin/sh -l

echo "Repo is ${REPO}"

git clone --quiet https://github.com/$REPO

git config --global --add safe.directory /github/workspace

tags=$(git tag --sort version:refname)

echo "Tags list is ${tags}"

tag=$(git tag --sort version:refname | tail -n 2 | head -n 1)

if [ "$tag" ]; then
  echo "Previous tag is ${tag}"
  changelog=$(git log --pretty=format:"%C(yellow)%h%Creset %ad [%an]  %s" --date=short $tag..HEAD)
else
  echo "Previous tag is empty"
  changelog=$(git log --pretty=format:"%C(yellow)%h%Creset %ad [%an]  %s" --date=short)
fi

echo "Changelog is ### ${changelog}"

changelog="${changelog//'%'/'%25'}"
changelog="${changelog//$'\n'/'%0A' - }"
changelog=" - ${changelog//$'\r'/'%0D'}"

echo "::set-output name=changelog::$changelog"
