if [ "$#" -eq 0]; then 
	echo "There are no arguments!"
	exit 1
fi

for arg in "$@"; do
	sudo useradd "$arg"
	echo "User $arg has been added"
done
