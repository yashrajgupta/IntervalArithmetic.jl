# This file is part of the IntervalArithmetic.jl package; MIT licensed

## Powers

# CRlibm does not contain a correctly-rounded ^ function for Float64
# Use the BigFloat version from MPFR instead, which is correctly-rounded:

# Write explicitly like this to avoid ambiguity warnings:
for T in (:Integer, :Float64, :BigFloat, :Interval)
    @eval ^(a::Interval{Float64}, x::$T) = atomic(Interval{Float64}, big53(a)^x)
end


# Integer power:

# overwrite new behaviour for small integer powers from
# https://github.com/JuliaLang/julia/pull/24240:

Base.literal_pow(::typeof(^), x::Interval{T}, ::Val{p}) where {T,p} = x^p


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
            a.lo == 0 && return @round(0, a.hi^n)
            a.hi == 0 && return @round(a.lo^n, 0)
            return @round(a.lo^n, a.hi^n)
        else
            if a.lo ≥ 0
                a.lo == 0 && return @round(a.hi^n, Inf)
                return @round(a.hi^n, a.lo^n)

            elseif a.hi ≤ 0
                a.hi == 0 && return @round(-Inf, a.lo^n)
                return @round(a.hi^n, a.lo^n)
            else
                return entireinterval(a)
            end
        end

    else # even power
        if n > 0
            if a.lo ≥ 0
                return @round(a.lo^n, a.hi^n)
            elseif a.hi ≤ 0
                return @round(a.hi^n, a.lo^n)
            else
                return @round(mig(a)^n, mag(a)^n)
            end

        else
            if a.lo ≥ 0
                return @round(a.hi^n, a.lo^n)
            elseif a.hi ≤ 0
                return @round(a.lo^n, a.hi^n)
            else
                return @round(mag(a)^n, mig(a)^n)
            end
        end
    end
end

function sqr(a::Interval{T}) where T<:Real
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

    xx = atomic(Interval{BigFloat}, x)

    # @round() can't be used directly, because both arguments may
    # Inf or -Inf, which throws an error
    # lo = @round(a.lo^xx.lo, a.lo^xx.lo)
    lolod = @round_down(a.lo^xx.lo)
    lolou = @round_up(a.lo^xx.lo)
    lo = (lolod == Inf || lolou == -Inf) ?
        wideinterval(lolod) : Interval(lolod, lolou)

    # lo1 = @round(a.lo^xx.hi, a.lo^xx.hi)
    lohid = @round_down(a.lo^xx.hi)
    lohiu = @round_up(a.lo^xx.hi)
    lo1 = (lohid == Inf || lohiu == -Inf) ?
        wideinterval(lohid) : Interval(lohid, lohiu)

    # hi = @round(a.hi^xx.lo, a.hi^xx.lo)
    hilod = @round_down(a.hi^xx.lo)
    hilou = @round_up(a.hi^xx.lo)
    hi = (hilod == Inf || hilou == -Inf) ?
        wideinterval(hilod) : Interval(hilod, hilou)

    # hi1 = @round(a.hi^xx.hi, a.hi^xx.hi)
    hihid = @round_down(a.hi^xx.hi)
    hihiu = @round_up(a.hi^xx.hi)
    hi1 = (hihid == Inf || hihiu == -Inf) ?
        wideinterval(hihid) : Interval(hihid, hihiu)

    lo = hull(lo, lo1)
    hi = hull(hi, hi1)

    return hull(lo, hi)
end

function ^(a::Interval{Rational{T}}, x::AbstractFloat) where T<:Integer
    a = Interval(a.lo.num/a.lo.den, a.hi.num/a.hi.den)
    a = a^x
    atomic(Interval{Rational{T}}, a)
end

