module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module ElementDesigner
            module Component
							module RebarComponent
								class Rebar < BaseComponent

									include Utils::Constants
									include Calculation

									attr_reader :pts, :diameter

									def initialize(element, pts, diameter, presentation, description, id = SecureRandom.uuid)
										@element = element
										@pts = pts
										@diameter = diameter
										@presentation = presentation
										@description = description
										@id = id
										@type = COMPONENT_TYPE_REBAR
									end

									def origin_point
										@pts[0]
									end

									def origin_vector
										@pts[0].vector_to(@pts[1])
									end

									def end_vector
										@pts[-2].vector_to(@pts[-1])
									end

								end
							end

            end
          end
        end
      end
    end
  end
end