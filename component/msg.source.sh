#!/bin/bash
###############################################################################
#
#	Purpose:
#		Provide consistent logging interface & behavior.
#
#	Notes:
#		>	Important conventions when modifying this file:
#			https://github.com/WhisperingChaos/SOLID_Bash/blob/master/README.md#source-file-conventions
#
###############################################################################

msg_VERBOSE_OUTPUT='false'; 	# X-cutting concern - msg_inform and _error don't include call stack info with message text - the others do. 
msg_INFORM_FILE='&1';			# X-cutting concern - define default to appropriate STD??? handle.  Can also redirect to file. Ex: '>/var/log/logging' which will append messages to logging file.
msg_ERROR_FILE='&2'
msg_DEBUG_FILE='&2'
msg_FATAL_FILE='&2'

msg_inform(){
	local -ri rtnCd=$?
	local -r msg="$1"

	msg__basic "$msg" 'Inform' "$msg_INFORM_FILE" '1'

	return $rtnCd
}

msg_error(){
	local -i rtnCd=$?
	local -r msg="$1"

	if [ $rtnCd -eq 0 ]; then rtnCd=1; fi
	local -r rtnCd	

	msg__basic "$msg"  'Error'  "$msg_ERROR_FILE" '1'

	return $rtnCd
}

msg_debug() {
	local -i rtnCd=$?
	local -r msg="$1"
	local -ir rtnCdArg=$2

	msg__rtncd_error_chooser "$rtnCdArg" "$rtnCd"
	local -r rtnCd=$?

	local -r msg_VERBOSE_OUTPUT='true'
	msg__basic "$msg" 'Debug' "$msg_DEBUG_FILE" '1'
	
	return $rtnCd
}

msg_fatal(){
	local -i rtnCd=$?
	local -r msg="$1"
	local -ir rtnCdArg=$2

	msg__rtncd_error_chooser "$rtnCdArg" "$rtnCd"
	local -r rtnCd=$?	

	local -r msg_VERBOSE_OUTPUT='true'
	local -i clvl=1

	msg__basic "$msg" 'Fatal' "$msg_FATAL_FILE" $clvl
	# print call frames for functions above the one that called fatal
	# This if frame 0 then frame 1 issued call. Report on remaining
	# call stack: frame 2,3,4,...,n
	local   pasCallFrame
	local -ri maxCallDepth=${#BASH_LINENO[@]}-1
	for (( clvl; clvl < maxCallDepth; clvl++ )) {
		if [ -z "${FUNCNAME[$clvl]}" ]; then break; fi
		msg__call_frame "$clvl" 'pasCallFrame'
		#eval echo \" +\ Caller\:\$pasCallFrame\" \>$msg_FATAL_FILE
		eval echo \"\ \+\ \ Caller\:\$pasCallFrame\" \>$msg_FATAL_FILE

	}
	exit $rtnCd
}

msg__rtncd_error_chooser(){
	local -ir asArg=$1
	local -ir callers=$2

	# prededence: argument from caller, caller's environment then 1
	if [ -n "$asArg" ]   && [ $asArg -ne 0 ];  then return $asArg;   fi
	if [ -n "$callers" ] && [ $callers -ne 0 ]; then return $callers; fi
	return 1
}

msg__basic(){
	local msg="$1"
	local -r msgType="$2"
	local -r outputFile="$3"
	local -ri msgCallerFrame="$4"

	if [ -z "$msg" ]; then msg="Message not specified."; fi

	local pasVerbose
	if [ "$msg_VERBOSE_OUTPUT" == 'true' ]; then
		msg__call_frame "$msgCallerFrame" 'pasVerbose'
	fi
	local -r msgQuotEscape="${msg/\'/\'\\\'\'}"	
	eval echo \"msgType=\'\$msgType\'\" \"msg\=\'\$msgQuotEscape\'\"\$pasVerbose \>$outputFile
}

msg__call_frame(){
	local -ri callLvl=$1
	local -r rtnCallFrame="$2"

	local  callFrame=" file='${BASH_SOURCE[$callLvl+2]}'"
	callFrame="$callFrame lineNo=${BASH_LINENO[$callLvl+1]}"
	callFrame="$callFrame func='${FUNCNAME[$callLvl+2]}'"
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
