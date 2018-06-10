extends KinematicBody2D

var id = self
var dead = false
var vector_velocity = Vector2()
var maximum_velocity = 325
var vector_normal = Vector2(0,0)
var gravity = 0
var collapse_position = Vector2()

var void = preload("res://Scenes/void/void.tscn")

signal game_over

func _ready():
	global.player = id
	connect('game_over', global, 'game_over')
	add_to_group('Player')
	set_physics_process(true)

func _physics_process(delta):
	if Input.is_action_just_pressed('ui_void') and not dead: create_void()
	
	var vector_movement = get_global_mouse_position() - self.global_position
	var direction_of_movement = vector_movement.normalized() if not dead else (collapse_position - self.global_position).normalized()
	self.rotation = direction_of_movement.angle() if vector_movement.length() > 5 else self.rotation
	if vector_movement.length() > 5:
		vector_velocity.x = lerp(vector_velocity.x, maximum_velocity*direction_of_movement.x, 0.25)
		vector_velocity.y = lerp(vector_velocity.y, maximum_velocity*direction_of_movement.y, 0.25) + gravity
	else:
		vector_velocity.x = lerp(vector_velocity.x, 0, 0.5)
		vector_velocity.y = lerp(vector_velocity.y, 0, 0.5) + gravity
		
	vector_velocity = move_and_slide(vector_velocity, vector_normal)
	if (get_global_mouse_position() - self.global_position).length() < 0.1: self.global_position = get_global_mouse_position()

func hit():
	global.camera.shake(0.5, 15, 10)
	dead = true
	$collision_shape_2d.disabled = true
	$twn_end.interpolate_property(self, 'scale', self.scale, Vector2(0,0), 1.0, Tween.TRANS_BACK, Tween.EASE_IN)
	$twn_end.start()

func create_void():
	$snd_void.play()
	var i = void.instance()
	i.global_position = self.global_position
	get_parent().add_child(i)


func _on_twn_end_tween_completed(object, key):
	yield(get_tree().create_timer(0.5), 'timeout')
	emit_signal('game_over')
	print('player: Game Over')
