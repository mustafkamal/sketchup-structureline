module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module ElementDesigner
            module ColumnDesigner
              module RcColumnDesigner
                module Catalog
                  extend self

                  include Utils::Constants
                  include Component
                  include BrickComponent::Description
                  include ConcreteBoxComponent::Description
                  include RebarComponent::Description

                  RC_COLUMN_PRESENTATION_SIMPLE = {
                    REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_HIDDEN,
                    REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_HIDDEN,
                    CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_HIDDEN
                  }

                  RC_COLUMN_PRESENTATION_FULL = {
                    REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_FULL,
                    REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_FULL,
                    CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_FULL
                  }

                  RC_COLUMN_PRESENTATION_PARTIAL = {
                    REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_FULL,
                    REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_FULL,
                    CONCRETE_BOX_DESCRIPTION_PLAIN => CONCRETE_BOX_PRESENTATION_PARTIAL
                  }

                  RC_COLUMN_PRESENTATION_NO_CONCRETE = {
                    REBAR_DESCRIPTION_DEFORMED => COMPONENT_PRESENTATION_FULL,
                    REBAR_DESCRIPTION_STIRRUP => COMPONENT_PRESENTATION_FULL,
                    CONCRETE_BOX_DESCRIPTION_PLAIN => COMPONENT_PRESENTATION_HIDDEN
                  }

                  COLUMN_PRESENTATION_CATALOG = {
                    ELEMENT_PRESENTATION_SIMPLE => RC_COLUMN_PRESENTATION_SIMPLE,
                    ELEMENT_PRESENTATION_FULL => RC_COLUMN_PRESENTATION_FULL,
                    COLUMN_PRESENTATION_PARTIAL_CONCRETE => RC_COLUMN_PRESENTATION_PARTIAL,
                    COLUMN_PRESENTATION_NO_CONCRETE => RC_COLUMN_PRESENTATION_NO_CONCRETE
                  }

                end
              end
            end
          end
        end
      end
    end
  end
end