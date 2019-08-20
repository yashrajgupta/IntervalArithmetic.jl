using IntervalArithmetic
using Test

@testset "IntervalToText" begin
    @test interval_to_string(Interval(1, 4)) == "[1, 4]"
    @test interval_to_string(Interval(1.1, 4.1)) == "[1.1, 4.1]"
    @test interval_to_string(Interval(1.12, 4.13)) == "[1.12, 4.13]"
    @test interval_to_string(Interval(1.123423423, 4.1334224)) == "[1.12342, 4.13343]"
    @test interval_to_string(Interval(1.1234234232342325423543452, 4.13343242352543534532534224)) == "[1.12342, 4.13344]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "6 : [c  .  ]") == "[2, 4]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "7 : [c  .  ]") == " [2, 4]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "8 : [c  .  ]") == "[2.3, 4]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "9 : [c  .  ]") == "[2.35, 4]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "10 : [c  .  ]") == "[2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "11 : [c  .  ]") == "[2.35, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "12 : [c  .  ]") == "[2.35, 3.57]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "13 : [c  .  ]") == "[2.353, 3.57]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "14 : [c  .  ]") == "[2.353, 3.565]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "15 : [c  .  ]") == "[2.3534, 3.565]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "16 : [c  .  ]") == "[2.3534, 3.5646]"
    @test interval_to_string(Interval(2.3534534644, 3.56453), "17 : [c  .  ]") == "[2.35345, 3.5646]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "18 : [c  .  ]") == "[2.35345, 3.56454]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "19 : [c  .  ]") == " [2.35345, 3.56454]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "20 : [c  .  ]") == "  [2.35345, 3.56454]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 1 .  ]") == "[2, 4]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 2 .  ]") == "[ 2,  4]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 3 .  ]") == "[2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 4 .  ]") == "[2.35, 3.57]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 5 .  ]") == "[2.353, 3.565]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 6 .  ]") == "[2.3534, 3.5646]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 7 .  ]") == "[2.35345, 3.56454]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 8 .  ]") == "[ 2.35345,  3.56453]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 9 .  ]") == "[  2.35345,   3.56453]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 10 .  ]") == "[   2.35345,    3.56453]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 0 ]") == "[2, 4]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 1 ]") == "[2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 2 ]") == "[2.35, 3.57]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 3 ]") == "[2.353, 3.565]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 4 ]") == "[2.3534, 3.5646]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 5 ]") == "[2.35345, 3.56454]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 6 ]") == "[2.353453, 3.564538]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 7 ]") == "[2.3534534, 3.5645379]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 8 ]") == "[2.35345346, 3.56453789]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 9 ]") == "[2.353453464, 3.564537888]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 10 ]") == "[2.3534534643, 3.5645378877]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 11 ]") == "[2.35345346439, 3.56453788769]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 12 ]") == "[2.353453464400, 3.564537887688]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 13 ]") == "[2.3534534644000, 3.5645378876871]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 14 ]")== "[2.35345346439999, 3.56453788768701]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c  . 15 ]") == "[2.353453464400000, 3.564537887687001]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 2 . 0 ]") == "[ 2,  4]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 3 . 1 ]") == "[2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 4 . 1 ]") == "[ 2.3,  3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 4 . 2 ]") == "[2.35, 3.57]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 5 . 2 ]") == "[ 2.35,  3.57]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "12 : [c  . 2 ]") == "[2.35, 3.57]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "12 : [c  . 1 ]") == "  [2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "12 : [c  . 0 ]") == "      [2, 4]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "14 : [c  . 3 ]") == "[2.353, 3.565]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "15 : [c  . 3 ]") == " [2.353, 3.565]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c  . 4 ]") == "[2.3534, 3.5646]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c 3 .  ]") == "      [2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c 3 . 1]") == "      [2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "12 : [c 3 . 1]") == "  [2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "10 : [c 3 . 1]") == "[2.3, 3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "12 : [c 4 . 1]") == "[ 2.3,  3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "12 : [ 4 . 1]") ==  "[ 2.3,  3.6]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "12 : [  4 . 1]") == "[ 2.3,  3.6]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "10 : [c .  e]") == "[2e1, 2e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "11 : [c .  e]") == " [2e1, 2e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "12 : [c .  e]") == "[2.3e1, 2e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "13 : [c .  e]") == "[2.35e1, 2e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "14 : [c .  e]") == "[2.3e1, 1.1e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "15 : [c .  e]") == "[2.35e1, 1.1e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "16 : [c .  e]") == "[2.35e1, 1.01e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "17 : [c .  e]") == "[2.353e1, 1.01e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "18 : [c .  e]") == "[2.353e1, 1.007e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "19 : [c .  e]") == "[2.3534e1, 1.007e2]"
    @test interval_to_string(Interval(23.534534644, 100.64537887687), "20 : [c .  e]") == "[2.3534e1, 1.0065e2]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 3 .  e]") == "[2e0, 4e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 4 .  e]") == "[ 2e0,  4e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 5 .  e]") == "[2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 6 .  e]") == "[2.35e0, 3.57e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 7 .  e]") == "[2.353e0, 3.565e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 8 .  e]") == "[2.3534e0, 3.5646e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 9 .  e]") == "[2.35345e0, 3.56454e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 10 .  e]") == "[ 2.35345e0,  3.56453e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 11 .  e]") == "[  2.35345e0,   3.56453e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 12 .  e]") == "[   2.35345e0,    3.56453e0]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 0 e]") == "[2e0, 4e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 1 e]") == "[2.3e0, 3.1e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 2 e]") == "[2.35e0, 3.06e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 3 e]") == "[2.353e0, 3.057e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 4 e]") == "[2.3534e0, 3.0565e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 5 e]") == "[2.35345e0, 3.05646e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 6 e]") == "[2.353453e0, 3.056454e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 7 e]") == "[2.3534534e0, 3.0564538e1]"
    @test interval_to_string(Interval(2.3534534644, 30.564537887687), " : [c  . 8 e]") == "[2.35345346e0, 3.05645379e1]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 3 . 0 e]") == "[2e0, 4e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 5 . 1 e]") == "[2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 6 . 1 e]") == "[ 2.3e0,  3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 6 . 2 e]") == "[2.35e0, 3.57e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), " : [c 7 . 2 e]") == "[ 2.35e0,  3.57e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c  . 2 e]") == "[2.35e0, 3.57e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c  . 1 e]") == "  [2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c  . 0 e]") == "      [2e0, 4e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "18 : [c  . 3 e]") == "[2.353e0, 3.565e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "19 : [c  . 3 e]") == " [2.353e0, 3.565e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "20 : [c  . 4 e]") == "[2.3534e0, 3.5646e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c 5 .  e]") == "  [2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c 5 . 1 e]") == "  [2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c 5 . 1 e]") == "  [2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "14 : [c 5 . 1 e]") == "[2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [c 6 . 1 e]") == "[ 2.3e0,  3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [  5 . 1 e]") ==  "  [2.3e0, 3.6e0]"
    @test interval_to_string(Interval(2.3534534644, 3.564537887687), "16 : [  6 . 1 e]") == "[ 2.3e0,  3.6e0]"

    @test interval_to_string(3.55 .. 3.578, "6 :  4 . 2 ?") == "3.56?2"
    @test interval_to_string(3.55 .. 3.578, "7 :  4 . 2 ?") == " 3.56?2"
    @test interval_to_string(3.55 .. 3.578, " :u 4 . 2 ?") == "3.55?3u"
    @test interval_to_string(3.55 .. 3.578, "8 :u 4 . 2 ?") == " 3.55?3u"
    @test interval_to_string(3.55 .. 3.578, " :d 4 . 2 ?") == "3.58?3d"
    @test interval_to_string(3.55 .. 3.578, "8 :d 4 . 2 ?") == " 3.58?3d"
    @test interval_to_string(Interval(3.555, 3.565), "7 : . 3 ?") == "3.560?5"
    @test interval_to_string(Interval(3.555, 3.565), "8 : . 3 ?") == " 3.560?5"
    @test interval_to_string(Interval(3.555, 3.565), "8 :c 6 . 3 ?") == " 3.560?5"
    @test interval_to_string(Interval(3.555, 3.565), "8 :0 6 . 3 ?") == "03.560?5"

    @test interval_to_string(35.5 .. 36.78, "8 :  4 . 2 ? 1 e") == "3.61?7e1"
    @test interval_to_string(35.5 .. 36.78, "9 :  4 . 2 ? 1 e") == " 3.61?7e1"
    @test interval_to_string(35.55 .. 35.65, "9 : . 3 ? 1 e") == "3.560?6e1"
    @test interval_to_string(35.55 .. 35.65, "10 : . 3 ? 1 e") == " 3.560?6e1"
    @test interval_to_string(35.55 .. 35.65, "10 :c 6 . 3 ? 1 e") == " 3.560?6e1"
    @test interval_to_string(35.55 .. 35.65, "10 :0 6 . 3 ? 1 e") == "03.560?6e1"

    @test interval_to_string(3.55 .. 3.578, "6 :  4 .  ?") == "3.56?2"
    @test interval_to_string(3.55 .. 3.578, "7 :  4 .  ?") == " 3.56?2"
    @test interval_to_string(3.55 .. 3.578, " :u 4 .  ?") == "3.55?3u"
    @test interval_to_string(3.55 .. 3.578, "8 :u 4 . ?") == " 3.55?3u"
    @test interval_to_string(3.55 .. 3.578, " :d 4 .  ?") == "3.58?3d"
    @test interval_to_string(3.55 .. 3.578, "8 :d 4 . ?") == " 3.58?3d"
    @test interval_to_string(Interval(3.555, 3.565), "7 : .  ?") == "3.560?6"
    @test interval_to_string(Interval(3.555, 3.565), "8 : .  ?") == " 3.560?6"
    @test interval_to_string(Interval(3.555, 3.565), "8 :c 6 .  ?") == " 3.560?6"
    @test interval_to_string(Interval(3.555, 3.565), "8 :0 6 . ?") == "03.560?6"

    @test interval_to_string(35.5 .. 35.78, "8 :  4 .  ? e") == "3.56?2e1"
    @test interval_to_string(35.5 .. 35.78, "9 :  4 .  ? e") == " 3.56?2e1"
    @test interval_to_string(Interval(35.55, 35.65), "9 : .  ? e") == "3.560?6e1"
    @test interval_to_string(Interval(35.55, 35.65), "10 : .  ? e") == " 3.560?6e1"
    @test interval_to_string(Interval(35.55, 35.65), "10 :c 6 .  ? e") == " 3.560?6e1"
    @test interval_to_string(Interval(35.55, 35.65), "10 :0 6 . ? e") == "03.560?6e1"
end