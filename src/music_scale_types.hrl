%% Note
-type note_name() :: a | h | c | d | e | f | g.
-type accidental() :: integer().
-type note() :: {note, note_name(), accidental()}.
-type text_note() :: binary().

%% Interval
-type interval_name() ::
        unison |
        second |
        third |
        fourth |
        fifth |
        sixth |
        seventh |
        octave |
        ninth |
        tenth |
        eleventh |
        twelfth |
        thirteenth |
        fourteenth |
        fifteenth.
-type interval_type() :: perfect | major | minor | diminished | augmented.
-type interval() :: {interval, interval_name(), interval_type()}.
-type direction() :: up | down.

%% Chord
-type chord_type() ::
        major_triad |
        minor_triad |
        diminished_triad |
        augmented_triad |
        major_7th |
        dominant_7th |
        minor_7th |
        half_diminished_7th |
        diminished_7th.
-type chord() :: {chord, chord_type()}.
-type chord_intervals() :: [interval()].
-type chord_notes_internal() :: [note()].
-type chord_notes() :: [text_note()].

%% Scale

-type scale_atom() ::
        natural_major |
        natural_minor |
        ionian |
        dorian |
        phrygian |
        lydian |
        mixolydian |
        aeolian |
        locrian |
        harmonic_minor |
        melodic_minor |
        double_harmonic_minor |
        dominant_major |
        major_pentatonic |
        minor_pentatonic.
-type scale() :: {scale, scale_atom()}.
-type scale_notes() :: [text_note()].

%% Fretboard chart

-type mus_string() :: {mus_string, integer(), note()}.
-type mus_string_text() :: {mus_string, integer(), text_note()}.
-type fretboard() :: {fretboard, [mus_string()], integer()}.
-type chart() :: {chart, [{mus_string(), [{integer(), note()}]}]}.
-type chart_text() :: {chart, [{mus_string_text(), [{integer(), text_note()}]}]}.
