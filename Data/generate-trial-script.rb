#!/usr/bin/env ruby
#
# Generates C code containing the data for trial sequences.

sequenceCount = 3;
stepCount = 20;
minDistance = 0.1;

puts '#import "CTDTrialScriptData.h"'
puts
puts "CTDTrialScriptData trialScriptData ="
puts "{"
puts "    #{sequenceCount},"
puts "    {"

(1..sequenceCount).each do |sequenceIndex|
  puts "        {"
  puts "            #{stepCount},"
  puts "            {"

  prevColor = 0;
  (1..stepCount).each do |stepIndex|
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

    puts "                { %d, %.5f, %.5f, %.5f, %.5f }%s" % [color, x1, y1, x2, y2, stepIndex < stepCount ? "," : ""]

    prevColor = color
  end

  puts "            }"
  puts "        }%s" % [sequenceIndex < sequenceCount ? "," : ""]
end

puts "    }"
puts "};"
