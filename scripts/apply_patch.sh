# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
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
#     * Neither the name of Qualcomm Innovation Center, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
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

# params: git_repo_path change_id
lookup_change_id()
{
        if [ $# -lt 2 ]; then
                return ${ERROR_INVALID_PARAMS}
        fi

	if [ $# -eq 3 ]; then
		depth="-n $3"
	fi
	FOUND=$(git -C $1 log ${depth} | grep "$2")
	if [ -z "${FOUND}" ]; then
		return 0
	else
		return 1
	fi
}

# params: git_patch change_id
get_change_id_from_patch()
{
	echo "$(cat $1 | grep "Change-Id"|awk '{print $2}')"
}

# params: folder_path patch_name, base_commit_id
git_apply_patch()
{
        if [ $# -lt 2 ]; then
                return ${ERROR_INVALID_PARAMS}
        fi

        cd $1
        COMMIT_ID=$(git rev-parse --verify HEAD)
        if [ ! $? -eq 0 ]; then
                echo -e "git repo is not found"
                cd -
                return ${ERROR_NO_GIT}
        fi

        FILE=$2
        echo -e "Apply ${FILE}"
        git am ${FILE}  > /dev/null 2>&1
        if [ ! $? -eq 0 ]; then
                git am --abort
                echo -e "Patch not applied"
                echo -e "Poky TOP commit "${COMMIT_ID}
		if [ $# -eq 3 ]; then
	                echo -e "Expected Top commit "$3
		fi
        else
                echo -e "Apply patch successfully"
        fi
        cd -
}

declare -A P1
P1=( ["path"]="${WORK_SPACE}/sources/poky"
     ["name"]="${WORK_SPACE}/${SCRIPT_FOLDER}/files/0001-Address-do_rootfs-error-when-length-of-source-root-d.patch"
     ["base"]="269265c00091fa65f93de6cad32bf24f1e7f72a3" )

# align length check with the valie defined in patch file
# apply P1 patch to address KW build error when length of root folder is too long
LIMIT_LENGTH=150
DDIR="${WORK_SPACE}/build/tmp/deploy/deb"
PATH_LENGTH=${#DDIR}

if [ ! ${PATH_LENGTH} -lt ${LIMIT_LENGTH} ]; then
        CHANGE_ID=$(get_change_id_from_patch ${P1["name"]})
        lookup_change_id ${P1["path"]} ${CHANGE_ID} 1
        if [ $? -eq 0 ]; then
                git_apply_patch ${P1["path"]} ${P1["name"]} ${P1["base"]}
        fi
else
        echo -e "ROOT path length ${PATH_LENGTH} looks fine"
fi
