extends Camera3D

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = event.position
			var ray_origin = project_ray_origin(mouse_pos)
			var ray_end = ray_origin + project_ray_normal(mouse_pos) * 1000  # Adjust distance as needed

			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
			query.collide_with_areas = true
			var result = space_state.intersect_ray(query)
			
			if result:
				print("Clicked object: ", result.collider.name)
				# You can access properties or call methods on the clicked object here
