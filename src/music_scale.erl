-module(music_scale).

-include("music_scale_types.hrl").

-export([chart_for_arpeggio/3,
         chart_for_scale/3,
         chord_from/2,
         interval_from/3,
         known_scales/0,
         known_chords/0,
         standard_guitar_fretboard/0,
         tonality_from/2]).


%% @doc
%% Returns a fretboard chart for given tune, chord type and note.
%% @param Fretboard To use standard guitar fretboard just call {@link standard_guitar_fretboard/0}.
%% @param Chord Should be passed as <tt>{chord, chord_atom()}</tt>. To see list of currently known chord atoms with descriptions call {@link known_chords/0}.
%% @param Note UTF8 binary with note letter (ATTENTION: German system is used, B is si flat, H is si) with optional alteration.
%% ```
%% 1> music_scale:chart_for_arpeggio(music_scale:standard_guitar_fretboard(),
%%                                   {chord, major_triad},
%%                                   <<"c"/utf8>>).
%% {chart,[{{mus_string,1,{note,<<"e">>}},
%%          [{0,<<"e">>},{3,<<"g">>},{8,<<"c">>},{12,<<"e">>}]},
%%         {{mus_string,2,{note,<<"h">>}},
%%          [{1,<<"c">>},{5,<<"e">>},{8,<<"g">>}]},
%%         {{mus_string,3,{note,<<"g">>}},
%%          [{0,<<"g">>},{5,<<"c">>},{9,<<"e">>},{12,<<"g">>}]},
%%         {{mus_string,4,{note,<<"d">>}},
%%          [{2,<<"e">>},{5,<<"g">>},{10,<<"c">>}]},
%%         {{mus_string,5,{note,<<"a">>}},
%%          [{3,<<"c">>},{7,<<"e">>},{10,<<"g">>}]},
%%         {{mus_string,6,{note,<<"e">>}},
%%          [{0,<<"e">>},{3,<<"g">>},{8,<<"c">>},{12,<<"e">>}]}]}
%% '''
%% @end
-spec chart_for_arpeggio(fretboard(), chord(), text_note()) -> chart_text().
chart_for_arpeggio(Fretboard, Chord, Note) ->
    NoteInternal = text_notes:to_internal(Note),
    F = fretboard_charts:chart_for_arpeggio(Fretboard, Chord, NoteInternal),
    text_notes:fretboard_chart_from_internal(F).


%% @doc
%% Returns a fretboard chart for given tune, scale type and note.
%% @param Fretboard To use standard guitar fretboard just call standard_guitar_fretboard/0.
%% @param Scale Should be passed as <tt>{scale, scale_atom()}</tt>. To see list of currently known chord atoms with descriptions call {@link known_scales/0}.
%% @param Note UTF8 binary with note letter (ATTENTION: German system is used, B is si flat, H is si) with optional alteration.
%% ```
%% 1> music_scale:chart_for_scale(music_scale:standard_guitar_fretboard(),
%%                                {scale, natural_major},
%%                                <<"f"/utf8>>).
%% {chart,[{{mus_string,1,{note,<<"e">>}},
%%          [{0,<<"e">>},
%%           {1,<<"f">>},
%%           {3,<<"g">>},
%%           {5,<<"a">>},
%%           {6,<<"b">>},
%%           {8,<<"c">>},
%%           {10,<<"d">>},
%%           {12,<<"e">>}]},
%%         {{mus_string,2,{note,<<"h">>}},
%%          [{1,<<"c">>},
%%           {3,<<"d">>},
%%           {5,<<"e">>},
%%           {6,<<"f">>},
%%           {8,<<"g">>},
%%           {10,<<"a">>},
%%           {11,<<"b">>}]},
%%         ...
%%         {{mus_string,6,{note,<<"e">>}},
%%          [{0,<<"e">>},
%%           {1,<<"f">>},
%%           {3,<<"g">>},
%%           {5,<<"a">>},
%%           {6,<<"b">>},
%%           {8,<<"c">>},
%%           {10,<<"d">>},
%%           {12,<<"e">>}]}]}
%% '''
%% @end
-spec chart_for_scale(fretboard(), scale(), text_note()) -> chart_text().
chart_for_scale(Fretboard, Scale, Note) ->
    NoteInternal = text_notes:to_internal(Note),
    F = fretboard_charts:chart_for_scale(Fretboard, Scale, NoteInternal),
    text_notes:fretboard_chart_from_internal(F).


%% @doc
%% Returns a chord of given type for given note.
%% @param Note UTF8 binary with note letter (ATTENTION: German system is used, B is si flat, H is si) with optional alteration.
%% @param Chord Should be passed as <tt>{chord, chord_atom()}</tt>. To see list of currently known chord atoms with descriptions call {@link known_chords/0}.
%% ```
%% '''
%% @end
-spec chord_from(text_note(), chord()) -> chord_notes().
chord_from(Note, Chord) ->
    NoteInternal = text_notes:to_internal(Note),
    ChordNotes = chords:chord_from(NoteInternal, Chord),
    lists:map(fun text_notes:from_internal/1, ChordNotes).


%% @doc
%% Returns interval from a given note in given direction.
%% @param Note UTF8 binary with note letter (ATTENTION: German system is used, B is si flat, H is si) with optional alteration.
%% @param Interval Interval as <tt>{interval, IntervalName}</tt>, where <tt>IntervalName</tt> is an atom.
%% @param Direction <tt>up</tt> or <tt>down</tt> atom.
-spec interval_from(text_note(), interval(), direction()) -> text_note().
interval_from(Note, Interval, Direction) ->
    NoteInternal = text_notes:to_internal(Note),
    Result = intervals:interval_from(NoteInternal, Interval, Direction),
    text_notes:from_internal(Result).


%% @doc Returns the list of scales available in the form <tt>{ScaleAtom, ScaleName}</tt>
-spec known_scales() -> [{scale(), binary()}].
known_scales() ->
    scales:known_scales().


%% @doc Returns the list of chords available in the form <tt>{ChordAtom, ChordName}</tt>
-spec known_chords() -> [{chord(), binary()}].
known_chords() ->
    chords:known_chords().


%% @doc Standard guitar fretboard in the fretboard format
-spec standard_guitar_fretboard() -> fretboard().
standard_guitar_fretboard() ->
    fretboard_charts:standard_guitar_fretboard().


%% @doc Returns notes of a given scale from a given note.
%% @param Note UTF8 binary with note letter (ATTENTION: German system is used, B is si flat, H is si) with optional alteration.
%% @param Scale Should be passed as <tt>{scale, scale_atom()}</tt>. To see list of currently known chord atoms with descriptions call {@link known_scales/0}.
-spec tonality_from(text_note(), scale()) -> scale_notes().
tonality_from(Note, Scale) ->
    NoteInternal = text_notes:to_internal(Note),
    ScaleNotes = scales:tonality_from(NoteInternal, Scale),
    lists:map(fun text_notes:from_internal/1, ScaleNotes).
