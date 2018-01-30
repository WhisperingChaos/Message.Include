#!/bin/bash
config_executeable(){
	local -r myRoot="$1"
	echo myroot $myRoot
	# include components required to create this executable
	local mod
	for mod in $( "$myRoot/sourcer/sourcer.sh" "$myRoot"); do
		source "$mod"
	done
}

test_msg__basic(){
	assert_true "msg__basic '' 'basic' '&1' '2' | assert_output_true test_msg__basic_no_message"
	assert_true "msg__basic 'basic' 'basic' '&1' '2' | assert_output_true test_msg__basic_message"
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
	echo "msgType='basic' msg='basic' file='./base/assert.source.sh' lineNo='90' func='assert__bool'"
}



test_msg_inform(){
	assert_true 'msg_inform "inform" | assert_output_true test_msg_inform_inform'
}
test_msg_inform_inform(){
	echo "msgType='Inform' msg='inform'"
}

main(){
	config_executeable "$(dirname "${BASH_SOURCE[0]}")"
	test_msg__basic
	assert_raised_check
}
main
