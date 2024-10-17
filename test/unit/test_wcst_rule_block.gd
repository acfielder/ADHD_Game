extends GutTest

func test_set_rule():
	var rule_block = wcstRuleBlock.new()
	rule_block.set_rule()
	#assert_true(rule_block.rule == wcstRuleBlock.Rules.COLOR || rule_block.rule == wcstRuleBlock.Rules.COUNT)

func test_setup_add_trial():
	var rule_block = wcstRuleBlock.new()
	rule_block.phase = 1
	rule_block.setup_add_trial()
	assert_eq(rule_block.block_trials.size(),1)

func test_calc_adaption_rate():
	var rule_block = wcstRuleBlock.new()
	rule_block.phase = 1
	rule_block.setup_add_trial()
	rule_block.setup_add_trial()
	rule_block.setup_add_trial()
	rule_block.setup_add_trial()
	rule_block.setup_add_trial()
	rule_block.setup_add_trial()
	rule_block.block_trials[0].successful = true
	rule_block.block_trials[1].successful = true
	rule_block.block_trials[2].successful = false
	rule_block.block_trials[3].successful = true
	rule_block.block_trials[4].successful = false
	rule_block.block_trials[5].successful = true
	assert_eq(rule_block.calc_adaption_rate(),0.6)
	
	
func test_record_check_response():
	#var rule_block = wcstRuleBlock.new()
	#rule_block.rule = wcstRuleBlock.Rules.SHAPE
	#rule_block.phase = 1
	#rule_block.setup_add_trial()
	#rule_block.block_trials[-1].shape = wcstTrialInfo.Shapes.CIRCLE
	#assert_true(rule_block.record_check_response(["purple","circle","two"]))
	pass
