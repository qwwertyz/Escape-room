extends Button
signal curtains_opened



func _on_pressed() -> void:
	visible = false
	curtains_opened.emit()
	
