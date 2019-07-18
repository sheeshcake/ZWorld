extends KinematicBody2D

export (int) var detect_radius = 600
export (int) var speed = 2000
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

var target
var hit_pos
var velocity = Vector2()
var health = 100

func _ready():
	$Sprite.self_modulate = Color(0.2, 0, 0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape

func _physics_process(delta):
	update()
	if health == 0:
		self.queue_free()
	if target:
		aim()
	velocity = move_and_slide(velocity * delta)

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	if get_node("../Player/Body"):
		var target_extents = target.get_node('../Player/Body').shape.extents - Vector2(5, 5)
		var nw = target.position - target_extents
		var se = target.position + target_extents
		var ne = target.position + Vector2(target_extents.x, -target_extents.y)
		var sw = target.position + Vector2(-target_extents.x, target_extents.y)
		for pos in [target.position, nw, ne, se, sw]:
			var result = space_state.intersect_ray(position, pos, [self], collision_mask)
			if result:
				hit_pos.append(result.position)
				if result.collider.name == "Player":
					$Sprite.self_modulate.r = 1.0
					rotation = (target.position - position).angle()
					if target.position.x > self.position.x:
						velocity.x += speed
					if target.position.x < self.position.x:
						velocity.x -= speed
					if target.position.y > self.position.y:
						velocity.y += speed
					if target.position.y < self.position.y:
						velocity.y -= speed
					break

func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)

func _on_Visibility_body_entered(body):
	target = body
	if target:
		print(str(target.name))
		return



func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		$Sprite.self_modulate.r = 0.2
		
func _on_HitBox_area_entered(area):
	print(str(area.name))
	if area.name.similarity("Bullet"):
		if area.name.similarity("Player"):
			health -= 25
			$Label.set_text(str(health))
