var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Package",
    "title": "Package",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#IntervalArithmetic.jl-1",
    "page": "Package",
    "title": "IntervalArithmetic.jl",
    "category": "section",
    "text": "IntervalArithmetic.jl is a Julia package for performing Validated Numerics in Julia, i.e. rigorous computations with finite-precision floating-point arithmetic.All calculations are carried out using interval arithmetic: all quantities are treated as intervals, which are propagated throughout a calculation. The final result is an interval that is guaranteed to contain the correct result, starting from the given initial data.The aim of the package is correctness over speed, although performance considerations are also taken into account."
},

{
    "location": "index.html#Authors-1",
    "page": "Package",
    "title": "Authors",
    "category": "section",
    "text": "Luis Benet, Instituto de Ciencias Físicas, Universidad Nacional Autónoma de México (UNAM)\nDavid P. Sanders, Departamento de Física, Facultad de Ciencias, Universidad Nacional Autónoma de México (UNAM)"
},

{
    "location": "index.html#Contributors-1",
    "page": "Package",
    "title": "Contributors",
    "category": "section",
    "text": "Oliver Heimlich\nNikolay Kryukov\nJohn Verzani"
},

{
    "location": "index.html#Installation-1",
    "page": "Package",
    "title": "Installation",
    "category": "section",
    "text": "To install the package, from within Julia dojulia> Pkg.add(\"IntervalArithmetic\")"
},

{
    "location": "index.html#Contents-1",
    "page": "Package",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\"usage.md\",\n    \"decorations.md\",\n    \"multidim.md\",\n    \"rounding.md\",\n    \"api.md\"\n    ]"
},

{
    "location": "index.html#Bibliography-1",
    "page": "Package",
    "title": "Bibliography",
    "category": "section",
    "text": "Validated Numerics: A Short Introduction to Rigorous Computations, W. Tucker, Princeton University Press (2010)\nIntroduction to Interval Analysis, R.E. Moore, R.B. Kearfott & M.J. Cloud, SIAM (2009)"
},

{
    "location": "index.html#Related-packages-1",
    "page": "Package",
    "title": "Related packages",
    "category": "section",
    "text": "MPFI.jl, a Julia wrapper around the MPFI C library, a multiple-precision interval arithmetic library based on MPFR\nIntervals.jl, an alternative implementation of basic interval functions.\nUnums.jl, an implementation of interval arithmetic with variable precision (\"ubounds\")"
},

{
    "location": "index.html#Acknowledgements-1",
    "page": "Package",
    "title": "Acknowledgements",
    "category": "section",
    "text": "This project was developed in a masters' course in the postgraduate programs in Physics and in Mathematics at UNAM during the second semester of 2013 and the first semester of 2015. We thank the participants of the courses for putting up with the half-baked material and contributing energy and ideas.Financial support is acknowledged from DGAPA-UNAM PAPIME grants PE-105911 and PE-107114, and DGAPA-UNAM PAPIIT grant IN-117214. LB acknowledges support through a Cátedra Marcos Moshinsky (2013). DPS acknowledges a sabbatical fellowship from CONACYT and thanks Alan Edelman and the Julia group at MIT for hosting his sabbatical visit."
},

{
    "location": "usage.html#",
    "page": "Basic usage",
    "title": "Basic usage",
    "category": "page",
    "text": ""
},

{
    "location": "usage.html#Basic-usage-1",
    "page": "Basic usage",
    "title": "Basic usage",
    "category": "section",
    "text": "The basic elements of the package are intervals, i.e. sets of real numbers (possibly including \\pm \\infty) of the forma b =  a le x le b  subseteq mathbbR"
},

{
    "location": "usage.html#Creating-intervals-1",
    "page": "Basic usage",
    "title": "Creating intervals",
    "category": "section",
    "text": "Intervals are created using the @interval macro, which takes one or two expressions:julia> using IntervalArithmetic\n\njulia> a = @interval(1)\n[1, 1]\n\njulia> typeof(ans)\nIntervalArithmetic.Interval{Float64}\n\njulia> b = @interval(1, 2)\n[1, 2]The objects returned are of the parameterized type Interval, the basic object in the package. By default, Interval objects contain Float64s, but the library also allows using other types such as Rationals and BigFloats; for example:julia> @biginterval(1, 2)\n[1, 2]₂₅₆\n\njulia> showall(ans)\nInterval(1.000000000000000000000000000000000000000000000000000000000000000000000000000000, 2.000000000000000000000000000000000000000000000000000000000000000000000000000000)The constructor of the Interval type may be used directly, but this is generally not recommended, for the following reason:julia> a = Interval(0.1, 0.3)\n[0.1, 0.3]\n\njulia> b = @interval(0.1, 0.3)\n[0.0999999, 0.300001]What is going on here?Due to the way floating-point arithmetic works, the interval a created directly by the constructor turns out to contain neither the true real number 0.1, nor 0.3, since the floating point number associated to 0.1 is actually rounded up, whereas the one associated to 0.3 is rounded down. The @interval macro, however, uses directed rounding to guarantee that the true 0.1 and 0.3 are included in the result.Behind the scenes, the [@interval(@ref)] macro rewrites the expression(s) passed to it, replacing the literals (0.1, 1, etc.) by calls to create correctly-rounded intervals, handled by the convert function.This allows us to write, for examplejulia> @interval sin(0.1) + cos(0.2)\n[1.07989, 1.0799]which is equivalent tojulia> sin(@interval(0.1)) + cos(@interval(0.2))\n[1.07989, 1.0799]This can be used together with user-defined functions:julia> f(x) = 2x\nf (generic function with 1 method)\n\njulia> f(@interval(0.1))\n[0.199999, 0.200001]\n\njulia> @interval f(0.1)\n[0.199999, 0.200001]"
},

