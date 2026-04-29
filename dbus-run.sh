#!/usr/bin/env bash

# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2023, 2024, 2025, 2026
#                Pellegrino Prevete
#
#    All rights reserved
#    -----------------------------------------------------
#
#    This program is free software: you can redistribute
#    it and/or modify it under the terms of the
#    GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for
#    more details.
#
#    You should have received a copy of the
#    GNU Affero General Public License
#    along with this program.
#    If not, see <https://www.gnu.org/licenses/>.


global_variables() {
  _msg=()
}
_systemctl="/usr/bin/systemctl"

_restart_if_not_running() {
  local \
    _service="${1}"
  if ! "${_systemctl}" \
	 --quiet \
         --user \
	 is-active \
	   "${_service}"; then
    "${_systemctl}" \
      --user \
      restart \
      "${_service}"
  fi
}

_usage() {
  local \
    _exit="${1}" \
    _usage_text
  IFS='' \
    read \
      -r \
      -d '' \
      _usage_text << \
        ENDUSAGETEXT || true
Run command after restarting dbus service.

Usage:
  dbus-run
    [command]

  options:
     -h                     This message.
     -c                     Enable color output
     -v                     Enable verbose output
ENDUSAGETEXT
  printf \
    '%s\n' \
    "${_usage_text}"
  exit \
    "${1}"
}

if (( "${#}"  < 1 )); then
  _usage \
    1
fi

_restart_if_not_running \
  "dbus"
"${_systemctl}" \
  --user \
  import-environment

$@
