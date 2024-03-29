extends KinematicBody2D

export (int) var detect_radius

export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(0,0,0,0)
var laser_color = Color(1.0, .329, .298)
var velocity = Vector2()

var speed = 3000
var distance = 300
var target
var trace = false
var last_seen
var hit_pos
var can_shoot = true
var health = 100

func _ready():
	$Sprite.self_modulate = Color(0.2, 0, 0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate

func _physics_process(delta):
	update()
	if health <= 0:
		self.queue_free()
	if target != null:
		aim()

	velocity = move_and_slide(velocity*delta).normalized()

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('../Player/Body').shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "Player":
				if target.position.x > self.position.x + distance:
					velocity.x += speed
				if target.position.x < self.position.x - distance:
					velocity.x -= speed
				if target.position.y > self.position.y + distance:
					velocity.y += speed
				if target.position.y < self.position.y - distance:
					velocity.y -= speed
				$Sprite.self_modulate.r = 1.0
				rotation = (target.position - position).angle()
				if can_shoot:
					last_seen = target.position
					trace = true
					shoot(pos)
				break
			elif trace:
				if last_seen.x > self.position.x:
					velocity.x += speed
				if last_seen.x < self.position.x:
					velocity.x -= speed
				if last_seen.y > self.position.y:
					velocity.y += speed
				if last_seen.y < self.position.y:
					velocity.y -= speed
				if  self.position.x - last_seen.x > 200 && self.position.y - last_seen.y > 200:
					trace = false


func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()

func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)

func _on_Visibility_body_entered(body):
	if target:
		return
	target = body


func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		$Sprite.self_modulate.r = 0.2

func _on_ShootTimer_timeout():
	can_shoot = true
	
func _on_HitBox_area_entered(area):
	print(str(area.name))
	if area.name.similarity("Bullet"):
		if area.name.similarity("Player"):
			health -= 25
			$Label.set_text(str(health))
#
