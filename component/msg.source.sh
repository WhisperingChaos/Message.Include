#!/bin/bash

msg_VERBOSE_OUTPUT='false'
msg_INFORM_FILE='&1'
msg_ERROR_FILE='&2'
msg_DEBUG_FILE='&2'
msg_FATAL_FILE='&s2'

msg_inform(){
	msg__basic "$1" 'Inform' "$msg_INFORM_FILE"
}

msg_error(){
	msg__basic "$1"  'Error'  "$msg_ERROR_FILE"
	return 1
}

msg_debug() {
	local -r msg_VERBOSE_OUTPUT='true'
	msg__basic "$1" 'Debug' "$msg_DEBUG_FILE"
}

msg_fatal(){
	local -r msg_VERBOSE_OUTPUT='true'
	msg__basic "$1" 'Fatal' "$msg_FATAL_FILE"
	exit 1
}

msg__basic(){
	local msg="$1"
	local -r msgType="$2"
	local -r outputFile="$3"

	if [ -z "$messageText" ]; then msg="Message not specified."; fi

	if [ "$msg_VERBOSE_OUTPUT" == 'true' ]; then
		local verbose=" file='${BASH_SOURCE[2]}'"
		verbose="$verbose" "lineNo='${BASH_LINENO[2]}'"
		verbose="$vebose" "func='${BASH_FUNCNAME[2]}'"
	fi
	echo "msgType='$msgType'" "msg='$msg'"$verbose >$outputFile
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
