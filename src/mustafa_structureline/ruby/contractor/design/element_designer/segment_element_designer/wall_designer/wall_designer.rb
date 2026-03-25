require_relative 'brick_masonry_wall_designer/brick_masonry_wall_designer'

module Mustafa
  module StructureLine
    module Contractor
      module Design
        module ElementDesigner
          module WallDesigner
            extend self

            include Utils::Constants

            WALL_DESIGN_STYLE_MAP = {
              WALL_STYLE_BRICK_MASONRY => :design_brick_masonry_wall
            }

            def design(wall)
              @wall = wall
              method = WALL_DESIGN_STYLE_MAP[@wall.style]
              raise ArgumentError, "No design for this column style" unless method
              send(method)
            end

            private

            def design_brick_masonry_wall
              BrickMasonryWallDesigner.design(@wall)
            end

          end
        end
      end
    end
  end
end