# This file is part of the IntervalArithmetic.jl package; MIT licensed

## Definitions of special intervals and associated functions

## Empty interval:
doc"""`emptyinterval`s are represented as the interval [∞, -∞]; note
that this interval is an exception to the fact that the lower bound is
larger than the upper one."""
emptyinterval{T<:Real}(::Type{T}) = Interval{T}(Inf, -Inf)
emptyinterval{T<:Real}(::Type{Interval{T}}) = Interval{T}(Inf, -Inf)
emptyinterval{T<:Real}(::Type{FastInterval{T}}) = FastInterval{T}(Inf, -Inf)
emptyinterval{T<:Real}(::Interval{T}) = Interval{T}(Inf, -Inf)
emptyinterval{T<:Real}(::FastInterval{T}) = FastInterval{T}(Inf, -Inf)
emptyinterval() = emptyinterval(precision(Interval)[1])
const ∅ = emptyinterval(Float64)

isempty(x::AbstractInterval) = x.lo == Inf && x.hi == -Inf

const ∞ = Inf

## Entire interval:
doc"""`entireinterval`s represent the whole Real line: [-∞, ∞]."""
entireinterval{T<:Real}(::Type{T}) = Interval{T}(-Inf, Inf)
entireinterval{T<:Real}(::Type{Interval{T}}) = Interval{T}(-Inf, Inf)
entireinterval{T<:Real}(::Type{FastInterval{T}}) = FastInterval{T}(-Inf, Inf)
entireinterval{T<:Real}(::Interval{T}) = Interval{T}(-Inf, Inf)
entireinterval{T<:Real}(::FastInterval{T}) = FastInterval{T}(-Inf, Inf)
entireinterval() = entireinterval(precision(Interval)[1])

isentire(x::AbstractInterval) = x.lo == -Inf && x.hi == Inf
isunbounded(x::AbstractInterval) = x.lo == -Inf || x.hi == Inf


# NaI: not-an-interval
doc"""`NaI` not-an-interval: [NaN, NaN]."""
nai{T<:Real}(::Type{T}) = Interval{T}(convert(T, NaN), convert(T, NaN))
nai{T<:Real}(::Type{Interval{T}}) = Interval(convert(T, NaN), convert(T, NaN))
nai{T<:Real}(::Type{FastInterval{T}}) = FastInterval(convert(T, NaN), convert(T, NaN))
nai{T<:Real}(::Interval{T}) = Interval(convert(T, NaN), convert(T, NaN))
nai{T<:Real}(::FastInterval{T}) = FastInterval(convert(T, NaN), convert(T, NaN))
nai() = nai(precision(Interval)[1])

isnai(x::AbstractInterval) = isnan(x.lo) || isnan(x.hi)

isfinite(x::AbstractInterval) = isfinite(x.lo) && isfinite(x.hi)
isnan(x::AbstractInterval) = isnai(x)

doc"""`isthin(x)` corresponds to `isSingleton`, i.e. it checks if `x` is the set consisting of a single exactly representable float. Thus any float which is not exactly representable does *not* yield a thin interval."""
function isthin(x::AbstractInterval)
    # (m = mid(x); m == x.lo || m == x.hi)
    x.lo == x.hi
end

doc"`iscommon(x)` checks if `x` is a **common interval**, i.e. a non-empty, bounded, real interval."
function iscommon(a::AbstractInterval)
    (isentire(a) || isempty(a) || isnai(a) || isunbounded(a)) && return false
    true
end

doc"`widen(x)` widens the lowest and highest bounds of `x` to the previous and next representable floating-point numbers, respectively."
widen{T<:AbstractInterval}(x::T) = T(prevfloat(x.lo), nextfloat(x.hi))
