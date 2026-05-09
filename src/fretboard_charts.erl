%% @hidden

-module(fretboard_charts).

-include("music_scale_types.hrl").

-include_lib("eunit/include/eunit.hrl").

-export([chart_for_arpeggio/3,
         chart_for_scale/3,
         standard_guitar_fretboard/0]).


-spec chart_for_arpeggio(fretboard(), chord(), note()) -> chart().
chart_for_arpeggio({fretboard, _Strings, _FretCount} = Fretboard,
                   {chord, _ChordType} = Chord,
                   Note) ->
    ChordNotes = chords:chord_from(Note, Chord),
    generate_chart(Fretboard, ChordNotes);
chart_for_arpeggio(_, _, _) ->
    erlang:error(badarg).


-spec chart_for_scale(fretboard(), scale(), note()) -> chart().
chart_for_scale({fretboard, _Strings, _FretCount} = Fretboard,
                {scale, _ScaleName} = Scale,
                Note) ->
    ScaleNotes = scales:tonality_from(Note, Scale),
    generate_chart(Fretboard, ScaleNotes);
chart_for_scale(_, _, _) ->
    erlang:error(badarg).


-spec standard_guitar_fretboard() -> fretboard().
standard_guitar_fretboard() ->
    {fretboard,
     [{mus_string, 1, {note, e, 0}},
      {mus_string, 2, {note, h, 0}},
      {mus_string, 3, {note, g, 0}},
      {mus_string, 4, {note, d, 0}},
      {mus_string, 5, {note, a, 0}},
      {mus_string, 6, {note, e, 0}}],
     12}.


%%% Implementation


-spec generate_chart(fretboard(), [note()]) -> chart().
generate_chart({fretboard, Strings, FretCount}, NoteList) ->
    StringCharts =
        lists:map(fun({mus_string, _Number, StringNote} = String) ->
                          StringChart = calculate_string(StringNote, NoteList, FretCount),
                          {String, StringChart}
                  end,
                  Strings),
    {chart, StringCharts}.


-spec calculate_string(note(), [note()], integer()) -> [{integer(), note()}].
calculate_string({note, _NoteName, _Accidental} = From,
                 NoteList,
                 FretCount) ->
    Pitches = maps:from_list(lists:map(fun(N) -> {chromatic:pitch_class(N), N} end, NoteList)),
    StringPitch = chromatic:pitch_class(From),
    Frets = lists:seq(0, FretCount),
    {StringPitches, _} = lists:mapfoldl(fun(Fret, CurPitch) ->
                                                {{Fret, CurPitch}, (CurPitch + 1) rem 12}
                                        end,
                                        StringPitch,
                                        Frets),
    lists:filtermap(fun({Fret, Pitch}) ->
                            case maps:find(Pitch, Pitches) of
                                {ok, Note} -> {true, {Fret, Note}};
                                error -> false
                            end
                    end,
                    StringPitches);
calculate_string(_, _, _) ->
    erlang:error(badarg).


%%% Tests

-dialyzer({nowarn_function,
           [error_handling_test/0]}).


chart_for_arpeggio_c_major_triad_test() ->
    ?assertEqual(
      {chart,
       [{{mus_string, 1, {note, e, 0}},
         [{0, {note, e, 0}},
          {3, {note, g, 0}},
          {7, {note, h, 0}},
          {12, {note, e, 0}}]},
        {{mus_string, 2, {note, h, 0}},
         [{0, {note, h, 0}},
          {5, {note, e, 0}},
          {8, {note, g, 0}},
          {12, {note, h, 0}}]},
        {{mus_string, 3, {note, g, 0}},
         [{0, {note, g, 0}},
          {4, {note, h, 0}},
          {9, {note, e, 0}},
          {12, {note, g, 0}}]},
        {{mus_string, 4, {note, d, 0}},
         [{2, {note, e, 0}},
          {5, {note, g, 0}},
          {9, {note, h, 0}}]},
        {{mus_string, 5, {note, a, 0}},
         [{2, {note, h, 0}},
          {7, {note, e, 0}},
          {10, {note, g, 0}}]},
        {{mus_string, 6, {note, e, 0}},
         [{0, {note, e, 0}},
          {3, {note, g, 0}},
          {7, {note, h, 0}},
          {12, {note, e, 0}}]}]},
      chart_for_arpeggio(standard_guitar_fretboard(),
                         {chord, minor_triad},
                         {note, e, 0})).


