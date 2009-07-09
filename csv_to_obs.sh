#!/bin/bash
usage(){
	echo "$0 <CSV_FILE>"
	exit 1
}

# Define Variables
INPUT=$1
LOG_DIR=/tmp/csv_obs/csv_to_obs.$(date +%F-%H%M)
LOG_FILE=$LOG_DIR/csv_to_obs.log

# NOTE: Change this variable if git2obs uses a different log path.
GIT2OBS="git2obs-branch"
GIT2OBS_LOG_DIR=/tmp
OBS_CO_DIR="/tmp/home:gary_lin:branches:Moblin:UI"

run(){
	local command=$1
        $command > /dev/null 2>&1
}

run_log ()
{
        local command=$1

        echo "\$ $command" >> $LOG_FILE
        $command >> $LOG_FILE 2>&1
}

checkout_and_commit(){
	package=$1
	version=$2

	echo "=== $package ===" | tee -a $LOG_FILE

	# Checkout the source
	run "pushd $package"
	run_log "git checkout master"
	run_log "git pull"
	run_log "git checkout $version"
	run "popd"

	# Commit to OBS
	$GIT2OBS $package >> $LOG_FILE 2>&1
	if [ $? -ne 0 ]
	then
		FAILED_PACKAGE="$FAILED_PACKAGE $package"
	fi

	# Restore the source and leave
	run "pushd $package"
	run_log "git checkout master"
	run "popd"

	echo "" | tee -a $LOG_FILE

	# Re-locate git2obs's log to $LOG_DIR
	mv $GIT2OBS_LOG_DIR/git2obs.* $LOG_DIR/$package.log
}


[ -z "$1" ] && usage

# check the availability of git2obs
$GIT2OBS > /dev/null 2>&1 
if [ $? -ne 1 ]
then
	echo "$GIT2OBS not found!"
	exit 1
fi

# Preparation
mkdir -p $LOG_DIR
run "pushd $OBS_CO_DIR && rm -rf *"
run "popd"

LIST=`cat $INPUT | tr -d '\r'`
FAILED_PACKAGE=

for item in $LIST
do
	param=`echo $item |sed s/\;/\ /`
	checkout_and_commit $param
done

# Print failed packages
# TODO Send a e-mail if there is any failed package.
if [ ! -z "$FAILED_PACKAGE" ]
then
	echo "Failed pakcages:" >> $LOG_FILE
	echo $FAILED_PACKAGE >> $LOG_FILE
fi
