%% @hidden

-module(scales).

-include("music_scale_types.hrl").

-export([known_scales/0, tonality_from/2]).

-include_lib("eunit/include/eunit.hrl").


-spec tonality_from(note(), scale()) -> [note()].
tonality_from({note, _NoteName, _Accidental} = Note, {scale, _ScaleName} = Scale) ->
    tonality_from(Note, scale(Scale), [Note]);
tonality_from(_, _) -> erlang:error(badarg).


-spec known_scales() -> [{scale(), binary()}].
known_scales() ->
    [{{scale, natural_major}, <<"Natural major"/utf8>>},
     {{scale, natural_minor}, <<"Natural minor"/utf8>>},
     {{scale, ionian}, <<"Ionian"/utf8>>},
     {{scale, dorian}, <<"Dorian"/utf8>>},
     {{scale, phrygian}, <<"Phrygian"/utf8>>},
     {{scale, lydian}, <<"Lydian"/utf8>>},
     {{scale, mixolydian}, <<"Mixolydian"/utf8>>},
     {{scale, aeolian}, <<"Aeolian"/utf8>>},
     {{scale, locrian}, <<"Locrian"/utf8>>},
     {{scale, harmonic_minor}, <<"Harmonic minor"/utf8>>},
     {{scale, melodic_minor}, <<"Melodic minor"/utf8>>},
     {{scale, double_harmonic_minor}, <<"Double harmonic minor"/utf8>>},
     {{scale, dominant_major}, <<"Dominant major"/utf8>>},
     {{scale, major_pentatonic}, <<"Major pentatonic"/utf8>>},
     {{scale, minor_pentatonic}, <<"Minor pentatonic"/utf8>>}].


%%% Implementation


tonality_from(Note, [CurInterval | ScaleRest], Acc) ->
    NextNote = intervals:interval_from(Note, CurInterval, up),
    tonality_from(NextNote, ScaleRest, Acc ++ [NextNote]);
tonality_from(_, [], Acc) -> Acc.


scale({scale, natural_major}) ->
    [{interval, second, major},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, major}];
scale({scale, natural_minor}) ->
    [{interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, major}];
%% Diatonic modes
scale({scale, ionian}) -> scale({scale, natural_major});
scale({scale, dorian}) ->
    [{interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, major},
     {interval, second, minor}];
scale({scale, phrygian}) ->
    [{interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, major}];
scale({scale, lydian}) ->
    [{interval, second, major},
     {interval, second, major},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major}];
scale({scale, mixolydian}) ->
    [{interval, second, major},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, minor}];
scale({scale, aeolian}) -> scale({scale, natural_minor});
scale({scale, locrian}) ->
    [{interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major}];
%% Minors with high 7th
scale({scale, harmonic_minor}) ->
    [{interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, augmented}];
scale({scale, melodic_minor}) ->
    [{interval, second, major},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, second, major},
     {interval, second, major}];
scale({scale, double_harmonic_minor}) ->
    [{interval, second, major},
     {interval, second, minor},
     {interval, second, augmented},
     {interval, second, minor},
     {interval, second, minor},
     {interval, second, augmented}];
%% Other scales
scale({scale, dominant_major}) ->
    [{interval, second, minor},
     {interval, second, augmented},
     {interval, second, minor},
     {interval, second, major},
     {interval, second, minor},
     {interval, second, major}];
scale({scale, major_pentatonic}) ->
    [{interval, second, major},
     {interval, second, major},
     {interval, third, minor},
     {interval, second, major}];
scale({scale, minor_pentatonic}) ->
    [{interval, third, minor},
     {interval, second, major},
     {interval, second, major},
     {interval, third, minor}].


%%% Tests

-dialyzer({nowarn_function,
           [tonality_from_badarg_test/0]}).


tonality_from_natural_major_test() ->
    ?assertEqual([{note, c, 0},
                  {note, d, 0},
                  {note, e, 0},
                  {note, f, 0},
                  {note, g, 0},
                  {note, a, 0},
                  {note, h, 0}],
                 tonality_from({note, c, 0}, {scale, natural_major})),
    ?assertEqual([{note, g, 0},
                  {note, a, 0},
                  {note, h, 0},
                  {note, c, 0},
                  {note, d, 0},
                  {note, e, 0},
                  {note, f, 1}],
                 tonality_from({note, g, 0}, {scale, natural_major})).


