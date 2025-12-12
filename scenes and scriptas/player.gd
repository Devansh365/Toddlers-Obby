extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var SENSITIVITY= 0.005
@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/Camera3D
@onready var coinui: RichTextLabel = $CanvasLayer/coins
@onready var offering: RichTextLabel = $CanvasLayer/offering
@onready var anim: AnimationPlayer = $AnimationPlayer

var coinsinhand = 0
var magicalcoininhand = 0
var canmovee = true
var seashell = 0
var subwayd = true
var injecct2 = false

func _ready() -> void:
	$CanvasLayer/ColorRect.visible = false
#	Dialogic.signal_event.connect(_on_dialogic_signal)
#	Sm.canmove.connect(canmove)
#	Sm.cantmove.connect(cantmove)
#	Sm.seashellpicked.connect(seashellpicked)
#	Sm.toypicked.connect(toypicked)
#	Sm.noise.connect(noise)
#	Sm.noisegone.connect(noisegone)
#	Sm.dollpicked.connect(dollpicked)
	#Sm.fadeitup.connect(fadeitup)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if canmovee == true:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if Input.is_action_just_pressed("flashlight"):
		if $head/Camera3D/SpotLight3D.visible == false:
			$head/Camera3D/SpotLight3D.visible = true
		elif $head/Camera3D/SpotLight3D.visible == true:
			$head/Camera3D/SpotLight3D.visible = false
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if canmovee == true:
		if is_on_floor():
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
				
		else:
			velocity.x = lerp(velocity.x,direction.x * SPEED, delta * 3)
			velocity.z = lerp(velocity.z,direction.z * SPEED, delta * 3)
	if canmovee == false:
		velocity.x = 0
		velocity.z = 0
		
	if velocity.length() > 0:
		if is_on_floor():
			if not $footsteps1.playing:
				$footsteps1.play()
	else:
		if $footsteps1.playing:
			$footsteps1.stop()
	if not is_on_floor():
		if $footsteps1.playing:
			$footsteps1.stop()
			
		
	move_and_slide()

	if injecct2 == true:
		#global_position = Vector3(5, 2, -3)

		var new_transform = Transform3D()
		new_transform.origin = Vector3(3, 2, 0)
		set_global_transform(new_transform)
		
	if Sm.effect == 0:
		noisegone()
	if Sm.effect == 1:
		noise()


func toypicked():
	Sm.initt = 3
	coinui.visible = true
	coinsinhand = coinsinhand + 1
	coinui.text = str(coinsinhand) + "/3"
	if coinsinhand == 3:
		anim.play("fadee out")
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://facility.tscn")
		noisegone()
		Sm.effect = 0
		
		#injecct2 = true
		#Sm.scitist2.emit()
	#$magiccoin.play()
func coinplaced():
	coinsinhand = coinsinhand - 1
	coinui.text = "death count: " + str(coinsinhand)
	#$magiccoin.play()
	
func magicalcoinpicked():
	offering.visible = true
	magicalcoininhand = magicalcoininhand + 1
	offering.text = str(magicalcoininhand) + "/3"
	#$magiccoin.play()
func magicalcoinplaced():
	offering.visible = true
	magicalcoininhand = magicalcoininhand - 1
	offering.text = str(magicalcoininhand) + "/3"
	#$magiccoin.play()
	
func seashellpicked():
	offering.visible = true
	
	seashell += 1
	magicalcoininhand = magicalcoininhand + 1
	offering.text = str(magicalcoininhand) + "/6"
	if seashell == 6:
		anim.play("fadee out")
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://facility.tscn")
		
		injecct2 = true
		Sm.scitist2.emit()
		Sm.effect = 0
func dollpicked():
	Sm.effect = 0
	Sm.noisegone.emit()
	anim.play("fadee out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://facility.tscn")
	injecct2 = true
	
	Sm.scitist3.emit()
	Sm.effect = 0
func fadeitup():
	anim.play("fadee out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://facility.tscn")
	injecct2 = true
	Sm.scitist3.emit()
	Sm.initt = 5
	Sm.effect = 0
	
#func toypicked():
	#offering.visible = true
	
	#magicalcoininhand = magicalcoininhand + 1
	#offering.text = str(magicalcoininhand) + "/6"
	

		
	 
	
func _on_dialogic_signal(argument:String):
	if argument == "girl1end":
		offering.visible = true
	if argument == "inject2":
		canmove()
		Sm.caninject2.emit()
	if argument == "inject3":
		canmove()
		Sm.caninject3.emit()
	if argument == "inject4":
		canmove()
		Sm.caninject4.emit()
	if argument == "inject5":
		canmove()
		Sm.caninject5.emit()
		#Sm.scitist2.emit()
	if argument == "exitdia":
		canmove()
func noise():
	$CanvasLayer/ColorRect.visible = true
func noisegone():
	$CanvasLayer/ColorRect.visible = false

	
func canmove():
	camera.current = true
	
	canmovee = true
func cantmove():
	canmovee = false
	$head/Camera3D/SpotLight3D.visible = false


func _on_dream_body_entered(body: Node3D) -> void:
	anim.play("fadee out")
	await get_tree().create_timer(3.0).timeout	
	#Sm.effect = 0
	noisegone()
	#await get_tree().create_timer(1.0).timeout
	$"CanvasLayer/ending 1".visible = true
	await get_tree().create_timer(3.0).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#get_tree().change_scene_to_file("res://assets/menu.tscn")

	
	

func _on_real_body_entered(body: Node3D) -> void:
	anim.play("fadee out")
	await get_tree().create_timer(3.0).timeout	
	#Sm.effect = 0
	noisegone()
	#await get_tree().create_timer(1.0).timeout
	$"CanvasLayer/ending 2".visible = true
	await get_tree().create_timer(3.0).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#get_tree().change_scene_to_file("res://assets/menu.tscn")


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if subwayd == true:
		#Dialogic.start("subway")
		subwayd = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	
	get_tree().reload_current_scene()


func _on_enfing_body_entered(body: Node3D) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://menu.tscn")
