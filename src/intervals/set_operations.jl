# This file is part of the IntervalArithmetic.jl package; MIT licensed


"""
    in(x, a)
    ∈(x, a)

Checks if the number `x` is a member of the interval `a`, treated as a set.
Corresponds to `isMember` in the ITF-1788 Standard.
"""
function in(x::Real, a::AbstractInterval)
    isinf(x) && return false
    a.lo <= x <= a.hi
end



"""
    issubset(a,b)
    ⊆(a,b)

Checks if all the points of the interval `a` are within the interval `b`.
"""
function ⊆(a::AbstractInterval, b::AbstractInterval)
    isempty(a) && return true
    b.lo ≤ a.lo && a.hi ≤ b.hi
end


# isinterior
function isinterior(a::AbstractInterval, b::AbstractInterval)
    isempty(a) && return true
    islessprime(b.lo, a.lo) && islessprime(a.hi, b.hi)
end
const ⪽ = isinterior  # \subsetdot

# Disjoint:
function isdisjoint(a::AbstractInterval, b::AbstractInterval)
    (isempty(a) || isempty(b)) && return true
    islessprime(b.hi, a.lo) || islessprime(a.hi, b.lo)
end


# Intersection
"""
    intersect(a, b)
    ∩(a,b)

Returns the intersection of the intervals `a` and `b`, considered as
(extended) sets of real numbers. That is, the set that contains
the points common in `a` and `b`.
"""
function intersect{T<:AbstractInterval}(a::T, b::T)
    isdisjoint(a,b) && return emptyinterval(a)

    T(max(a.lo, b.lo), min(a.hi, b.hi))
end
# Specific promotion rule for intersect:
intersect{T<:AbstractInterval,S<:AbstractInterval}(a::T, b::S) =
    intersect(promote(a, b)...)


## Hull
"""
    hull(a, b)

Returns the "interval hull" of the intervals `a` and `b`, considered as
(extended) sets of real numbers, i.e. the smallest interval that contains
all of `a` and `b`.
"""
hull{T<:AbstractInterval}(a::T, b::T) = T(min(a.lo, b.lo), max(a.hi, b.hi))

hull{T<:AbstractInterval, S<:AbstractInterval}(a::T, b::S) =
    hull(promote(a, b)...)

"""
    union(a, b)
    ∪(a,b)

Returns the union (convex hull) of the intervals `a` and `b`; it is equivalent
to `hull(a,b)`.
"""
union{T<:AbstractInterval}(a::T, b::T) = hull(a, b)

union{T<:AbstractInterval, S<:AbstractInterval}(a::T, b::S) =
    union(promote(a, b)...)


doc"""
    setdiff(x::Interval, y::Interval)

Calculate the set difference `x \ y`, i.e. the set of values
that are inside the interval `x` but not inside `y`.

Returns an array of intervals.
The array may:

- be empty if `x ⊆ y`;
- contain a single interval, if `y` overlaps `x`
- contain two intervals, if `y` is strictly contained within `x`.
"""
function setdiff{T<:AbstractInterval}(x::T, y::T)
    intersection = x ∩ y

    isempty(intersection) && return [x]
    intersection == x && return typeof(x)[]  # x is subset of y; setdiff is empty

    x.lo == intersection.lo && return [T(intersection.hi, x.hi)]
    x.hi == intersection.hi && return [T(x.lo, intersection.lo)]

    return [T(x.lo, y.lo), T(y.hi, x.hi)]

end
