%% @hidden

-module(intervals).

-include("music_scale_types.hrl").

-export([interval_from/3]).

-include_lib("eunit/include/eunit.hrl").


-spec interval_from(note(), interval(), direction()) -> note().
interval_from({note, NoteName, _Accidental} = Note,
              {interval, IntervalName, _IntervalType} = Interval,
              Direction) ->
    TargetNoteName =
        case Direction of
            up -> degrees:up(NoteName, IntervalName);
            down -> degrees:down(NoteName, IntervalName);
            _ -> erlang:error(badarg)
        end,
    NotePitchClass = chromatic:pitch_class(Note),
    Semitones = chromatic:semitone_count(Interval),
    TargetPitchClass =
        case Direction of
            up -> (NotePitchClass + Semitones) rem 12;
            down -> (NotePitchClass - Semitones + 24) rem 12
        end,
    TargetAccidentalUp = TargetPitchClass - chromatic:pitch_class({note, TargetNoteName, 0}),
    TargetAccidentalDown = TargetAccidentalUp - 12,
    TargetAccidental =
        if
            abs(TargetAccidentalUp) > abs(TargetAccidentalDown) ->
                TargetAccidentalDown;
            true ->
                TargetAccidentalUp
        end,
    {note, TargetNoteName, TargetAccidental};
interval_from(_, _, _) ->
    erlang:error(badarg).


%%% Tests

-dialyzer({nowarn_function,
           [interval_from_badarg_test/0]}).


notes() ->
    [a, h, c, d, e, f, g].


interval_from_up_test() ->
    ?assertEqual({note, c, 0},
                 interval_from({note, c, 0},
                               {interval, unison, perfect},
                               up)),
    ?assertEqual({note, d, 0},
                 interval_from({note, c, 0},
                               {interval, second, major},
                               up)),
    ?assertEqual({note, e, 0},
                 interval_from({note, c, 0},
                               {interval, third, major},
                               up)),
    ?assertEqual({note, f, 0},
                 interval_from({note, c, 0},
                               {interval, fourth, perfect},
                               up)),
    ?assertEqual({note, g, 0},
                 interval_from({note, c, 0},
                               {interval, fifth, perfect},
                               up)),
    ?assertEqual({note, a, 0},
                 interval_from({note, g, 0},
                               {interval, second, major},
                               up)),
    ?assertEqual({note, c, 0},
                 interval_from({note, c, 0},
                               {interval, octave, perfect},
                               up)).


interval_from_down_test() ->
    ?assertEqual({note, c, 0},
                 interval_from({note, c, 0},
                               {interval, unison, perfect},
                               down)),
    ?assertEqual({note, h, -1},
                 interval_from({note, c, 0},
                               {interval, second, major},
                               down)),
    ?assertEqual({note, a, -1},
                 interval_from({note, c, 0},
                               {interval, third, major},
                               down)),
    ?assertEqual({note, c, 0},
                 interval_from({note, c, 0},
                               {interval, octave, perfect},
                               down)).


interval_from_accidentals_test() ->
    ?assertEqual({note, e, 1},
                 interval_from({note, c, 0},
                               {interval, third, augmented},
                               up)),
    ?assertEqual({note, d, -2},
                 interval_from({note, c, 0},
                               {interval, second, diminished},
                               up)).


interval_from_roundtrip_test() ->
    Notes = [ {note, N, 0} || N <- notes() ],
    Intervals = [{interval, unison, perfect},
                 {interval, second, minor},
                 {interval, second, major},
                 {interval, third, minor},
                 {interval, third, major},
                 {interval, fourth, perfect},
                 {interval, fifth, perfect},
                 {interval, octave, perfect}],
    lists:foreach(
      fun(Note) ->
              lists:foreach(
                fun(Interval) ->
                        Up = interval_from(Note, Interval, up),
                        Down = interval_from(Up, Interval, down),
                        ?assertEqual(Note, Down)
                end,
                Intervals)
      end,
      Notes).


interval_from_badarg_test() ->
    ?assertError(badarg, interval_from(foo, {interval, unison, perfect}, up)),
    ?assertError(badarg, interval_from({note, c, 0}, foo, up)),
    ?assertError(badarg,
                 interval_from({note, c, 0},
                               {interval, unison, perfect},
                               sideways)).
