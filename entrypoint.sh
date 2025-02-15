#!/bin/sh -l

git clone --quiet https://github.com/$REPO &> /dev/null

git config --global --add safe.directory /github/workspace

tag=$(git tag --sort version:refname | tail -n 2 | head -n 1)
tags=$(git tag --sort version:refname | tail -n 6)

if [ "$tag" ]; then
  echo "Tags list is ${tags}"
  echo "Previous tag is ${tag}"
  changelog=$(git log --pretty=format:":white_check_mark: %C(yellow)%h%Creset %ad [%an]:\n%B" --date=short $tag..HEAD)
  slackchangelog=$(git log --pretty=format:":white_check_mark: %ad [%an]:\n%B" --date=short $tag..HEAD)
else
  echo "Previous tag is empty"
  changelog=$(git log --pretty=format:":white_check_mark: %C(yellow)%h%Creset %ad [%an]:\n%B" --date=short)
  slackchangelog=$(git log --pretty=format:":white_check_mark: %ad [%an]:\n%B" --date=short)
fi

echo "Changelog is ### ${changelog}"

changelog="${changelog//'%'/'%25'}"
changelog="${changelog//$'\n'/'%0A'}"
changelog=" - ${changelog//$'\r'/'%0D'}"

slackchangelog="${slackchangelog//'%'/'%25'}"
slackchangelog="${slackchangelog//$'\n'/'%0A'}"
slackchangelog=" - ${slackchangelog//$'\r'/'%0D'}"

echo "::set-output name=changelog::$changelog"
echo "::set-output name=slackchangelog::$slackchangelog"
# echo "changelog=$changelog" >> $GITHUB_OUTPUT
# echo "slackchangelog=$slackchangelog" >> $GITHUB_OUTPUT
