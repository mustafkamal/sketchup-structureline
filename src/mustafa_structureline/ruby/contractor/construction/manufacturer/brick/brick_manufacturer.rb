require_relative '../../../component/brick/brick_catalog'
require_relative 'artist/red_brick_artist'
require_relative 'fabricator/full_brick_fabricator'

module Mustafa
  module StructureLine
    module Contractor
      module Construction
        module Manufacturer
          module BrickManufacturer
            extend self

            include Utils::Constants
            include Component::BrickCatalog

            BRICK_PRESENTATION_MAP = {
              COMPONENT_PRESENTATION_FULL => :call_full_brick_fabricator
            }

            BRICK_DESCRIPTION_MAP = {
              BRICK_DESCRIPTION_RED_BRICK => :call_red_brick_artist
            }

            def begin_manufacture(brick)
              @brick = brick
              @brick.establish_group
              pick_brick_fabricator
              pick_brick_artist
            end

            private

            def pick_brick_fabricator
              method = BRICK_PRESENTATION_MAP[@brick.presentation]
              raise ArgumentError, "Brick manufacturer does not recognized brick presentation" unless method
              send(method)
            end

            def call_full_brick_fabricator
              FullBrickFabricator.fabricate(@brick)
            end

            def pick_brick_artist
              method = BRICK_DESCRIPTION_MAP[@brick.description]
              raise ArgumentError, "Brick manufacturer does not recognized brick description" unless method
              send(method)
            end

            def call_red_brick_artist
              RedBrickArtist.paint(@brick)
            end

          end
        end
      end
    end
  end
end