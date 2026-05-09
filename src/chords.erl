%% @hidden

-module(chords).

-include("music_scale_types.hrl").

-include_lib("eunit/include/eunit.hrl").

-export([chord_from/2, known_chords/0]).

%%% Interface


-spec chord_from(note(), chord()) -> chord_notes_internal().
chord_from({note, _NoteName, _Accidental} = Note,
           {chord, _ChordType} = Chord) ->
    chord_from(Note, chord(Chord), [Note]);
chord_from(_, _) -> erlang:error(badarg).


-spec known_chords() -> [{chord(), binary()}].
known_chords() ->
    [{{chord, major_triad}, <<"Major triad"/utf8>>},
     {{chord, minor_triad}, <<"Minor triad"/utf8>>},
     {{chord, diminished_triad}, <<"Diminished triad"/utf8>>},
     {{chord, augmented_triad}, <<"Augmented triad"/utf8>>},
     {{chord, major_7th}, <<"Major seventh"/utf8>>},
     {{chord, dominant_7th}, <<"Dominant seventh"/utf8>>},
     {{chord, minor_7th}, <<"Minor seventh"/utf8>>},
     {{chord, half_diminished_7th}, <<"Half-diminished seventh"/utf8>>},
     {{chord, diminished_7th}, <<"Diminished seventh"/utf8>>}].


%%% Implementation


-spec chord_from(note(), chord_intervals(), chord_notes_internal()) ->
          chord_notes_internal().
chord_from(Note, [CurInterval | ScaleRest], Acc) ->
    NextNote = intervals:interval_from(Note, CurInterval, up),
    chord_from(NextNote, ScaleRest, Acc ++ [NextNote]);
chord_from(_, [], Acc) -> Acc.


-spec chord(chord()) -> chord_intervals().
chord({chord, major_triad}) ->
    [{interval, third, major},
     {interval, third, minor}];
chord({chord, minor_triad}) ->
    [{interval, third, minor},
     {interval, third, major}];
chord({chord, diminished_triad}) ->
    [{interval, third, minor},
     {interval, third, minor}];
chord({chord, augmented_triad}) ->
    [{interval, third, major},
     {interval, third, major}];
chord({chord, major_7th}) ->
    [{interval, third, major},
     {interval, third, minor},
     {interval, third, major}];
chord({chord, dominant_7th}) ->
    [{interval, third, major},
     {interval, third, minor},
     {interval, third, minor}];
chord({chord, minor_7th}) ->
    [{interval, third, minor},
     {interval, third, major},
     {interval, third, minor}];
chord({chord, half_diminished_7th}) ->
    [{interval, third, minor},
     {interval, third, minor},
     {interval, third, major}];
chord({chord, diminished_7th}) ->
    [{interval, third, minor},
     {interval, third, minor},
     {interval, third, minor}];
chord(_) -> erlang:error(badarg).


%%% Tests

-dialyzer({nowarn_function,
           [chord_from_badarg_test/0,
            chord_bad_chord_type_test/0]}).

%% Triads


chord_from_major_triad_test() ->
    ?assertEqual([{note, c, 0}, {note, e, 0}, {note, g, 0}],
                 chord_from({note, c, 0}, {chord, major_triad})),
    ?assertEqual([{note, a, 0}, {note, c, 1}, {note, e, 0}],
                 chord_from({note, a, 0}, {chord, major_triad})),
    ?assertEqual([{note, g, 0}, {note, h, 0}, {note, d, 0}],
                 chord_from({note, g, 0}, {chord, major_triad})).


chord_from_minor_triad_test() ->
    ?assertEqual([{note, a, 0}, {note, c, 0}, {note, e, 0}],
                 chord_from({note, a, 0}, {chord, minor_triad})),
    ?assertEqual([{note, d, 0}, {note, f, 0}, {note, a, 0}],
                 chord_from({note, d, 0}, {chord, minor_triad})).


chord_from_diminished_triad_test() ->
    ?assertEqual([{note, a, 0}, {note, c, 0}, {note, e, -1}],
                 chord_from({note, a, 0}, {chord, diminished_triad})),
    ?assertEqual([{note, c, 0}, {note, e, -1}, {note, g, -1}],
                 chord_from({note, c, 0}, {chord, diminished_triad})).


