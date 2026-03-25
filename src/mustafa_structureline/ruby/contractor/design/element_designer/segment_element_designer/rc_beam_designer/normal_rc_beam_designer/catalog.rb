module Mustafa
  module StructureLine
    module Contractor
      module Design
        module ElementDesigner
          module RcBeamDesigner
            module NormalRcBeamDesigner
              module Catalog
                extend self

                include Utils::Constants
                include Component::RebarCatalog
                include Component::ConcreteBoxCatalog

                NORMAL_RC_BEAM_PRESENTATION_SIMPLE = {
                  REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_HIDDEN,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_HIDDEN,
                  REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_HIDDEN
                }

                NORMAL_RC_BEAM_PRESENTATION_FULL = {
                  REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_FULL,
                  REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_FULL
                }

                NORMAL_RC_BEAM_PRESENTATION_PARTIAL_CONCRETE = {
                  REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => CONCRETE_BOX_PRESENTATION_PARTIAL,
                  REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_FULL
                }

                NORMAL_RC_BEAM_PRESENTATION_NO_CONCRETE = {
                  REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_FULL,
                  CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_HIDDEN,
                  REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_FULL
                }

                RC_BEAM_PRESENTATION_CATALOG = {
                  ELEMENT_PRESENTATION_SIMPLE => NORMAL_RC_BEAM_PRESENTATION_SIMPLE,
                  ELEMENT_PRESENTATION_FULL => NORMAL_RC_BEAM_PRESENTATION_FULL,
                  RC_BEAM_PRESENTATION_PARTIAL_CONCRETE => NORMAL_RC_BEAM_PRESENTATION_PARTIAL_CONCRETE,
                  RC_BEAM_PRESENTATION_NO_CONCRETE => NORMAL_RC_BEAM_PRESENTATION_NO_CONCRETE
                }

              end
            end
          end
        end
      end
    end
  end
end