tonality_from_natural_minor_test() ->
    ?assertEqual([{note, a, 0},
                  {note, h, 0},
                  {note, c, 0},
                  {note, d, 0},
                  {note, e, 0},
                  {note, f, 0},
                  {note, g, 0}],
                 tonality_from({note, a, 0}, {scale, natural_minor})),
    ?assertEqual([{note, c, 0},
                  {note, d, 0},
                  {note, e, -1},
                  {note, f, 0},
                  {note, g, 0},
                  {note, a, -1},
                  {note, h, -1}],
                 tonality_from({note, c, 0}, {scale, natural_minor})).


tonality_from_badarg_test() ->
    ?assertError(badarg, tonality_from(foo, {scale, natural_major})),
    ?assertError(badarg, tonality_from({note, c, 0}, foo)),
    ?assertError(badarg, tonality_from(foo, bar)).


all_scales() ->
    lists:map(fun({{scale, _ScaleAtom} = Scale, _ScaleName}) ->
                      Scale
              end,
              known_scales()).


diatonic_scales() ->
    NonDiatonic = sets:from_list(non_diatonic_scales()),
    lists:filter(fun(Scale) -> not sets:is_element(Scale, NonDiatonic) end,
                 all_scales()).


non_diatonic_scales() ->
    [{scale, major_pentatonic},
     {scale, minor_pentatonic}].


%% Property: diatonic scale produces exactly 7 notes from any starting note
scale_produces_7_notes_test() ->
    StartNote = {note, c, 0},
    ?assertEqual(7, length(tonality_from(StartNote, {scale, natural_major}))),
    ?assertEqual(7, length(tonality_from(StartNote, {scale, natural_minor}))),
    [ ?assertEqual(7, length(tonality_from(StartNote, S)))
      || S <- diatonic_scales() ].


%% Alias checks: modes that delegate to named scales must produce identical
%% results to their base scale.
ionian_equals_major_test() ->
    Start = {note, d, 0},
    ?assertEqual(
      tonality_from(Start, {scale, natural_major}),
      tonality_from(Start, {scale, ionian})).


aeolian_equals_minor_test() ->
    Start = {note, e, 0},
    ?assertEqual(
      tonality_from(Start, {scale, natural_minor}),
      tonality_from(Start, {scale, aeolian})).


%% Dorian (starts on D relative to C major: D-E-F-G-A-H-C)
%% Pattern: M-m-M-M-M-m
dorian_from_d_test() ->
    ?assertEqual([{note, d, 0},
                  {note, e, 0},
                  {note, f, 0},
                  {note, g, 0},
                  {note, a, 0},
                  {note, h, 0},
                  {note, c, 0}],
                 tonality_from({note, d, 0}, {scale, dorian})).


%% Phrygian (starts on E relative to C major: E-F-G-A-H-C-D)
%% Pattern: m-M-M-M-m-M
phrygian_from_e_test() ->
    ?assertEqual([{note, e, 0},
                  {note, f, 0},
                  {note, g, 0},
                  {note, a, 0},
                  {note, h, 0},
                  {note, c, 0},
                  {note, d, 0}],
                 tonality_from({note, e, 0}, {scale, phrygian})).


%% Lydian (starts on F relative to C major: F-G-A-H-C-D-E)
%% Pattern: M-M-M-m-M-M
lydian_from_f_test() ->
    ?assertEqual([{note, f, 0},
                  {note, g, 0},
                  {note, a, 0},
                  {note, h, 0},
                  {note, c, 0},
                  {note, d, 0},
                  {note, e, 0}],
                 tonality_from({note, f, 0}, {scale, lydian})).


%% Mixolydian (starts on G relative to C major: G-A-H-C-D-E-F)
%% Pattern: M-M-m-M-M-m
mixolydian_from_g_test() ->
    ?assertEqual([{note, g, 0},
                  {note, a, 0},
                  {note, h, 0},
                  {note, c, 0},
                  {note, d, 0},
                  {note, e, 0},
                  {note, f, 0}],
                 tonality_from({note, g, 0}, {scale, mixolydian})).