{
    "location": "usage.html#\\pi-1",
    "page": "Basic usage",
    "title": "\\pi",
    "category": "section",
    "text": "You can create correctly-rounded intervals containing \\pi:julia> @interval(pi)\n[3.14159, 3.1416]and embed it in expressions:julia> @interval(3*pi/2 + 1)\n[5.71238, 5.71239]\n\njulia> @interval 3π/2 + 1\n[5.71238, 5.71239]"
},

{
    "location": "usage.html#Constructing-intervals-1",
    "page": "Basic usage",
    "title": "Constructing intervals",
    "category": "section",
    "text": "Intervals may be constructed using rationals:julia> @interval(1//10)\n[0.0999999, 0.100001]Real literals are handled by internally converting them to rationals (using the Julia function rationalize). This gives a result that contains the computer's \"best guess\" for the real number the user \"had in mind\":julia> @interval(0.1)\n[0.0999999, 0.100001]If you instead know which exactly-representable floating-point number a you need and really want to make a thin interval, i.e., an interval of the form [a, a], containing precisely one float, then you can use the Interval constructor directly:julia> a = Interval(0.1)\n[0.1, 0.100001]\n\njulia> showall(a)\nInterval(0.1, 0.1)Here, the showall function shows the internal representation of the interval, in a reproducible form that may be copied and pasted directly. It uses Julia's internal function (which, in turn, uses the so-called Grisu algorithm) to show exactly as many digits are required to give an unambiguous floating-point number.Strings may be used inside @interval:julia> @interval \"0.1\"*2\n[0.199999, 0.200001]\n\njulia> @biginterval \"0.1\"*2\n[0.199999, 0.200001]₂₅₆\n\njulia> showall(ans)\nInterval(1.999999999999999999999999999999999999999999999999999999999999999999999999999983e-01, 2.000000000000000000000000000000000000000000000000000000000000000000000000000004e-01)\nStrings in the form of intervals may also be used:julia> @interval \"[1.2, 3.4]\"\n[1.19999, 3.40001]Intervals can be created from variables:julia> a = 3.6\n3.6\n\njulia> b = @interval(a)\n[3.59999, 3.60001]The upper and lower bounds of the interval may be accessed using the fields lo and hi:julia> b.lo\n3.5999999999999996\n\njulia> b.hi\n3.6The diameter (length) of an interval is obtained using diam(b); for numbers that cannot be represented exactly in base 2 (i.e., whose binary expansion is infinite or exceeds the current precision),  the diameter of intervals created by @interval with a single argument corresponds to the local machine epsilon (eps) in the :narrow interval-rounding mode:julia> diam(b)\n4.440892098500626e-16\n\njulia> eps(b.lo)\n4.440892098500626e-16Starting with v0.3, you can use additional syntax for creating intervals more easily: the .. operator,julia> 0.1..0.3\n[0.0999999, 0.300001]and the @I_str string macro:julia> I\"3.1\"\n[3.09999, 3.10001]\n\njulia> I\"[3.1, 3.2]\"\n[3.09999, 3.20001]From v0.4, you can also use the ± operator:julia> 1.5 ± 0.1\n[1.39999, 1.60001]"
},

{
    "location": "usage.html#Arithmetic-1",
    "page": "Basic usage",
    "title": "Arithmetic",
    "category": "section",
    "text": "Basic arithmetic operations (+, -, *, /, ^) are defined for pairs of intervals in a standard way (see, e.g., the book by Tucker): the result is the smallest interval containing the result of operating with each element of each interval. That is, for two intervals X and Y and an operation \\bigcirc, we define the operation on the two intervals bybigcirc Y =  x bigcirc y x in X text and  y in Y Again, directed rounding is used if necessary.For example:julia> a = @interval(0.1, 0.3)\n[0.0999999, 0.300001]\n\njulia> b = @interval(0.3, 0.6)\n[0.299999, 0.600001]\n\njulia> a + b\n[0.399999, 0.900001]However, subtraction of two intervals gives an initially unexpected result, due to the above definition:julia> a = @interval(0, 1)\n[0, 1]\n\njulia> a - a\n[-1, 1]"
},

