-module(music_scale_SUITE).

-include_lib("common_test/include/ct.hrl").

%% Test server callbacks
-export([suite/0, all/0]).

%% Test cases
-export([interval_from_up_test/1,
         interval_from_down_test/1,
         interval_from_accidentals_test/1,
         interval_from_roundtrip_test/1,
         interval_from_badarg_test/1,
         interval_from_all_types_test/1,
         tonality_from_natural_major_test/1,
         tonality_from_natural_minor_test/1,
         tonality_from_harmonic_minor_test/1,
         tonality_from_pentatonic_major_test/1,
         tonality_from_pentatonic_minor_test/1,
         tonality_from_badarg_test/1,
         chord_from_major_triad_test/1,
         chord_from_minor_triad_test/1,
         chord_from_diminished_triad_test/1,
         chord_from_augmented_triad_test/1,
         chord_from_major_seventh_test/1,
         chord_from_minor_seventh_test/1,
         chord_from_dominant_seventh_test/1,
         chord_from_badarg_test/1,
         chart_for_scale_test/1,
         chart_for_arpeggio_test/1,
         chart_for_scale_minor_test/1,
         standard_guitar_fretboard_test/1,
         known_scales_test/1,
         known_chords_test/1,
         tonality_from_all_scales_test/1,
         chord_from_all_chords_test/1]).

suite() ->
     [{timetrap,{minutes,1}}].

all() ->
    [interval_from_up_test,
     interval_from_down_test,
     interval_from_accidentals_test,
     interval_from_roundtrip_test,
     interval_from_badarg_test,
     interval_from_all_types_test,
     tonality_from_natural_major_test,
     tonality_from_natural_minor_test,
     tonality_from_harmonic_minor_test,
     tonality_from_pentatonic_major_test,
     tonality_from_pentatonic_minor_test,
     tonality_from_badarg_test,
     chord_from_major_triad_test,
     chord_from_minor_triad_test,
     chord_from_diminished_triad_test,
     chord_from_augmented_triad_test,
     chord_from_major_seventh_test,
     chord_from_minor_seventh_test,
     chord_from_dominant_seventh_test,
     chord_from_badarg_test,
     chart_for_scale_test,
     chart_for_arpeggio_test,
     chart_for_scale_minor_test,
     standard_guitar_fretboard_test,
     known_scales_test,
     known_chords_test,
     tonality_from_all_scales_test,
     chord_from_all_chords_test].

%% interval_from tests

interval_from_up_test(_Config) ->
    <<"c"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, unison, perfect}, up),
    <<"d"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, second, major}, up),
    <<"e"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, third, major}, up),
    <<"f"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, fourth, perfect}, up),
    <<"g"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, fifth, perfect}, up),
    <<"a"/utf8>> = music_scale:interval_from(<<"g"/utf8>>,
                      {interval, second, major}, up),
    <<"c"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, octave, perfect}, up).

interval_from_down_test(_Config) ->
    <<"c"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, unison, perfect}, down),
    <<"b"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, second, major}, down),
    <<"a♭"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, third, major}, down),
    <<"g"/utf8>> = music_scale:interval_from(<<"a"/utf8>>,
                      {interval, second, major}, down),
    <<"c"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, octave, perfect}, down).

interval_from_accidentals_test(_Config) ->
    <<"e♯"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, third, augmented}, up),
    <<"d𝄫"/utf8>> = music_scale:interval_from(<<"c"/utf8>>,
                      {interval, second, diminished}, up).

interval_from_roundtrip_test(_Config) ->
    Notes = [<<"a"/utf8>>,
             <<"b"/utf8>>,
             <<"h"/utf8>>,
             <<"c"/utf8>>,
             <<"c♯"/utf8>>,
             <<"d"/utf8>>,
             <<"e♭"/utf8>>,
             <<"e"/utf8>>,
             <<"f"/utf8>>,
             <<"f♯"/utf8>>,
             <<"g"/utf8>>,
             <<"a♭"/utf8>>],
    Intervals = [
        {interval, unison, perfect},
        {interval, second, minor}, {interval, second, major},
        {interval, third, minor}, {interval, third, major},
        {interval, fourth, perfect},
        {interval, fifth, perfect},
        {interval, octave, perfect}
    ],
    lists:foreach(
        fun(Note) ->
            lists:foreach(
                fun(Interval) ->
                    Up = music_scale:interval_from(Note, Interval, up),
                    Down = music_scale:interval_from(Up, Interval, down),
                    case Down of
                        Note -> ok;
                        _ -> ct:fail({roundtrip_mismatch,
                                      note, Note,
                                      interval, Interval,
                                      up, Up,
                                      down, Down})
                    end
                end,
                Intervals
            )
        end,
        Notes
    ).

