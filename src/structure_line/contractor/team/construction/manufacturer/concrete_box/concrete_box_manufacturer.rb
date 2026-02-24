module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Manufacturer
            module ConcreteBoxManufacturer
              extend self

              include Utils::Constants
              include Design::ElementDesigner::Component::ConcreteBoxComponent::Description

              CONCRETE_BOX_PRESENTATION_MAP = {
                COMPONENT_PRESENTATION_FULL => :call_full_concrete_box_fabricator,
                CONCRETE_BOX_PRESENTATION_PARTIAL => :call_partial_concrete_box_fabricator,
              }

              CONCRETE_BOX_DESCRIPTION_MAP = {
                CONCRETE_BOX_DESCRIPTION_PLAIN => :call_plain_concrete_artist,
                CONCRETE_BOX_DESCRIPTION_PLASTER => :call_plain_concrete_artist,
              }

              def begin_manufacture(concrete_box)
                @concrete_box = concrete_box
                @concrete_box.establish_group
                pick_concrete_box_fabricator
                pick_concrete_box_artist
              end

              private

              def pick_concrete_box_fabricator
                method = CONCRETE_BOX_PRESENTATION_MAP[@concrete_box.presentation]
                raise ArgumentError, "Concrete box manufacturer does not recognized presentation" unless method
                send(method)
              end

              def call_full_concrete_box_fabricator
                FullConcreteBoxFabricator.fabricate(@concrete_box)
              end

              def call_partial_concrete_box_fabricator
                PartialConcreteBoxFabricator.fabricate(@concrete_box)
              end

              def pick_concrete_box_artist
                method = CONCRETE_BOX_DESCRIPTION_MAP[@concrete_box.description]
                raise ArgumentError, "Concrete box manufacturer does not recognized description" unless method
                send(method)
              end

              def call_plain_concrete_artist
                PlainConcreteArtist.paint(@concrete_box)
              end


            end
          end
        end
      end
    end
  end
end