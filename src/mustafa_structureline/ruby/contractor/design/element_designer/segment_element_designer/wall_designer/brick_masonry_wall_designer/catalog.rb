module Mustafa
  module StructureLine
    module Contractor
      module Design
        module ElementDesigner
          module WallDesigner
            module BrickMasonryWallDesigner
              module Catalog
                extend self

                include Component::BrickCatalog
                include Component::ConcreteBoxCatalog
                include Utils::Constants

                BRICK_MASONRY_WALL_PRESENTATION_SIMPLE = {
                  BRICK_DESCRIPTION_RED_BRICK => COMPONENT_PRESENTATION_HIDDEN,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_HIDDEN,
                  CONCRETE_BOX_DESCRIPTION_PLASTER => COMPONENT_PRESENTATION_HIDDEN
                }

                BRICK_MASONRY_WALL_PRESENTATION_FULL = {
                  BRICK_DESCRIPTION_RED_BRICK => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLASTER => COMPONENT_PRESENTATION_FULL
                }

                BRICK_MASONRY_WALL_PRESENTATION_PARTIAL_PLASTER = {
                  BRICK_DESCRIPTION_RED_BRICK => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLASTER => CONCRETE_BOX_PRESENTATION_PARTIAL
                }

                BRICK_MASONRY_WALL_PRESENTATION_NO_PLASTER = {
                  BRICK_DESCRIPTION_RED_BRICK => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLASTER => COMPONENT_PRESENTATION_HIDDEN
                }

                WALL_PRESENTATION_CATALOG = {
                  ELEMENT_PRESENTATION_SIMPLE => BRICK_MASONRY_WALL_PRESENTATION_SIMPLE,
                  ELEMENT_PRESENTATION_FULL => BRICK_MASONRY_WALL_PRESENTATION_FULL,
                  WALL_PRESENTATION_PARTIAL_PLASTER => BRICK_MASONRY_WALL_PRESENTATION_PARTIAL_PLASTER,
                  WALL_PRESENTATION_NO_PLASTER => BRICK_MASONRY_WALL_PRESENTATION_NO_PLASTER
                }

              end
            end
          end
        end
      end
    end
  end
end