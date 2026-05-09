%% @hidden

-module(chromatic).

-include("music_scale_types.hrl").

-include_lib("eunit/include/eunit.hrl").

-export([pitch_class/1, semitone_count/1]).

%%% Interface


-spec pitch_class(note()) -> integer().
pitch_class({note, NoteName, Accidental}) ->
    case maps:get(NoteName, white_keys(), undefined) of
        undefined -> erlang:error(badarg);
        Base -> (Base + 12 + Accidental) rem 12
    end;
pitch_class(_) -> erlang:error(badarg).


-spec semitone_count(interval()) -> integer().
semitone_count({interval, unison, perfect}) -> 0;
semitone_count({interval, second, minor}) -> 1;
semitone_count({interval, second, major}) -> 2;
semitone_count({interval, third, minor}) -> 3;
semitone_count({interval, third, major}) -> 4;
semitone_count({interval, fourth, perfect}) -> 5;
semitone_count({interval, fifth, perfect}) -> 7;
semitone_count({interval, sixth, minor}) -> 8;
semitone_count({interval, sixth, major}) -> 9;
semitone_count({interval, seventh, minor}) -> 10;
semitone_count({interval, seventh, major}) -> 11;
semitone_count({interval, octave, perfect}) -> 12;
semitone_count({interval, ninth, minor}) -> 13;
semitone_count({interval, ninth, major}) -> 14;
semitone_count({interval, tenth, minor}) -> 15;
semitone_count({interval, tenth, major}) -> 16;
semitone_count({interval, eleventh, perfect}) -> 17;
semitone_count({interval, twelfth, perfect}) -> 19;
semitone_count({interval, thirteenth, minor}) -> 20;
semitone_count({interval, thirteenth, major}) -> 21;
semitone_count({interval, fourteenth, minor}) -> 22;
semitone_count({interval, fourteenth, major}) -> 23;
semitone_count({interval, fifteenth, perfect}) -> 24;
semitone_count({interval, Interval, diminished})
  when Interval =:= unison;
       Interval =:= fourth;
       Interval =:= fifth;
       Interval =:= octave;
       Interval =:= eleventh;
       Interval =:= twelfth;
       Interval =:= fifteenth ->
    semitone_count({interval, Interval, perfect}) - 1;
semitone_count({interval, Interval, diminished})
  when Interval =:= second;
       Interval =:= third;
       Interval =:= sixth;
       Interval =:= seventh;
       Interval =:= ninth;
       Interval =:= tenth;
       Interval =:= thirteenth;
       Interval =:= fourteenth ->
    semitone_count({interval, Interval, minor}) - 1;
semitone_count({interval, Interval, augmented})
  when Interval =:= unison;
       Interval =:= fourth;
       Interval =:= fifth;
       Interval =:= octave;
       Interval =:= eleventh;
       Interval =:= twelfth;
       Interval =:= fifteenth ->
    semitone_count({interval, Interval, perfect}) + 1;
semitone_count({interval, Interval, augmented})
  when Interval =:= second;
       Interval =:= third;
       Interval =:= sixth;
       Interval =:= seventh;
       Interval =:= ninth;
       Interval =:= tenth;
       Interval =:= thirteenth;
       Interval =:= fourteenth ->
    semitone_count({interval, Interval, major}) + 1;
semitone_count(_) -> erlang:error(badarg).


%%% Implementation


white_keys() ->
    #{a => 0, h => 2, c => 3, d => 5, e => 7, f => 8, g => 10}.


%%% Tests

-dialyzer({nowarn_function,
           [semitone_count_badarg_test/0,
            pitch_class_test/0]}).


semitone_count_perfect_test() ->
    ?assertEqual(0, semitone_count({interval, unison, perfect})),
    ?assertEqual(5, semitone_count({interval, fourth, perfect})),
    ?assertEqual(7, semitone_count({interval, fifth, perfect})),
    ?assertEqual(12, semitone_count({interval, octave, perfect})),
    ?assertError(badarg, semitone_count({interval, second, perfect})),
    ?assertError(badarg, semitone_count({interval, third, perfect})).


semitone_count_major_minor_test() ->
    ?assertEqual(1, semitone_count({interval, second, minor})),
    ?assertEqual(2, semitone_count({interval, second, major})),
    ?assertEqual(3, semitone_count({interval, third, minor})),
    ?assertEqual(4, semitone_count({interval, third, major})),
    ?assertError(badarg, semitone_count({interval, unison, major})),
    ?assertError(badarg, semitone_count({interval, fifth, minor})).


semitone_count_diminished_augmented_test() ->
    ?assertEqual(6, semitone_count({interval, fifth, diminished})),
    ?assertEqual(0, semitone_count({interval, second, diminished})),
    ?assertEqual(8, semitone_count({interval, fifth, augmented})),
    ?assertEqual(3, semitone_count({interval, second, augmented})).


semitone_count_badarg_test() ->
    ?assertError(badarg, semitone_count(foo)),
    ?assertError(badarg, semitone_count({interval, blargh, perfect})).


pitch_class_test() ->
    ?assertEqual(0, pitch_class({note, a, 0})),
    ?assertEqual(1, pitch_class({note, a, 1})),
    ?assertEqual(11, pitch_class({note, a, -1})),
    ?assertEqual(3, pitch_class({note, c, 0})),
    ?assertEqual(5, pitch_class({note, d, 0})),
    ?assertEqual(10, pitch_class({note, g, 0})),
    ?assertEqual(0, pitch_class({note, g, 2})),
    ?assertEqual(2, pitch_class({note, h, 0})),
    ?assertError(badarg, pitch_class(foo)),
    ?assertError(badarg, pitch_class({note, z, 0})).