{
    "location": "usage.html#Changing-the-precision-1",
    "page": "Basic usage",
    "title": "Changing the precision",
    "category": "section",
    "text": "By default, the @interval macro creates intervals of Float64s. This may be changed globally using the setprecision function:julia> @interval 3π/2 + 1\n[5.71238, 5.71239]\n\njulia> showall(ans)\nInterval(5.71238898038469, 5.712388980384691)\n\njulia> setprecision(Interval, 256)\n256\n\njulia> @interval 3π/2 + 1\n[5.71238, 5.71239]₂₅₆\n\njulia> showall(ans)\nInterval(5.712388980384689857693965074919254326295754099062658731462416888461724609429262, 5.712388980384689857693965074919254326295754099062658731462416888461724609429401)The subscript 256 at the end denotes the precision.To change back to Float64s, usejulia> setprecision(Interval, Float64)\nFloat64\n\njulia> @interval(pi)\n[3.14159, 3.1416]To check which mode is currently set, usejulia> precision(Interval)\n(Float64,256)The result is a tuple of the type (currently Float64 or BigFloat) and the current BigFloat precision.Note that the BigFloat precision is set internally by setprecision(Interval). You should not use setprecision(BigFloat) directly,   since the package carries out additional steps to ensure internal consistency of operations involving π, in particular trigonometric functions."
},

{
    "location": "usage.html#Elementary-functions-1",
    "page": "Basic usage",
    "title": "Elementary functions",
    "category": "section",
    "text": "The main elementary functions are implemented, for both Interval{Float64} and Interval{BigFloat}.The functions for Interval{Float64} internally use routines from the correctly-rounded CRlibm library where possible, i.e. for the following functions defined in that library:exp, expm1\nlog, log1p, log2, log10\nsin, cos, tan\nasin, acos, atan\nsinh, coshOther functions that are implemented for Interval{Float64} internally convert to an Interval{BigFloat}, and then use routines from the MPFR library (BigFloat in Julia):^\nexp2, exp10\natan2, atanhNote, in particular, that in order to obtain correct rounding for the power function (^), intervals are converted to and from BigFloat; this implies a significant slow-down in this case.Examples:julia> a = @interval(1)\n[1, 1]\n\njulia> sin(a)\n[0.84147, 0.841471]\n\njulia> cos(cosh(a))\n[0.0277121, 0.0277122]julia> setprecision(Interval, 53)\n53\n\njulia> sin(@interval(1))\n[0.84147, 0.841471]₅₃\n\njulia> @interval sin(0.1) + cos(0.2)\n[1.07989, 1.0799]₅₃julia> setprecision(Interval, 128)\n128\n\njulia> @interval sin(1)\n[0.84147, 0.841471]₁₂₈"
},

{
    "location": "usage.html#Interval-rounding-modes-1",
    "page": "Basic usage",
    "title": "Interval rounding modes",
    "category": "section",
    "text": "By default, the directed rounding used corresponds to using the RoundDown and RoundUp rounding modes when performing calculations; this gives the narrowest resulting intervals, and is set byjulia> setrounding(Interval, :correct)\nAn alternative rounding method is to perform calculations using the (standard) RoundNearest rounding mode, and then widen the result by one machine epsilon in each direction using prevfloat and nextfloat. This is achived byjulia> setrounding(Interval, :fast);\nIt generally results in wider intervals, but seems to be significantly faster."
},

{
    "location": "usage.html#Display-modes-1",
    "page": "Basic usage",
    "title": "Display modes",
    "category": "section",
    "text": "There are several useful output representations for intervals, some of which we have already touched on. The display is controlled globally by the setformat function, which has the following options, specified by keyword arguments (type ?setformat to get help at the REPL):format: interval output format\n:standard: output of the form [1.09999, 1.30001], rounded to the current number of significant figures\n:full: output of the form Interval(1.0999999999999999, 1.3), as in the showall function\n:midpoint: output in the midpoint-radius form, e.g. 1.2 ± 0.100001\nsigfigs: number of significant figures to show in standard mode\ndecorations (boolean): whether to show decorations or not"
},

{
    "location": "usage.html#Examples-1",
    "page": "Basic usage",
    "title": "Examples",
    "category": "section",
    "text": "julia> setprecision(Interval, Float64)\nFloat64\n\njulia> a = @interval(1.1, pi)\n[1.09999, 3.1416]\n\njulia> setformat(sigfigs=10)\n10\n\njulia> a\n[1.099999999, 3.141592654]\n\njulia> setformat(:full)\n10\n\njulia> a\nInterval(1.0999999999999999, 3.1415926535897936)\n\njulia> setformat(:midpoint)\n10\n\njulia> a\n2.120796327 ± 1.020796327\n\njulia> setformat(:midpoint, sigfigs=4)\n4\n\njulia> a\n2.121 ± 1.021\n\njulia> setformat(:standard)\n4\n\njulia> a\n[1.099, 3.142]\n\njulia> setformat(:standard, sigfigs=6)\n6"
},

{
    "location": "decorations.html#",
    "page": "Decorations",
    "title": "Decorations",
    "category": "page",
    "text": "DocTestSetup = quote\n    using IntervalArithmetic\nend"
},

{
    "location": "decorations.html#Decorations-1",
    "page": "Decorations",
    "title": "Decorations",
    "category": "section",
    "text": "Decorations are flags, or labels, attached to intervals to indicate the status of a given interval as the result of evaluating a function on an initial interval. The combination of an interval X and a decoration d is called a decorated interval.The allowed decorations and their ordering are as follows: com > dac > def > trv > ill.Suppose that a decorated interval (X d) is the result of evaluating a function f, or the composition of a sequence of functions, on an initial decorated interval (X_0 d_0). The meaning of the resulting decoration d is as follows:com (\"common\"): X is a closed, bounded, nonempty subset of the domain of f; f is continuous on the interval X; and the resulting interval f(X) is bounded.\ndac (\"defined & continuous\"): X is a nonempty subset of mathrmDom(f), and f is continuous on X.\ndef (\"defined\"): X is a nonempty subset of mathrmDom(f), i.e. f is defined at each point of X.\ntrv (\"trivial\"): always true; gives no information\nill (\"ill-formed\"): Not an Interval (an error occurred), e.g. mathrmDom(f) = emptyset.An example will be given at the end of this section."
},

