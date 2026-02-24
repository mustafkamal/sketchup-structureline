module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Standard
          module ConfinedMasonry

            CONFINED_MASONRY_ELEMENT_NAME_COLUMN = "Column".freeze
            CONFINED_MASONRY_ELEMENT_NAME_WALL = "Wall".freeze
            CONFINED_MASONRY_ELEMENT_NAME_RING_BEAM = "Ring beam".freeze

            class StructureStandard < BaseStandard

              include Catalog

              attr_accessor :columns, :walls, :ring_beams, :element_managers
              attr_reader :structure,
                          :node_elements_attachment_table, :segment_elements_attachment_table, :ring_beam_offset

              def initialize(structure)
                @structure = structure
                establish_objects
                setup_structure_element_managers
                establish_elements_attachment_table
              end

              def get_vertical_limit
                @overall_height
              end

              def ring_beam_offset
                Geom::Vector3d.new(0, 0, @wall_height)
              end

              def process_user_input(key)
                case key
                when 49,  87 # Angka 1 atau huruf w
                  toggle_attachment(@node_elements_attachment_table, @columns)
                when 50 # Angka 2
                  toggle_attachment(@segment_elements_attachment_table, @walls)
                else
                  return
                end
              end

              def get_element_style(element_name)
                CONFINED_MASONRY_STYLE_CATALOG[@structure.style][element_name]
              end

              def get_element_presentation(element_name)
                CONFINED_MASONRY_PRESENTATION_CATALOG[@structure.presentation][element_name]
              end

              private

              def establish_objects
                # Untuk sementara dimensi2 ini di hard coded
                # Nanti in the future bakal ada UI nya untuk input data2 ini
                @overall_height = 2200.mm
                @column_size = 100.mm
                @ring_beam_height = 200.mm
                @ring_beam_width = 100.mm
                @wall_thickness = 100.mm
                @wall_height = @overall_height - @ring_beam_height
              end

              def setup_structure_element_managers
                @columns = Elements::Columns.new(CONFINED_MASONRY_ELEMENT_NAME_COLUMN, @structure, @column_size,
                                                 @overall_height)
                @walls = Elements::Walls.new(CONFINED_MASONRY_ELEMENT_NAME_WALL, @structure, @wall_thickness,
                                             @wall_height)
                @ring_beams = Elements::RingBeams.new(CONFINED_MASONRY_ELEMENT_NAME_RING_BEAM, @structure,
                                                      @ring_beam_width, @ring_beam_height)
                @element_managers = {@columns.name => @columns, @walls.name => @walls, @ring_beams.name => @ring_beams}
              end

              def establish_elements_attachment_table
                @node_elements_attachment_table = {@columns.name => true}
                @segment_elements_attachment_table = {@walls.name => true, @ring_beams.name => true}
              end

              def toggle_attachment(table, element)
                table[element.name] = !table[element.name]
              end

            end
          end
        end
      end
    end
  end
end