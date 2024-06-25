extends Object

class_name Utilities

static func start_timer(node: Node, duration: float, callback: Callable):
	var timer = node.get_tree().create_timer(duration)
	timer.connect("timeout", callback)
	return timer