chart_for_arpeggio_e_minor_triad_open_g_test() ->
    FretboardGuitarOpenG =
        {fretboard,
         [{mus_string, 1, {note, d, 0}},
          {mus_string, 2, {note, h, 0}},
          {mus_string, 3, {note, g, 0}},
          {mus_string, 4, {note, d, 0}},
          {mus_string, 5, {note, g, 0}},
          {mus_string, 6, {note, d, 0}}],
         12},
    ?assertEqual(
      {chart,
       [{{mus_string, 1, {note, d, 0}},
         [{2, {note, e, 0}},
          {5, {note, g, 0}},
          {9, {note, h, 0}}]},
        {{mus_string, 2, {note, h, 0}},
         [{0, {note, h, 0}},
          {5, {note, e, 0}},
          {8, {note, g, 0}},
          {12, {note, h, 0}}]},
        {{mus_string, 3, {note, g, 0}},
         [{0, {note, g, 0}},
          {4, {note, h, 0}},
          {9, {note, e, 0}},
          {12, {note, g, 0}}]},
        {{mus_string, 4, {note, d, 0}},
         [{2, {note, e, 0}},
          {5, {note, g, 0}},
          {9, {note, h, 0}}]},
        {{mus_string, 5, {note, g, 0}},
         [{0, {note, g, 0}},
          {4, {note, h, 0}},
          {9, {note, e, 0}},
          {12, {note, g, 0}}]},
        {{mus_string, 6, {note, d, 0}},
         [{2, {note, e, 0}},
          {5, {note, g, 0}},
          {9, {note, h, 0}}]}]},
      chart_for_arpeggio(FretboardGuitarOpenG,
                         {chord, minor_triad},
                         {note, e, 0})).


chart_for_arpeggio_c_major_7th_test() ->
    %% C Major 7th: C, E, G, H
    ?assertEqual(
      {chart,
       [{{mus_string, 1, {note, e, 0}},
         [{0, {note, e, 0}},
          {3, {note, g, 0}},
          {7, {note, h, 0}},
          {8, {note, c, 0}},
          {12, {note, e, 0}}]},
        {{mus_string, 2, {note, h, 0}},
         [{0, {note, h, 0}},
          {1, {note, c, 0}},
          {5, {note, e, 0}},
          {8, {note, g, 0}},
          {12, {note, h, 0}}]},
        {{mus_string, 3, {note, g, 0}},
         [{0, {note, g, 0}},
          {4, {note, h, 0}},
          {5, {note, c, 0}},
          {9, {note, e, 0}},
          {12, {note, g, 0}}]},
        {{mus_string, 4, {note, d, 0}},
         [{2, {note, e, 0}},
          {5, {note, g, 0}},
          {9, {note, h, 0}},
          {10, {note, c, 0}}]},
        {{mus_string, 5, {note, a, 0}},
         [{2, {note, h, 0}},
          {3, {note, c, 0}},
          {7, {note, e, 0}},
          {10, {note, g, 0}}]},
        {{mus_string, 6, {note, e, 0}},
         [{0, {note, e, 0}},
          {3, {note, g, 0}},
          {7, {note, h, 0}},
          {8, {note, c, 0}},
          {12, {note, e, 0}}]}]},
      chart_for_arpeggio(standard_guitar_fretboard(),
                         {chord, major_7th},
                         {note, c, 0})).


chart_for_arpeggio_a_dominant_7th_test() ->
    %% A Dominant 7th: A, E, C#, G
    ?assertEqual(
      {chart,
       [{{mus_string, 1, {note, e, 0}},
         [{0, {note, e, 0}},
          {3, {note, g, 0}},
          {5, {note, a, 0}},
          {9, {note, c, 1}},
          {12, {note, e, 0}}]},
        {{mus_string, 2, {note, h, 0}},
         [{2, {note, c, 1}},
          {5, {note, e, 0}},
          {8, {note, g, 0}},
          {10, {note, a, 0}}]},
        {{mus_string, 3, {note, g, 0}},
         [{0, {note, g, 0}},
          {2, {note, a, 0}},
          {6, {note, c, 1}},
          {9, {note, e, 0}},
          {12, {note, g, 0}}]},
        {{mus_string, 4, {note, d, 0}},
         [{2, {note, e, 0}},
          {5, {note, g, 0}},
          {7, {note, a, 0}},
          {11, {note, c, 1}}]},
        {{mus_string, 5, {note, a, 0}},
         [{0, {note, a, 0}},
          {4, {note, c, 1}},
          {7, {note, e, 0}},
          {10, {note, g, 0}},
          {12, {note, a, 0}}]},
        {{mus_string, 6, {note, e, 0}},
         [{0, {note, e, 0}},
          {3, {note, g, 0}},
          {5, {note, a, 0}},
          {9, {note, c, 1}},
          {12, {note, e, 0}}]}]},
      chart_for_arpeggio(standard_guitar_fretboard(),
                         {chord, dominant_7th},
                         {note, a, 0})).