interval_from_badarg_test(_Config) ->
    try
        music_scale:interval_from(<<"c"/utf8>>,
                   {interval, unison, perfect}, sideways),
        ct:fail("interval_from(_, _, sideways) should throw badarg")
    catch
        error:badarg -> ok;
        _:_ -> ct:fail(unexpected_exception)
    end,
    try
        music_scale:interval_from(<<"c"/utf8>>,
                   not_an_interval, up),
        ct:fail("interval_from(_, not_an_interval, _) should throw badarg")
    catch
        error:badarg -> ok;
        _:_ -> ct:fail(unexpected_exception)
    end,
    try
        music_scale:interval_from(not_a_note,
                   {interval, unison, perfect}, up),
        ct:fail("interval_from(not_a_note, _, _) should throw badarg")
    catch
        error:badarg -> ok;
        _:_ -> ct:fail(unexpected_exception)
    end.

interval_from_all_types_test(_Config) ->
    AllIntervals = [
        {interval, unison, perfect},
        {interval, second, minor},
        {interval, second, major},
        {interval, third, minor},
        {interval, third, major},
        {interval, fourth, perfect},
        {interval, fourth, augmented},
        {interval, fifth, diminished},
        {interval, fifth, perfect},
        {interval, fifth, augmented},
        {interval, sixth, minor},
        {interval, sixth, major},
        {interval, seventh, minor},
        {interval, seventh, major},
        {interval, octave, perfect}
    ],
    lists:foreach(
        fun(Interval) ->
            Result = music_scale:interval_from(<<"c"/utf8>>, Interval, up),
            true = is_binary(Result)
        end,
        AllIntervals
    ).

%% tonality_from tests

tonality_from_natural_major_test(_Config) ->
    [
     <<"c"/utf8>>,
     <<"d"/utf8>>,
     <<"e"/utf8>>,
     <<"f"/utf8>>,
     <<"g"/utf8>>,
     <<"a"/utf8>>,
     <<"h"/utf8>>
    ] = music_scale:tonality_from(<<"c"/utf8>>, {scale, natural_major}),
    [
     <<"g"/utf8>>,
     <<"a"/utf8>>,
     <<"h"/utf8>>,
     <<"c"/utf8>>,
     <<"d"/utf8>>,
     <<"e"/utf8>>,
     <<"f♯"/utf8>>
    ] = music_scale:tonality_from(<<"g"/utf8>>, {scale, natural_major}).

tonality_from_natural_minor_test(_Config) ->
    [
     <<"a"/utf8>>,
     <<"h"/utf8>>,
     <<"c"/utf8>>,
     <<"d"/utf8>>,
     <<"e"/utf8>>,
     <<"f"/utf8>>,
     <<"g"/utf8>>
    ] = music_scale:tonality_from(<<"a"/utf8>>, {scale, natural_minor}),
    [
     <<"c"/utf8>>,
     <<"d"/utf8>>,
     <<"e♭"/utf8>>,
     <<"f"/utf8>>,
     <<"g"/utf8>>,
     <<"a♭"/utf8>>,
     <<"b"/utf8>>
    ] = music_scale:tonality_from(<<"c"/utf8>>, {scale, natural_minor}).

tonality_from_badarg_test(_Config) ->
    try
        music_scale:tonality_from(foo, {scale, natural_major}),
        ct:fail("tonality_from(foo, _) should throw badarg")
    catch
        error:badarg -> ok;
        _Class:Reason ->
            ct:fail({unexpected_exception, _Class, Reason})
    end,
    try
        music_scale:tonality_from(<<"c"/utf8>>, not_a_scale),
        ct:fail("tonality_from(_, not_a_scale) should throw badarg")
    catch
        error:badarg -> ok;
        _:_ ->ct:fail(unexpected_exception)
    end.

