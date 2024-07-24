#!/usr/bin/zsh
# Wrapper for common fastboot flash commands

# Example usage (as an alias)
# Assumes the device is running Android, syncs kernel modules (and whatever else)
# and then reboots and flashes the kernel
# $ alias aflashboot="adb remount && adb sync; aflash.sh -t -b"
#
# Flashes everything, from bootloader
# $ alias aflashall="aflash.sh -t -s -v -b"

usage() {
        echo "Usage: $0 [OPTION]..."
        echo "  -p, --path            path to outdir, default is \"$OUT\""
        echo "  -f, --format          format userdata"
        echo "  -h, --help            display this help and exit"
        echo "  -s, --system          flash Android system partition"
        echo "  -b, --boot            flash boot partition"
        echo "  -m  --vendor_boot     flash vendor boot partition"
        echo "  -v, --vendor          flash vendor partition"
        echo "  -u, --super           flash super partition"
        echo "  -n, --no-reboot       do not reboot after flashing"
        echo "  -t, --to-bootloader   reboot device to bootloader"
}

# Get target state
# Possible return values:
# 'booted'
# 'bootloader'
# 'adb' (booted into Android)
# 'nc' (not connected)
at-state() {
	if (ip a | grep -q 172.16.42.2); then
		echo "booted"
		return
	elif [ "$(fastboot devices | wc -l)" -gt 0 ]; then
		echo "bootloader"
		return
	elif [ "$(adb devices | wc -l)" -gt 2 ]; then
		echo "adb"
		return
	fi
	echo 'nc'
}


# Put the device in bootloader mode
# returns when the device is in bootlaoder
# mode
at-to_bootloader() {
	state="$(at-state)"
	while [ "$state" = "nc" ]; do
		sleep 0.2
		state="$(at-state)"
	done
	echo "Device in state: $state"
	slot=""
	if [ "$state" = "booted" ]; then
		echo "Device is booted into Linux, please reboot manually"
	elif [ "$state" = "adb" ]; then
		adb reboot bootloader
	fi
}

while getopts ":p:fhstbmvun" opt; do
        case $opt in
                p)
                        images_path=$OPTARG
                        ;;
                f)
                        format=true
                        ;;
                h)
                        usage
                        exit 0
                        ;;
                s)
                        system=true
                        ;;
                b)
                        boot=true
                        ;;
                m)
                        vendor_boot=true
                        ;;
                v)
                        vendor=true
                        ;;
                u)
                        super=true
                        ;;
                n)
                        no_reboot=true
                        ;;
                t)
                        to_bootloader=true
                        ;;
                \?)
                        echo "Invalid option: -$OPTARG" >&2
                        usage
                        exit 1
                        ;;
                :)
                        echo "Option -$OPTARG requires an argument." >&2
                        usage
                        exit 1
                        ;;
        esac
done

cmd="fastboot"

if [ -z "$cmd" ]; then
        echo "fastboot not found"
        exit 1
fi

if [ -z "$images_path" ]; then
        images_path=$OUT
fi

if [ -z "$images_page" ]; then
        images_page="$PWD"
fi

if [ ! -d "$images_path" ]; then
        echo "Error: $images_path is not a directory"
        exit 1
fi

if [ -z "$system" ]; then
        system=false
elif [ ! -f "$images_path/system.img" ]; then
        echo "Error: $images_path/system.img does not exist"
        exit 1
else
        cmd="$cmd flash system $images_path/system.img"
fi

if [ -z "$vendor" ]; then
        vendor=false
elif [ ! -f "$images_path/vendor.img" ]; then
        echo "Error: $images_path/vendor.img does not exist"
        exit 1
else
        cmd="$cmd flash vendor $images_path/vendor.img"
fi

if [ -z "$super" ]; then
        super=false
elif [ ! -f "$images_path/super.img" ]; then
        echo "Error: $images_path/super.img does not exist"
        exit 1
else
        cmd="$cmd flash super $images_path/super.img"
fi

if [ -z "$boot" ]; then
        boot=false
elif [ ! -f "$images_path/boot.img" ]; then
        echo "Error: $images_path/boot.img does not exist"
        exit 1
else
        cmd="$cmd flash boot $images_path/boot.img"
fi

if [ -z "$vendor_boot" ]; then
        vendor_boot=false
elif [ ! -f "$images_path/vendor_boot.img" ]; then
        echo "Error: $images_path/vendor_boot.img does not exist"
        exit 1
else
        cmd="$cmd flash vendor_boot $images_path/vendor_boot.img"
fi

if [ -n "$format" ]; then
        cmd="$cmd format userdata"
fi

# This HAS to be the last thing
if [ -z "$no_reboot" ]; then
        cmd="$cmd reboot"
fi

if [ -n "$to_bootloader" ]; then
        echo "rebooting to bootloader"
        at-to_bootloader
fi

pushd $images_path > /dev/null
echo "$ $cmd"
eval $cmd
popd > /dev/null
