require_relative '../../../component/rebar/rebar_catalog'
require_relative 'artist/stirrup_artist'
require_relative 'artist/deformed_rebar_artist'
require_relative 'fabricator/full_rebar_fabricator'

module Mustafa
  module StructureLine
    module Contractor
      module Construction
        module Manufacturer
          module RebarManufacturer
            extend self

            include Utils::Constants
            include Component::RebarCatalog

            REBAR_PRESENTATION_MAP = {
              COMPONENT_PRESENTATION_FULL => :call_full_rebar_fabricator,
            }

            REBAR_DESCRIPTION_MAP = {
              REBAR_DESCRIPTION_DEFORMED => :call_deformed_rebar_artist,
              REBAR_DESCRIPTION_STIRRUP => :call_stirrup_artist,
            }

            def begin_manufacture(rebar)
              @rebar = rebar
              @rebar.establish_group
              pick_rebar_fabricator
              pick_rebar_artist
            end

            private

            def pick_rebar_fabricator
              method = REBAR_PRESENTATION_MAP[@rebar.presentation]
              raise ArgumentError, "Rebar manufacturer does not recognized presentation" unless method
              send(method)
            end

            def call_full_rebar_fabricator
              FullRebarFabricator.fabricate(@rebar)
            end

            def pick_rebar_artist
              method = REBAR_DESCRIPTION_MAP[@rebar.description]
              raise ArgumentError, "Rebar manufacturer does not recognized description" unless method
              send(method)
            end

            def call_deformed_rebar_artist
              DeformedRebarArtist.paint(@rebar)
            end

            def call_stirrup_artist
              StirrupArtist.paint(@rebar)
            end


          end
        end
      end
    end
  end
end