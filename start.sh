#!/bin/sh
set -e

INPUT_TARGET_BRANCH=${INPUT_TARGET_BRANCH:-master}
INPUT_UPSTREAM_BRANCH=${INPUT_UPSTREAM_BRANCH:-master}
TARGET_REPOSITORY=${INPUT_TARGET_REPOSITORY:-$GITHUB_REPOSITORY}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
_FORCE_OPTION=''

echo "Synchronizing repostiory ${TARGET_REPOSITORY}:${INPUT_TARGET_BRANCH} with ${INPUT_UPSTREAM_REPOSITORY}:${INPUT_UPSTREAM_BRANCH}";

[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".' 1>&2;
    exit 1;
};

[ -z "${INPUT_UPSTREAM_REPOSITORY}" ] && {
    echo 'Missing input "upstream_repository' 1>&2;
    echo '  e.g. "upstream_repository: TobKed/github-forks-sync-action".' 1>&2;
    exit 1;
};

#if ${INPUT_FORCE}; then
#    _FORCE_OPTION='--force'
#fi

if ${INPUT_TAGS}; then
    _TAGS='--tags'
fi

upstream_repo="https://github.com/${INPUT_UPSTREAM_REPOSITORY}.git"
#upstream_dir=${INPUT_UPSTREAM_REPOSITORY##*/}
target_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${TARGET_REPOSITORY}.git"
target_dir=${TARGET_REPOSITORY##*/}

git config --global user.email "tobked@git.io"
git config --global user.name "${GITHUB_ACTOR}"

git clone ${target_repo}
cd ${target_dir}
git remote add upstream ${upstream_repo}
git pull upstream ${INPUT_UPSTREAM_BRANCH}
git push
