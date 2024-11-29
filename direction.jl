module DirectionModule

export CardinalDirectionLat, North, South
export CardinalDirectionLon, East, West
export AngleDegreesMinutesSeconds,_45d_
export reduce_AngleDegreesMinutesSeconds
export CardinalBearing

# Enum for North/South
@enum CardinalDirectionLat begin
    North = 1
    South = 2
end

# Enum for East/West
@enum CardinalDirectionLon begin
    East = 1
    West = 2
end




struct AngleDegreesMinutesSeconds
   degrees::Int
   minutes::Int
   seconds::Float64
   decimal::Float64

   # Standard constructor.
   function AngleDegreesMinutesSeconds(degrees::Int,minutes::Int,seconds::Float64)

       # Reduce seconds until under 60, add excess to minutes.
       while seconds >= 60.000000
           seconds -= 60.0
           minutes += 1
       end
       # Reduce Minutes until under 60, add excess to degrees.
       while minutes >= 60
           minutes -= 60
           degrees += 1
       end
       # Add adjusted fields to your new object.
       return new(degrees,minutes,seconds,Float(degrees) + Float(minutes)/60.0 + Float(seconds)/3600)
   end

   # Clone constructor.
   function AngleDegreesMinutesSeconds(angle::AngleDegreesMinutesSeconds)
      return AngleDegreesMinutesSeconds(angle.degrees,angle.minutes,angle.seconds)
   end

   # Single arg constructor
   function AngleDegreesMinutesSeconds(degrees::Int)
      return AngleDegreesMinutesSeconds(degrees,0,0.00)
   end

end

function to_string(angle::AngleDegreesMinutesSeconds)
    degrees = string(angle.degrees)
    minutes = string(angle.minutes)
    seconds = string(angle.seconds)

    if angle.seconds < 10.0
        seconds = "0"*seconds
    end

    if angle.minutes < 10
        minutes = "0"*minutes
    end

    return "$(degrees)°$(minutes)\'$(seconds)\""
end

# Return new AngleDegreesMinutesSeconds such that it is between 0d and 360d
function reduce_AngleDegreesMinutesSeconds(angle::AngleDegreesMinutesSeconds)
    degrees = angle.degrees
    minutes = angle.minutes
    seconds = angle.seconds

    while degrees > 360
        degrees -= 360
    end
    return AngleDegreesMinutesSeconds(degrees,minutes,seconds)
end



# Overload Base functions for AngleDegreesMinutesSeconds

function Base.show(io::IO,x::AngleDegreesMinutesSeconds)
   print(io,"AngleDegreesMinutesSeconds($(to_string(x)))")
end

function Base.:(==)(a::AngleDegreesMinutesSeconds, b::AngleDegreesMinutesSeconds)
    return a.degrees == b.degrees && a.minutes == b.minutes && a.seconds == b.seconds
end

# Overloading `<` for comparison
function Base.:(<)(a::AngleDegreesMinutesSeconds, b::AngleDegreesMinutesSeconds)
    return (a.degrees < b.degrees) || (a.degrees == b.degrees && a.minutes < b.minutes) ||
        (a.degrees == b.degrees && a.minutes == b.minutes && a.seconds < b.seconds)
end

# Overloading `>` for comparison
function Base.:(>)(a::AngleDegreesMinutesSeconds, b::AngleDegreesMinutesSeconds)
    return (a.degrees > b.degrees) || (a.degrees == b.degrees && a.minutes > b.minutes) ||
        (a.degrees == b.degrees && a.minutes == b.minutes && a.seconds > b.seconds)
end

# Overloading `<=` for comparison
function Base.:(<=)(a::AngleDegreesMinutesSeconds, b::AngleDegreesMinutesSeconds)
    return !(a > b)
end

# Overloading `>=` for comparison
function Base.:(>=)(a::AngleDegreesMinutesSeconds, b::AngleDegreesMinutesSeconds)
    return !(a < b)
end

# Overload `+` for addition
function Base.:(+)(a::AngleDegreesMinutesSeconds, b::AngleDegreesMinutesSeconds)
    return AngleDegreesMinutesSeconds(a.degrees+b.degrees,a.minutes+b.minutes,a.seconds+b.seconds)
end

# Overload `-` for subtraction
function Base.:(-)(a::AngleDegreesMinutesSeconds,b::AngleDegreesMinutesSeconds)
    degrees = 0, minutes = 0, seconds = 0.0

    if a.seconds < b.seconds
        seconds = 60.0 + (a.seconds - b.seconds)
        minutes -= 1
    else
        seconds = a.seconds - b.seconds
    end

    minutes += a.minutes

    if minutes < b.minutes
        minutes = 60 + (a.minutes - b.minutes)
        degrees -= 1
    else
        minutes -= b.minutes
    end




end

_0d_ = AngleDegreesMinutesSeconds(0)
_45d_ = AngleDegreesMinutesSeconds(45)
_90d_ = AngleDegreesMinutesSeconds(90)
_135d_ = AngleDegreesMinutesSeconds(135)
_180d_ = AngleDegreesMinutesSeconds(180)
_225d_ = AngleDegreesMinutesSeconds(225)
_270d_ = AngleDegreesMinutesSeconds(270)
_315d_ = AngleDegreesMinutesSeconds(315)
_360d_ = AngleDegreesMinutesSeconds(360)

struct CardinalBearing
    lat_dir::CardinalDirectionLat
    lon_dir::CardinalDirectionLon
    angle::AngleDegreesMinutesSeconds

    # Standard constructor.
    function CardinalBearing(lat_dir::CardinalDirectionLat, lon_dir::CardinalDirectionLon, angle::AngleDegreesMinutesSeconds)
        if angle.degrees > 90 || (angle.degrees == 90 && (angle.minutes > 0 || angle.seconds > 0.0))
            throw(DomainError(angle,"Does $(lat_dir) $(to_string(angle)) $(lon_dir) make sense to you? It certainly doesn\'t to me.  CardinalCardinalBearings can\'t have angles greater than 90 degrees Sir or Madam."))
        end
        return new(lat_dir,lon_dir,AngleDegreesMinutesSeconds(angle))
    end

    # Make CardinalBearing given AngleDegreesMinutesSeconds as azimuth.
    function CardinalBearing(azimuth::AngleDegreesMinutesSeconds)
        while azimuth >= _350d_
            azimuth = AngleDegreesMinutesSeconds(azimuth.degrees)
        end
    end
end

function Base.show(io::IO,x::CardinalBearing)
    print(io,"CardinalBearing($(x.lat_dir) $(to_string(x.angle)) $(x.lon_dir))")
end

end