tonality_from_harmonic_minor_test(_Config) ->
    Result = music_scale:tonality_from(<<"a"/utf8>>, {scale, harmonic_minor}),
    7 = length(Result),
    <<"a"/utf8>> = hd(Result),
    <<"h"/utf8>> = lists:nth(2, Result),
    <<"c"/utf8>> = lists:nth(3, Result),
    <<"d"/utf8>> = lists:nth(4, Result),
    <<"e"/utf8>> = lists:nth(5, Result),
    <<"f"/utf8>> = lists:nth(6, Result),
    <<"g♯"/utf8>> = lists:nth(7, Result).

tonality_from_pentatonic_major_test(_Config) ->
    Result = music_scale:tonality_from(<<"c"/utf8>>, {scale, major_pentatonic}),
    5 = length(Result),
    [<<"c"/utf8>>, <<"d"/utf8>>, <<"e"/utf8>>, <<"g"/utf8>>, <<"a"/utf8>>] = Result.

tonality_from_pentatonic_minor_test(_Config) ->
    Result = music_scale:tonality_from(<<"a"/utf8>>, {scale, minor_pentatonic}),
    5 = length(Result),
    [<<"a"/utf8>>, <<"c"/utf8>>, <<"d"/utf8>>, <<"e"/utf8>>, <<"g"/utf8>>] = Result.

%% chord_from tests

chord_from_major_triad_test(_Config) ->
    [
        <<"c"/utf8>>, <<"e"/utf8>>, <<"g"/utf8>>
    ] = music_scale:chord_from(<<"c"/utf8>>, {chord, major_triad}),
    [
        <<"a"/utf8>>, <<"c♯"/utf8>>, <<"e"/utf8>>
    ] = music_scale:chord_from(<<"a"/utf8>>, {chord, major_triad}).

chord_from_minor_triad_test(_Config) ->
    [
        <<"a"/utf8>>, <<"c"/utf8>>, <<"e"/utf8>>
    ] = music_scale:chord_from(<<"a"/utf8>>, {chord, minor_triad}),
    [
        <<"d"/utf8>>, <<"f"/utf8>>, <<"a"/utf8>>
    ] = music_scale:chord_from(<<"d"/utf8>>, {chord, minor_triad}).

chord_from_diminished_triad_test(_Config) ->
    [
        <<"a"/utf8>>, <<"c"/utf8>>, <<"e♭"/utf8>>
    ] = music_scale:chord_from(<<"a"/utf8>>, {chord, diminished_triad}),
    [
        <<"c"/utf8>>, <<"e♭"/utf8>>, <<"g♭"/utf8>>
    ] = music_scale:chord_from(<<"c"/utf8>>, {chord, diminished_triad}).

chord_from_augmented_triad_test(_Config) ->
    [
        <<"a"/utf8>>, <<"c♯"/utf8>>, <<"e♯"/utf8>>
    ] = music_scale:chord_from(<<"a"/utf8>>, {chord, augmented_triad}),
    [
        <<"f"/utf8>>, <<"a"/utf8>>, <<"c♯"/utf8>>
    ] = music_scale:chord_from(<<"f"/utf8>>, {chord, augmented_triad}).

chord_from_badarg_test(_Config) ->
    try
        music_scale:chord_from(foo, {chord, major_triad}),
        ct:fail("chord_from(foo, _) should throw badarg")
    catch
        error:badarg -> ok;
        _:_ ->ct:fail(unexpected_exception)
    end,
    try
        music_scale:chord_from(<<"c"/utf8>>, not_a_chord),
        ct:fail("chord_from(_, not_a_chord) should throw badarg")
    catch
        error:badarg -> ok;
        _:_ ->ct:fail(unexpected_exception)
    end.

chord_from_major_seventh_test(_Config) ->
    [<<"c"/utf8>>, <<"e"/utf8>>, <<"g"/utf8>>, <<"h"/utf8>>] =
        music_scale:chord_from(<<"c"/utf8>>, {chord, major_7th}),
    [<<"g"/utf8>>, <<"h"/utf8>>, <<"d"/utf8>>, <<"f♯"/utf8>>] =
        music_scale:chord_from(<<"g"/utf8>>, {chord, major_7th}).

