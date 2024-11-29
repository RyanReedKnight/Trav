include("direction.jl")

using .DirectionModule

test = AngleDegreesMinutesSeconds(89,0,0.0)
test3 = AngleDegreesMinutesSeconds(788,0,0.0)
b = CardinalBearing(North,East,test)
test2 = AngleDegreesMinutesSeconds(test)
println(test2)

println(b)

println(_45d_+_45d_)

println(test3 > test)
