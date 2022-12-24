extends Node2D

const minRopeLength: int = 32
const maxRopeLength : int= 470
const rotateSpeed: int = 3
const ropeSpeed: int = 3
var rotate: bool = true
var direction: bool = false
var shoot: bool = false
var allowUserInput: bool = true
var catch: String = ""
var score: int = 0

func _ready():
	if not direction: 
		$DirectionController.rotation_degrees = 90
	elif direction:
		$DirectionController.rotation_degrees = -90

func _process(delta):
	$Rotate.text = "Rotate: " + str(rotate)
	$Direction.text = "Direction: " + ["Left", "Right"][int(direction)]
	$Shoot.text = "Shoot: " + str(shoot)
	$AllowUserInput.text = "Allow User Input: " + str(allowUserInput)
	$Score.text = "Score: " + str(score)
	
	if $DirectionController.rotation_degrees >= 90:
		direction = true
	elif $DirectionController.rotation_degrees <= -90:
		direction = false
	if rotate:
		if not direction:
			$DirectionController.rotate(rotateSpeed * delta)
		elif direction:
			$DirectionController.rotate(-rotateSpeed * delta)

	if allowUserInput:
		if Input.is_action_just_pressed("Space"):
			#cheat shoot = not shoot
			if allowUserInput:
				shoot = true
				allowUserInput = false

	if shoot:
		rotate = false
		if $DirectionController/Rope.rect_size.y + 1 <= maxRopeLength:
			$DirectionController/Rope.rect_size.y += ropeSpeed
			$DirectionController/Rope/Hook.position.y += ropeSpeed
		else:
			shoot = false
			allowUserInput = false
	elif not shoot:
		if $DirectionController/Rope.rect_size.y > minRopeLength:
			$DirectionController/Rope.rect_size.y -= ropeSpeed
			$DirectionController/Rope/Hook.position.y -= ropeSpeed
			if catch != "":
				$DirectionController/Rope/Hook/Area2D.hide()
				get_node(catch).global_position = Vector2($DirectionController/Rope/Hook.global_position.x, $DirectionController/Rope/Hook.global_position.y)
		else:
			rotate = true
			allowUserInput = true
			if catch != "":
				get_node(catch).queue_free()
				catch = ""
				score += 1
				$DirectionController/Rope/Hook/Area2D.show()

	if ($Timer.time_left == 0):
		$Timer.start()

func Catch(body):
	shoot = false
	allowUserInput = false
	catch = body.get_parent().get_parent().name + "/" + body.get_parent().name

func IsTimeToSpawnFish():
	var fish: Sprite = preload("res://Instances/Fish.tscn").instance()
	var fishDirection: String = RandomDirection()
	var fishSpawnPoint: String =  str(RandomSpawnPoint())
	get_node(fishDirection + fishSpawnPoint).add_child(fish)
	if fishDirection == "Left":
		get_node(fishDirection + fishSpawnPoint).get_child(0).speed *= -1
	elif fishDirection == "Right":
		get_node(fishDirection + fishSpawnPoint).get_child(0).speed *= 1

func RandomDirection():
	randomize()
	var directions: Array = ["Left", "Right"]
	return directions[randi() % directions.size()]

func RandomSpawnPoint():
	randomize()
	var spawnPoints: Array = [1, 2]
	return spawnPoints[randi() % spawnPoints.size()]
