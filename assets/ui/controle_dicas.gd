extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"habilita_dicas_controle"):
		visible = not visible