chart_for_scale_c_major_test() ->
    ?assertEqual(
      {chart,
       [{{mus_string, 1, {note, e, 0}},
         [{0, {note, e, 0}},
          {1, {note, f, 0}},
          {3, {note, g, 0}},
          {5, {note, a, 0}},
          {7, {note, h, 0}},
          {8, {note, c, 0}},
          {10, {note, d, 0}},
          {12, {note, e, 0}}]},
        {{mus_string, 2, {note, h, 0}},
         [{0, {note, h, 0}},
          {1, {note, c, 0}},
          {3, {note, d, 0}},
          {5, {note, e, 0}},
          {6, {note, f, 0}},
          {8, {note, g, 0}},
          {10, {note, a, 0}},
          {12, {note, h, 0}}]},
        {{mus_string, 3, {note, g, 0}},
         [{0, {note, g, 0}},
          {2, {note, a, 0}},
          {4, {note, h, 0}},
          {5, {note, c, 0}},
          {7, {note, d, 0}},
          {9, {note, e, 0}},
          {10, {note, f, 0}},
          {12, {note, g, 0}}]},
        {{mus_string, 4, {note, d, 0}},
         [{0, {note, d, 0}},
          {2, {note, e, 0}},
          {3, {note, f, 0}},
          {5, {note, g, 0}},
          {7, {note, a, 0}},
          {9, {note, h, 0}},
          {10, {note, c, 0}},
          {12, {note, d, 0}}]},
        {{mus_string, 5, {note, a, 0}},
         [{0, {note, a, 0}},
          {2, {note, h, 0}},
          {3, {note, c, 0}},
          {5, {note, d, 0}},
          {7, {note, e, 0}},
          {8, {note, f, 0}},
          {10, {note, g, 0}},
          {12, {note, a, 0}}]},
        {{mus_string, 6, {note, e, 0}},
         [{0, {note, e, 0}},
          {1, {note, f, 0}},
          {3, {note, g, 0}},
          {5, {note, a, 0}},
          {7, {note, h, 0}},
          {8, {note, c, 0}},
          {10, {note, d, 0}},
          {12, {note, e, 0}}]}]},
      chart_for_scale(standard_guitar_fretboard(),
                      {scale, natural_major},
                      {note, c, 0})).


chart_for_scale_d_dorian_test() ->
    %% D Dorian: D, E, F, G, A, H, C
    %% (Dorian is M-m-M-M-M-m)
    ?assertEqual(
      {chart,
       [{{mus_string, 1, {note, e, 0}},
         [{0, {note, e, 0}},
          {1, {note, f, 0}},
          {3, {note, g, 0}},
          {5, {note, a, 0}},
          {7, {note, h, 0}},
          {8, {note, c, 0}},
          {10, {note, d, 0}},
          {12, {note, e, 0}}]},
        {{mus_string, 2, {note, h, 0}},
         [{0, {note, h, 0}},
          {1, {note, c, 0}},
          {3, {note, d, 0}},
          {5, {note, e, 0}},
          {6, {note, f, 0}},
          {8, {note, g, 0}},
          {10, {note, a, 0}},
          {12, {note, h, 0}}]},
        {{mus_string, 3, {note, g, 0}},
         [{0, {note, g, 0}},
          {2, {note, a, 0}},
          {4, {note, h, 0}},
          {5, {note, c, 0}},
          {7, {note, d, 0}},
          {9, {note, e, 0}},
          {10, {note, f, 0}},
          {12, {note, g, 0}}]},
        {{mus_string, 4, {note, d, 0}},
         [{0, {note, d, 0}},
          {2, {note, e, 0}},
          {3, {note, f, 0}},
          {5, {note, g, 0}},
          {7, {note, a, 0}},
          {9, {note, h, 0}},
          {10, {note, c, 0}},
          {12, {note, d, 0}}]},
        {{mus_string, 5, {note, a, 0}},
         [{0, {note, a, 0}},
          {2, {note, h, 0}},
          {3, {note, c, 0}},
          {5, {note, d, 0}},
          {7, {note, e, 0}},
          {8, {note, f, 0}},
          {10, {note, g, 0}},
          {12, {note, a, 0}}]},
        {{mus_string, 6, {note, e, 0}},
         [{0, {note, e, 0}},
          {1, {note, f, 0}},
          {3, {note, g, 0}},
          {5, {note, a, 0}},
          {7, {note, h, 0}},
          {8, {note, c, 0}},
          {10, {note, d, 0}},
          {12, {note, e, 0}}]}]},
      chart_for_scale(standard_guitar_fretboard(),
                      {scale, dorian},
                      {note, d, 0})).


%% Custom Fretboard Test
%% Ensures the logic works with any arbitrary string tuning and fret count.
chart_for_custom_fretboard_test() ->
    CustomFretboard = {fretboard,
                       [{mus_string, 1, {note, c, 0}},
                        {mus_string, 2, {note, c, 0}}],
                       3},
    %% C Major Triad on a 2-string C-C fretboard (3 frets)
    ?assertEqual(
      {chart,
       [{{mus_string, 1, {note, c, 0}}, [{0, {note, c, 0}}]},
        {{mus_string, 2, {note, c, 0}}, [{0, {note, c, 0}}]}]},
      chart_for_arpeggio(CustomFretboard, {chord, major_triad}, {note, c, 0})).


error_handling_test() ->
    Fretboard = {fretboard, [], 12},
    ?assertError(badarg, chart_for_scale(Fretboard, {not_a_scale, major}, {note, c, 0})),
    ?assertError(badarg, chart_for_arpeggio(Fretboard, {not_a_chord, major}, {note, c, 0})),
    ?assertError(badarg, chart_for_scale({not_a_fretboard, [], 12}, {scale, major}, {note, c, 0})).