{
    "location": "decorations.html#Initialisation-1",
    "page": "Decorations",
    "title": "Initialisation",
    "category": "section",
    "text": "The simplest way to create a DecoratedInterval is with the @decorated macro, which does correct rounding:julia> @decorated(0.1, 0.3)\n[0.1, 0.3]The DecoratedInterval constructor may also be used if necessary:julia> X = DecoratedInterval(3, 4)\n[3, 4]By default, decorations are not displayed. The following turns on display of decorations:julia> setformat(decorations=true)\n6\n\njulia> X\n[3, 4]_comIf no decoration is explicitly specified when a DecoratedInterval is created, then it is initialised with a decoration according to its interval X:com: if X is nonempty and bounded;\ndac if X is unbounded;\ntrv if X is empty.An explicit decoration may be provided for advanced use:julia> DecoratedInterval(3, 4, dac)\n[3, 4]_dac\n\njulia> DecoratedInterval(X, def)\n[3, 4]_defHere, a new DecoratedInterval was created by extracting the interval from another one and appending a different decoration."
},

{
    "location": "decorations.html#Action-of-functions-1",
    "page": "Decorations",
    "title": "Action of functions",
    "category": "section",
    "text": "A decoration is the combination of an interval together with the sequence of functions that it has passed through. Here are some examples:julia> X1 = @decorated(0.5, 3)\n[0.5, 3]_com\n\njulia> sqrt(X1)\n[0.707106, 1.73206]_comIn this case, both input and output are \"common\" intervals, meaning that they are closed and bounded, and that the resulting function is continuous over the input interval, so that fixed-point theorems may be applied. Since sqrt(X1) ⊆ X1, we know that there must be a fixed point of the function inside the interval X1 (in this case, sqrt(1) == 1).julia> X2 = DecoratedInterval(3, ∞)\n[3, ∞]_dac\n\njulia> sqrt(X2)\n[1.73205, ∞]_dacSince the intervals are unbounded here, the maximum decoration possible is dac.julia> X3 = @decorated(-3, 4)\n[-3, 4]_com\n\njulia> sign(X3)\n[-1, 1]_defThe sign function is discontinuous at 0, but is defined everywhere on the input interval, so the decoration is def.julia> X4 = @decorated(-3.5, 4.1)\n[-3.5, 4.1]_com\n\njulia> sqrt(X4)\n[0, 2.02485]_trvThe negative part of X is discarded by the sqrt function, since its domain is [0,∞]. (This process of discarding parts of the input interval that are not in the domain is called \"loose evaluation\".) The fact that this occurred is, however, recorded by the resulting decoration, trv, indicating a loss of information: \"nothing is known\" about the relationship between the output interval and the input.In this case, we know why the decoration was reduced to trv. But if this were just a single step in a longer calculation, a resulting trv decoration shows only that something like this happened at some step. For example:julia> X5 = @decorated(-3, 3)\n[-3, 3]_com\n\njulia> asin(sqrt(X5))\n[0, 1.5708]_trv\n\njulia> X6 = @decorated(0, 3)\n[0, 3]_com\n\njulia> asin(sqrt(X6))\n[0, 1.5708]_trvIn both cases, asin(sqrt(X)) gives a result with a trv decoration, but we do not know at which step this happened, unless we break down the function into its constituent parts:julia> sqrt(X5)\n[0, 1.73206]_trv\n\njulia> sqrt(X6)\n[0, 1.73206]_comThis shows that loose evaluation occurred in different parts of the expression in the two different cases.In general, the trv decoration is thus used only to signal that \"something unexpected\" happened during the calculation. Often this is later used to split up the original interval into pieces and reevaluate the function on each piece to refine the information that is obtained about the function.DocTestSetup = nothing"
},

{
    "location": "multidim.html#",
    "page": "Multi-dimensional boxes",
    "title": "Multi-dimensional boxes",
    "category": "page",
    "text": ""
},

{
    "location": "multidim.html#Multi-dimensional-boxes-1",
    "page": "Multi-dimensional boxes",
    "title": "Multi-dimensional boxes",
    "category": "section",
    "text": "Starting with v0.3, multi-dimensional (hyper-)boxes are implemented in the IntervalBox type. These represent Cartesian products of intervals, i.e. rectangles (in 2D), cuboids (in 3D), etc.IntervalBoxes are constructed from an array of Intervals; it is often convenient to use the .. notation:julia> using IntervalArithmetic # hide\n\njulia> X = IntervalBox(1..3, 2..4)\n[1, 3] × [2, 4]\n\njulia> Y = IntervalBox(2.1..2.9, 3.1..4.9)\n[2.09999, 2.90001] × [3.09999, 4.90001]Several operations are defined on IntervalBoxes, for example:julia> X ∩ Y\n[2.09999, 2.90001] × [3.09999, 4]\n\njulia> X ⊆ Y\nfalseGiven a multi-dimensional function taking several inputs, and interval box can be constructed as follows:julia> f(x, y) = (x + y, x - y)\nf (generic function with 1 method)\n\njulia> X = IntervalBox(1..1, 2..2)\n[1, 1] × [2, 2]\n\njulia> f(X...)  \n([3, 3],[-1, -1])\n\njulia> IntervalBox(f(X...))\n[3, 3] × [-1, -1]DocTestSetup = nothing"
},

