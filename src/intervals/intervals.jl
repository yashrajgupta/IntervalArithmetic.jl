# This file is part of the IntervalArithmetic.jl package; MIT licensed

# The order in which files are included is important,
# since certain things need to be defined before others use them

## Interval type

@compat abstract type AbstractInterval <: Real end

immutable Interval{T<:Real} <: AbstractInterval
    lo :: T
    hi :: T

    function Interval(a::Real, b::Real)

        if isnan(a) || isnan(b)
            return new(NaN, NaN)  # nai
        end

        if a > b
            (isinf(a) && isinf(b)) && return new(a, b)  # empty interval = [∞,-∞]

            throw(ArgumentError("Must have a ≤ b to construct Interval(a, b)."))
        end



        new(a, b)
    end
end


## Outer constructors

Interval{T<:Real}(a::T, b::T) = Interval{T}(a, b)
Interval{T<:Real}(a::T) = Interval(a, a)
Interval(a::Tuple) = Interval(a...)
Interval{T<:Real, S<:Real}(a::T, b::S) = Interval(promote(a,b)...)

## Concrete constructors for Interval, to effectively deal only with Float64,
# BigFloat or Rational{Integer} intervals.
Interval{T<:Integer}(a::T, b::T) = Interval(float(a), float(b))
Interval{T<:Irrational}(a::T, b::T) = Interval(float(a), float(b))

eltype{T<:Real}(x::Interval{T}) = T

Interval(x::Interval) = x
Interval(x::Complex) = Interval(real(x)) + im*Interval(imag(x))

(::Type{Interval{T}}){T}(x) = Interval(convert(T, x))

(::Type{Interval{T}}){T}(x::Interval) = convert(Interval{T}, x)

## FastInterval
immutable FastInterval{T<:Real} <: AbstractInterval
    lo :: T
    hi :: T

    function (::Type{FastInterval{T}}){T}(a::T, b::T)
        (isnan(a) || isnan(b))  && return new{T}(NaN, NaN)  # nai
        new{T}(a, b)
    end
end
FastInterval{T<:Real}(a::T, b::T) = FastInterval{T}(a, b)
FastInterval{T<:Real}(a::T) = FastInterval(a, a)
FastInterval(a::Tuple) = FastInterval(a...)
FastInterval{T<:Real, S<:Real}(a::T, b::S) =
    FastInterval(promote(a,b)...)

## Concrete constructors for FastInterval, to effectively deal only with Float64,
# BigFloat or Rational{Integer} intervals.
FastInterval{T<:Integer}(a::T, b::T) = FastInterval(float(a), float(b))
FastInterval{T<:Irrational}(a::T, b::T) = FastInterval(float(a), float(b))

eltype{T<:Real}(x::FastInterval{T}) = T

FastInterval(x::FastInterval) = x
FastInterval(x::Complex) = Complex(FastInterval(real(x)), FastInterval(imag(x)))

(::Type{FastInterval{T}}){T}(x) = FastInterval(convert(T, x))

(::Type{FastInterval{T}}){T}(x::FastInterval) = convert(FastInterval{T}, x)


## Include files
include("special.jl")
include("macros.jl")
include("rounding_macros.jl")
include("rounding.jl")
include("conversion.jl")
include("precision.jl")
include("set_operations.jl")
include("arithmetic.jl")
include("functions.jl")
include("trigonometric.jl")
include("hyperbolic.jl")


# Syntax for intervals

a..b = Interval(convert(Interval, a).lo, convert(Interval, b).hi)

macro I_str(ex)  # I"[3,4]"
    @interval(ex)
end

a ± b = (a-b)..(a+b)
