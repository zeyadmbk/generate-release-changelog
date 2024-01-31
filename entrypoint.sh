#!/bin/sh -l

git clone --quiet https://github.com/$REPO &> /dev/null

git config --global --add safe.directory /github/workspace

tag=$(git tag --sort version:refname | tail -n 2 | head -n 1)

if [ "$tag" ]; then
  echo "Previous tag is ${tag}"
  changelog=$(git log --pretty=format:"%C(yellow)%h%Creset %ad [%an]  %s" --date=short $tag..HEAD)
  slackchangelog=$(git log --pretty=format:"%ad [%an]  %s" --date=short $tag..HEAD)
else
  echo "Previous tag is empty"
  changelog=$(git log --pretty=format:"%C(yellow)%h%Creset %ad [%an]  %s" --date=short)
  slackchangelog=$(git log --pretty=format:"%ad [%an]  %s" --date=short)
fi

echo "Changelog is ### ${changelog}"

changelog="${changelog//'%'/'%25'}"
changelog="${changelog//$'\n'/'%0A' - }"
changelog=" - ${changelog//$'\r'/'%0D'}"

slackchangelog="${slackchangelog//'%'/'%25'}"
slackchangelog="${slackchangelog//$'\n'/'%0A' - }"
slackchangelog=" - ${slackchangelog//$'\r'/'%0D'}"

# echo "::set-output name=changelog::$changelog"
echo "changelog=$slackchangelog" >> $GITHUB_OUTPUT
echo "slackchangelog=$slackchangelog" >> $GITHUB_OUTPUT