{
    "location": "rounding.html#",
    "page": "Rounding",
    "title": "Rounding",
    "category": "page",
    "text": ""
},

{
    "location": "rounding.html#Why-is-rounding-necessary?-1",
    "page": "Rounding",
    "title": "Why is rounding necessary?",
    "category": "section",
    "text": "What happens when we write the following Julia code?julia> x = 0.1\n0.1This appears to store the value 0.1 in a variable x of type Float64. In fact, however, it stores a slightly different number, since 0.1 cannot be represented exactly in binary floating point arithmetic, at any precision.The true value that is actually stored in the variable can be conveniently determined in Julia using arbitrary-precision arithmetic with BigFloats:julia> big(0.1)\n1.000000000000000055511151231257827021181583404541015625000000000000000000000000e-01So, in fact, the Julia float 0.1 refers to a real number that is slightly greater than 0.1. By default, such calculations are done in round-to-nearest mode (RoundNearest); i.e., the nearest representable floating-point number to 0.1 is used.[Recall that to get a BigFloat that is as close as possible to the true 0.1, you can use a special string macro:julia> big\"0.1\"\n1.000000000000000000000000000000000000000000000000000000000000000000000000000002e-01]Suppose that we create a thin interval, containing just the floating-point number 0.1:julia> using IntervalArithmetic\n\njulia> II = Interval(0.1)\n[0.1, 0.100001]\n\njulia> showall(II)\nInterval(0.1, 0.1)It looks like II contains (the true) 0.1, but from the above discussion we see that it does not. In order to contain 0.1, the end-points of the interval must be rounded outwards (\"directed rounding\"): the lower bound is rounded down, and the upper bound is rounded up.This rounding is handled by the @interval  macro, which generates correctly-rounded intervals:julia> a = @interval(0.1)\n[0.0999999, 0.100001]\nThe true 0.1 is now correctly contained in the intervals, so that any calculations on these intervals will contain the true result of calculating with 0.1. For example, if we definejulia> f(x) = 2x + 0.2\nf (generic function with 1 method)\nthen we can apply the function f to the interval a to obtainjulia> f(a)\n[0.399999, 0.400001]\n\njulia> showall(f(a))\nInterval(0.39999999999999997, 0.4)The result correctly contains the true 0.4."
},

{
    "location": "rounding.html#More-detail:-the-internal-representation-1",
    "page": "Rounding",
    "title": "More detail: the internal representation",
    "category": "section",
    "text": "Let's look at the internal representation of the Float64 number 0.1:julia> bits(0.1)\n\"0011111110111001100110011001100110011001100110011001100110011010\"The last 53 bits of these 64 bits correspond to the binary expansion of 0.1, which is0.000110011001100110011001100110011001100...We see that the expansion is periodic; in fact, the binary expansion of 0.1 has an infinite repetition of the sequence of digits 1100. It is thus impossible to represent the decimal 0.1 in binary, with any precision.The true value must be approximated by a floating-point number with fixed precision – this procedure is called rounding. For positive numbers, rounding down may be accomplished simply by truncating the expansion; rounding up is accomplished by incrementing the final binary digit and propagating any resulting changes."
},

{
    "location": "api.html#",
    "page": "API",
    "title": "API",
    "category": "page",
    "text": "DocTestSetup = quote\n    using IntervalArithmetic\nend"
},

{
    "location": "api.html#IntervalArithmetic.DecoratedInterval",
    "page": "API",
    "title": "IntervalArithmetic.DecoratedInterval",
    "category": "Type",
    "text": "DecoratedInterval\n\nA DecoratedInterval is an interval, together with a decoration, i.e. a flag that records the status of the interval when thought of as the result of a previously executed sequence of functions acting on an initial interval.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.@biginterval-Tuple{Any,Vararg{Any,N}}",
    "page": "API",
    "title": "IntervalArithmetic.@biginterval",
    "category": "Macro",
    "text": "The @biginterval macro constructs an interval with BigFloat entries.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.@floatinterval-Tuple{Any,Vararg{Any,N}}",
    "page": "API",
    "title": "IntervalArithmetic.@floatinterval",
    "category": "Macro",
    "text": "The @floatinterval macro constructs an interval with Float64 entries.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.@format-Tuple{Vararg{Any,N}}",
    "page": "API",
    "title": "IntervalArithmetic.@format",
    "category": "Macro",
    "text": "@format [style::Symbol] [decorations::Bool] [sigfigs::Integer]\n\nThe @format macro provides a simple interface to control the output format for intervals. These options are passed to the setformat function.\n\nThe arguments may be in any order and of type:\n\nSymbol: the output format (:full, :standard or :midpoint)\nBool: whether to display decorations\nInteger: the number of significant figures\n\nE.g.\n\njulia> x = 0.1..0.3\n@[0.0999999, 0.300001]\n\njulia> @format full\n\njulia> x\nInterval(0.09999999999999999, 0.30000000000000004)\n\njulia> @format standard 3\n\njulia> x\n[0.0999, 0.301]\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.@interval-Tuple{Any,Vararg{Any,N}}",
    "page": "API",
    "title": "IntervalArithmetic.@interval",
    "category": "Macro",
    "text": "The @interval macro is the main method to create an interval. It converts each expression into a narrow interval that is guaranteed to contain the true value passed by the user in the one or two expressions passed to it. When passed two expressions, it takes the hull of the resulting intervals to give a guaranteed containing interval.\n\nExamples:\n\n    @interval(0.1)\n\n    @interval(0.1, 0.2)\n\n    @interval(1/3, 1/6)\n\n    @interval(1/3^2)\n\n\n\n"
},

