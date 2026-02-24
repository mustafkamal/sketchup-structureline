module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module ElementDesigner
            module WallDesigner
							module BrickMasonryWallDesigner
								extend self

								include Component::BrickComponent
								include Component::ConcreteBoxComponent
								include Calculation
								include Catalog
	
	              def design(wall)
									@wall = wall
									establish_wall_objects
									establish_presentation_catalog
									establish_construction_data
									register_components
	              end
	
	              private
								
								def establish_wall_objects
									@extrusion_points = @wall.extrusion_points
									@height = @wall.height
									@height_vector = Geom::Vector3d.new(0,0, @height)
									@length = @wall.length
									@vector = @wall.vector
									@direction = @wall.vector.normalize
									@thickness = @wall.thickness
								end

								def establish_presentation_catalog
									@mortar_presentation = WALL_PRESENTATION_CATALOG[@wall.presentation][CONCRETE_BOX_DESCRIPTION_PLAIN]
									@brick_presentation = WALL_PRESENTATION_CATALOG[@wall.presentation][BRICK_DESCRIPTION_RED_BRICK]
									@plaster_presentation = WALL_PRESENTATION_CATALOG[@wall.presentation][CONCRETE_BOX_DESCRIPTION_PLASTER]

								end

								def establish_construction_data
									@brick_height = 65.mm
									@brick_length = 215.mm
									@mortar_thickness = 10.mm
									@mortar_joint_radius = 5.mm
									@plaster_thickness = 15.mm
									@rectangle_points = [] # This is the rectangular that is formed if we cut out the mittered area
								end

								def register_components
									register_brick_at_mittered_start_position
									register_brick_at_mittered_end_position
									register_brick_at_the_rectangle_area
									register_plaster_along_the_wall
								end

								def register_brick_at_mittered_start_position
									mitter_vector = @extrusion_points[0].vector_to(@extrusion_points[3])
									angle = mitter_vector.angle_between(@direction)
									bp = [] # brick points
									pp = [] # plaster points
									if angle < 90.degrees - 0.001
										bp0_offset_dist = @plaster_thickness/Math.sin(angle)
										perpendicular_vector = @wall.perpendicular_vector(:right)

										bp[0] = @extrusion_points[0].offset(mitter_vector, bp0_offset_dist)
										bp[1] = @extrusion_points[3].offset(perpendicular_vector, @thickness - @plaster_thickness)
										bp[2] = @extrusion_points[3]

										pp[0] = @extrusion_points[0].clone
										pp[1] = @extrusion_points[3].offset(perpendicular_vector, @thickness)
										pp[2] = bp[1].clone
										pp[3] = bp[0].clone

										@rectangle_points[0] = bp[1]
										@rectangle_points[3] = bp[2].offset(perpendicular_vector, @plaster_thickness)
									elsif angle > 90.degrees + 0.001
										bp0_offset_dist = @plaster_thickness/Math.sin(180.degrees - angle)
										perpendicular_vector = @wall.perpendicular_vector(:left)

										bp[0] = @extrusion_points[3].offset(mitter_vector.reverse, bp0_offset_dist)
										bp[1] = @extrusion_points[0]
										bp[2] = @extrusion_points[0].offset(perpendicular_vector, @thickness - @plaster_thickness)

										pp[0] = bp[0].clone
										pp[1] = bp[1].clone
										pp[2] = @extrusion_points[0].offset(perpendicular_vector, @thickness)
										pp[3] = @extrusion_points[3].clone

										@rectangle_points[0] = bp[1].offset(perpendicular_vector, @plaster_thickness)
										@rectangle_points[3] = bp[2]
									else
										# The wall is not mittered, no need to create a brick
										perpendicular_vector = @wall.perpendicular_vector(:left)

										@rectangle_points[0] = @extrusion_points[0].offset(perpendicular_vector, @plaster_thickness)
										@rectangle_points[3] = @extrusion_points[0].offset(perpendicular_vector, @thickness - @plaster_thickness)
										return
									end
									stack_mittered_brick(bp)
									register_plaster(pp, @height_vector)
								end

								def register_brick_at_mittered_end_position
									mitter_vector = @extrusion_points[1].vector_to(@extrusion_points[2])
									angle = mitter_vector.angle_between(@direction)
									bp = []
									pp = []
									if angle < 90.degrees - 0.001
										bp0_dist = @plaster_thickness/Math.sin(angle)
										perpendicular_vector = @wall.perpendicular_vector(:left)

										bp[0] = @extrusion_points[2].offset(mitter_vector.reverse, bp0_dist)
										bp[1] = @extrusion_points[1]
										bp[2] = @extrusion_points[1].offset(perpendicular_vector, @thickness - @plaster_thickness)

										pp[0] = bp[2].clone
										pp[1] = bp[0].clone
										pp[2] = @extrusion_points[2].clone
										pp[3] = @extrusion_points[1].offset(perpendicular_vector, @thickness)

										@rectangle_points[1] = bp[1].offset(perpendicular_vector, @plaster_thickness)
										@rectangle_points[2] = bp[2]
									elsif angle > 90.degrees + 0.001
										bp0_dist = @plaster_thickness/Math.sin(180.degrees - angle)
										perpendicular_vector = @wall.perpendicular_vector(:right)

										bp[0] = @extrusion_points[1].offset(mitter_vector, bp0_dist)
										bp[1] = @extrusion_points[2].offset(perpendicular_vector, @thickness - @plaster_thickness)
										bp[2] = @extrusion_points[2]

										pp[0] = @extrusion_points[2].offset(perpendicular_vector, @thickness)
										pp[1] = @extrusion_points[1].clone
										pp[2] = bp[0].clone
										pp[3] = bp[1].clone

										@rectangle_points[1] = bp[1]
										@rectangle_points[2] = bp[2].offset(perpendicular_vector, @plaster_thickness)
									else
										# The wall is not mittered, no need to create a brick
										@rectangle_points[1] = @extrusion_points[1]
										@rectangle_points[2] = @extrusion_points[2]
										return
									end
									stack_mittered_brick(bp)
									register_plaster(pp, @height_vector)
								end

								def stack_mittered_brick(bp)
									course_height = @brick_height + @mortar_thickness
									num_courses = (@height / course_height).floor
									leftover_height = @height - (num_courses * course_height)

									brick_vector  = Geom::Vector3d.new(0, 0, @brick_height)
									mortar_vector = Geom::Vector3d.new(0, 0, @mortar_thickness)

									num_courses.times do
										register_brick(bp.clone, brick_vector)
										bp.map! {|pt| pt.offset(brick_vector)}
										register_mortar(bp.clone, mortar_vector)
										bp.map! {|pt| pt.offset(mortar_vector)}
									end

									if leftover_height > 0
										final_vector = Geom::Vector3d.new(0, 0, leftover_height)
										register_brick(bp.clone, final_vector)
									end
								end

								def register_brick_at_the_rectangle_area
 									course_height = @brick_height + @mortar_thickness
									num_courses = (@height / course_height).floor
									leftover_height = @height - (num_courses * course_height)

									elevation_vector = Geom::Vector3d.new(0, 0, 0)
									first_brick_length = @brick_length

									num_courses.times do
										lay_brick_along_wall_length(elevation_vector, first_brick_length, @brick_height)
										elevation_vector.z += @brick_height
										lay_mortar_along_wall_length(elevation_vector)
										elevation_vector.z += @mortar_thickness
										if first_brick_length == @brick_length
											first_brick_length = @brick_length/2
										else
											first_brick_length = @brick_length
										end
									end

									if leftover_height > 0
										lay_brick_along_wall_length(elevation_vector, first_brick_length, leftover_height)
									end

								end

								def lay_brick_along_wall_length(elevation_vector, first_brick_length, brick_height)
									bp = []
									bp[0] = @rectangle_points[0].offset(elevation_vector)
									bp[3] = @rectangle_points[3].offset(elevation_vector)
									bp[1] = bp[0].offset(@direction, first_brick_length)
									bp[2] = bp[3].offset(@direction, first_brick_length)

									mp = []
									mortar_joint_center_1 = bp[1].offset(@direction, @mortar_joint_radius)
									mortar_joint_center_2 = bp[2].offset(@direction, @mortar_joint_radius)
									mp += arc_points(mortar_joint_center_1, Z_AXIS, @mortar_joint_radius,
																	 0.degrees, 180.degrees, 12, @direction)
									mp += arc_points(mortar_joint_center_2, Z_AXIS, @mortar_joint_radius,
																	 180.degrees, 360.degrees, 12, @direction)

									course_length = @brick_length + @mortar_thickness
									brick_height_vector = Geom::Vector3d.new(0, 0, brick_height)

									# Registering the first brick
									register_brick(bp.clone, brick_height_vector)
									bp[0] = bp[0].offset(@direction, first_brick_length + @mortar_thickness)
									bp[3] = bp[3].offset(@direction, first_brick_length + @mortar_thickness)
									bp[1] = bp[1].offset(@direction, course_length)
									bp[2] = bp[2].offset(@direction, course_length)
									register_mortar(mp.clone, brick_height_vector, Z_AXIS)
									mp.map! {|pt| pt.offset(@direction, course_length)}

									leftover_rectangular_length = rectangular_length - (first_brick_length + @mortar_thickness)
									num_courses = (leftover_rectangular_length / course_length).floor
									leftover_length = leftover_rectangular_length - (num_courses * course_length)

									num_courses.times do
										register_brick(bp.clone, brick_height_vector)
										bp.map! {|pt| pt.offset(@direction, course_length)}
										register_mortar(mp.clone, brick_height_vector, Z_AXIS)
										mp.map! {|pt| pt.offset(@direction, course_length)}
									end

									if leftover_length > 0
										bp[1] = bp[0].offset(@direction, leftover_length)
										bp[2] = bp[3].offset(@direction, leftover_length)
										register_brick(bp.clone, brick_height_vector)
									end

								end

								def lay_mortar_along_wall_length(elevation_vector)
									mortar_joint_center_elevation = elevation_vector.length + @mortar_joint_radius

									mp = []
									mortar_joint_center_1 = @rectangle_points[0].offset(Z_AXIS, mortar_joint_center_elevation)
									mortar_joint_center_2 = @rectangle_points[3].offset(Z_AXIS, mortar_joint_center_elevation)
									mp += arc_points(mortar_joint_center_1, @direction, @mortar_joint_radius,
																	 180.degrees, 360.degrees, 12, Z_AXIS)
									mp += arc_points(mortar_joint_center_2, @direction, @mortar_joint_radius,
																	 0.degrees, 180.degrees, 12, Z_AXIS)

									register_mortar(mp, @rectangle_points[1] - @rectangle_points[0], @direction)
								end

								def register_plaster_along_the_wall
									pp_1 = [@extrusion_points[0], @rectangle_points[0],
													@rectangle_points[0].offset(@height_vector), @extrusion_points[0].offset(@height_vector)]
									pp_2 = [@rectangle_points[3], @extrusion_points[3],
													@extrusion_points[3].offset(@height_vector), @rectangle_points[3].offset(@height_vector)]
									register_plaster(pp_1, @vector)
									register_plaster(pp_2, @vector)
								end

								def register_brick(bp, height_vector)
									new_brick = Brick.new(@wall, bp, height_vector, @brick_presentation, BRICK_DESCRIPTION_RED_BRICK)
									@wall.components[new_brick.id] = new_brick
								end

								def register_mortar(pts, vector, soft_edge_vector = nil)
									new_mortar = ConcreteBox.new(@wall, pts, vector, @mortar_presentation, CONCRETE_BOX_DESCRIPTION_PLAIN)
									new_mortar.soft_edge_vector = soft_edge_vector if soft_edge_vector
									@wall.components[new_mortar.id] = new_mortar
								end

								def register_plaster(pts, vector)
									new_plaster = ConcreteBox.new(@wall, pts, vector, @plaster_presentation, CONCRETE_BOX_DESCRIPTION_PLASTER)
									@wall.components[new_plaster.id] = new_plaster
								end

								def rectangular_length
									(@rectangle_points[1] - @rectangle_points[0]).length
								end

							end
            end
          end
        end
      end
    end
  end
end