extends TileMapLayer

const WIDTH: int = 10
const HEIGHT: int = 10

const TILE_GRASS: int = 0
const TILE_DIRT: int = 1
const TILE_WATER: int = 2

var all_tiles: Array[int] = [TILE_GRASS, TILE_DIRT, TILE_WATER]
var grid: Array = []


func _ready() -> void:
	print("READY CALLED")

	set_cell(Vector2i(0, 0), TILE_GRASS)
	set_cell(Vector2i(1, 0), TILE_DIRT)
	set_cell(Vector2i(2, 0), TILE_WATER)

	generate_map()


func generate_map() -> void:
	clear()
	_init_grid()

	var success: bool = _run_wfc()

	if success:
		_draw_result()
	else:
		print("WFC failed — retrying...")
		generate_map()


func _init_grid() -> void:
	grid.clear()

	for x in range(WIDTH):
		var col: Array = []
		for y in range(HEIGHT):
			col.append(all_tiles.duplicate())
		grid.append(col)


func _run_wfc():
	while true:
		var cell: Vector2i = _find_lowest_entropy_cell()

		if cell == Vector2i(-1, -1):
			return true

		var x: int = cell.x
		var y: int = cell.y
		var possibilities: Array = grid[x][y]

		if possibilities.is_empty():
			return false

		var chosen: int = possibilities[randi() % possibilities.size()]
		grid[x][y] = [chosen]

		if not _propagate_from(x, y):
			return false


func _find_lowest_entropy_cell() -> Vector2i:
	var best_entropy: int = 999
	var best_cell: Vector2i = Vector2i(-1, -1)

	for x in range(WIDTH):
		for y in range(HEIGHT):
			var poss: Array = grid[x][y]
			var entropy: int = poss.size()

			if entropy > 1 and entropy < best_entropy:
				best_entropy = entropy
				best_cell = Vector2i(x, y)

	return best_cell


func _propagate_from(start_x: int, start_y: int) -> bool:
	var queue: Array[Vector2i] = [Vector2i(start_x, start_y)]

	while queue.size() > 0:
		var cell: Vector2i = queue.pop_front()

		for direction in ["up", "down", "left", "right"]:
			var nx: int = cell.x
			var ny: int = cell.y

			match direction:
				"up": ny -= 1
				"down": ny += 1
				"left": nx -= 1
				"right": nx += 1

			if nx < 0 or nx >= WIDTH or ny < 0 or ny >= HEIGHT:
				continue

			if _prune_neighbor(cell.x, cell.y, nx, ny, direction):
				if grid[nx][ny].is_empty():
					return false

				queue.append(Vector2i(nx, ny))

	return true


func _allowed_neighbors(tile_id: int, direction: String) -> Array[int]:
	return [TILE_GRASS, TILE_DIRT, TILE_WATER]


func _prune_neighbor(x: int, y: int, nx: int, ny: int, direction: String) -> bool:
	var changed := false

	var source_tiles: Array = grid[x][y]
	var neighbor_tiles: Array = grid[nx][ny]

	var allowed: Dictionary = {}

	for src in source_tiles:
		for t in _allowed_neighbors(src, direction):
			allowed[t] = true

	var new_list: Array = []
	for tile in neighbor_tiles:
		if allowed.has(tile):
			new_list.append(tile)

	if new_list.size() < neighbor_tiles.size():
		grid[nx][ny] = new_list
		changed = true

	return changed


func _draw_result() -> void:
	print("DRAW RESULT CALLED")
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var tile_id: int = grid[x][y][0]
			set_cell(Vector2i(x, y), tile_id)
			print("Placing tile at: ", x, ",", y, " = ", tile_id)
