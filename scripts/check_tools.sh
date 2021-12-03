#!/bin/bash
set -e
echo ""
echo "Checking local tools..."
warnings=0
problems=0

check_tool(){
    tool_name=$1
    tool_cmd=$2
    version_cmd=$3
    recommended_version=$4

    echo ""
    echo "${tool_name}..."
    if hash ${tool_cmd} 2>/dev/null; then
            actual_version=$(${version_cmd})
        echo "    Version: ${actual_version}"
        if [[ ! "${actual_version}" == *"${recommended_version}"* ]]; then
            echo "        * WARNING: Version does not contain: ${recommended_version}"
            warnings=$((warnings+1))
        fi
    else
        echo "    * PROBLEM: '${tool_cmd}' command not found!"
        problems=$((problems+1))
    fi
}


check_tool "Docker" "docker" "docker --version" "version 20.10"
check_tool "Docker-Compose" "docker-compose" "docker-compose --version" "version v2.1.1"
check_tool "Git" "git" "git --version" "version 2.33"
check_tool "Code (Visual Studio Code)" "code" "code --version" "1.62"

echo ""
echo ""
echo "Done checking local tools:"
if [ ${warnings} -eq 1 ]; then
    echo "    Found: 1 Warning"
elif [ ${warnings} -gt 0 ]; then
    echo "    Found: ${warnings} Warnings"
else
    echo "    No Warnings"
fi
if [ ${problems} -gt 0 ]; then
    echo "    Found: ${problems} Problem(s)"
    echo ""
    echo "PLEASE: Fix these before moving on!"
else
    echo "    No Problems"
fi
echo ""
echo ""
echo "Done ($0)."