%% Locrian (starts on H relative to C major: H-C-D-E-F-G-A)
%% Pattern: m-M-M-m-M-M
locrian_from_b_test() ->
    ?assertEqual([{note, h, 0},
                  {note, c, 0},
                  {note, d, 0},
                  {note, e, 0},
                  {note, f, 0},
                  {note, g, 0},
                  {note, a, 0}],
                 tonality_from({note, h, 0}, {scale, locrian})).


%% Harmonic minor — A harmonic minor: A-H-C-D-E-F-G#
%% Pattern: M-m-M-M-m-aug
harmonic_minor_from_a_test() ->
    Result = tonality_from({note, a, 0}, {scale, harmonic_minor}),
    %% First 5 notes match natural minor; 6th stays F; 7th is raised
    ?assertEqual({note, a, 0}, lists:nth(1, Result)),
    ?assertEqual({note, h, 0}, lists:nth(2, Result)),
    ?assertEqual({note, c, 0}, lists:nth(3, Result)),
    ?assertEqual({note, d, 0}, lists:nth(4, Result)),
    ?assertEqual({note, e, 0}, lists:nth(5, Result)),
    ?assertEqual({note, f, 0}, lists:nth(6, Result)),
    %% The 7th note must be raised (accidental +1 relative to natural minor G)
    ?assertEqual({note, g, 1}, lists:nth(7, Result)).


%% Melodic minor — A melodic minor ascending: A-H-C-D-E-F#-G#
%% Pattern: M-m-M-M-M-M
melodic_minor_from_a_test() ->
    Result = tonality_from({note, a, 0}, {scale, melodic_minor}),
    ?assertEqual({note, a, 0}, lists:nth(1, Result)),
    ?assertEqual({note, h, 0}, lists:nth(2, Result)),
    ?assertEqual({note, c, 0}, lists:nth(3, Result)),
    ?assertEqual({note, d, 0}, lists:nth(4, Result)),
    ?assertEqual({note, e, 0}, lists:nth(5, Result)),
    %% 6th raised: F -> F# (accidental +1)
    ?assertEqual({note, f, 1}, lists:nth(6, Result)),
    %% 7th raised: G -> G# (accidental +1 relative to natural minor G)
    ?assertEqual({note, g, 1}, lists:nth(7, Result)).


%% Double harmonic minor — A double harmonic minor: A-H-C-D#-E-F-G#
%% Pattern: M-m-aug-m-m-aug
double_harmonic_minor_from_a_test() ->
    Result = tonality_from({note, a, 0}, {scale, double_harmonic_minor}),
    ?assertEqual({note, a, 0}, lists:nth(1, Result)),
    ?assertEqual({note, h, 0}, lists:nth(2, Result)),
    ?assertEqual({note, c, 0}, lists:nth(3, Result)),
    %% C + augmented second (3 semitones) = D# (accidental +1 from D)
    ?assertEqual({note, d, 1}, lists:nth(4, Result)),
    ?assertEqual({note, e, 0}, lists:nth(5, Result)),
    ?assertEqual({note, f, 0}, lists:nth(6, Result)),
    %% F + augmented second (3 semitones) = G#
    ?assertEqual({note, g, 1}, lists:nth(7, Result)).


%% Dominant major
%% Pattern: m-aug-m-M-m-M)
%% Starting on C: C-Db-E-F-G-Ab-B
dominant_major_from_c_test() ->
    Result = tonality_from({note, c, 0}, {scale, dominant_major}),
    ?assertEqual({note, c, 0}, lists:nth(1, Result)),
    ?assertEqual({note, d, -1}, lists:nth(2, Result)),
    ?assertEqual({note, e, 0}, lists:nth(3, Result)),
    ?assertEqual({note, f, 0}, lists:nth(4, Result)),
    ?assertEqual({note, g, 0}, lists:nth(5, Result)),
    ?assertEqual({note, a, -1}, lists:nth(6, Result)),
    ?assertEqual({note, h, -1}, lists:nth(7, Result)).
