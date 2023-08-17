tool
extends Node2D

export var flag = false

func remove_focus_on_all_children(node: Node):
	if node is BaseButton:
		var b: BaseButton = node
		b.focus_mode = Control.FOCUS_NONE
	
	for child in node.get_children():
		remove_focus_on_all_children(child)

func go():
	remove_focus_on_all_children(self)

func _process(delta):
	if flag:
		flag = false
		go()
