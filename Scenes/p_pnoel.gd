extends CharacterBody3D

@export var damage_amount: int = 10
@export var speed: float = 2.0
@export var chase_speed: float = 3.5
@export var detection_distance: float = 6.0
@export var patrol_distance: float = 4.0
@export var knockback_force: float = 4.0
@export var knockback_time: float = 0.3

var start_position: Vector3
var moving_forward := true
var is_bouncing := false

@onready var health_component: HealthComponent = $HealthComponent2
@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim_player: AnimationPlayer = $idleWS2/AnimationPlayer
@onready var victory_screen = $"../VictoryScene"

func _ready() -> void:
	axis_lock_linear_x = true
	health_component.died.connect(_on_health_component_died)
	start_position = global_position
	print("Victory achada: ", victory_screen)

func _physics_process(delta: float) -> void:
	if is_bouncing:
		if not is_on_floor():
			velocity += get_gravity() * delta

		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0

	var player_detected := false

	if player:
		if global_position.distance_to(player.global_position) <= detection_distance:
			player_detected = true

	if player_detected:
		var direction = (player.global_position - global_position).normalized()
		velocity.z = direction.z * chase_speed
	else:
		velocity.z = 0
	velocity.x = 0

	var is_attacking = anim_player.current_animation == "Noel/Lançar" and anim_player.is_playing()
	
	if not is_attacking:
		if not is_on_floor():
			anim_player.play("Noel/Jump")
		elif abs(velocity.z) > 0.1:
			anim_player.play("Noel/SLWrun")
		else:
			anim_player.play("Noel/IDLE")



	move_and_slide()

func _on_hitbox_dano_body_entered(body: Node3D) -> void:
	if body == player and not is_bouncing:
		if anim_player.current_animation != "Noel/Lançar":
			anim_player.play("Noel/Lançar")

		player.take_damage(damage_amount)

		is_bouncing = true

		var dir_recuo = global_position.z - player.global_position.z
		velocity.z = sign(dir_recuo) * knockback_force
		velocity.y = 2.0

		move_and_slide()

		await get_tree().create_timer(knockback_time).timeout
		is_bouncing = false

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func _on_health_component_died() -> void:
	set_physics_process(false)
	hide()

	await get_tree().create_timer(2.0).timeout

	victory_screen.visible = true
	
	