chord_from_augmented_triad_test() ->
    ?assertEqual([{note, a, 0}, {note, c, 1}, {note, e, 1}],
                 chord_from({note, a, 0}, {chord, augmented_triad})),
    ?assertEqual([{note, f, 0}, {note, a, 0}, {note, c, 1}],
                 chord_from({note, f, 0}, {chord, augmented_triad})).


%% 7th Chord Tests


chord_from_major_7th_test() ->
    % C major 7th: C, E, G, H
    ?assertEqual([{note, c, 0}, {note, e, 0}, {note, g, 0}, {note, h, 0}],
                 chord_from({note, c, 0}, {chord, major_7th})),
    % A major 7th: A, C#, E, G#
    ?assertEqual([{note, a, 0}, {note, c, 1}, {note, e, 0}, {note, g, 1}],
                 chord_from({note, a, 0}, {chord, major_7th})),
    % G major 7th: G, B, D, F#
    ?assertEqual([{note, g, 0}, {note, h, 0}, {note, d, 0}, {note, f, 1}],
                 chord_from({note, g, 0}, {chord, major_7th})).


chord_from_dominant_7th_test() ->
    % C dominant 7th: C, E, G, B
    ?assertEqual([{note, c, 0}, {note, e, 0}, {note, g, 0}, {note, h, -1}],
                 chord_from({note, c, 0}, {chord, dominant_7th})),
    % A dominant 7th: A, C#, E, G
    ?assertEqual([{note, a, 0}, {note, c, 1}, {note, e, 0}, {note, g, 0}],
                 chord_from({note, a, 0}, {chord, dominant_7th})),
    % G dominant 7th: G, B, D, F
    ?assertEqual([{note, g, 0}, {note, h, 0}, {note, d, 0}, {note, f, 0}],
                 chord_from({note, g, 0}, {chord, dominant_7th})).


chord_from_minor_7th_test() ->
    % C minor 7th: C, Eb, G, B
    ?assertEqual([{note, c, 0}, {note, e, -1}, {note, g, 0}, {note, h, -1}],
                 chord_from({note, c, 0}, {chord, minor_7th})),
    % A minor 7th: A, C, E, G
    ?assertEqual([{note, a, 0}, {note, c, 0}, {note, e, 0}, {note, g, 0}],
                 chord_from({note, a, 0}, {chord, minor_7th})),
    % D minor 7th: D, F, A, C
    ?assertEqual([{note, d, 0}, {note, f, 0}, {note, a, 0}, {note, c, 0}],
                 chord_from({note, d, 0}, {chord, minor_7th})).


chord_from_half_diminished_7th_test() ->
    % C half-diminished 7th (m7b5): C, Eb, Gb, B
    ?assertEqual([{note, c, 0}, {note, e, -1}, {note, g, -1}, {note, h, -1}],
                 chord_from({note, c, 0}, {chord, half_diminished_7th})),
    % A half-diminished 7th: A, C, Eb, G
    ?assertEqual([{note, a, 0}, {note, c, 0}, {note, e, -1}, {note, g, 0}],
                 chord_from({note, a, 0}, {chord, half_diminished_7th})).


chord_from_diminished_7th_test() ->
    % C diminished 7th: C, Eb, Gb, Bb
    ?assertEqual([{note, c, 0}, {note, e, -1}, {note, g, -1}, {note, h, -2}],
                 chord_from({note, c, 0}, {chord, diminished_7th})),
    % A diminished 7th: A, C, Eb, Gb
    ?assertEqual([{note, a, 0}, {note, c, 0}, {note, e, -1}, {note, g, -1}],
                 chord_from({note, a, 0}, {chord, diminished_7th})).


%% Bad chords


chord_from_badarg_test() ->
    ?assertError(badarg, chord_from(foo, {chord, major_triad})),
    ?assertError(badarg, chord_from({note, c, 0}, foo)),
    ?assertError(badarg, chord_from(foo, bar)).


chord_bad_chord_type_test() ->
    ?assertError(badarg, chord({chord, unknown})).