{
    "location": "api.html#Base.widen-Tuple{IntervalArithmetic.Interval{T<:AbstractFloat}}",
    "page": "API",
    "title": "Base.widen",
    "category": "Method",
    "text": "widen(x) widens the lowest and highest bounds of x to the previous and next representable floating-point numbers, respectively.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.cancelminus",
    "page": "API",
    "title": "IntervalArithmetic.cancelminus",
    "category": "Function",
    "text": "cancelminus(xx, yy)\n\nDecorated interval extension; the result is decorated as trv, following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.cancelminus-Tuple{IntervalArithmetic.Interval{T<:Real},IntervalArithmetic.Interval{T<:Real}}",
    "page": "API",
    "title": "IntervalArithmetic.cancelminus",
    "category": "Method",
    "text": "cancelminus(a, b)\n\nReturn the unique interval c such that b+c=a.\n\nSee Section 12.12.5 of the IEEE-1788 Standard for Interval Arithmetic.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.cancelplus",
    "page": "API",
    "title": "IntervalArithmetic.cancelplus",
    "category": "Function",
    "text": "cancelplus(xx, yy)\n\nDecorated interval extension; the result is decorated as trv, following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.cancelplus-Tuple{IntervalArithmetic.Interval,IntervalArithmetic.Interval}",
    "page": "API",
    "title": "IntervalArithmetic.cancelplus",
    "category": "Method",
    "text": "cancelplus(a, b)\n\nReturns the unique interval c such that b-c=a; it is equivalent to cancelminus(a, −b).\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.diam-Tuple{IntervalArithmetic.Interval{T<:Real}}",
    "page": "API",
    "title": "IntervalArithmetic.diam",
    "category": "Method",
    "text": "diam(a::Interval)\n\nReturn the diameter (length) of the Interval a.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.emptyinterval-Tuple{Type{T<:Real}}",
    "page": "API",
    "title": "IntervalArithmetic.emptyinterval",
    "category": "Method",
    "text": "emptyintervals are represented as the interval [∞, -∞]; note that this interval is an exception to the fact that the lower bound is larger than the upper one.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.entireinterval-Tuple{Type{T<:Real}}",
    "page": "API",
    "title": "IntervalArithmetic.entireinterval",
    "category": "Method",
    "text": "entireintervals represent the whole Real line: [-∞, ∞].\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.hull",
    "page": "API",
    "title": "IntervalArithmetic.hull",
    "category": "Function",
    "text": "hull(xx, yy)\n\nDecorated interval extension; the result is decorated as trv, following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.hull-Tuple{IntervalArithmetic.Interval{T},IntervalArithmetic.Interval{T}}",
    "page": "API",
    "title": "IntervalArithmetic.hull",
    "category": "Method",
    "text": "hull(a, b)\n\nReturns the \"interval hull\" of the intervals a and b, considered as (extended) sets of real numbers, i.e. the smallest interval that contains all of a and b.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.iscommon-Tuple{IntervalArithmetic.Interval}",
    "page": "API",
    "title": "IntervalArithmetic.iscommon",
    "category": "Method",
    "text": "iscommon(x) checks if x is a common interval, i.e. a non-empty, bounded, real interval.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.isthin-Tuple{IntervalArithmetic.Interval}",
    "page": "API",
    "title": "IntervalArithmetic.isthin",
    "category": "Method",
    "text": "isthin(x) corresponds to isSingleton, i.e. it checks if x is the set consisting of a single exactly representable float. Thus any float which is not exactly representable does not yield a thin interval.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.mid-Tuple{IntervalArithmetic.Interval{T},Any}",
    "page": "API",
    "title": "IntervalArithmetic.mid",
    "category": "Method",
    "text": "mid(a::Interval, α=0.5)\n\nFind the midpoint (or, in general, an intermediate point) at a distance α along the interval a. The default is the true midpoint at α=0.5.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.nai-Tuple{Type{T<:Real}}",
    "page": "API",
    "title": "IntervalArithmetic.nai",
    "category": "Method",
    "text": "NaI not-an-interval: [NaN, NaN].\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.pow-Tuple{IntervalArithmetic.Interval{T},Integer}",
    "page": "API",
    "title": "IntervalArithmetic.pow",
    "category": "Method",
    "text": "pow(x::Interval, n::Integer)\n\nA faster implementation of x^n using power_by_squaring. pow(x, n) will usually return an interval that is slightly larger than that calculated byx^n`, but is guaranteed to be a correct enclosure when using multiplication with correct rounding.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.radius-Tuple{IntervalArithmetic.Interval}",
    "page": "API",
    "title": "IntervalArithmetic.radius",
    "category": "Method",
    "text": "radius(a::Interval)\n\nReturn the radius of the Interval a, such that a ⊆ m ± radius, where m = mid(a) is the midpoint.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.setformat",
    "page": "API",
    "title": "IntervalArithmetic.setformat",
    "category": "Function",
    "text": "setformat(;kw)\n\nsetformat changes how intervals are displayed using keyword arguments. The following options are available:\n\nformat: interval output format\n:standard: [1, 2]\n:full: Interval(1, 2)\n:midpoint: 1.5 ± 0.5\nsigfigs: number of significant figures to show in standard mode; the default is 6\ndecorations (boolean):  show decorations or not\n\nExample:\n\njulia> setformat(:full, decorations=true)\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.DECORATION",
    "page": "API",
    "title": "IntervalArithmetic.DECORATION",
    "category": "Type",
    "text": "DECORATION\n\nEnumeration constant for the types of interval decorations. The nomenclature of the follows the IEEE-1788 (2015) standard (sect 11.2):\n\ncom -> 4: common: bounded, non-empty\ndac -> 3: defined (nonempty) and continuous\ndef -> 2: defined (nonempty)\ntrv -> 1: always true (no information)\nill -> 0: nai (\"not an interval\")\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.IntervalRounding",
    "page": "API",
    "title": "IntervalArithmetic.IntervalRounding",
    "category": "Type",
    "text": "Interval rounding trait type\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.@round-Tuple{Any,Any}",
    "page": "API",
    "title": "IntervalArithmetic.@round",
    "category": "Macro",
    "text": "@round(ex1, ex2)\n\nMacro for internal use that creates an interval by rounding down ex1 and rounding up ex2. Each expression may consist of only a single operation that needs rounding, e.g. a.lo + b.lo or sin(a.lo). It also handles min(...) and max(...), where the arguments are each themselves single operations.\n\nThe macro uses the internal round_expr function to transform e.g. a + b into +(a, b, RoundDown).\n\nThe user-facing equivalent is @interval, which can handle much more general cases.\n\n\n\n"
},

