# This file is part of the IntervalArithmetic.jl package; MIT licensed

## Powers

# CRlibm does not contain a correctly-rounded ^ function for Float64
# Use the BigFloat version from MPFR instead, which is correctly-rounded:

# Write explicitly like this to avoid ambiguity warnings:
for T in (:Integer, :Rational, :Float64, :BigFloat, :Interval)

    @eval ^(a::Interval{Float64}, x::$T) = convert(Interval{Float64}, big53(a)^x)
    @eval ^(a::FastInterval{Float64}, x::$T) = convert(FastInterval{Float64}, big53(a)^x)
end


# Integer power:

# overwrite new behaviour for small integer powers:
# ^{p}(x::IntervalArithmetic.Interval, ::Type{Val{p}}) = x^p

function ^(a::Interval{BigFloat}, n::Integer)
    isempty(a) && return a
    n == 0 && return one(a)
    n == 1 && return a
    # n == 2 && return sqr(a)
    n < 0 && a == zero(a) && return emptyinterval(a)

    T = BigFloat

    if isodd(n) # odd power
        isentire(a) && return a
        if n > 0
            a.lo == 0 && return Interval(@round(0, a.hi^n))
            a.hi == 0 && return Interval(@round(a.lo^n, 0))
            return Interval(@round(a.lo^n, a.hi^n))
        else
            if a.lo ≥ 0
                a.lo == 0 && return Interval(@round(a.hi^n, Inf))
                return Interval(@round(a.hi^n, a.lo^n))

            elseif a.hi ≤ 0
                a.hi == 0 && return Interval(@round(-Inf, a.lo^n))
                return Interval(@round(a.hi^n, a.lo^n))
            else
                return entireinterval(a)
            end
        end

    else # even power
        if n > 0
            if a.lo ≥ 0
                return Interval(@round(a.lo^n, a.hi^n))
            elseif a.hi ≤ 0
                return Interval(@round(a.hi^n, a.lo^n))
            else
                return Interval(@round(mig(a)^n, mag(a)^n))
            end

        else
            if a.lo ≥ 0
                return Interval(@round(a.hi^n, a.lo^n))
            elseif a.hi ≤ 0
                return Interval(@round(a.lo^n, a.hi^n))
            else
                return Interval(@round(mag(a)^n, mig(a)^n))
            end
        end
    end
end
function ^(a::FastInterval{BigFloat}, n::Integer)
    isempty(a) && return a
    n == 0 && return one(a)
    n == 1 && return a
    # n == 2 && return sqr(a)
    n < 0 && a == zero(a) && return emptyinterval(a)

    T = BigFloat

    if isodd(n) # odd power
        isentire(a) && return a
        if n > 0
            a.lo == 0 && return FastInterval( @round(0, a.hi^n) )
            a.hi == 0 && return FastInterval( @round(a.lo^n, 0) )
            return FastInterval( @round(a.lo^n, a.hi^n) )
        else
            if a.lo ≥ 0
                a.lo == 0 && return FastInterval( @round(a.hi^n, Inf) )
                return FastInterval( @round(a.hi^n, a.lo^n) )

            elseif a.hi ≤ 0
                a.hi == 0 && return FastInterval( @round(-Inf, a.lo^n) )
                return FastInterval( @round(a.hi^n, a.lo^n) )
            else
                return entireinterval(a)
            end
        end

    else # even power
        if n > 0
            if a.lo ≥ 0
                return FastInterval( @round(a.lo^n, a.hi^n) )
            elseif a.hi ≤ 0
                return FastInterval( @round(a.hi^n, a.lo^n) )
            else
                return FastInterval( @round(mig(a)^n, mag(a)^n) )
            end

        else
            if a.lo ≥ 0
                return FastInterval( @round(a.hi^n, a.lo^n) )
            elseif a.hi ≤ 0
                return FastInterval( @round(a.lo^n, a.hi^n) )
            else
                return FastInterval( @round(mag(a)^n, mig(a)^n) )
            end
        end
    end
end

function sqr(a::AbstractInterval)
    return a^2
    # isempty(a) && return a
    # if a.lo ≥ zero(T)
    #     return @round(a.lo^2, a.hi^2)
    #
    # elseif a.hi ≤ zero(T)
    #     return @round(a.hi^2, a.lo^2)
    # end
    #
    # return @round(mig(a)^2, mag(a)^2)
