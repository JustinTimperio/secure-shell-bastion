#!/usr/bin/env sh

# Bin Paths
base_path="/opt/secure-shell-bastion"
jail_build="$base_path/bin/jail_build.sh"
jail_remove="$base_path/bin/jail_remove.sh"
user_add_key="$base_path/bin/key_add.sh"
user_rm_key="$base_path/bin/key_remove.sh"
user_show_pub="$base_path/bin/key_list.sh"

list_users="$base_path/bin/list_users.sh"


# Parse Args
case $1 in
    # Takes User as Arg
    -n|--new_user)
        . $jail_build $2
        ;;

    # Takes User as Arg
    -r|--remove_user)
        . "$jail_remove" $2
        ;;

    # Takes No Args
    -l|--list_users)
        . $list_users
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
        echo "usage: Secure Shell Bastion (ssb)"
        echo ""
        echo ""
        ;;
esac
