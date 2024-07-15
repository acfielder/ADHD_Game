extends GutTest

func test_set_rule():
	var rule_block = wcstRuleBlock.new()
	rule_block.set_rule()
	assert(rule_block.rule == wcstRuleBlock.Rules.COLOR || rule_block.rule == wcstRuleBlock.Rules.COUNT)



#func set_rule(prev_rule : Rules = Rules.SHAPE):
#	rule = prev_rule
#	while rule == prev_rule:
#		var rule_num = rng.randi_range(0, 2)
#		match rule_num:
#			0: rule = Rules.SHAPE
##			1: rule = Rules.COLOR
#			2: rule = Rules.COUNT
#	return rule

#func setup_add_trial():
#	var trial = wcstTrialInfo.new()
#	trial.set_card_type(phase)
#	block_trials.append(trial)
#	return trial.get_card_info_string()

#adaption rate for this block - adaption period of 5 trials
#func calc_adaption_rate():
#	var sorted = 0
#	for i in range(3):
#		if block_trials[i].successful:
#			sorted += 1
#	adaption_rate = float(sorted)/float(4)#correct/adaption period length
#	return adaption_rate
	
#when a card is attempted to be sorted
#the following two will need to go into the block to get the last trial
#func record_check_response(info: Array): #color,shape,count
#	block_trials[-1].set_sort_press_true()
#	var trial_info = block_trials[-1].get_card_info_string()
#	match rule:
#		Rules.SHAPE:
#			if trial_info[1] == info[1]:
#				block_trials[-1].successful = true
#			else:
#				block_trials[-1].successful = false
#		Rules.COLOR:
#			if trial_info[0] == info[0]:
#				block_trials[-1].successful = true
#			else:
#				block_trials[-1].successful = false
#		Rules.COUNT:
#			if trial_info[2] == info[2]:
#				block_trials[-1].successful = true
#			else:
#				block_trials[-1].successful = false
#	return block_trials[-1].successful
	
#func timer_ended_trial():
#	block_trials[-1].successful = false
#	
#func update_trial_rt(rt: float):
#	block_trials[-1].r_t = rt
	
#func get_accuracy():
#	var accurate = 0
#	for trial in block_trials:
#		if trial.successful:
#			accurate += 1
#	return accurate
	
#func get_rts_total():
#	var tot_rt = 0
#	for trial in block_trials:
#		if trial.r_t != -1:
#			tot_rt += trial.r_t
#	return tot_rt