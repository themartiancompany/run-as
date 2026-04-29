# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
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


PREFIX ?= /usr/local
_PROJECT=run-as
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
LIB_DIR=$(DESTDIR)$(PREFIX)/lib

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_DIR=\
  install \
    -vdm755
_INSTALL_EXE=\
  install \
    -vDm755

DOC_FILES=\
  $(wildcard \
      *.rst) \
  $(wildcard \
      *.md)

_BASH_FILES=\
  enable-graphical-services.sh
_PYTHON_FILES=\
  $(_PROJECT).py

_CHECK_TARGETS=\
  shellcheck
_CHECK_TARGETS_ALL=\
  check \
  $(_CHECK_TARGETS)
_INSTALL_SCRIPTS_TARGETS=\
  install-bash-scripts \
  install-python-scripts
INSTALL_DOC_TARGETS=\
  install-doc \
  install-man
_INSTALL_TARGETS=\
  install-scripts \
  $(_INSTALL_DOC_TARGETS)
_INSTALL_TARGETS_ALL=\
  install \
  $(_INSTALL_TARGETS) \
  $(_INSTALL_SCRIPTS_TARGETS)

_PHONY_TARGETS=\
  $(_CHECK_TARGETS_ALL) \
  $(_INSTALL_TARGETS_ALL)
  
all:

check: shellcheck

shellcheck:

	shellcheck \
	  -s \
	    "bash" \
	  $(_BASH_FILES)

install: $(_INSTALL_TARGETS)

install-scripts: $(_INSTALL_SCRIPTS_TARGETS)

install-bash-scripts:

	for _file in $(_BASH_FILES); do \
	  $(_INSTALL_EXE) \
	    "$(_PROJECT)/$${_file}" \
	    "$(LIB_DIR)/$(_PROJECT)/$${_file}"; \
	done

install-python-scripts:

	for _file in $(_PYTHON_FILES); do \
	  $(_INSTALL_EXE) \
	    "$(_PROJECT)/$${_file}" \
	    "$(LIB_DIR)/$(_PROJECT)/$${_file}"; \
	done
	ln \
	  -s \
	  "$(PREFIX)/lib/$(_PROJECT)/$(_PROJECT).py" \
	  "$(BIN_DIR)/$(_PROJECT)"

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  "$(DOC_DIR)/"

install-man:

	$(_INSTALL_DIR) \
	  "$(MAN_DIR)/man1"
	rst2man \
	  "man/evm-contract-bytecode-get.1.rst" \
	  "$(MAN_DIR)/man1/evm-contract-bytecode-get.1"
	rst2man \
	  "man/evm-contract-call.1.rst" \
	  "$(MAN_DIR)/man1/evm-contract-call.1"
	rst2man \
	  "man/evm-contract-deployer-get.1.rst" \
	  "$(MAN_DIR)/man1/evm-contract-deployer-get.1"

.PHONY: $(_PHONY_TARGETS)
