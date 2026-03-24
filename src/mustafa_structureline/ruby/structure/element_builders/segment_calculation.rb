require_relative '../../../utils/ls/line_relation'

module Mustafa
  module StructureLine
    module Structure
      module ElementBuilders
        module SegmentCalculation
          include Utils::LineRelation

          def relation(segment)
            Utils::LineRelation.relation(self.start_position, self.end_position,
                                         segment.start_position, segment.end_position)
          end

          def identical?(segment)
            Utils::LineRelation.identical?(self.start_position, self.end_position,
                                           segment.start_position, segment.end_position)
          end

          def identical_same_direction?(segment)
            Utils::LineRelation.identical_same_direction?(self.start_position, self.end_position,
                                                          segment.start_position, segment.end_position)
          end

          def identical_different_direction?(segment)
            Utils::LineRelation.identical_different_direction?(self.start_position, self.end_position,
                                                               segment.start_position, segment.end_position)
          end

          def colinear?(segment)
            Utils::LineRelation.colinear?(self.start_position, self.end_position,
                                          segment.start_position, segment.end_position)
          end

          def get_colinear_type(segment)
            Utils::LineRelation.get_colinear_type(self.start_position, self.end_position,
                                                  segment.start_position, segment.end_position)
          end

          def perpendicular_touch?(segment)
            end_point_on_segment?(segment) || start_point_on_segment?(segment)
          end

          def end_point_on_segment?(segment)
            Utils::LineRelation.point_on_segment?(self.end_position, segment.start_position, segment.end_position)
          end

          def start_point_on_segment?(segment)
            Utils::LineRelation.point_on_segment?(self.start_position, segment.start_position, segment.end_position)
          end

          def point_on_point?(segment)
            Utils::LineRelation.point_on_point?(self.start_position, self.end_position,
                                                segment.start_position, segment.end_position)
          end
        end
      end
    end
  end
end