extends Node2D

#text info for report, could be in a dict with user so the whole dict is passed and has everything
var sequence_tracking : Array = ["Sequences completed", "Total correct", "Crimes solved", "Overall Performance"]
var stop_go : Array = []


func _ready(): #maybe init - takes in values needed for report
	pass
#func _init(longest_legnth: int, total_correct: Array, crimes_solved: int, overall_performance: Array:
	#pass #above are arrays for fractions, but this is specific to sequence, others would be rather different
	#should instead take in users session obj with that games specific info - one will tell type 0-2
	#take in the above mentioned dict

func set_tracking_texts():
	#if this type, or from dict take each - keys maybe be the strings
	$label1.text = ""
	$label2.text = ""
	$Label3.text = ""
	$Label4.text = ""
	$Label5.text = ""
	$label6.text = ""
	pass
	
#graph updating logic
func setup_graph(performances: Array):
	#var performances = [stm_per, up_man_per, delay_per]
	for per in performances:
		var points = $graph_cont/GraphReport.determine_line_points_sequence(per)
		$graph_cont/GraphReport.create_line(points)
