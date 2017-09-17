#!/usr/bin/env bash
#
# The functions within this script will tag the repository.
#
set -o nounset
set -o errexit -o errtrace

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

function push_tag
{
  git push origin --tags
  success "Successfully pushed the new tag: ${current_version}"
}

function get_current_version
{
  current_version="v$(node -p -e "require('${SCRIPT_DIR}/../package.json').version")"
  info "Project Version: ${current_version}";
}

function remove_existing_tag
{
  result=$(git tag --delete "${current_version}")
  warning "${current_version} removed"
}

function add_tag
{
  info "Setting new tag: ${current_version}"
  $(git tag "${current_version}")
  success "Successfully set the new tag: ${current_version}"
}

function set_tag
{
 if [[ `git tag -l $current_version` == $current_version ]]; then
    warning "Version, ${current_version}, already exists, deleting ${current_version}"
    remove_existing_tag
    add_tag
  else
    add_tag
  fi
}

get_current_version
set_tag
push_tag
