extends KinematicBody2D
### Enemy
var id = self
var dead = false
var vector_velocity = Vector2()
var maximum_velocity = 100
var vector_normal = Vector2(0,0)
var gravity = 0
var collapse_position = Vector2()

func _ready():
	randomize()
	var dim = rand_range(0.85, 2.25)
	$sprite.scale *= dim
	$collision_shape_2d.shape.extents *= dim
	$area_2d/collision_shape_2d.shape.extents *= dim
	
	add_to_group('Enemy')
	set_physics_process(true)

func _physics_process(delta):
	var direction_of_movement = (global.player.global_position - self.global_position).normalized() if not dead else (collapse_position - self.global_position).normalized()
	self.rotation = direction_of_movement.angle()
	vector_velocity.x = lerp(vector_velocity.x, maximum_velocity*direction_of_movement.x, 0.1)
	vector_velocity.y = lerp(vector_velocity.y, maximum_velocity*direction_of_movement.y, 0.1) + gravity
	vector_velocity = move_and_slide(vector_velocity, vector_normal)

func _on_area_2d_body_entered(body):
	if body.is_in_group('Player'):
		body.collapse_position = body.global_position
		body.hit()

func hit():
	$snd_hit.play()
	global.camera.shake(0.2, 15, 8)
	global.score += 50
	dead = true
	$collision_shape_2d.disabled = true
	$area_2d/collision_shape_2d.disabled = true
	$twn_end.interpolate_property(self, 'scale', self.scale, Vector2(0,0), 1.0, Tween.TRANS_BACK, Tween.EASE_IN)
	$twn_end.start()


func _on_twn_end_tween_completed(object, key): self.queue_free()
