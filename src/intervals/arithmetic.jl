# This file is part of the IntervalArithmetic.jl package; MIT licensed


## Comparisons

"""
    ==(a,b)

Checks if the intervals `a` and `b` are equal.
"""
function ==(a::AbstractInterval, b::AbstractInterval)
    isempty(a) && isempty(b) && return true
    a.lo == b.lo && a.hi == b.hi
end
!=(a::AbstractInterval, b::AbstractInterval) = !(a==b)


# Auxiliary functions: equivalent to </<=, but Inf <,<= Inf returning true
function islessprime{T<:Real}(a::T, b::T)
    (isinf(a) || isinf(b)) && a==b && return true
    a < b
end

# Weakly less, \le, <=
function <=(a::AbstractInterval, b::AbstractInterval)
    isempty(a) && isempty(b) && return true
    (isempty(a) || isempty(b)) && return false
    (a.lo ≤ b.lo) && (a.hi ≤ b.hi)
end

# Strict less: <
function <(a::AbstractInterval, b::AbstractInterval)
    isempty(a) && isempty(b) && return true
    (isempty(a) || isempty(b)) && return false
    islessprime(a.lo, b.lo) && islessprime(a.hi, b.hi)
end

# precedes
function precedes(a::AbstractInterval, b::AbstractInterval)
    (isempty(a) || isempty(b)) && return true
    a.hi ≤ b.lo
end

# strictpreceds
function strictprecedes(a::AbstractInterval, b::AbstractInterval)
    (isempty(a) || isempty(b)) && return true
    # islessprime(a.hi, b.lo)
    a.hi < b.lo
end
const ≺ = strictprecedes # \prec


# zero, one
zero{T<:Real}(a::Interval{T}) = Interval(zero(T))
zero{T<:Real}(a::FastInterval{T}) = FastInterval(zero(T))
zero{T<:Real}(::Type{Interval{T}}) = Interval(zero(T))
zero{T<:Real}(::Type{FastInterval{T}}) = FastInterval(zero(T))
one{T<:Real}(a::Interval{T}) = Interval(one(T))
one{T<:Real}(a::FastInterval{T}) = FastInterval(one(T))
one{T<:Real}(::Type{Interval{T}}) = Interval(one(T))
one{T<:Real}(::Type{FastInterval{T}}) = FastInterval(one(T))


## Addition and subtraction

+(a::AbstractInterval) = a
-{T<:AbstractInterval}(a::T) = T(-a.hi, -a.lo)