# Rational power
function ^(a::Interval{T}, x::Rational) where T
    domain = Interval{T}(0, Inf)

    p = x.num
    q = x.den

    isempty(a) && return emptyinterval(a)
    x == 0 && return one(a)

    if a == zero(a)
        x > zero(x) && return zero(a)
        return emptyinterval(a)
    end

    x == (1//2) && return sqrt(a)

    if x >= 0
        if a.lo ≥ 0
            isinteger(x) && return a ^ Int64(x)
            a = @biginterval(a)
            ui = convert(Culong, q)
            low = BigFloat()
            high = BigFloat()
            ccall((:mpfr_rootn_ui, :libmpfr) , Int32 , (Ref{BigFloat}, Ref{BigFloat}, Culong, MPFRRoundingMode) , low , a.lo , ui, MPFRRoundDown)
            ccall((:mpfr_rootn_ui, :libmpfr) , Int32 , (Ref{BigFloat}, Ref{BigFloat}, Culong, MPFRRoundingMode) , high , a.hi , ui, MPFRRoundUp)
            b = interval(low, high)
            b = convert(Interval{T}, b)
            return b^p
        end

        if a.lo < 0 && a.hi ≥ 0
            isinteger(x) && return a ^ Int64(x)
            a = a ∩ Interval{T}(0, Inf)
            a = @biginterval(a)
            ui = convert(Culong, q)
            low = BigFloat()
            high = BigFloat()
            ccall((:mpfr_rootn_ui, :libmpfr) , Int32 , (Ref{BigFloat}, Ref{BigFloat}, Culong, MPFRRoundingMode) , low , a.lo , ui, MPFRRoundDown)
            ccall((:mpfr_rootn_ui, :libmpfr) , Int32 , (Ref{BigFloat}, Ref{BigFloat}, Culong, MPFRRoundingMode) , high , a.hi , ui, MPFRRoundUp)
            b = interval(low, high)
            b = convert(Interval{T}, b)
            return b^p
        end

        if a.hi < 0
            isinteger(x) && return a ^ Int64(x)
            return emptyinterval(a)
        end

    end

    if x < 0
        return inv(a^(-x))
    end

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


function sqrt(a::Interval{T}) where T
    domain = Interval{T}(0, Inf)
    a = a ∩ domain

    isempty(a) && return a

    @round(sqrt(a.lo), sqrt(a.hi))  # `sqrt` is correctly-rounded
end

"""
    pow(x::Interval, n::Integer)

A faster implementation of `x^n`, currently using `power_by_squaring`.
`pow(x, n)` will usually return an interval that is slightly larger than that calculated by `x^n`, but is guaranteed to be a correct
enclosure when using multiplication with correct rounding.
"""
function pow(x::Interval, n::Integer)  # fast integer power

    isempty(x) && return x

    if iseven(n) && 0 ∈ x

        return hull(zero(x),
                    hull(Base.power_by_squaring(Interval(mig(x)), n),
                        Base.power_by_squaring(Interval(mag(x)), n))
            )

    else

      return hull( Base.power_by_squaring(Interval(x.lo), n),
                    Base.power_by_squaring(Interval(x.hi), n) )

    end

end

function pow(x::Interval, y::Real)  # fast real power, including for y an Interval

    isempty(x) && return x

    return exp(y * log(x))

end




for f in (:exp, :expm1)
    @eval begin
        function ($f)(a::Interval{T}) where T
            isempty(a) && return a
            @round( ($f)(a.lo), ($f)(a.hi) )
        end
    end
end

for f in (:exp2, :exp10)

    @eval function ($f)(x::BigFloat, r::RoundingMode)  # add BigFloat functions with rounding:
            setrounding(BigFloat, r) do
                ($f)(x)
            end
        end

    @eval ($f)(a::Interval{Float64}) = atomic(Interval{Float64}, $f(big53(a)))  # no CRlibm version

    @eval function ($f)(a::Interval{BigFloat})
            isempty(a) && return a
            @round( ($f)(a.lo), ($f)(a.hi) )
        end
end


for f in (:log, :log2, :log10, :log1p)

    @eval function ($f)(a::Interval{T}) where T
            domain = Interval{T}(0, Inf)
            a = a ∩ domain

            (isempty(a) || a.hi ≤ zero(T)) && return emptyinterval(a)

            @round( ($f)(a.lo), ($f)(a.hi) )

        end
end

```
This function takes an interval and a conversion specifier as input and gives a string interval containing the interval x.
    for cs equal to u , it outputs empty, entire and nai in upper case
    for cs equals to l, it outputs empty, entire and nai in lower case
    for cs equal to f, it outputs full interval [-Inf,Inf] instead of entire interval.
    for any other it outputs default string interval.
```

function string(x :: Interval{T}, cs :: AbstractString)
    m = match(r"(\d*)\s?\:\s?\[(.)\s?(\d*)\s?\.\s?(\d*)\s?\]", cs)
    infsup_string(x, m)
    if m == nothing
        m = match(r"(\d*)\s?\:\s?(.)\s?(\d*)\s?\.\s?(\d*)\s?\?\s(\d*)\s", cs)
        uncertain_string(x, m)
        if m == nothing
            throw(ArgumentError("Unable to process string $x as decorated interval"))
        end
    end
end

function string(x :: Interval{T}, cs :: Char) where T
    if cs == 'u'
        x == ∅ && return "[Empty]"
        x == entireinterval(T) && return "Entire"
        isnai(x) && return "[Nai]"
    end
    if cs == 'l'
        x == ∅ && return "[empty]"
        x == entireinterval(T) && return "entire"
        isnai(x) && return "[nai]"
    end
    if cs == 'f'
        x == entireinterval(T) && return "[-Inf,Inf]"
    end
    return string(x)
end

```
Without any parameters, string function outputs the string of interval containing the interval x within 2 precision digits.
julia> string(1.12321 .. 2.21322)
"[1.12, 2.22]"
```
function string(x :: Interval{T}) where T
    x == ∅ && return "[Empty]"
    x == entireinterval(T) && return "Entire"
    isnai(x) && return "[Nai]"
    low = Float64(floor(x.lo * 100) / 100)
    high = Float64(ceil(x.hi * 100) / 100)
    if isinteger(low)
        low = Int64(low)
    end
    if isinteger(high)
        high = Int64(high)
    end
    return "[$low, $high]"
end

```
The argument string_len corresponds to the total length of the output string.
```
function string(x :: Interval{T}, string_len :: Integer) where T
    x == ∅ && return "[Empty]"
    x == entireinterval(T) && return "Entire"
    isnai(x) && return "[Nai]"
    min_len = length(string(trunc(x.lo))) + length(string(ceil(x.hi))) - 1
    if string_len < min_len
        throw(ArgumentError("Cannot output the interval as a string"))
    end
    if string_len == min_len
        low = Int64(trunc(x.lo))
        high = Int64(ceil(x.hi))
    end
    if string_len == min_len + 1
        low = Int64(trunc(x.lo))
        high = Int64(ceil(x.hi))
        return "[$low, $high]"
    end
    if string_len == min_len + 2
        low_prec = 1
        low = Float64(floor(x.lo * 10^low_prec) / 10^low_prec)
        high = Int64(ceil(x.hi))
    end
    if string_len == min_len + 3
        low_prec = 1
        low = Float64(floor(x.lo * 10^low_prec) / 10^low_prec)
        high = Int64(ceil(x.hi))
    end
    if string_len >= min_len + 4
        high_prec = trunc((string_len - min_len - 2) / 2)
        low_prec = string_len - min_len - high_prec - 2
        low = Float64(floor(x.lo * 10^low_prec) / 10^low_prec)
        high = Float64(trunc(x.hi * 10^high_prec + 1) / 10^high_prec)
    end
    s = "[$low,$high]"
    return "[$low" * "0"^(string_len - length(s)) * ",$high]"
end

```
low_fw : length of the lower limit of the interval string
high_fw : length of the higher limit of the interval string
low_precision : number of digits after decimal in the lower limit of interval string
high_precision : number of digits after decimal in the higher limit of interval string
julia> string(big(5)^(1/3) .. big(6.76455689) , 6, 6, 4, 4)
"[1.7099,6.7646]"
```
function string(x :: Interval{T}, low_fw :: Int64, high_fw :: Int64, low_precision :: Int64, high_precision :: Int64) where T
    x == ∅ && return "[Empty]"
    x == entireinterval(T) && return "Entire"
    isnai(x) && return "[Nai]"
    low = Float64(floor(x.lo * 10^low_precision) / 10^low_precision)
    high = Float64(trunc(x.hi * 10^high_precision + 1) / 10^high_precision)
    s_low = " "^(low_fw - length(string(low))) * string(low)
    s_high = " "^(high_fw - length(string(high))) * string(high)
    return "["*s_low*","*s_high*"]"
end

function uncertain_string(x :: Interval{T}, m :: RegexMatch) where T
    overall_width = m.captures[1]
    flag = m.captures[2]
    width = m.captures[3]
    precision = m.captures[4]
    rad_width = m.captures[5]
    mid = (x.lo + x.hi) / 2
    r = (x.hi - x.lo) / 2
    r = Int32(trunc(r*10 + 1))
    mid = Float64(trunc(mid * 10) / 10)
    if r > 9
        r = Int64(trunc(r / 10 + 1))
        mid = Int64(trunc(mid))
    end
    return "$mid?$r"
end
