#!/bin/bash

msg_VERBOSE_OUTPUT='false'
msg_INFORM_FILE='&1'
msg_ERROR_FILE='&2'
msg_DEBUG_FILE='&2'
msg_FATAL_FILE='&s2'

msg_inform(){
	msg__basic "$1" 'Inform' "$msg_INFORM_FILE" '2'
}

msg_error(){
	msg__basic "$1"  'Error'  "$msg_ERROR_FILE" '2'
	return 1
}

msg_debug() {

	local -r msg_VERBOSE_OUTPUT='true'
	msg__basic "$1" 'Debug' "$msg_DEBUG_FILE" '2'
}

msg_fatal(){
	
	local -r msg_VERBOSE_OUTPUT='true'
	local -i clvl=2

	msg__basic "$1" 'Fatal' "$msg_FATAL_FILE" $clvl
	# print call frames for functions above the one that called fatal
	# This if frame 0 then frame 1 issued call. Report on remaining
	# call stack: frame 2,3,4,...,n
	local   pasCallFrame
	for (( clvl; true; clvl++)) {
		if [ -z "${FUNCNAME[$clvl]}" ]; then break; fi
		msg__call_frame "$clvl" 'pasCallFrame'
		eval echo \"Caller\:\ \$pasCallFrame\" \>$msg_FATAL_FILE
	}
	exit 1
}

msg__basic(){
	local msg="$1"
	local -r msgType="$2"
	local -r outputFile="$3"
	local -ri msgCallerFrame="$4"

	if [ -z "$msg" ]; then msg="Message not specified."; fi

	local verbose
	if [ "$msg_VERBOSE_OUTPUT" == 'true' ]; then
		msg__call_frame "$msgCallerFrame" 'verbose'
	fi
	eval echo \"msgType=\'\$msgType\'\" \"msg\=\'\$msg\'\"\$verbose \>$outputFile
}

msg__call_frame(){
	local -ri callLvl=$1
	local -r rtnCallFrame="$2"

	local  callFrame=" file='${BASH_SOURCE[$callLvl+1]}'"
	callFrame="$callFrame lineNo='${BASH_LINENO[$callLvl+1]}'"
	callFrame="$callFrame func='${FUNCNAME[$callLvl+1]}'"
	eval $rtnCallFrame\=\"\$callFrame\"
}
###############################################################################
# 
# The MIT License (MIT)
# Copyright (c) 2018 Richard Moyse License@Moyse.US
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
###############################################################################
