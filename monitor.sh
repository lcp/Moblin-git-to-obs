list="mutter-moblin moblin-web-browser"
site="https://api.opensuse.org"
repo="home:gary_lin:branches:Moblin:UI"

clear
while [ "$list" != "" ]
do
	for package in $list 
	do
		echo "==== $package ===="
		output=`osc -A $site r $repo $package -a i586`
		echo "$output"
		echo ""

		result=`echo $output | awk '{print $3}'`
		if [ "$result" == "succeeded" ]
		then
			notify-send "$package built successfully"
			list=`echo "$list" | sed "s/$package//"`

			#remove leading and trailing spaces
			list=`echo $list|sed "s/^ *//" |sed "s/ *$//"`
		else if [ "$result" == "failed:" ]
		then
			notify-send "$package failed"
		fi
		fi
	done
	sleep 10
	clear
done