function +{T<:Real}(a::Interval{T}, b::Interval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    Interval(@round(a.lo + b.lo, a.hi + b.hi))
end
function +{T<:Real}(a::FastInterval{T}, b::FastInterval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    FastInterval(@round(a.lo + b.lo, a.hi + b.hi))
end

function -{T<:Real}(a::Interval{T}, b::Interval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    Interval(@round(a.lo - b.hi, a.hi - b.lo))
end
function -{T<:Real}(a::FastInterval{T}, b::FastInterval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    FastInterval(@round(a.lo - b.hi, a.hi - b.lo))
end


## Multiplication

function *{T<:Real}(a::Interval{T}, b::Interval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(a)

    (a == zero(a) || b == zero(b)) && return zero(a)

    if b.lo >= zero(T)
        a.lo >= zero(T) && return Interval(@round(a.lo*b.lo, a.hi*b.hi))
        a.hi <= zero(T) && return Interval(@round(a.lo*b.hi, a.hi*b.lo))
        return Interval(@round(a.lo*b.hi, a.hi*b.hi))   # zero(T) ∈ a
    elseif b.hi <= zero(T)
        a.lo >= zero(T) && return Interval(@round(a.hi*b.lo, a.lo*b.hi))
        a.hi <= zero(T) && return Interval(@round(a.hi*b.hi, a.lo*b.lo))
        return Interval(@round(a.hi*b.lo, a.lo*b.lo))   # zero(T) ∈ a
    else
        a.lo > zero(T) && return Interval(@round(a.hi*b.lo, a.hi*b.hi))
        a.hi < zero(T) && return Interval(@round(a.lo*b.hi, a.lo*b.lo))
        return Interval(@round(min(a.lo*b.hi, a.hi*b.lo), max(a.lo*b.lo, a.hi*b.hi)))
    end
end
function *{T<:Real}(a::FastInterval{T}, b::FastInterval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(a)

    (a == zero(a) || b == zero(b)) && return zero(a)

    if b.lo >= zero(T)
        a.lo >= zero(T) && return FastInterval(@round(a.lo*b.lo, a.hi*b.hi))
        a.hi <= zero(T) && return FastInterval(@round(a.lo*b.hi, a.hi*b.lo))
        return FastInterval(@round(a.lo*b.hi, a.hi*b.hi))   # zero(T) ∈ a
    elseif b.hi <= zero(T)
        a.lo >= zero(T) && return FastInterval(@round(a.hi*b.lo, a.lo*b.hi))
        a.hi <= zero(T) && return FastInterval(@round(a.hi*b.hi, a.lo*b.lo))
        return FastInterval(@round(a.hi*b.lo, a.lo*b.lo))   # zero(T) ∈ a
    else
        a.lo > zero(T) && return FastInterval(@round(a.hi*b.lo, a.hi*b.hi))
        a.hi < zero(T) && return FastInterval(@round(a.lo*b.hi, a.lo*b.lo))
        return FastInterval(@round(min(a.lo*b.hi, a.hi*b.lo), max(a.lo*b.lo, a.hi*b.hi)))
    end
end


## Division

function inv{T<:Real}(a::Interval{T})
    isempty(a) && return emptyinterval(a)

    if zero(T) ∈ a
        a.lo < zero(T) == a.hi && return Interval(@round(-Inf, inv(a.lo)))
        a.lo == zero(T) < a.hi && return Interval(@round(inv(a.hi), Inf))
        a.lo < zero(T) < a.hi && return entireinterval(a)
        a == zero(a) && return emptyinterval(a)
    end

    Interval(@round(inv(a.hi), inv(a.lo)))
end
function inv{T<:Real}(a::FastInterval{T})
    isempty(a) && return emptyinterval(a)

    if zero(T) ∈ a
        a.lo < zero(T) == a.hi && return FastInterval(@round(-Inf, inv(a.lo)))
        a.lo == zero(T) < a.hi && return FastInterval(@round(inv(a.hi), Inf))
        a.lo < zero(T) < a.hi && return entireinterval(a)
        a == zero(a) && return emptyinterval(a)
    end

    FastInterval(@round(inv(a.hi), inv(a.lo)))
end

function /{T<:Real}(a::Interval{T}, b::Interval{T})
    S = typeof(a.lo / b.lo)
    (isempty(a) || isempty(b)) && return emptyinterval(Interval{S})
    b == zero(b) && return emptyinterval(Interval{S})

    if b.lo > zero(T) # b strictly positive

        a.lo >= zero(T) && return Interval(@round(a.lo/b.hi, a.hi/b.lo))
        a.hi <= zero(T) && return Interval(@round(a.lo/b.lo, a.hi/b.hi))
        return Interval(@round(a.lo/b.lo, a.hi/b.lo))  # zero(T) ∈ a

    elseif b.hi < zero(T) # b strictly negative

        a.lo >= zero(T) && return Interval(@round(a.hi/b.hi, a.lo/b.lo))
        a.hi <= zero(T) && return Interval(@round(a.hi/b.lo, a.lo/b.hi))
        return Interval(@round(a.hi/b.hi, a.lo/b.hi))  # zero(T) ∈ a

    else   # b contains zero, but is not zero(b)

        a == zero(a) && return zero(Interval{S})

        if b.lo == zero(T)

            a.lo >= zero(T) && return Interval(@round(a.lo/b.hi, Inf))
            a.hi <= zero(T) && return Interval(@round(-Inf, a.hi/b.hi))
            return entireinterval(Interval{S})

        elseif b.hi == zero(T)

            a.lo >= zero(T) && return Interval(@round(-Inf, a.lo/b.lo))
            a.hi <= zero(T) && return Interval(@round(a.hi/b.lo, Inf))
            return entireinterval(Interval{S})

        else

            return entireinterval(Interval{S})

        end
    end
end
function /{T<:Real}(a::FastInterval{T}, b::FastInterval{T})
    S = typeof(a.lo / b.lo)
    (isempty(a) || isempty(b)) && return emptyinterval(FastInterval{S})
    b == zero(b) && return emptyinterval(FastInterval{S})

    if b.lo > zero(T) # b strictly positive

        a.lo >= zero(T) && return FastInterval(@round(a.lo/b.hi, a.hi/b.lo))
        a.hi <= zero(T) && return FastInterval(@round(a.lo/b.lo, a.hi/b.hi))
        return FastInterval(@round(a.lo/b.lo, a.hi/b.lo))  # zero(T) ∈ a

    elseif b.hi < zero(T) # b strictly negative

        a.lo >= zero(T) && return FastInterval(@round(a.hi/b.hi, a.lo/b.lo))
        a.hi <= zero(T) && return FastInterval(@round(a.hi/b.lo, a.lo/b.hi))
        return FastInterval(@round(a.hi/b.hi, a.lo/b.hi))  # zero(T) ∈ a

    else   # b contains zero, but is not zero(b)

        a == zero(a) && return zero(FastInterval{S})

        if b.lo == zero(T)

            a.lo >= zero(T) && return FastInterval(@round(a.lo/b.hi, Inf))
            a.hi <= zero(T) && return FastInterval(@round(-Inf, a.hi/b.hi))
            return entireinterval(FastInterval{S})

        elseif b.hi == zero(T)

            a.lo >= zero(T) && return FastInterval(@round(-Inf, a.lo/b.lo))
            a.hi <= zero(T) && return FastInterval(@round(a.hi/b.lo, Inf))
            return entireinterval(FastInterval{S})

        else

            return entireinterval(FastInterval{S})

        end
    end
end

//(a::Interval, b::Interval) = a / b    # to deal with rationals
//(a::FastInterval, b::FastInterval) = a / b    # to deal with rationals

if VERSION >= v"0.6.0-dev.1024"
    const filter = Iterators.filter
end

function min_ignore_nans(args...)
    min(filter(x->!isnan(x), args)...)
end

function max_ignore_nans(args...)
    max(filter(x->!isnan(x), args)...)
end



## fma: fused multiply-add
function fma{T}(a::Interval{T}, b::Interval{T}, c::Interval{T})
    #T = promote_type(eltype(a), eltype(b), eltype(c))

    (isempty(a) || isempty(b) || isempty(c)) && return emptyinterval(T)

    if isentire(a)
        b == zero(b) && return c
        return entireinterval(T)

    elseif isentire(b)
        a == zero(a) && return c
        return entireinterval(T)

    end

    lo = setrounding(T, RoundDown) do
        lo1 = fma(a.lo, b.lo, c.lo)
        lo2 = fma(a.lo, b.hi, c.lo)
        lo3 = fma(a.hi, b.lo, c.lo)
        lo4 = fma(a.hi, b.hi, c.lo)
        min_ignore_nans(lo1, lo2, lo3, lo4)
    end

    hi = setrounding(T, RoundUp) do
        hi1 = fma(a.lo, b.lo, c.hi)
        hi2 = fma(a.lo, b.hi, c.hi)
        hi3 = fma(a.hi, b.lo, c.hi)
        hi4 = fma(a.hi, b.hi, c.hi)
        max_ignore_nans(hi1, hi2, hi3, hi4)
    end

    Interval(lo, hi)
end
function fma{T}(a::FastInterval{T}, b::FastInterval{T}, c::FastInterval{T})
    #T = promote_type(eltype(a), eltype(b), eltype(c))

    (isempty(a) || isempty(b) || isempty(c)) && return emptyinterval(a)

    if isentire(a)
        b == zero(b) && return c
        return entireinterval(a)

    elseif isentire(b)
        a == zero(a) && return c
        return entireinterval(a)

    end

    lo = setrounding(T, RoundDown) do
        lo1 = fma(a.lo, b.lo, c.lo)
        lo2 = fma(a.lo, b.hi, c.lo)
        lo3 = fma(a.hi, b.lo, c.lo)
        lo4 = fma(a.hi, b.hi, c.lo)
        min_ignore_nans(lo1, lo2, lo3, lo4)
    end

    hi = setrounding(T, RoundUp) do
        hi1 = fma(a.lo, b.lo, c.hi)
        hi2 = fma(a.lo, b.hi, c.hi)
        hi3 = fma(a.hi, b.lo, c.hi)
        hi4 = fma(a.hi, b.hi, c.hi)
        max_ignore_nans(hi1, hi2, hi3, hi4)
    end

    FastInterval(lo, hi)
end


## Scalar functions on intervals (no directed rounding used)

function mag(a::AbstractInterval)
    isempty(a) && return convert(eltype(a), NaN)
    # r1, r2 = setrounding(T, RoundUp) do
    #     abs(a.lo), abs(a.hi)
    # end
    max( abs(a.lo), abs(a.hi) )
end

function mig(a::AbstractInterval)
    T = eltype(a)
    isempty(a) && return convert(T, NaN)
    zero(a.lo) ∈ a && return zero(a.lo)
    r1, r2 = setrounding(T, RoundDown) do
        abs(a.lo), abs(a.hi)
    end
    min( r1, r2 )
end


# Infimum and supremum of an interval
infimum(a::AbstractInterval) = a.lo
supremum(a::AbstractInterval) = a.hi


## Functions needed for generic linear algebra routines to work
real(a::AbstractInterval) = a

function abs{T<:AbstractInterval}(a::T)
    isempty(a) && return emptyinterval(a)
    T(mig(a), mag(a))
end

function min{T<:AbstractInterval}(a::T, b::T)
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    T( min(a.lo, b.lo), min(a.hi, b.hi))
end

function max{T<:AbstractInterval}(a::T, b::T)
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    T( max(a.lo, b.lo), max(a.hi, b.hi))
end



dist{T<:AbstractInterval}(a::T, b::T) = max(abs(a.lo-b.lo), abs(a.hi-b.hi))

eps{T<:AbstractInterval}(a::T) = max(eps(a.lo), eps(a.hi))


## floor, ceil, trunc, sign, roundTiesToEven, roundTiesToAway
function floor{T<:AbstractInterval}(a::T)
    isempty(a) && return emptyinterval(a)
    T(floor(a.lo), floor(a.hi))
end

function ceil{T<:AbstractInterval}(a::T)
    isempty(a) && return emptyinterval(a)
    T(ceil(a.lo), ceil(a.hi))
end

function trunc{T<:AbstractInterval}(a::T)
    isempty(a) && return emptyinterval(a)
    T(trunc(a.lo), trunc(a.hi))
end

function sign{T<:AbstractInterval}(a::T)
    isempty(a) && return emptyinterval(a)
    return T(sign(a.lo), sign(a.hi))
end

# RoundTiesToEven is an alias of `RoundNearest`
const RoundTiesToEven = RoundNearest
# RoundTiesToAway is an alias of `RoundNearestTiesAway`
const RoundTiesToAway = RoundNearestTiesAway

"""
    round(a::Interval[, RoundingMode])

Returns the interval with rounded to an interger limits.

For compliance with the IEEE Std 1788-2015, "roundTiesToEven" corresponds
to `round(a)` or `round(a, RoundNearest)`, and "roundTiesToAway"
to `round(a, RoundNearestTiesAway)`.
"""
round(a::AbstractInterval) = round(a, RoundNearest)
round(a::AbstractInterval, ::RoundingMode{:ToZero}) = trunc(a)
round(a::AbstractInterval, ::RoundingMode{:Up}) = ceil(a)
round(a::AbstractInterval, ::RoundingMode{:Down}) = floor(a)

function round{T<:AbstractInterval}(a::T, ::RoundingMode{:Nearest})
    isempty(a) && return emptyinterval(a)
    T(round(a.lo), round(a.hi))
end

function round{T<:AbstractInterval}(a::T, ::RoundingMode{:NearestTiesAway})
    isempty(a) && return emptyinterval(a)
    T(round(a.lo, RoundNearestTiesAway), round(a.hi, RoundNearestTiesAway))
end

# mid, diam, radius

# Compare pg. 64 of the IEEE 1788-2015 standard:
doc"""
    mid(a::Interval, α=0.5)

Find the midpoint (or, in general, an intermediate point) at a distance α along the interval `a`. The default is the true midpoint at α=0.5.
"""
function mid(a::AbstractInterval, α)

    isempty(a) && return convert(eltype(a), NaN)
    isentire(a) && return zero(a.lo)

    a.lo == -∞ && return nextfloat(a.lo)
    a.hi == +∞ && return prevfloat(a.hi)

    @assert 0 ≤ α ≤ 1

    # return (1-α) * a.lo + α * a.hi  # rounds to nearest
    return α*(a.hi - a.lo) + a.lo  # rounds to nearest
end

function mid(a::AbstractInterval)  # specialized version for α=0.5

    isempty(a) && return convert(eltype(a), NaN)
    isentire(a) && return zero(a.lo)

    a.lo == -∞ && return nextfloat(a.lo)
    a.hi == +∞ && return prevfloat(a.hi)

    # @assert 0 ≤ α ≤ 1

    return simple_mid(a)
end

mid{T}(a::Interval{Rational{T}}) = (1//2) * (a.lo + a.hi)
mid{T}(a::FastInterval{Rational{T}}) = (1//2) * (a.lo + a.hi)

function simple_mid(a::AbstractInterval)
    return 0.5*(a.lo + a.hi)
end

doc"""
    diam(a::Interval)

Return the diameter (length) of the `Interval` `a`.
"""
function diam(a::AbstractInterval)
    T = eltype(a)
    isempty(a) && return convert(T, NaN)

    @round_up(a.hi - a.lo) # cf page 64 of IEEE1788
end

doc"""
    radius(a::Interval)

Return the radius of the `Interval` `a`, such that
`a ⊆ m ± radius`, where `m = mid(a)` is the midpoint.
"""
# Should `radius` yield diam(a)/2? This affects other functions!
function radius(a::AbstractInterval)
    isempty(a) && return convert(eltype(a), NaN)
    m = mid(a)
    return max(m - a.lo, a.hi - m)
end

# cancelplus and cancelminus
"""
    cancelminus(a, b)

Return the unique interval `c` such that `b+c=a`.
"""
function cancelminus(a::Interval, b::Interval)
    T = promote_type(eltype(a), eltype(b))

    (isempty(a) && (isempty(b) || !isunbounded(b))) && return emptyinterval(Interval{T})

    (isunbounded(a) || isunbounded(b) || isempty(b)) && return entireinterval(Interval{T})

    a.lo - b.lo > a.hi - b.hi && return entireinterval(Interval{T})

    # The following is needed to avoid finite precision problems
    ans = false
    if diam(a) == diam(b)
        prec = T == Float64 ? 128 : 128+precision(BigFloat)
        ans = setprecision(prec) do
            diam(@biginterval(a)) < diam(@biginterval(b))
        end
    end
    ans && return entireinterval(Interval{T})

    Interval(@round(a.lo - b.lo, a.hi - b.hi))
end
function cancelminus(a::FastInterval, b::FastInterval)
    T = promote_type(eltype(a), eltype(b))

    (isempty(a) && (isempty(b) || !isunbounded(b))) && return emptyinterval(FastInterval{T})

    (isunbounded(a) || isunbounded(b) || isempty(b)) && return entireinterval(FastInterval{T})

    a.lo - b.lo > a.hi - b.hi && return entireinterval(FastInterval{T})

    # The following is needed to avoid finite precision problems
    ans = false
    if diam(a) == diam(b)
        prec = T == Float64 ? 128 : 128+precision(BigFloat)
        ans = setprecision(prec) do
            diam(@biginterval(a)) < diam(@biginterval(b))
        end
    end
    ans && return entireinterval(FastInterval{T})

    FastInterval(@round(a.lo - b.lo, a.hi - b.hi))
end

"""
    cancelplus(a, b)

Returns the unique interval `c` such that `b-c=a`;
it is equivalent to `cancelminus(a, −b)`.
"""
cancelplus{T<:AbstractInterval}(a::T, b::T) = cancelminus(a, -b)


# midpoint-radius forms
midpoint_radius(a::AbstractInterval) = (mid(a), radius(a))

interval_from_midpoint_radius(midpoint, radius) = Interval(midpoint-radius, midpoint+radius)
fastinterval_from_midpoint_radius(midpoint, radius) = FastInterval(midpoint-radius, midpoint+radius)

isinteger(a::AbstractInterval) = (a.lo == a.hi) && isinteger(a.lo)

convert(::Type{Integer}, a::AbstractInterval) = isinteger(a) ?
        convert(Integer, a.lo) : throw(ArgumentError("Cannot convert $a to integer"))
