# $FreeBSD$
#
# .cshrc - csh resource script, read at beginning of execution by each shell
#
# see also csh(1), environ(7).
# more examples available at /usr/share/examples/csh/
#

alias h		history 25
alias j		jobs -l
alias la	ls -aF
alias lf	ls -FA
alias ll	ls -lAF

# read(2) of directories may not be desirable by default, as this will provoke
# EISDIR errors from each directory encountered.
# alias grep	grep -d skip

# A righteous umask
umask 22

set path = ($HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin)

setenv	EDITOR	vi
setenv	PAGER	less

setenv	LANG en_US.UTF-8
setenv	LC_CTYPE C.UTF-8
setenv	LC_COLLATE C.UTF-8
setenv	LC_TIME C.UTF-8
setenv	LC_NUMERIC C.UTF-8
setenv	LC_MONETARY C.UTF-8
setenv	LC_MESSAGES C.UTF-8

if ($?prompt) then
	# An interactive shell -- set some stuff up
	set prompt="%{\033[1;32m%}%m: %{\033[1;32m%}%.%{\033[0m%}%# "
	set promptchars = "%#"
	set filec
	set autolist
	set history = 100
	set savehist = 100
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up     history-search-backward
		bindkey -k down   history-search-forward
		bindkey "\e[1~"   beginning-of-line       # Home
		bindkey "\e[2~"   overwrite-mode          # Insert
		bindkey "\e[3~"   delete-char             # Delete
		bindkey "\e[4~"   end-of-line             # End
		bindkey "\e[5~"   history-search-backward # Page Up
		bindkey "\e[6~"   history-search-forward  # Page Down
		bindkey "\eOc"    forward-word            # ctrl right
		bindkey "\e[1;5C" forward-word            # ctrl right
		bindkey "\eOd"    backward-word           # ctrl left
		bindkey "\e[1;5D" backward-word           # ctrl left
	endif
endif

#if ( "ttyv0" == "$tty" || "ttyu0" == "$tty" || "xc0" == "$tty" ) then
if (! $?MYB_SUBSHELL ) then
	setenv MYB_SUBSHELL 1
	/etc/rc.initial
endif
#endif
