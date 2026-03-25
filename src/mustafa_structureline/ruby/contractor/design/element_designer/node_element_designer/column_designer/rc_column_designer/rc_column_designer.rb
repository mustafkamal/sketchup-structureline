require_relative 'catalog'

module Mustafa
  module StructureLine
    module Contractor
			module Design
				module ElementDesigner
					module ColumnDesigner
						module RcColumnDesigner
							extend self

							include Component
							include Component::RebarCatalog
							include Component::ConcreteBoxCatalog
							include Catalog
							include Utils::Constants

							def design(column)
								@column = column
								establish_column_objects
								establish_presentation_catalog
								establish_construction_data
								handle_rebar_registration
								handle_stirrup_registration
								register_concrete_box
							end

							private

							def establish_column_objects
								@position = @column.position
								@size = @column.size
								@height = @column.height
								@height_vector = Geom::Vector3d.new(0, 0, @height)
								@direction = @column.direction
								@extrusion_points = @column.extrusion_points
								@components = @column.components
							end

							def establish_presentation_catalog
								@rebar_presentation = COLUMN_PRESENTATION_CATALOG[@column.presentation][REBAR_DESCRIPTION_DEFORMED]
								@stirrup_presentation = COLUMN_PRESENTATION_CATALOG[@column.presentation][REBAR_DESCRIPTION_STIRRUP]
								@concrete_box_presentation =
									COLUMN_PRESENTATION_CATALOG[@column.presentation][CONCRETE_BOX_DESCRIPTION_PLAIN]
							end

							def establish_construction_data
								@rebar_size = 10.mm
								@rebar_pts = []
								@stirrup_size = 6.mm
								@stirrup_spacing = 150.mm
							end

							def handle_rebar_registration
								rotation_transform = Geom::Transformation.rotation(@position, Z_AXIS, 315.degrees)
								u1 = @direction.transform(rotation_transform)
								off_dist = Math.hypot(0.2*@size, 0.2*@size)
								@rebar_pts[3] = @extrusion_points[3].offset(u1, off_dist)
								register_rebar(@rebar_pts[3])
								off_dist = Math.hypot(0.8*@size, 0.8*@size)
								@rebar_pts[1] = @extrusion_points[3].offset(u1, off_dist)
								register_rebar(@rebar_pts[1])

								rotation_transform = Geom::Transformation.rotation(@position, Z_AXIS, 45.degrees)
								u1 = @direction.transform(rotation_transform)
								off_dist = Math.hypot(0.2*@size, 0.2*@size)
								@rebar_pts[0] = @extrusion_points[0].offset(u1, off_dist)
								register_rebar(@rebar_pts[0])
								off_dist = Math.hypot(0.8*@size, 0.8*@size)
								@rebar_pts[2] = @extrusion_points[0].offset(u1, off_dist)
								register_rebar(@rebar_pts[2])
							end

							def handle_stirrup_registration
								sp = []
								bend_radius = @rebar_size/2 + @stirrup_size/2
								center_0 = @rebar_pts[0].offset(Z_AXIS, 50.mm)
								center_3 = @rebar_pts[3].offset(Z_AXIS, 50.mm)
								center_2 = @rebar_pts[2].offset(Z_AXIS, 50.mm)
								center_1 = @rebar_pts[1].offset(Z_AXIS, 50.mm)

								sp += arc_points(center_0, Z_AXIS, bend_radius, 180.degrees, 270.degrees,12, @direction)
								sp += arc_points(center_1, Z_AXIS, bend_radius, 270.degrees, 360.degrees,12, @direction)
								sp += arc_points(center_2, Z_AXIS, bend_radius, 0.degrees, 90.degrees,12, @direction)
								sp += arc_points(center_3, Z_AXIS, bend_radius, 90.degrees, 180.degrees,12, @direction)
								sp += [sp.first]

								z = 0.mm
								while z < @height - 50.mm
									new_rebar = Rebar.new(@column, sp.clone, @stirrup_size, @stirrup_presentation,
																				REBAR_DESCRIPTION_STIRRUP)
									@components[new_rebar.id] = new_rebar
									z += @stirrup_spacing
									sp.map! {|pt| pt.offset(Z_AXIS, @stirrup_spacing)}
								end

							end

							def register_rebar(pt1)
								new_rebar = Rebar.new(@column, [pt1, pt1.offset(Z_AXIS, @height)], @rebar_size,
																			@rebar_presentation, REBAR_DESCRIPTION_DEFORMED)
								@column.components[new_rebar.id] = new_rebar
							end

							def register_concrete_box
								pts = [@extrusion_points[0], @extrusion_points[1], @extrusion_points[2], @extrusion_points[3]]
								new_concrete_box = ConcreteBox.new(@column, pts, @height_vector,
																									 @concrete_box_presentation, CONCRETE_BOX_DESCRIPTION_PLAIN)
								@column.components[new_concrete_box.id] = new_concrete_box
							end

						end
					end
				end
			end
    end
  end
end