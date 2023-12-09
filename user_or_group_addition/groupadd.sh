if [ '$#' -eq 0]; then 
	echo "There are no arguments!"
	exit 1
fi

for arg in '$@'; do
	sudo groupadd '@arg'
	echo "Group @arg has been added!"
done
