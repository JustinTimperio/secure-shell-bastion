#!/usr/bin/env sh

# Bin Paths
base_path="/opt/secure-shell-bastion"
jail_build="$base_path/bin/jail_build.sh"
jail_remove="$base_path/bin/jail_remove.sh"
user_add_key="$base_path/bin/key_add.sh"
user_rm_key="$base_path/bin/key_remove.sh"
user_show_pub="$base_path/bin/show_pub.sh"
list_users="$base_path/bin/list_users.sh"

if [ "$(id -u)" -ne 0 ]; then 
  echo "Please run SSB with sudo or as root!"
  exit
fi


# Parse Args
case $1 in
    # Takes No Args
    -l|--list_users)
	echo "=========================="
	echo "Secure Shell Bastion Users"
	echo "=========================="
        . $list_users
        ;;

    # Takes User as Arg
    -n|--new_user)
        . $jail_build $2
        ;;

    # Takes User as Arg
    -r|--remove_user)
        . "$jail_remove" $2
        ;;

    # Takes User as Arg
    -ak|-add_key)
        . $user_add_key $2 
        ;;

    # Takes User as Arg
    -rk|-rm_key)
        . $user_rm_key $2 
        ;;

    # Takes User as Arg
    -sp|--show_pub)
        . $user_show_pub $2 
        ;;

    *)
        echo "usage: Secure Shell Bastion (SSB)"
        echo ""
        echo "SSB is an automated fake root jail for ssh users using Alpine Linux and MUSL"
        echo ""
        echo "-l,  --list                   List all user accounts"
        echo "-n,  --new_user               Create a new SSB user account"
        echo "-r,  --remove_user            Remove a existing SSB user account"
        echo "-ak, --add_key                Open a users authorized_keys file to add a new key"
        echo "-rk, --remove_key             Removes all authorized_keys for a user, locking the account"
        echo "-sp, --show_pub               Show the internal pubkey for a SSB user"
        echo ""
        ;;
esac