end
^(a::Interval{BigFloat}, x::AbstractFloat) = a^big(x)
^(a::FastInterval{BigFloat}, x::AbstractFloat) = a^big(x)

# Floating-point power of a BigFloat interval:
function ^(a::Interval{BigFloat}, x::BigFloat)

    domain = Interval{BigFloat}(0, Inf)

    if a == zero(a)
        a = a ∩ domain
        x > zero(x) && return zero(a)
        return emptyinterval(a)
    end

    isinteger(x) && return a^(round(Int, x))
    x == 0.5 && return sqrt(a)

    a = a ∩ domain
    (isempty(x) || isempty(a)) && return emptyinterval(a)

    xx = convert(Interval{BigFloat}, x)

    lo = Interval(@round(a.lo^xx.lo, a.lo^xx.lo))
    lo1 = Interval(@round(a.lo^xx.hi, a.lo^xx.hi))
    hi = Interval(@round(a.hi^xx.lo, a.hi^xx.lo))
    hi1 = Interval(@round(a.hi^xx.hi, a.hi^xx.hi))

    lo = hull(lo, lo1)
    hi = hull(hi, hi1)

    return hull(lo, hi)
end
function ^(a::FastInterval{BigFloat}, x::BigFloat)

    domain = FastInterval{BigFloat}(0, Inf)

    if a == zero(a)
        a = a ∩ domain
        x > zero(x) && return zero(a)
        return emptyinterval(a)
    end

    isinteger(x) && return a^(round(Int, x))
    x == 0.5 && return sqrt(a)

    a = a ∩ domain
    (isempty(x) || isempty(a)) && return emptyinterval(a)

    xx = convert(FastInterval{BigFloat}, x)

    lo = FastInterval( @round(a.lo^xx.lo, a.lo^xx.lo) )
    lo1 = FastInterval( @round(a.lo^xx.hi, a.lo^xx.hi) )
    hi = FastInterval( @round(a.hi^xx.lo, a.hi^xx.lo) )
    hi1 = FastInterval( @round(a.hi^xx.hi, a.hi^xx.hi) )

    lo = hull(lo, lo1)
    hi = hull(hi, hi1)

    return hull(lo, hi)
end

function ^{T<:Integer}(a::Interval{Rational{T}}, x::AbstractFloat)
    a = Interval(a.lo.num/a.lo.den, a.hi.num/a.hi.den)
    a = a^x
    convert(Interval{Rational{T}}, a)
end
function ^{T<:Integer}(a::FastInterval{Rational{T}}, x::AbstractFloat)
    a = FastInterval(a.lo.num/a.lo.den, a.hi.num/a.hi.den)
    a = a^x
    convert(FastInterval{Rational{T}}, a)
end

# Rational power
function ^{S<:Integer}(a::Interval{BigFloat}, r::Rational{S})
    T = BigFloat
    domain = Interval{T}(0, Inf)

    if a == zero(a)
        a = a ∩ domain
        r > zero(r) && return zero(a)
        return emptyinterval(a)
    end

    isinteger(r) && return convert(Interval{T}, a^round(S,r))
    r == one(S)//2 && return sqrt(a)

    a = a ∩ domain
    (isempty(r) || isempty(a)) && return emptyinterval(a)

    y = convert(Interval{BigFloat}, r)

    a^y
end
function ^{S<:Integer}(a::FastInterval{BigFloat}, r::Rational{S})
    T = BigFloat
    domain = FastInterval{T}(0, Inf)

    if a == zero(a)
        a = a ∩ domain
        r > zero(r) && return zero(a)
        return emptyinterval(a)
    end

    isinteger(r) && return convert(FastInterval{T}, a^round(S,r))
    r == one(S)//2 && return sqrt(a)

    a = a ∩ domain
    (isempty(r) || isempty(a)) && return emptyinterval(a)

    y = convert(FastInterval{BigFloat}, r)

    a^y
end

# Interval power of an interval:
function ^(a::Interval{BigFloat}, x::Interval)
    T = BigFloat
    domain = Interval{T}(0, Inf)

    a = a ∩ domain

    (isempty(x) || isempty(a)) && return emptyinterval(a)

    lo1 = a^x.lo
    lo2 = a^x.hi
    lo1 = hull(lo1, lo2)

    hi1 = a^x.lo
    hi2 = a^x.hi
    hi1 = hull(hi1, hi2)

    hull(lo1, hi1)
