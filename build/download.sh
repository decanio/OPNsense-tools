#!/bin/sh

# Copyright (c) 2018 Franco Fichtner <franco@opnsense.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

set -e

SELF=download

. ./common.sh

if [ -z "${1}" ]; then
	echo ">> Missing download target"
	exit 1
fi

SSHTARGET=${1}

# remove first argument
shift

download()
{
	echo ">>> Downloading ${1}..."
	scp ${SSHTARGET}:"${2}/${3}" ${2}
}

for ARG in ${@}; do
	case ${ARG} in
	arm|dvd|nano|serial|vga|vm)
		sh ./clean.sh ${ARG}
		download ${ARG} ${IMAGESDIR} "${ARG}-*-${PRODUCT_FLAVOUR}-*"
		;;
	base|kernel)
		sh ./clean.sh ${ARG}
		download ${ARG} ${SETSDIR} "${ARG}-*"
		;;
	logs)
		sh ./clean.sh ${ARG}
		download ${ARG} ${LOGSDIR} "[0-9]*.tgz"
		;;
	packages|release)
		sh ./clean.sh ${ARG}
		download ${ARG} ${SETSDIR} "${ARG}-*-${PRODUCT_FLAVOUR}-*"
		;;
	esac
done
