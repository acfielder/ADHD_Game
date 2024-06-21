extends Node3D
class_name TerrainControllerMovement

var TerrainBlocks : Array = [] #holds loaded terrain block scenes 
var current_terrain : Array[MeshInstance3D] = [] #terrain blocks currently rendered in the scene viewport
@export var num_terrain_blocks = 4 #num blocks to keep rendered at a time
@export_dir var terrain_blocks_path = "res://Stop_Go/Hall_Terrain" #directory path holding the terrain block scenes
@export var terrain_length : int = 20 #length/y of mesh obj of terrain floor
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_node("/root/Stop_Go_World/Player")
	_load_terrain_scenes(terrain_blocks_path)
	_init_blocks(num_terrain_blocks)
	
func _physics_process(delta: float) -> void:
	_process_terrain(delta)
	
func _process_terrain(delta: float) -> void:
	var current_block = current_terrain[0]
	var next_block = current_terrain[1]

	if player.global_transform.origin.z <= next_block.global_transform.origin.z - terrain_length / 2:
		var last_terrain = current_terrain[-1]
		var first_terrain = current_terrain.pop_front()

		var block = TerrainBlocks.pick_random().instantiate()
		append_to_far_edge(last_terrain, block)
		add_child(block)
		current_terrain.append(block)
		first_terrain.queue_free()
	
	
	
#	if current_terrain[0].position.z >= current_terrain[0].mesh.size.y/2:
#		var last_terrain = current_terrain[-1]
#		var first_terrain = current_terrain.pop_front()
#
#		var block = TerrainBlocks.pick_random().instantiate()
#		append_to_far_edge(last_terrain, block)
#		add_child(block)
#		current_terrain.append(block)
#		first_terrain.queue_free()
	
	
func _load_terrain_scenes(path: String) -> void:
	var dir = DirAccess.open(path)
	for scene_path in dir.get_files():
		print("loading block: " + path + "/" + scene_path)
		TerrainBlocks.append(load(path + "/" + scene_path))
		
func _init_blocks(num_of_blocks: int) -> void:
	for block_index in num_of_blocks:
		var block = TerrainBlocks.pick_random().instantiate()
		if block_index == 0:
			block.position.z = block.mesh.size.y/2
		else:
			append_to_far_edge(current_terrain[block_index-1],block)
		add_child(block)
		current_terrain.append(block)
		
func append_to_far_edge(last_block: MeshInstance3D, new_block: MeshInstance3D) -> void:
	new_block.position.z = last_block.position.z - last_block.mesh.size.y/2 - new_block.mesh.size.y/2
