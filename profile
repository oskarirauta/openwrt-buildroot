# Append "$1" to $PATH when not already in.
# Copied from Arch Linux, see #12803 for details.
append_path () {
	case ":$PATH:" in
		*:"$1":*)
			;;
		*)
			PATH="${PATH:+$PATH:}$1"
			;;
	esac
}

append_path "/usr/local/sbin"
append_path "/usr/local/bin"
append_path "/usr/sbin"
append_path "/usr/bin"
append_path "/sbin"
append_path "/bin"
unset -f append_path

export PATH
export PAGER=less
umask 022

# use nicer PS1 for bash and busybox ash
if [ -n "$BASH_VERSION" -o "$BB_ASH_VERSION" ]; then
	PS1='\h:\w\$ '
# use nicer PS1 for zsh
elif [ -n "$ZSH_VERSION" ]; then
	PS1='%m:%~%# '
# set up fallback default PS1
else
	: "${HOSTNAME:=$(hostname)}"
	PS1='${HOSTNAME%%.*}:$PWD'
	[ "$(id -u)" -eq 0 ] && PS1="${PS1}# " || PS1="${PS1}\$ "
fi

for script in /etc/profile.d/*.sh ; do
	if [ -r "$script" ] ; then
		. "$script"
	fi
done
unset script

pkgcount() {
	sz=$(du -c -h -a /usr/src/openwrt/bin | tail -1)
	pkgs=$(find /usr/src/openwrt/bin -type f -name "*.ipk"| wc -l)
	cnt=$(find /usr/src/openwrt/bin -type f | wc -l)
	echo $sz
	echo "$pkgs packages / $cnt files"
}

export SHELL=/bin/bash
export PS1='[$(whoami)@$(hostname) $PWD]\$ '
export EDITOR='/usr/bin/nano'
alias ls='ls --color'
