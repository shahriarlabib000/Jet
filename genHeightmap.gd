@tool
extends MeshInstance3D

# Export a Texture2D for the heightmap
@export var heightmap_texture: Texture2D

# Heightmap scale (distance between vertices)
@export var scale_: float = 1.0

# Height scale (how much to multiply the height values)
@export var height_scale: float = 10.0

# Tool button to generate the heightmap mesh
@export_tool_button("gw") var fu:Callable = generate_mesh
func generate_mesh():
	for child in get_children():
		if child is StaticBody3D:
			child.queue_free()
	# Check if the texture is valid
	if not heightmap_texture:
		print("No heightmap texture provided!")
		return
	
	# Get the image from the texture
	var image = heightmap_texture.get_image()
	if not image:
		print("Failed to get image data from texture!")
		return
	
	# Create the mesh
	var m= create_heightmap_mesh(image)
	if m:
		mesh = m
	create_trimesh_collision()
	for child in get_children():
		if child is StaticBody3D:
			print("added")
			child.add_to_group("terrain")

func create_heightmap_mesh(image: Image) -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Get image dimensions
	var width = image.get_width()
	var height = image.get_height()
	
	# Generate vertices
	for x in range(width):
		for z in range(height):
			# Get the pixel color (heightmap is grayscale, so we use the red channel)
			var pixel = image.get_pixel(x, z)
			var y = pixel.r * height_scale  # Use the red channel for height
			
			# Create vertex
			var vertex = Vector3(x * scale_, y, z * scale_)
			st.add_vertex(vertex)
			
	
	# Generate indices for triangles
	for x in range(width - 1):
		for z in range(height - 1):
			var i = x + z * width
			var i1 = (x + 1) + z * width
			var i2 = x + (z + 1) * width
			var i3 = (x + 1) + (z + 1) * width
			
			st.add_index(i1)
			st.add_index(i3)
			st.add_index(i2)
			
			st.add_index(i)
			st.add_index(i1)
			st.add_index(i2)
	
	# Generate normals (optional but recommended for lighting)
	st.generate_normals()
	
	# Create the mesh
	var m = st.commit()
	return m
