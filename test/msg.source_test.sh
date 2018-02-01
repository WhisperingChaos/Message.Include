#!/bin/bash
config_executeable(){
	local -r myRoot="$1"
	# include components required to create this executable
	local mod
	for mod in $( "$myRoot/sourcer/sourcer.sh" "$myRoot"); do
		source "$mod"
	done
}


test_msg__basic(){
	assert_true "msg__basic '' 'basic' '&1' '1' | assert_output_true test_msg__basic_no_message"
	assert_true "msg__basic 'basic' 'basic' '&1' '1' | assert_output_true test_msg__basic_message"
	local msg_VERBOSE_OUTPUT='true'
	assert_true "msg__basic 'basic' 'basic' '&1' '1' | assert_output_true test_msg__verbose_message"

}
test_msg__basic_no_message(){
	echo "msgType='basic' msg='Message not specified.'"
}
test_msg__basic_message(){
	echo "msgType='basic' msg='basic'"
}
test_msg__verbose_message(){
	echo "${assert_REGEX_COMPARE}msgType='basic' msg='basic' file='./base/assert.source.sh' lineNo=[0-9]+ func='assert_true'"
}


test_msg_inform(){
	assert_true 'msg_inform "inform" | assert_output_true test_msg_inform_inform'
	test_error_code_set 127
	msg_inform "inform" >/dev/null
	assert_true "[ $? == 127 ]"
}
test_msg_inform_inform(){
	echo "msgType='Inform' msg='inform'"
}


test_msg_error(){
	assert_true 'msg_error "error" 2>&1 | assert_output_true test_msg_error_error'
	true	
	assert_false 'msg_error "error" 2>/dev/null'
	test_error_code_set 127
	msg_error "error" 2>/dev/null
	assert_true "[ $? == 127 ]"
	local msg_ERROR_FILE='&1'
	assert_true 'msg_error "error" | assert_output_true test_msg_error_error'
	local msg_VERBOSE_OUTPUT='true'
	assert_true 'msg_error "error" | assert_output_true test_msg_error_verbose'
}
test_msg_error_error(){
	echo "msgType='Error' msg='error'"
}
test_msg_error_verbose(){
	echo "${assert_REGEX_COMPARE}msgType='Error' msg='error' file='./base/assert.source.sh' lineNo=[0-9]+ func='assert__bool'"
}

test_error_code_set(){
	return $1
}


test_msg_debug(){
	assert_true 'msg_debug "debug" 2>&1 | assert_output_true test_msg_debug_debug'
	local msg_DEBUG_FILE='&1'
	assert_true 'msg_debug "debug" | assert_output_true test_msg_debug_debug'
	# can't intentionally shut verbose off in debug case
	local msg_VERBOSE_OUTPUT='false'
	assert_true 'msg_debug "debug" | assert_output_true test_msg_debug_verbose'
	false # debug reflects caller's error code 
	msg_debug "debug" >/dev/null
	assert_false "[  $? == 0  ]"
	msg_debug "debug" 8 >/dev/null
	assert_true "[  $? == 8  ]"
}
test_msg_debug_debug(){
	echo "${assert_REGEX_COMPARE}msgType='Debug' msg='debug' file='./base/assert.source.sh' lineNo=[0-9]+ func='assert__bool"
}
test_msg_debug_verbose(){
	echo "${assert_REGEX_COMPARE}msgType='Debug' msg='debug' file='./base/assert.source.sh' lineNo=[0-9]+ func='assert__bool'"
}


test_msg_fatal(){
	msg_fatal "fatal" 2>&1 | assert_output_true test_msg_fatal_fatal
	local -r msg_FATAL_FILE='&1'
	msg_fatal "fatal" | assert_output_true test_msg_fatal_fatal
	# can't intentionally shut verbose off in fatal case
	local msg_VERBOSE_OUTPUT='false'
	msg_fatal "fatal" | assert_output_true test_msg_fatal_verbose
	false # fatal reflects caller's error code 
	( msg_fatal "fatal" >/dev/null )
	assert_false "[  $? == 0  ]"
	( msg_fatal "fatal" 127 >/dev/null )
	assert_true "[  $? == 127  ]"
}
test_msg_fatal_fatal(){
	# although the actual output generated retains the leading space when generating the caller's stack info: " +  Caller:", the assert in the test code seems to remove this leading space.  Note, a regex compare is being performed which may affect comparison of leading space on LHS of an expression.
	cat <<EXPECTEDOUT
${assert_REGEX_COMPARE}msgType='Fatal' msg='fatal' file='./msg.source_test.sh' lineNo=[0-9]+ func='test_msg_fatal'
${assert_REGEX_COMPARE}\+  Caller: file='./msg.source_test.sh' lineNo=[0-9]+ func='main'
${assert_REGEX_COMPARE}\+  Caller: file='./msg.source_test.sh' lineNo=[0-9]+ func='main'
EXPECTEDOUT
}
test_msg_fatal_verbose(){
	# although the actual output generated retains the leading space when generating the caller's stack info: " +  Caller:", the assert in the test code seems to remove this leading space.  Note, a regex compare is being performed which may affect comparison of leading space on LHS of an expression.
	cat <<EXPECTEDOUT
${assert_REGEX_COMPARE}msgType='Fatal' msg='fatal' file='./msg.source_test.sh' lineNo=[0-9]+ func='test_msg_fatal
${assert_REGEX_COMPARE}\+  Caller: file='./msg.source_test.sh' lineNo=[0-9]+ func='main'
${assert_REGEX_COMPARE}\+  Caller: file='./msg.source_test.sh' lineNo=[0-9]+ func='main'
EXPECTEDOUT
}


main(){
	config_executeable "$(dirname "${BASH_SOURCE[0]}")"
	test_msg__basic
	test_msg_inform
	test_msg_error
	test_msg_debug
	test_msg_fatal
	assert_raised_check
}
main