end
function ^(a::FastInterval{BigFloat}, x::FastInterval)
    T = BigFloat
    domain = FastInterval{T}(0, Inf)

    a = a ∩ domain

    (isempty(x) || isempty(a)) && return emptyinterval(a)

    lo1 = a^x.lo
    lo2 = a^x.hi
    lo1 = hull(lo1, lo2)

    hi1 = a^x.lo
    hi2 = a^x.hi
    hi1 = hull(hi1, hi2)

    hull(lo1, hi1)
end


function sqrt{T}(a::Interval{T})
    domain = Interval{T}(0, Inf)
    a = a ∩ domain

    isempty(a) && return a

    Interval(@round(sqrt(a.lo), sqrt(a.hi)))  # `sqrt` is correctly-rounded
end
function sqrt{T}(a::FastInterval{T})
    domain = FastInterval{T}(0, Inf)
    a = a ∩ domain

    isempty(a) && return a

    FastInterval( @round(sqrt(a.lo), sqrt(a.hi)))  # `sqrt` is correctly-rounded
end

doc"""
    pow(x::Interval, n::Integer)

A faster implementation of `x^n` using `power_by_squaring`.
`pow(x, n)` will usually return an interval that is slightly larger
than that calculated by `x^n`, but is guaranteed to be a correct
enclosure when using multiplication with correct rounding.
"""
function pow(x::Interval, n::Integer)  # fast integer power

    isempty(x) && return x

    if iseven(n) && zero(Interval) ∈ x

        return hull(zero(x),
                    hull(Base.power_by_squaring(Interval(mig(x)), n),
                        Base.power_by_squaring(Interval(mag(x)), n))
            )

    else

      return hull( Base.power_by_squaring(Interval(x.lo), n),
                    Base.power_by_squaring(Interval(x.hi), n) )

    end

end
function pow(x::FastInterval, n::Integer)  # fast integer power

    isempty(x) && return x

    if iseven(n) && zero(FastInterval) ∈ x

        return hull(zero(x),
                    hull(Base.power_by_squaring(FastInterval(mig(x)), n),
                        Base.power_by_squaring(FastInterval(mag(x)), n))
            )

    else

      return hull( Base.power_by_squaring(FastInterval(x.lo), n),
                    Base.power_by_squaring(FastInterval(x.hi), n) )

    end

end




for f in (:exp, :expm1), T in (:Interval, :FastInterval)
    @eval begin
        function ($f)(a::$T)
            isempty(a) && return a
            $T(@round(($f)(a.lo), ($f)(a.hi)))
        end
    end
end

for f in (:exp2, :exp10)

    @eval function ($f)(x::BigFloat, r::RoundingMode)  # add BigFloat functions with rounding:
            setrounding(BigFloat, r) do
                ($f)(x)
            end
        end

    @eval ($f)(a::Interval{Float64}) = convert(Interval{Float64}, $f(big53(a)))  # no CRlibm version
    @eval ($f)(a::FastInterval{Float64}) = convert(FastInterval{Float64}, $f(big53(a)))  # no CRlibm version

    @eval function ($f)(a::Interval{BigFloat})
            isempty(a) && return a
            Interval(@round(($f)(a.lo), ($f)(a.hi) ))
        end
    @eval function ($f)(a::FastInterval{BigFloat})
            isempty(a) && return a
            FastInterval( @round(($f)(a.lo), ($f)(a.hi) ) )
        end
end


for f in (:log, :log2, :log10, :log1p)

    @eval function ($f){T}(a::Interval{T})
            domain = Interval{T}(0, Inf)
            a = a ∩ domain

            (isempty(a) || a.hi ≤ zero(T)) && return emptyinterval(a)

            Interval(@round(($f)(a.lo), ($f)(a.hi) ))

        end
    @eval function ($f){T}(a::FastInterval{T})
            domain = FastInterval{T}(0, Inf)
            a = a ∩ domain

            (isempty(a) || a.hi ≤ zero(T)) && return emptyinterval(a)

            FastInterval( @round(($f)(a.lo), ($f)(a.hi) ) )

        end

end