{
    "location": "api.html#Base.:==-Tuple{IntervalArithmetic.Interval,IntervalArithmetic.Interval}",
    "page": "API",
    "title": "Base.:==",
    "category": "Method",
    "text": "==(a,b)\n\nChecks if the intervals a and b are equal.\n\n\n\n"
},

{
    "location": "api.html#Base.:⊆-Tuple{IntervalArithmetic.Interval,IntervalArithmetic.Interval}",
    "page": "API",
    "title": "Base.:⊆",
    "category": "Method",
    "text": "issubset(a,b)\n⊆(a,b)\n\nChecks if all the points of the interval a are within the interval b.\n\n\n\n"
},

{
    "location": "api.html#Base.Rounding.setrounding-Tuple{Type{IntervalArithmetic.Interval},Symbol}",
    "page": "API",
    "title": "Base.Rounding.setrounding",
    "category": "Method",
    "text": "setrounding(Interval, rounding_type::Symbol)\n\nSet the rounding type used for all interval calculations on Julia v0.6 and above. Valid rounding_types are :correct, :fast and :none.\n\n\n\n"
},

{
    "location": "api.html#Base.in-Tuple{T<:Real,IntervalArithmetic.Interval}",
    "page": "API",
    "title": "Base.in",
    "category": "Method",
    "text": "in(x, a)\n∈(x, a)\n\nChecks if the number x is a member of the interval a, treated as a set. Corresponds to isMember in the ITF-1788 Standard.\n\n\n\n"
},

{
    "location": "api.html#Base.intersect",
    "page": "API",
    "title": "Base.intersect",
    "category": "Function",
    "text": "intersect(xx, yy)\n\nDecorated interval extension; the result is decorated as trv, following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).\n\n\n\n"
},

{
    "location": "api.html#Base.intersect-Tuple{IntervalArithmetic.Interval{T},IntervalArithmetic.Interval{T}}",
    "page": "API",
    "title": "Base.intersect",
    "category": "Method",
    "text": "intersect(a, b)\n∩(a,b)\n\nReturns the intersection of the intervals a and b, considered as (extended) sets of real numbers. That is, the set that contains the points common in a and b.\n\n\n\n"
},

{
    "location": "api.html#Base.parse-Tuple{Type{IntervalArithmetic.DecoratedInterval{T}},AbstractString}",
    "page": "API",
    "title": "Base.parse",
    "category": "Method",
    "text": "parse{T}(DecoratedInterval{T}, s::AbstractString)\n\nParse a string of the form \"[a, b]_dec\" as a DecoratedInterval with decoration dec.\n\n\n\n"
},

