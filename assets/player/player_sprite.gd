@tool
extends Sprite2D

@onready var _parado = preload("res://assets/player/sprites/Idle.png")
@onready var _pulando = preload("res://assets/player/sprites/Idle.png")
@onready var _correndo = preload("res://assets/player/sprites/Walk.png")

const FRAMERATE = 15

var _direcao := 0
var _progresso := 0.0
var _nodo_pai : Node25D
var _matematica : PlayerMath25D

func _ready():
	_nodo_pai = get_parent()
	_matematica = _nodo_pai.get_child(0)

func _process(delta):
	if Engine.is_editor_hint():
		return #Nao rode isso no editor

	_sprite_basico()
	var movimento = _checar_movimento()

	var confirmarColisao = _matematica.move_and_collide(Vector3.DOWN * 10 * delta, true, true, true)
	if confirmarColisao != null:
		if movimento:
			hframes = 6
			texture = _correndo
			if(Input.is_action_pressed(&"modificador_movimento")):
				delta /= 2
			_progresso = fmod((_progresso + FRAMERATE * delta), 6)
			frame = _direcao * 6 + int(_progresso)
		else:
			hframes = 1
			texture = _parado
			_progresso = 0
			var pulando = 1 if _matematica.velocidadeVertical < 0 else 0
			frame = _direcao * 2 + pulando

func definir_modo_visao(vm_centro):
	match vm_centro:
		0:
			transform.x = Vector2(4,0)
			transform.y = Vector2(0,3)
		1:
			transform.x = Vector2(4,0)
			transform.y = Vector2(0,3)
		2:
			transform.x = Vector2(4,0)
			transform.y = Vector2(0,3)
		3:
			transform.x = Vector2(4,0)
			transform.y = Vector2(0,3)
		4:
			transform.x = Vector2(4,0)
			transform.y = Vector2(0,3)
		5:
			transform.x = Vector2(4,0)
			transform.y = Vector2(0,3)

func _sprite_basico():
		if not Engine.is_editor_hint():
			if Input.is_action_pressed(&"forty_five_mode"):
				definir_modo_visao(0)
			elif Input.is_action_pressed(&"isometric_mode"):
				definir_modo_visao(1)
			elif Input.is_action_pressed(&"top_down_mode"):
				definir_modo_visao(2)
			elif Input.is_action_pressed(&"front_side_mode"):
				definir_modo_visao(3)
			elif Input.is_action_pressed(&"oblique_y_mode"):
				definir_modo_visao(4)
			elif Input.is_action_pressed(&"oblique_z_mode"):
				definir_modo_visao(5)

func _checar_movimento() -> bool:
	var x = 0
	var z = 0

	if Input.is_action_pressed(&"mover_direita"):
		x += 1
	if Input.is_action_pressed(&"mover_esquerda"):
		x -= 1
	if Input.is_action_pressed(&"mover_cima"):
		z -= 1
	if Input.is_action_pressed(&"mover_baixo"):
		z += 1

	if not _matematica.controlesIsometricos and is_equal_approx(Node25D.SCALE * 0.86602540378, _nodo_pai.get_basis()[0].x):
		if Input.is_action_pressed(&"mover_direita"):
			z += 1
		if Input.is_action_pressed(&"mover_esquerda"):
			z -= 1
		if Input.is_action_pressed(&"mover_cima"):
			x += 1
		if Input.is_action_pressed(&"mover_baixo"):
			x -= 1

	if x == 0:
		if z == 0:
			return false # No movement.
		elif z > 0:
			_direcao = 0
		else:
			_direcao = 4
	elif x > 0:
		if z == 0:
			_direcao = 2
			flip_h = true
		elif z > 0:
			_direcao = 1
			flip_h = true
		else:
			_direcao = 3
			flip_h = true
	else:
		if z == 0:
			_direcao = 2
			flip_h = false
		elif z > 0:
			_direcao = 1
			flip_h = false
		else:
			_direcao = 3
			flip_h = false
	return true