chord_from_minor_seventh_test(_Config) ->
    [<<"a"/utf8>>, <<"c"/utf8>>, <<"e"/utf8>>, <<"g"/utf8>>] =
        music_scale:chord_from(<<"a"/utf8>>, {chord, minor_7th}),
    [<<"d"/utf8>>, <<"f"/utf8>>, <<"a"/utf8>>, <<"c"/utf8>>] =
        music_scale:chord_from(<<"d"/utf8>>, {chord, minor_7th}).

chord_from_dominant_seventh_test(_Config) ->
    [<<"c"/utf8>>, <<"e"/utf8>>, <<"g"/utf8>>, <<"b"/utf8>>] =
        music_scale:chord_from(<<"c"/utf8>>, {chord, dominant_7th}),
    [<<"g"/utf8>>, <<"h"/utf8>>, <<"d"/utf8>>, <<"f"/utf8>>] =
        music_scale:chord_from(<<"g"/utf8>>, {chord, dominant_7th}).

%% chart_for_scale tests

chart_for_scale_test(_Config) ->
    {chart,[{{mus_string,1,<<"e">>},
         [{0,<<"e">>},
          {1,<<"f">>},
          {3,<<"g">>},
          {5,<<"a">>},
          {7,<<"h">>},
          {8,<<"c">>},
          {10,<<"d">>},
          {12,<<"e">>}]},
        {{mus_string,2,<<"h">>},
         [{0,<<"h">>},
          {1,<<"c">>},
          {3,<<"d">>},
          {5,<<"e">>},
          {6,<<"f">>},
          {8,<<"g">>},
          {10,<<"a">>},
          {12,<<"h">>}]},
        {{mus_string,3,<<"g">>},
         [{0,<<"g">>},
          {2,<<"a">>},
          {4,<<"h">>},
          {5,<<"c">>},
          {7,<<"d">>},
          {9,<<"e">>},
          {10,<<"f">>},
          {12,<<"g">>}]},
        {{mus_string,4,<<"d">>},
         [{0,<<"d">>},
          {2,<<"e">>},
          {3,<<"f">>},
          {5,<<"g">>},
          {7,<<"a">>},
          {9,<<"h">>},
          {10,<<"c">>},
          {12,<<"d">>}]},
        {{mus_string,5,<<"a">>},
         [{0,<<"a">>},
          {2,<<"h">>},
          {3,<<"c">>},
          {5,<<"d">>},
          {7,<<"e">>},
          {8,<<"f">>},
          {10,<<"g">>},
          {12,<<"a">>}]},
        {{mus_string,6,<<"e">>},
         [{0,<<"e">>},
          {1,<<"f">>},
          {3,<<"g">>},
          {5,<<"a">>},
          {7,<<"h">>},
          {8,<<"c">>},
          {10,<<"d">>},
          {12,<<"e">>}]}]} =
        music_scale:chart_for_scale(music_scale:standard_guitar_fretboard(),
                                    {scale, natural_major},
                                    <<"c"/utf8>>).

%% chart_for_arpeggio tests

chart_for_arpeggio_test(_Config) ->
    Result = music_scale:chart_for_arpeggio(music_scale:standard_guitar_fretboard(),
                                            {chord, major_triad},
                                            <<"c"/utf8>>),
    case Result of
        {chart, _} -> ok;
        _ -> ct:fail({wrong_return_type, Result})
    end,
    case Result of
        {_,
         [{{mus_string,1,<<"e">>},
           [{0,<<"e">>},
            {3,<<"g">>},
            {8,<<"c">>},
            {12,<<"e">>}]},
          {{mus_string,2,<<"h">>},
           [{1,<<"c">>},
            {5,<<"e">>},
            {8,<<"g">>}]},
          {{mus_string,3,<<"g">>},
           [{0,<<"g">>},
            {5,<<"c">>},
            {9,<<"e">>},
            {12,<<"g">>}]},
          {{mus_string,4,<<"d">>},
           [{2,<<"e">>},
            {5,<<"g">>},
            {10,<<"c">>}]},
          {{mus_string,5,<<"a">>},
           [{3,<<"c">>},
            {7,<<"e">>},
            {10,<<"g">>}]},
          {{mus_string,6,<<"e">>},
           [{0,<<"e">>},
            {3,<<"g">>},
            {8,<<"c">>},
            {12,<<"e">>}]}]
        } -> ok;
        _ -> ct:fail({incorrect_chart, Result})
    end.