{
    "location": "api.html#Base.parse-Tuple{Type{IntervalArithmetic.Interval{T}},AbstractString}",
    "page": "API",
    "title": "Base.parse",
    "category": "Method",
    "text": "parse{T}(Interval{T}, s::AbstractString)\n\nParse a string as an interval. Formats allowed include:\n\n\"1\"\n\"[1]\"\n\"[3.5, 7.2]\"\n\"[-0x1.3p-1, 2/3]\"  # use numerical expressions\n\n\n\n"
},

{
    "location": "api.html#Base.round-Tuple{IntervalArithmetic.Interval}",
    "page": "API",
    "title": "Base.round",
    "category": "Method",
    "text": "round(a::Interval[, RoundingMode])\n\nReturns the interval with rounded to an interger limits.\n\nFor compliance with the IEEE Std 1788-2015, \"roundTiesToEven\" corresponds to round(a) or round(a, RoundNearest), and \"roundTiesToAway\" to round(a, RoundNearestTiesAway).\n\n\n\n"
},

{
    "location": "api.html#Base.setdiff-Tuple{IntervalArithmetic.Interval,IntervalArithmetic.Interval}",
    "page": "API",
    "title": "Base.setdiff",
    "category": "Method",
    "text": "setdiff(x::Interval, y::Interval)\n\nCalculate the set difference x \\ y, i.e. the set of values that are inside the interval x but not inside y.\n\nReturns an array of intervals. The array may:\n\nbe empty if x ⊆ y;\ncontain a single interval, if y overlaps x\ncontain two intervals, if y is strictly contained within x.\n\n\n\n"
},

{
    "location": "api.html#Base.setdiff-Tuple{IntervalArithmetic.IntervalBox{N,T},IntervalArithmetic.IntervalBox{N,T}}",
    "page": "API",
    "title": "Base.setdiff",
    "category": "Method",
    "text": "setdiff(A::IntervalBox{N,T}, B::IntervalBox{N,T})\n\nReturns a vector of IntervalBoxes that are in the set difference A \\ B, i.e. the set of x that are in A but not in B.\n\nAlgorithm: Start from the total overlap (in all directions); expand each direction in turn.\n\n\n\n"
},

{
    "location": "api.html#Base.union",
    "page": "API",
    "title": "Base.union",
    "category": "Function",
    "text": "union(xx, yy)\n\nDecorated interval extension; the result is decorated as trv, following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).\n\n\n\n"
},

{
    "location": "api.html#Base.union-Tuple{IntervalArithmetic.Interval{T},IntervalArithmetic.Interval{T}}",
    "page": "API",
    "title": "Base.union",
    "category": "Method",
    "text": "union(a, b)\n∪(a,b)\n\nReturns the union (convex hull) of the intervals a and b; it is equivalent to hull(a,b).\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.big53-Tuple{IntervalArithmetic.Interval{Float64}}",
    "page": "API",
    "title": "IntervalArithmetic.big53",
    "category": "Method",
    "text": "big53 creates an equivalent BigFloat interval to a given Float64 interval.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.find_quadrants-Tuple{AbstractFloat}",
    "page": "API",
    "title": "IntervalArithmetic.find_quadrants",
    "category": "Method",
    "text": "Finds the quadrant(s) corresponding to a given floating-point number. The quadrants are labelled as 0 for x ∈ [0, π/2], etc. For numbers very near a boundary of the quadrant, a tuple of two quadrants is returned. The minimum or maximum must then be chosen appropriately.\n\nThis is a rather indirect way to determine if π/2 and 3π/2 are contained in the interval; cf. the formula for sine of an interval in Tucker, Validated Numerics.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.labelled_setdiff-Tuple{IntervalArithmetic.Interval{T},IntervalArithmetic.Interval{T}}",
    "page": "API",
    "title": "IntervalArithmetic.labelled_setdiff",
    "category": "Method",
    "text": "Returns a list of pairs (interval, label) label is 1 if the interval is excluded from the setdiff label is 0 if the interval is included in the setdiff label is -1 if the intersection of the two intervals was empty\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.make_interval-Tuple{Any,Any,Any}",
    "page": "API",
    "title": "IntervalArithmetic.make_interval",
    "category": "Method",
    "text": "make_interval does the hard work of taking expressions and making each literal (0.1, 1, etc.) into a corresponding interval construction, by calling transform.\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.round_expr-Tuple{Expr,RoundingMode}",
    "page": "API",
    "title": "IntervalArithmetic.round_expr",
    "category": "Method",
    "text": "round_expr(ex::Expr, rounding_mode::RoundingMode)\n\nTransforms a single expression by applying a rounding mode, e.g.\n\na + b into +(a, b, RoundDown)\nsin(a) into sin(a, RoundDown)\n\n\n\n"
},

{
    "location": "api.html#IntervalArithmetic.transform-Tuple{Symbol,Any,Any}",
    "page": "API",
    "title": "IntervalArithmetic.transform",
    "category": "Method",
    "text": "transform transforms a string by applying the function f and type T to each argument, i.e. :(x+y) is transformed to :(f(T, x) + f(T, y))\n\n\n\n"
},

{
    "location": "api.html#API-1",
    "page": "API",
    "title": "API",
    "category": "section",
    "text": "Pages = [\"api.md\"]\nModule = [IntervalArithmetic]\nOrder = [:type, :macro, :function, :constant]Modules = [IntervalArithmetic]\nOrder   = [:type, :macro, :function, :constant]"
},

]}
