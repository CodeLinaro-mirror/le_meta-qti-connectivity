# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries. 
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted (subject to the limitations in the
# disclaimer below) provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
#     * Neither the name of Qualcomm Innovation Center, Inc. nor the names of
#       its contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE
# GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT
# HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

ERROR_INVALID_PARAMS=300
ERROR_NO_GIT=400
ERROR_INVALID_BASE=401
ERROR_CHANGE_APPLIED=402

_LAST()
{
	echo $1 | awk -F'/' '{print $NF}'
}

# params: git_repo_path change_id
lookup_change_id()
{
	if [ $# -lt 2 ]; then
		return ${ERROR_INVALID_PARAMS}
	fi

	PATCH_FOLDER=$(_LAST "$1")
	echo -e "git path: ${PATCH_FOLDER}|"
	echo -e "changeid: $2|"

	cid=$2
	top_cid="$(git -C "$1" log -n 1 2>/dev/null | grep -m1 "Change-Id" | awk '{print $2}')"
	echo -e "top cid: ${top_cid}|"
	if [ "${top_cid}" == "${cid}" ]; then
		echo -e "Found qc patch on ${PATCH_FOLDER}"
		return 1
	else
		echo -e "Patch (Change-Id) is not on top of ${PATCH_FOLDER}"
		return 0
	fi
}


# params: git_patch change_id
get_change_id_from_patch()
{
	grep -m1 "Change-Id" "$1" | awk '{print $2}'
}


# params: folder_path patch_file [git_am_opt]
git_apply_patch()
{
	if [ $# -lt 2 ]; then
		return ${ERROR_INVALID_PARAMS}
	fi

	cd "$1" || return ${ERROR_NO_GIT}

	COMMIT_ID=$(git rev-parse --verify HEAD 2>/dev/null)
	if [ $? -ne 0 ]; then
		echo -e "Git repo not found: $1"
		cd - > /dev/null 2>&1
		return ${ERROR_NO_GIT}
	fi

	FILE="$2"
	AM_OPT="$3"

	echo -e "Apply $(_LAST "${FILE}")"
	if [ -n "${AM_OPT}" ]; then
		git am ${AM_OPT} "${FILE}" > /dev/null 2>&1
	else
		git am "${FILE}" > /dev/null 2>&1
	fi
	status=$?

	if [ ${status} -ne 0 ]; then
		git am --abort > /dev/null 2>&1
		echo -e "Patch not applied"
		echo -e "TOP commit ${COMMIT_ID}"
		if [ $# -eq 3 ]; then
			echo -e "git am option ${AM_OPT}"
		fi
		cd - > /dev/null 2>&1
		return ${status}
	fi

	echo -e "Apply patch successfully"
	cd - > /dev/null 2>&1
	return 0
}


declare -A P1
P1=(
["path"]="${WORK_SPACE}/sources/poky"
["name"]="${WORK_SPACE}/${SCRIPT_FOLDER}/files/"\
"0001-Address-do_rootfs-error-when-length-of-source-root-d.patch"
)

declare -A P2
P2=(
["path"]="${WORK_SPACE}/sources/meta-freescale"
["name"]="${WORK_SPACE}/sources/meta-qti-connectivity/recipes-kernel/"\
"linux-kernel/files/lk-6.12/"\
"4001-imx8mq-evk.conf-Restore-imx8mqevk-conf-for-3GDDR-boa.patch"
)

declare -A P3
P3=(
["path"]="${WORK_SPACE}/sources/meta-imx"
["name"]="${WORK_SPACE}/sources/meta-qti-connectivity/recipes-kernel/"\
"linux-kernel/files/lk-6.12/"\
"4002-imx8mqevk.conf-Restore-imx8mqevk-configure-for-3GDDR.patch"
)

declare -A P4
P4=(
["path"]="${WORK_SPACE}/sources/bitbake"
["name"]="${WORK_SPACE}/${SCRIPT_FOLDER}/files/"\
"0001-temporary-fix-for-crate-fetch-issue.patch"
)

# align length check with the value defined in patch file
# apply P1 patch to address KW build error when length of root folder is too
# long
LIMIT_LENGTH=150
DDIR="${WORK_SPACE}/build/tmp/deploy/deb"
PATH_LENGTH=${#DDIR}

if [ ${KERNELVERSION} == "5.10" ]; then
if [ ! ${PATH_LENGTH} -lt ${LIMIT_LENGTH} ]; then
	CHANGE_ID=$(get_change_id_from_patch ${P1["name"]})
	lookup_change_id ${P1["path"]} ${CHANGE_ID}
	if [ $? -eq 0 ]; then
		git_apply_patch ${P1["path"]} ${P1["name"]}
	fi
	echo -e "[KW] prepare done"
else
	echo -e "ROOT path length ${PATH_LENGTH} looks fine"
fi
fi

if [ ${MACHINE} == "imx8mqevk" -a ${KERNELVERSION} == "6.12" ]; then
	CHANGE_ID=$(get_change_id_from_patch ${P2["name"]})
	lookup_change_id ${P2["path"]} ${CHANGE_ID}
	if [ $? -eq 0 ]; then
		git_apply_patch ${P2["path"]} ${P2["name"]}
	fi

	CHANGE_ID=$(get_change_id_from_patch ${P3["name"]})
	lookup_change_id ${P3["path"]} ${CHANGE_ID}
	if [ $? -eq 0 ]; then
		git_apply_patch ${P3["path"]} ${P3["name"]}
	fi
else
	CHANGE_ID=$(get_change_id_from_patch ${P2["name"]})
	lookup_change_id ${P2["path"]} ${CHANGE_ID}
	if [ $? -eq 1 ]; then
		echo -e "Revoke "$(_LAST ${P2["name"]})
		cd ${P2["path"]}
		git reset --hard HEAD~1
		cd -
	fi

	CHANGE_ID=$(get_change_id_from_patch ${P3["name"]})
	lookup_change_id ${P3["path"]} ${CHANGE_ID}
	if [ $? -eq 1 ]; then
		echo -e "Revoke "$(_LAST ${P3["name"]})
		cd ${P3["path"]}
		git reset --hard HEAD~1
		cd -
	fi
fi

# Apply BitBake crate fetcher patch
if [ -f "${P4[name]}" ]; then
	CHANGE_ID=$(get_change_id_from_patch "${P4[name]}")
	lookup_change_id "${P4[path]}" "${CHANGE_ID}"
	if [ $? -eq 0 ]; then
		if git_apply_patch "${P4[path]}" "${P4[name]}"; then
			echo -e "[crate] P4 applied successfully: $(_LAST "${P4[name]}")"
		fi
	fi
else
	echo -e "[crate] Patch file not found: ${P4[name]}"
fi
