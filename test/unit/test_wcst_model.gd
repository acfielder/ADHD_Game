extends GutTest

func test_update_rule_block_phase_length():
	var model = wcstModel.new()
	var user = User_Data_Manager.load_resource()
	model.set_user(user)
	user.reset_wcst_data()
	model.update_rule_block_phase_length()
	assert_eq(model.rule_length,11)
	
	user.prev_overall_adaption_rate = 0.82
	user.prev_rule_block_length = 11
	model.update_rule_block_phase_length()
	assert_eq(model.rule_length,14)


func test_rule_change():
	var model = wcstModel.new()
	model.change_rule()
	assert_eq(model.current_rule,1)
	assert_eq(model.session_rule_blocks.size(),1)
	
func test_setup_trial():
	#var model
	pass

#func setup_trial():
	#will get the current block and call into that to create it
#	current_trial += 1
#	current_trial_in_rule += 1
#	var trial_info = session_rule_blocks[-1].setup_add_trial() #string of 3 properties
#	return trial_info

#when a card is attempted to be sorted
#the following two will need to go into the block to get the last trial
#func record_check_response(info: Array):
#	calc_update_current_rt()
#	if session_rule_blocks[-1].record_check_response(info):
#		score += 1
#		return true
#	else: return false
#	
	
#func calc_update_current_rt():
#	var rt = final_rt - start_rt
#	session_rule_blocks[-1].update_trial_rt(rt)
#	if rt < best_rt || best_rt == -1:
#		best_rt = rt
	

#func end_phase():
#	match current_phase:
#		1:
#			accuracy_rate_phase_one = calc_accuracy_rate()
#			avg_r_t_phase_one = calc_avg_r_t()
#			overall_adaption_rate_phase_one = calc_overall_adaption_rate()
#		2:
#			accuracy_rate_phase_two = calc_accuracy_rate()
#			avg_r_t_phase_two = calc_avg_r_t()
#			overall_adaption_rate_phase_two = calc_overall_adaption_rate()
	

	

#func calc_accuracy_rate():
#	var tot_correct = 0
#	var total = 0
#	for rule_block in session_rule_blocks:
#		tot_correct += rule_block.get_accuracy()
#		total += rule_block.block_trials.size() 
#	var accuracy_rate = float(tot_correct)/float(total)
#	return accuracy_rate
#	
#func calc_avg_r_t():
#	var tot_time = 0
#	var num_trials = 0
#	for rule_block in session_rule_blocks:
#		tot_time += rule_block.get_rts_total()
#		num_trials += rule_block.block_trials.size()  
#	var avg_r_t = float(tot_time)/float(num_trials)
#	return avg_r_t
#	
#func calc_overall_adaption_rate():
#	var a_rate_tot = 0
#	for rule_block in session_rule_blocks:
#		a_rate_tot += rule_block.adaption_rate
#	var overall_adaption_rate = float(a_rate_tot)/float(phase_length)
#	return overall_adaption_rate

