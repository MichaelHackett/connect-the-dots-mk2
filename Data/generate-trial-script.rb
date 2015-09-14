#!/usr/bin/env ruby
#
# Generates CSV rows containing the data for trial sequences.

sequenceCount = 3;
sequenceLength = 20;
minDistance = 0.2;

prevColor = 0;
(1..sequenceCount).each do |sequenceIndex|
  (1..sequenceLength).each do |stepIndex|
    x1 = rand(0.0..1.0)
    y1 = rand(0.0..1.0)

    begin
      x2 = rand(0.0..1.0)
      y2 = rand(0.0..1.0)
      distance = Math.hypot(x2-x1, y2-y1)
    end while distance < minDistance

    begin
      color = rand(1..3)
    end while color == prevColor

    puts "%d, %.5f, %.5f, %.5f, %.5f" % [color, x1, y1, x2, y2]

    prevColor = color
  end
end
