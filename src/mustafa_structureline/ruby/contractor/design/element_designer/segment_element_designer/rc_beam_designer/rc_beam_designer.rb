require_relative 'normal_rc_beam_designer/normal_rc_beam_designer'

module Mustafa
  module StructureLine
    module Contractor
      module Design
        module ElementDesigner
          module RcBeamDesigner
            extend self

            include Component
            include Utils::Constants

            RC_BEAM_DESIGN_STYLE_MAP = {
              RC_BEAM_STYLE_NORMAL => :design_normal_rc_beam
            }

            def design(rc_beam)
              @rc_beam = rc_beam
              method = RC_BEAM_DESIGN_STYLE_MAP[@rc_beam.style]
              raise ArgumentError, "No design for this rc beam style" unless method
              send(method)
            end

            private

            def design_normal_rc_beam
              NormalRcBeamDesigner.design(@rc_beam)
            end

          end
        end
      end
    end
  end
end