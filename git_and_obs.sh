#!/bin/bash

export PATH=$PATH:.

LOG_DIR=/tmp/git_and_obs.$(date +%F-%H%M)
LOG_FILE=$LOG_DIR/git_and_obs.log

# NOTE: Change this variable if git2obs uses a different log path.
GIT2OBS_LOG_DIR=/tmp

# Show usage.
function show_usage {
	echo "Usage:"
	echo "$0"
	echo "  update    Update all git repos"
	echo "  commit    Commit all git snapshots to obs://Moblin:UI:Snapshot"
	echo "  all       Update & commit all git snapshots to obs://Moblin:UI:Snapshot"
	exit 1
}

# Update upstream git repos.
function update_git {
	for git_dir in $packages
	do
		# Go to the git repo dir
		pushd $git_dir > /dev/null

		# Grab from upstream
		echo "== Update $git_dir ==" | tee -a $LOG_FILE
		git pull  >> $LOG_FILE 2>&1
		git fetch >> $LOG_FILE 2>&1
		echo "" | tee -a $LOG_FILE

		# Leave the git repo dir
		popd > /dev/null 
	done
}

# Commit git repos to obs
function commit_git_to_obs {
	\rm $GIT2OBS_LOG_DIR/git2obs.* 
	for pack in $packages
	do
		# git2obs
		echo "== Commit $pack == " | tee -a $LOG_FILE
		git2obs $pack >> $LOG_FILE 2>&1
		if [ $? -ne 0 ]
		then
			FAILED_PACKAGE="$FAILED_PACKAGE $pack"
		fi
		echo "" | tee -a $LOG_FILE

		# Re-locate git2obs's log to $LOG_DIR
		mv GIT2OBS_LOG_DIR/git2obs.* $LOG_DIR/$pack.log
	done
}

# Show usage if no parameter.
[ -z $1 ] && show_usage

# Check package_list.txt
if [ ! -f package_list.txt ]
then
	echo "Please place package_list.txt in this directory."
	exit
fi
packages=$(cat package_list.txt)

# check the availability of git2obs
git2obs &> /dev/null
if [ $? -ne 1 ]
then
	echo "git2obs not found!"
	exit
fi

action=$1

mkdir -p $LOG_DIR

case $action in 
update)
	update_git
	;;
commit)
	commit_git_to_obs
	;;
all)
	update_git
	commit_git_to_obs
	;;
help)
	show_usage
	;;
*)
	show_usage
	;;
esac	

if [ -z $FAILED_PACKAGE ]
then
	echo "Failed pakcages:" >> $LOG_FILE
	echo $FAILED_PACKAGE >> $LOG_FILE
fi