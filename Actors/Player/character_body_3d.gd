extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.5

# Referência ao nó visual para não rotacionar o CharacterBody3D inteiro
@onready var visual_node: Node3D = $Sketchfab_Scene

func _physics_process(delta: float) -> void:
	# Adiciona gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# --- LÓGICA DE ROTAÇÃO ---
		# Se o movimento no eixo X for positivo (direita), rotaciona para 0 graus
		if input_dir.x > 0:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, rad_to_deg(0), 0.2)
		# Se for negativo (esquerda), rotaciona para 180 graus (PI radianos)
		elif input_dir.x < 0:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, deg_to_rad(180), 0.2)
		# -------------------------
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
