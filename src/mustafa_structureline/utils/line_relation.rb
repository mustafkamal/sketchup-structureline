module Mustafa
  module StructureLine
    module Utils
      module LineRelation
        IDENTICAL = :identical
        POINT_ON_SEGMENT = :point_on_segment
        POINT_ON_LINE = :point_on_line
        POINT_ON_POINT = :point_on_point
        PARALLEL = :parallel
        PERPENDICULAR = :perpendicular
        SKEWED = :skewed
        COLINEAR_DISJOINT = :colinear_disjoint
        COLINEAR_TOUCH = :colinear_touch
        COLINEAR_OVERLAP = :colinear_overlap
        COLINEAR_COVER = :colinear_cover
        COLINEAR_CONTAINMENT = :colinear_containment
        COLINEAR_COVER_EXTEND = :colinear_cover_extend
        COLINEAR_COVER_PARTIAL = :colinear_cover_partial
        COLINEAR_OVERLAP_EXTEND = :colinear_overlap_extend
        COLINEAR_RELATIONSHIP_NOT_FOUND = :colinear_relationship_not_found

        extend self
        # Method untuk ngereturn relation type dari dua buah line
        #
        # @param b1 Beginning point for line 1 [Sketchup::Point3d]
        # @param e1 End point for line 1 [Sketchup::Point3d]
        # @param b2 Beginning point for line 2 [Sketchup::Point3d]
        # @param e2 End point for line 2 [Sketchup::Point3d]
        def relation(b1, e1, b2, e2)
          return :invalid if b1 == e1 || b2 == e2

          # Vector for line 1
          v1 = e1 - b1
          # Vector for line 2
          v2 = e2 - b2

          if identical?(b1, e1, b2, e2)
            IDENTICAL
          elsif colinear?(b1, e1, b2, e2)
            get_colinear_type(b1, e1, b2, e2)
          elsif point_on_segment?(e1, b2, e2)
            POINT_ON_SEGMENT
          elsif point_on_line?(e1, b2, e2)
            POINT_ON_LINE
          elsif point_on_point?(b1, e1, b2, e2)
            POINT_ON_POINT
          elsif parallel?(v1, v2)
            PARALLEL
          elsif perpendicular?(v1, v2)
            PERPENDICULAR
          else
            SKEWED
          end
        end

        def identical?(b1, e1, b2, e2)
          identical_same_direction?(b1, e1, b2, e2) || identical_different_direction?(b1, e1, b2, e2)
        end

        def identical_same_direction?(b1, e1, b2, e2)
          b1 == b2 && e1 == e2
        end

        def identical_different_direction?(b1, e1, b2, e2)
          b1 == e2 && e1 == b2
        end

        def colinear?(b1, e1, b2, e2)
          dir1 = (e1 - b1).normalize
          dir2 = (e2 - b2).normalize
          return false unless dir1.parallel?(dir2)

          # If both lines start at the same point, they are colinear if their directions are parallel
          return true if b1 == b2

          (b2 - b1).normalize.parallel?(dir1)
        end

        def get_colinear_type(b1, e1, b2, e2)
          # Project all points onto the same axis
          axis = (b1 - e1).normalize
          projections = [b1, e1, b2, e2].map { |pt| pt.vector_to(b1).dot(axis) }

          # Sort projections to find overlap
          s1_min, s1_max = projections[0..1].minmax
          s2_min, s2_max = projections[2..3].minmax

          if s1_min > s2_max || s1_max < s2_min
            COLINEAR_DISJOINT
          elsif s1_min == s2_max || s1_max == s2_min
            COLINEAR_TOUCH
          elsif s1_min < s2_min && s1_max > s2_min && s1_max < s2_max
            COLINEAR_OVERLAP
          elsif s1_min < s2_min && s1_max == s2_max
            COLINEAR_COVER
          elsif s1_min < s2_min && s1_max > s2_max
            COLINEAR_CONTAINMENT
          elsif s1_min == s2_min && s1_max > s2_max
            COLINEAR_COVER_EXTEND
          elsif s1_min == s2_min && s1_max < s2_max
            COLINEAR_COVER_PARTIAL
          elsif s1_min > s2_min && s1_max > s2_max
            COLINEAR_OVERLAP_EXTEND
          else
            COLINEAR_RELATIONSHIP_NOT_FOUND
          end
        end

        def point_on_line?(e1, b2, e2)
          dir = (e2 - b2).normalize
          to_point = (e1 - b2)
          to_point.length > 0 && to_point.normalize.parallel?(dir)
        end

        def point_on_segment?(e1, b2, e2)
          return false if e1 == b2 || e1 == e2
          return false unless point_on_line?(e1, b2, e2)
          point_between?(e1, b2, e2)
        end

        def point_on_point?(b1, e1, b2, e2)
          b1 == b2 || b1 == e2 || e1 == b2 || e1 == e2
        end

        def parallel?(vector1, vector2)
          vector1.parallel?(vector2)
        end

        def perpendicular?(vector1, vector2)
          vector1.dot(vector2).abs < 1e-6
        end

        private

        def point_between?(e1, b2, e2, tol: 1e-6)
          v0 = e1 - b2
          v1 = e2 - b2

          # 1. Colinearity check via cross product magnitude
          #    |v0 × v1| should be near zero if v0 is parallel to v1
          return false if v0.cross(v1).length > tol

          # 2. Projection check via dot product
          #    dot = v0 • v1 gives how far along v1 the point projects
          dot = v0.dot(v1)
          sq_len = v1.dot(v1)

          # 3. Bounds check: 0 ≤ dot ≤ |v1|² (with tolerance)
          dot >= -tol && dot <= sq_len + tol
        end
      end
    end
  end
end