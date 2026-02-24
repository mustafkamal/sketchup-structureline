require_relative 'catalog'

module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module ElementDesigner
            module RcBeamDesigner
              module NormalRcBeamDesigner
                extend self

                include Catalog
                include Component::RebarComponent
                include Component::ConcreteBoxComponent
                include Calculation
                include Utils::Constants

                def design(rc_beam)
                  @rc_beam = rc_beam
                  establish_rc_beam_objects
                  establish_presentation_catalog
                  establish_construction_data
                  register_components
                end

                private

                def establish_rc_beam_objects
                  @extrusion_points = @rc_beam.extrusion_points
                  @height = @rc_beam.height
                  @height_vector = Geom::Vector3d.new(0,0,@height)
                  @length = @rc_beam.length
                  @direction = @rc_beam.vector.normalize
                  @width = @rc_beam.width
                  @vector = @rc_beam.vector
                  @components = @rc_beam.components
                end

                def establish_presentation_catalog
                  @rebar_presentation = RC_BEAM_PRESENTATION_CATALOG[@rc_beam.presentation][REBAR_DESCRIPTION_DEFORMED]
                  @stirrup_presentation = RC_BEAM_PRESENTATION_CATALOG[@rc_beam.presentation][REBAR_DESCRIPTION_STIRRUP]
                  @concrete_box_presentation =
                    RC_BEAM_PRESENTATION_CATALOG[@rc_beam.presentation][CONCRETE_BOX_DESCRIPTION_PLAIN]
                end

                def establish_construction_data
                  @rebar_size = 10.mm
                  @rebar_pts = []
                  @stirrup_size = 8.mm
                  @stirrup_spacing = 200.mm
                  @rectangle_points = []
                end

                def register_components
                  register_concrete_at_mittered_start_position
                  register_concrete_at_mittered_end_position
                  register_concrete_at_rectangular_area
                  handle_rebar_registration
                  handle_stirrup_registration
                end

                def register_concrete_at_mittered_start_position
                  mitter_vector = @extrusion_points[0].vector_to(@extrusion_points[3])
                  angle = mitter_vector.angle_between(@direction)
                  cp = []
                  if angle < 90.degrees - 0.001
                    cp[0] = @extrusion_points[0]
                    cp[1] = @extrusion_points[3].offset(@rc_beam.perpendicular_vector(:right), @width)
                    cp[2] = @extrusion_points[3]

                    @rectangle_points[0] = cp[1]
                    @rectangle_points[3] = cp[2]
                  elsif angle > 90.degrees + 0.001
                    cp[0] = @extrusion_points[0]
                    cp[1] = @extrusion_points[0].offset(@rc_beam.perpendicular_vector(:left), @width)
                    cp[2] = @extrusion_points[3]

                    @rectangle_points[0] = cp[0]
                    @rectangle_points[3] = cp[1]
                  else
                    # The wall is not mittered, no need to create register concrete box
                    @rectangle_points[0] = @extrusion_points[0]
                    @rectangle_points[3] = @extrusion_points[3]
                    return
                  end
                  register_concrete_box(cp, @height_vector)
                end

                def register_concrete_at_mittered_end_position
                  mitter_vector = @extrusion_points[1].vector_to(@extrusion_points[2])
                  angle = mitter_vector.angle_between(@direction)
                  cp = []
                  if angle < 90.degrees - 0.001
                    cp[0] = @extrusion_points[1]
                    cp[1] = @extrusion_points[1].offset(@rc_beam.perpendicular_vector(:left), @width)
                    cp[2] = @extrusion_points[2]

                    @rectangle_points[1] = cp[0]
                    @rectangle_points[2] = cp[1]
                  elsif angle > 90.degrees + 0.001
                    cp[0] = @extrusion_points[1]
                    cp[1] = @extrusion_points[2].offset(@rc_beam.perpendicular_vector(:right), @width)
                    cp[2] = @extrusion_points[2]

                    @rectangle_points[1] = cp[1]
                    @rectangle_points[2] = cp[2]
                  else
                    # The wall is not mittered, no need to create register concrete box
                    @rectangle_points[1] = @extrusion_points[1]
                    @rectangle_points[2] = @extrusion_points[2]
                    return
                  end

                  register_concrete_box(cp, @height_vector)
                end

                def register_concrete_at_rectangular_area
                  cp = [@rectangle_points[0].clone, @rectangle_points[3].clone,
                        @rectangle_points[3].offset(@height_vector), @rectangle_points[0].offset(@height_vector)]
                  register_concrete_box(cp, @vector)
                end

                def handle_rebar_registration
                  rebar_vector_0 = @rc_beam.perpendicular_vector(:left).normalize + Z_AXIS
                  rebar_dist_0 = Math.hypot(0.3*@width, 0.3*@width)
                  @rebar_pts[0] = @rectangle_points[0].offset(rebar_vector_0, rebar_dist_0)
                  @rebar_pts[1] = @rebar_pts[0].offset(Z_AXIS, 0.7*@height)

                  rebar_vector_3 = @rc_beam.perpendicular_vector(:right).normalize + Z_AXIS
                  rebar_dist_3 = Math.hypot(0.3*@width, 0.3*@width)
                  @rebar_pts[3] = @rectangle_points[3].offset(rebar_vector_3, rebar_dist_3)
                  @rebar_pts[2] = @rebar_pts[3].offset(Z_AXIS, 0.7*@height)

                  @rebar_pts.each {|pt| register_rebar(pt)}
                end

                def handle_stirrup_registration
                  sp = []
                  bend_radius = @rebar_size/2 + @stirrup_size/2
                  center_0 = @rebar_pts[0].offset(@direction, 50.mm)
                  center_3 = @rebar_pts[3].offset(@direction, 50.mm)
                  center_2 = @rebar_pts[2].offset(@direction, 50.mm)
                  center_1 = @rebar_pts[1].offset(@direction, 50.mm)

                  sp += arc_points(center_0, @direction, bend_radius, 90.degrees, 180.degrees,12, Z_AXIS)
                  sp += arc_points(center_3, @direction, bend_radius, 180.degrees, 270.degrees,12, Z_AXIS)
                  sp += arc_points(center_2, @direction, bend_radius, 270.degrees, 360.degrees,12, Z_AXIS)
                  sp += arc_points(center_1, @direction, bend_radius, 0.degrees, 90.degrees,12, Z_AXIS)

                  sp += [sp.first]

                  z = 0.mm
                  while z < rectangular_length
                    new_rebar = Rebar.new(@rc_beam, sp.clone, @stirrup_size,
                                          @stirrup_presentation, REBAR_DESCRIPTION_STIRRUP)
                    @rc_beam.components[new_rebar.id] = new_rebar
                    z += @stirrup_spacing
                    sp.map! {|pt| pt.offset(@direction, @stirrup_spacing)}
                  end
                end

                def register_rebar(pt)
                  new_rebar = Rebar.new(@rc_beam, [pt, pt.offset(@direction, rectangular_length)], @rebar_size,
                                        @rebar_presentation, REBAR_DESCRIPTION_DEFORMED)
                  @rc_beam.components[new_rebar.id] = new_rebar
                end

                def register_concrete_box(cp, vector)
									new_concrete_box = ConcreteBox.new(@rc_beam, cp, vector, @concrete_box_presentation,
                                                     CONCRETE_BOX_DESCRIPTION_PLAIN)
                  @rc_beam.components[new_concrete_box.id] = new_concrete_box
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