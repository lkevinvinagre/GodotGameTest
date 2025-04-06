extends CharacterBody3D
class_name PlayerMath25D

var velocidadeVertical := 0.0
var controlesIsometricos := true
@onready var _nodo_pai: Node25D = get_parent()

func _processo_fisico(delta):
	if Input.is_action_pressed(&"exit"):
		get_tree().quit()
	if Input.is_action_just_pressed(&"toggle_isometric_controls"):
		controlesIsometricos = not controlesIsometricos
	if Input.is_action_just_pressed(&"reset_position") or position.y <= -100:
		# Reset player position if the player fell down into the void.
		transform = Transform3D(Basis(), Vector3.UP * 0.5)
		velocidadeVertical = 0
	else:
		_movimento_horizontal(delta)
		_movimento_vertical(delta)

func _movimento_horizontal(delta):
	var xlocal = Vector3.RIGHT
	var zlocal = Vector3.BACK

	if controlesIsometricos and is_equal_approx(Node25D.SCALE * 0.86602540378, _nodo_pai.get_basis()[0].x):
		xlocal = Vector3(0.70710678118, 0, -0.70710678118)
		zlocal = Vector3(0.70710678118, 0, 0.70710678118)

	var movimentoVetor = Input.get_vector(&"mover_esquerda", &"mover_direita", &"mover_cima", &"mover_baixo")
	var direcaoMovimento = xlocal * movimentoVetor.x + zlocal * movimentoVetor.y

	velocity = direcaoMovimento * delta * 1200
	if Input.is_action_pressed(&"modificador_movimento"):
		velocity /= 2

	move_and_slide()

func _movimento_vertical(delta):
	var ylocal = Vector3.UP
	if Input.is_action_just_pressed(&"pular"):
		velocidadeVertical = 0.55
	velocidadeVertical -= delta * 2
	var moverColidir = move_and_collide(ylocal * velocidadeVertical)
	if moverColidir != null:
		velocidadeVertical = 0
