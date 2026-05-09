%% @hidden

-module(degrees).

-export([down/2, up/2]).

-include("music_scale_types.hrl").

-include_lib("eunit/include/eunit.hrl").


-spec down(note_name(), interval_name()) -> note_name().
down(Note, IntervalName) ->
    degrees_down(Note, degree_count(IntervalName)).


-spec up(note_name(), interval_name()) -> note_name().
up(Note, IntervalName) ->
    degrees_up(Note, degree_count(IntervalName)).


%%% Implementation


notes() ->
    [a, h, c, d, e, f, g].


notes_indexed() ->
    lists:enumerate([a, h, c, d, e, f, g]).


degree_count(unison) -> 0;
degree_count(second) -> 1;
degree_count(third) -> 2;
degree_count(fourth) -> 3;
degree_count(fifth) -> 4;
degree_count(sixth) -> 5;
degree_count(seventh) -> 6;
degree_count(octave) -> 7;
degree_count(ninth) -> 8;
degree_count(tenth) -> 9;
degree_count(eleventh) -> 10;
degree_count(twelfth) -> 11;
degree_count(thirteenth) -> 12;
degree_count(fourteenth) -> 13;
degree_count(fifteenth) -> 14;
degree_count(_) -> erlang:error(badarg).


degrees_up(Note, Degree) ->
    case lists:keyfind(Note, 2, notes_indexed()) of
        {Index, Note} ->
            ResIndex = ((Index - 1 + Degree) rem 7) + 1,
            lists:nth(ResIndex, notes());
        false ->
            erlang:error(badarg)
    end.


degrees_down(Note, Degree) ->
    case lists:keyfind(Note, 2, notes_indexed()) of
        {Index, Note} ->
            ResIndex = ((7 + Index - 1 - (Degree rem 7)) rem 7) + 1,
            lists:nth(ResIndex, notes());
        false ->
            erlang:error(badarg)
    end.


%%% Tests

-dialyzer({nowarn_function,
           [down_test/0,
            up_test/0,
            degree_count_test/0]}).


down_test() ->
    ?assertEqual(down(a, unison), a),
    ?assertEqual(down(a, second), g),
    ?assertEqual(down(a, third), f),
    ?assertEqual(down(a, octave), a),
    ?assertEqual(down(a, fifteenth), a),
    ?assertEqual(down(c, unison), c),
    ?assertEqual(down(c, second), h),
    ?assertEqual(down(c, third), a),
    ?assertEqual(down(c, octave), c),
    ?assertEqual(down(c, fifteenth), c),
    ?assertEqual(down(g, unison), g),
    ?assertEqual(down(g, second), f),
    ?assertEqual(down(g, third), e),
    ?assertEqual(down(g, octave), g),
    ?assertEqual(down(g, fifteenth), g),
    ?assertError(badarg, down(b, second)),
    ?assertError(badarg, down(a, unknown_interval)).


up_test() ->
    ?assertEqual(up(a, unison), a),
    ?assertEqual(up(a, second), h),
    ?assertEqual(up(a, third), c),
    ?assertEqual(up(a, octave), a),
    ?assertEqual(up(a, fifteenth), a),
    ?assertEqual(up(c, unison), c),
    ?assertEqual(up(c, second), d),
    ?assertEqual(up(c, third), e),
    ?assertEqual(up(c, octave), c),
    ?assertEqual(up(c, fifteenth), c),
    ?assertEqual(up(g, unison), g),
    ?assertEqual(up(g, second), a),
    ?assertEqual(up(g, third), h),
    ?assertEqual(up(g, octave), g),
    ?assertEqual(up(g, fifteenth), g),
    ?assertError(badarg, up(b, second)),
    ?assertError(badarg, up(a, unknown_interval)).


roundtrip_test() ->
    Notes = notes(),
    Intervals = [unison, second, third, fourth, fifth, sixth, seventh,
                 octave, ninth, tenth, eleventh, twelfth, thirteenth,
                 fourteenth, fifteenth],
    lists:foreach(
      fun(Note) ->
              lists:foreach(
                fun(Interval) ->
                        ?assertEqual(Note, up(down(Note, Interval), Interval)),
                        ?assertEqual(Note, down(up(Note, Interval), Interval))
                end,
                Intervals)
      end,
      Notes).


octave_circle_test() ->
    Notes = notes(),
    lists:foreach(
      fun(Note) ->
              ?assertEqual(Note, up(Note, octave)),
              ?assertEqual(Note, down(Note, octave)),
              ?assertEqual(Note, up(Note, fifteenth)),
              ?assertEqual(Note, down(Note, fifteenth))
      end,
      Notes).


degree_count_test() ->
    ?assertEqual(0, degree_count(unison)),
    ?assertEqual(1, degree_count(second)),
    ?assertEqual(2, degree_count(third)),
    ?assertEqual(3, degree_count(fourth)),
    ?assertEqual(4, degree_count(fifth)),
    ?assertEqual(5, degree_count(sixth)),
    ?assertEqual(6, degree_count(seventh)),
    ?assertEqual(7, degree_count(octave)),
    ?assertEqual(8, degree_count(ninth)),
    ?assertEqual(9, degree_count(tenth)),
    ?assertEqual(10, degree_count(eleventh)),
    ?assertEqual(11, degree_count(twelfth)),
    ?assertEqual(12, degree_count(thirteenth)),
    ?assertEqual(13, degree_count(fourteenth)),
    ?assertEqual(14, degree_count(fifteenth)),
    ?assertError(badarg, degree_count(invalid)).