chart_for_scale_minor_test(_Config) ->
    Result = music_scale:chart_for_scale(music_scale:standard_guitar_fretboard(),
                                         {scale, natural_minor},
                                         <<"a"/utf8>>),
    {chart, Strings} = Result,
    case Result of
        {chart,
         [{{mus_string,1,<<"e">>},
           [{0,<<"e">>},
            {1,<<"f">>},
            {3,<<"g">>},
            {5,<<"a">>},
            {7,<<"h">>},
            {8,<<"c">>},
            {10,<<"d">>},
            {12,<<"e">>}]},
          {{mus_string,2,<<"h">>},
           [{0,<<"h">>},
            {1,<<"c">>},
            {3,<<"d">>},
            {5,<<"e">>},
            {6,<<"f">>},
            {8,<<"g">>},
            {10,<<"a">>},
            {12,<<"h">>}]},
          {{mus_string,3,<<"g">>},
           [{0,<<"g">>},
            {2,<<"a">>},
            {4,<<"h">>},
            {5,<<"c">>},
            {7,<<"d">>},
            {9,<<"e">>},
            {10,<<"f">>},
            {12,<<"g">>}]},
          {{mus_string,4,<<"d">>},
           [{0,<<"d">>},
            {2,<<"e">>},
            {3,<<"f">>},
            {5,<<"g">>},
            {7,<<"a">>},
            {9,<<"h">>},
            {10,<<"c">>},
            {12,<<"d">>}]},
          {{mus_string,5,<<"a">>},
           [{0,<<"a">>},
            {2,<<"h">>},
            {3,<<"c">>},
            {5,<<"d">>},
            {7,<<"e">>},
            {8,<<"f">>},
            {10,<<"g">>},
            {12,<<"a">>}]},
          {{mus_string,6,<<"e">>},
           [{0,<<"e">>},
            {1,<<"f">>},
            {3,<<"g">>},
            {5,<<"a">>},
            {7,<<"h">>},
            {8,<<"c">>},
            {10,<<"d">>},
            {12,<<"e">>}]}]
        } -> ok;
        _ -> ct:fail({incorrect_chart, Result})
    end,
    6 = length(Strings).

standard_guitar_fretboard_test(_Config) ->
    Fretboard = music_scale:standard_guitar_fretboard(),
    {fretboard, Strings, FretCount} = Fretboard,
    6 = length(Strings),
    12 = FretCount.

known_scales_test(_Config) ->
    Scales = music_scale:known_scales(),
    true = lists:member({{scale, natural_major}, <<"Natural major"/utf8>>},
                        Scales),
    true = lists:member({{scale, natural_minor}, <<"Natural minor"/utf8>>},
                        Scales),
    true = is_list(Scales),
    true = length(Scales) > 0.

known_chords_test(_Config) ->
    Chords = music_scale:known_chords(),
    true = lists:member({{chord, major_triad}, <<"Major triad"/utf8>>}, Chords),
    true = lists:member({{chord, minor_triad}, <<"Minor triad"/utf8>>}, Chords),
    true = is_list(Chords),
    true = length(Chords) > 0.

%% comprehensive tests for all known scales and chords

all_scales() ->
    lists:map(fun({{scale, _ScaleAtom}=Scale, _ScaleName}) ->
                      Scale
              end,
              music_scale:known_scales()).

tonality_from_all_scales_test(_Config) ->
    Root = <<"c"/utf8>>,
    lists:foreach(
        fun(Scale) ->
            Result = music_scale:tonality_from(Root, Scale),
            true = is_list(Result),
            true = length(Result) > 0,
            <<"c"/utf8>> = hd(Result)
        end,
        all_scales()
    ).

all_chords() ->
    lists:map(fun({{chord, _ChordType}=Chord, _ChordName}) ->
                      Chord
              end,
              music_scale:known_chords()).

chord_from_all_chords_test(_Config) ->
    Root = <<"c"/utf8>>,
    lists:foreach(
        fun(Chord) ->
            Result = music_scale:chord_from(Root, Chord),
            true = is_list(Result),
            true = length(Result) >= 3,
            <<"c"/utf8>> = hd(Result)
        end,
        all_chords()
    ).
