extends Node3D
class_name TerrainController


# Holds the catalog of loaded terrian block scenes
var TerrainBlocks: Array = [] # holds all loaded terrian block scenes
var terrain_belt: Array[MeshInstance3D] = [] #terrian blocks currently rendered to viewport
@export var terrain_velocity: float = 8.0 #was 10.0
@export var num_terrain_blocks = 4 #num blocks to keep rendered to the viewport
@export_dir var terrian_blocks_path = "res://Stop_Go/Hall_Terrain" #directory path holding the terrain block scenes


func _ready() -> void:
	_load_terrain_scenes(terrian_blocks_path)
	_init_blocks(num_terrain_blocks)


func _physics_process(delta: float) -> void:
	_progress_terrain(delta)


func _init_blocks(number_of_blocks: int) -> void:
	for block_index in number_of_blocks:
		var block = TerrainBlocks.pick_random().instantiate()
		if block_index == 0:
			block.position.z = block.mesh.size.y/2
		else:
			_append_to_far_edge(terrain_belt[block_index-1], block)
		add_child(block)
		terrain_belt.append(block)


func _progress_terrain(delta: float) -> void:
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta

	if terrain_belt[0].position.z >= terrain_belt[0].mesh.size.y/2:
		var last_terrain = terrain_belt[-1]
		var first_terrain = terrain_belt.pop_front()

		var block = TerrainBlocks.pick_random().instantiate()
		_append_to_far_edge(last_terrain, block)
		add_child(block)
		terrain_belt.append(block)
		first_terrain.queue_free()


func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2


func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrian block scene: " + target_path + "/" + scene_path)
		TerrainBlocks.append(load(target_path + "/" + scene_path))
