%% @hidden

-module(text_notes).

-include("music_scale_types.hrl").

-export([from_internal/1, to_internal/1, fretboard_chart_from_internal/1]).

-include_lib("eunit/include/eunit.hrl").


-spec to_internal(text_note()) -> note().
to_internal(<<"a𝄫"/utf8>>) -> {note, a, -2};
to_internal(<<"a♭"/utf8>>) -> {note, a, -1};
to_internal(<<"a"/utf8>>) -> {note, a, 0};
to_internal(<<"a♮"/utf8>>) -> {note, a, 0};
to_internal(<<"a♯"/utf8>>) -> {note, a, 1};
to_internal(<<"a𝄪"/utf8>>) -> {note, a, 2};
to_internal(<<"b♭"/utf8>>) -> {note, h, -2};
to_internal(<<"b"/utf8>>) -> {note, h, -1};
to_internal(<<"b♮"/utf8>>) -> {note, h, -1};
to_internal(<<"h"/utf8>>) -> {note, h, 0};
to_internal(<<"h♮"/utf8>>) -> {note, h, 0};
to_internal(<<"h♭"/utf8>>) -> {note, h, -1};
to_internal(<<"h♯"/utf8>>) -> {note, h, 1};
to_internal(<<"h𝄪"/utf8>>) -> {note, h, 2};
to_internal(<<"c𝄫"/utf8>>) -> {note, c, -2};
to_internal(<<"c♭"/utf8>>) -> {note, c, -1};
to_internal(<<"c"/utf8>>) -> {note, c, 0};
to_internal(<<"c♮"/utf8>>) -> {note, c, 0};
to_internal(<<"c♯"/utf8>>) -> {note, c, 1};
to_internal(<<"c𝄪"/utf8>>) -> {note, c, 2};
to_internal(<<"d𝄫"/utf8>>) -> {note, d, -2};
to_internal(<<"d♭"/utf8>>) -> {note, d, -1};
to_internal(<<"d"/utf8>>) -> {note, d, 0};
to_internal(<<"d♮"/utf8>>) -> {note, d, 0};
to_internal(<<"d♯"/utf8>>) -> {note, d, 1};
to_internal(<<"d𝄪"/utf8>>) -> {note, d, 2};
to_internal(<<"e𝄫"/utf8>>) -> {note, e, -2};
to_internal(<<"e♭"/utf8>>) -> {note, e, -1};
to_internal(<<"e"/utf8>>) -> {note, e, 0};
to_internal(<<"e♮"/utf8>>) -> {note, e, 0};
to_internal(<<"e♯"/utf8>>) -> {note, e, 1};
to_internal(<<"e𝄪"/utf8>>) -> {note, e, 2};
to_internal(<<"f𝄫"/utf8>>) -> {note, f, -2};
to_internal(<<"f♭"/utf8>>) -> {note, f, -1};
to_internal(<<"f"/utf8>>) -> {note, f, 0};
to_internal(<<"f♮"/utf8>>) -> {note, f, 0};
to_internal(<<"f♯"/utf8>>) -> {note, f, 1};
to_internal(<<"f𝄪"/utf8>>) -> {note, f, 2};
to_internal(<<"g𝄫"/utf8>>) -> {note, g, -2};
to_internal(<<"g♭"/utf8>>) -> {note, g, -1};
to_internal(<<"g"/utf8>>) -> {note, g, 0};
to_internal(<<"g♮"/utf8>>) -> {note, g, 0};
to_internal(<<"g♯"/utf8>>) -> {note, g, 1};
to_internal(<<"g𝄪"/utf8>>) -> {note, g, 2};
to_internal(_) -> erlang:error(badarg).


-spec from_internal(note()) -> text_note().
from_internal({note, a, -2}) -> <<"a𝄫"/utf8>>;
from_internal({note, a, -1}) -> <<"a♭"/utf8>>;
from_internal({note, a, 0}) -> <<"a"/utf8>>;
from_internal({note, a, 1}) -> <<"a♯"/utf8>>;
from_internal({note, a, 2}) -> <<"a𝄪"/utf8>>;
from_internal({note, h, -2}) -> <<"b♭"/utf8>>;
from_internal({note, h, -1}) -> <<"b"/utf8>>;
from_internal({note, h, 0}) -> <<"h"/utf8>>;
from_internal({note, h, 1}) -> <<"h♯"/utf8>>;
from_internal({note, h, 2}) -> <<"h𝄪"/utf8>>;
from_internal({note, c, -2}) -> <<"c𝄫"/utf8>>;
from_internal({note, c, -1}) -> <<"c♭"/utf8>>;
from_internal({note, c, 0}) -> <<"c"/utf8>>;
from_internal({note, c, 1}) -> <<"c♯"/utf8>>;
from_internal({note, c, 2}) -> <<"c𝄪"/utf8>>;
from_internal({note, d, -2}) -> <<"d𝄫"/utf8>>;
from_internal({note, d, -1}) -> <<"d♭"/utf8>>;
from_internal({note, d, 0}) -> <<"d"/utf8>>;
from_internal({note, d, 1}) -> <<"d♯"/utf8>>;
from_internal({note, d, 2}) -> <<"d𝄪"/utf8>>;
from_internal({note, e, -2}) -> <<"e𝄫"/utf8>>;
from_internal({note, e, -1}) -> <<"e♭"/utf8>>;
from_internal({note, e, 0}) -> <<"e"/utf8>>;
from_internal({note, e, 1}) -> <<"e♯"/utf8>>;
from_internal({note, e, 2}) -> <<"e𝄪"/utf8>>;
from_internal({note, f, -2}) -> <<"f𝄫"/utf8>>;
from_internal({note, f, -1}) -> <<"f♭"/utf8>>;
from_internal({note, f, 0}) -> <<"f"/utf8>>;
from_internal({note, f, 1}) -> <<"f♯"/utf8>>;
from_internal({note, f, 2}) -> <<"f𝄪"/utf8>>;
from_internal({note, g, -2}) -> <<"g𝄫"/utf8>>;
from_internal({note, g, -1}) -> <<"g♭"/utf8>>;
from_internal({note, g, 0}) -> <<"g"/utf8>>;
from_internal({note, g, 1}) -> <<"g♯"/utf8>>;
from_internal({note, g, 2}) -> <<"g𝄪"/utf8>>;
from_internal(_) -> erlang:error(badarg).


-spec fretboard_chart_from_internal(chart()) -> chart_text().
fretboard_chart_from_internal({chart, StringCharts}) ->
    {chart, lists:map(fun string_from_internal/1, StringCharts)};
fretboard_chart_from_internal(_) ->
    erlang:error(badarg).


%%% Implementation


-spec string_from_internal({mus_string(), [{integer(), note()}]}) ->
          {mus_string_text(), [{integer(), text_note()}]}.
string_from_internal({{mus_string,
                       StringNumber,
                       {note, _StringNote, _StringAccidental} = OpenString},
                      StringChart}) ->
    {{mus_string,
      StringNumber,
      from_internal(OpenString)},
     lists:map(fun fret_note_from_internal/1,
               StringChart)}.


-spec fret_note_from_internal({integer(), note()}) -> {integer(), text_note()}.
fret_note_from_internal({Fret, InternalNote}) ->
    {Fret, from_internal(InternalNote)}.


%%% Tests

-dialyzer({nowarn_function,
           [to_internal_error_test/0,
            from_internal_error_test/0,
            fretboard_chart_from_internal_error_test/0]}).


to_internal_all_notes_test() ->
    %% C
    ?assertEqual({note, c, -2}, to_internal(<<"c𝄫"/utf8>>)),
    ?assertEqual({note, c, -1}, to_internal(<<"c♭"/utf8>>)),
    ?assertEqual({note, c, 0}, to_internal(<<"c"/utf8>>)),
    ?assertEqual({note, c, 0}, to_internal(<<"c♮"/utf8>>)),
    ?assertEqual({note, c, 1}, to_internal(<<"c♯"/utf8>>)),
    ?assertEqual({note, c, 2}, to_internal(<<"c𝄪"/utf8>>)),
    %% D
    ?assertEqual({note, d, -2}, to_internal(<<"d𝄫"/utf8>>)),
    ?assertEqual({note, d, -1}, to_internal(<<"d♭"/utf8>>)),
    ?assertEqual({note, d, 0}, to_internal(<<"d"/utf8>>)),
    ?assertEqual({note, d, 0}, to_internal(<<"d♮"/utf8>>)),
    ?assertEqual({note, d, 1}, to_internal(<<"d♯"/utf8>>)),
    ?assertEqual({note, d, 2}, to_internal(<<"d𝄪"/utf8>>)),
    %% E
    ?assertEqual({note, e, -2}, to_internal(<<"e𝄫"/utf8>>)),
    ?assertEqual({note, e, -1}, to_internal(<<"e♭"/utf8>>)),
    ?assertEqual({note, e, 0}, to_internal(<<"e"/utf8>>)),
    ?assertEqual({note, e, 0}, to_internal(<<"e♮"/utf8>>)),
    ?assertEqual({note, e, 1}, to_internal(<<"e♯"/utf8>>)),
    ?assertEqual({note, e, 2}, to_internal(<<"e𝄪"/utf8>>)),
    %% F
    ?assertEqual({note, f, -2}, to_internal(<<"f𝄫"/utf8>>)),
    ?assertEqual({note, f, -1}, to_internal(<<"f♭"/utf8>>)),
    ?assertEqual({note, f, 0}, to_internal(<<"f"/utf8>>)),
    ?assertEqual({note, f, 0}, to_internal(<<"f♮"/utf8>>)),
    ?assertEqual({note, f, 1}, to_internal(<<"f♯"/utf8>>)),
    ?assertEqual({note, f, 2}, to_internal(<<"f𝄪"/utf8>>)),
    %% G
    ?assertEqual({note, g, -2}, to_internal(<<"g𝄫"/utf8>>)),
    ?assertEqual({note, g, -1}, to_internal(<<"g♭"/utf8>>)),
    ?assertEqual({note, g, 0}, to_internal(<<"g"/utf8>>)),
    ?assertEqual({note, g, 0}, to_internal(<<"g♮"/utf8>>)),
    ?assertEqual({note, g, 1}, to_internal(<<"g♯"/utf8>>)),
    ?assertEqual({note, g, 2}, to_internal(<<"g𝄪"/utf8>>)),
    %% A
    ?assertEqual({note, a, -2}, to_internal(<<"a𝄫"/utf8>>)),
    ?assertEqual({note, a, -1}, to_internal(<<"a♭"/utf8>>)),
    ?assertEqual({note, a, 0}, to_internal(<<"a"/utf8>>)),
    ?assertEqual({note, a, 0}, to_internal(<<"a♮"/utf8>>)),
    ?assertEqual({note, a, 1}, to_internal(<<"a♯"/utf8>>)),
    ?assertEqual({note, a, 2}, to_internal(<<"a𝄪"/utf8>>)),
    %% H and B
    ?assertEqual({note, h, -2}, to_internal(<<"b♭"/utf8>>)),
    ?assertEqual({note, h, -1}, to_internal(<<"b"/utf8>>)),
    ?assertEqual({note, h, -1}, to_internal(<<"b♮"/utf8>>)),
    ?assertEqual({note, h, 0}, to_internal(<<"h"/utf8>>)),
    ?assertEqual({note, h, 0}, to_internal(<<"h♮"/utf8>>)),
    ?assertEqual({note, h, -1}, to_internal(<<"h♭"/utf8>>)),
    ?assertEqual({note, h, 1}, to_internal(<<"h♯"/utf8>>)),
    ?assertEqual({note, h, 2}, to_internal(<<"h𝄪"/utf8>>)).


from_internal_all_notes_test() ->
    %% C
    ?assertEqual(<<"c𝄫"/utf8>>, from_internal({note, c, -2})),
    ?assertEqual(<<"c♭"/utf8>>, from_internal({note, c, -1})),
    ?assertEqual(<<"c"/utf8>>, from_internal({note, c, 0})),
    ?assertEqual(<<"c♯"/utf8>>, from_internal({note, c, 1})),
    ?assertEqual(<<"c𝄪"/utf8>>, from_internal({note, c, 2})),
    %% D
    ?assertEqual(<<"d𝄫"/utf8>>, from_internal({note, d, -2})),
    ?assertEqual(<<"d♭"/utf8>>, from_internal({note, d, -1})),
    ?assertEqual(<<"d"/utf8>>, from_internal({note, d, 0})),
    ?assertEqual(<<"d♯"/utf8>>, from_internal({note, d, 1})),
    ?assertEqual(<<"d𝄪"/utf8>>, from_internal({note, d, 2})),
    %% E
    ?assertEqual(<<"e𝄫"/utf8>>, from_internal({note, e, -2})),
    ?assertEqual(<<"e♭"/utf8>>, from_internal({note, e, -1})),
    ?assertEqual(<<"e"/utf8>>, from_internal({note, e, 0})),
    ?assertEqual(<<"e♯"/utf8>>, from_internal({note, e, 1})),
    ?assertEqual(<<"e𝄪"/utf8>>, from_internal({note, e, 2})),
    %% F
    ?assertEqual(<<"f𝄫"/utf8>>, from_internal({note, f, -2})),
    ?assertEqual(<<"f♭"/utf8>>, from_internal({note, f, -1})),
    ?assertEqual(<<"f"/utf8>>, from_internal({note, f, 0})),
    ?assertEqual(<<"f♯"/utf8>>, from_internal({note, f, 1})),
    ?assertEqual(<<"f𝄪"/utf8>>, from_internal({note, f, 2})),
    %% G
    ?assertEqual(<<"g𝄫"/utf8>>, from_internal({note, g, -2})),
    ?assertEqual(<<"g♭"/utf8>>, from_internal({note, g, -1})),
    ?assertEqual(<<"g"/utf8>>, from_internal({note, g, 0})),
    ?assertEqual(<<"g♯"/utf8>>, from_internal({note, g, 1})),
    ?assertEqual(<<"g𝄪"/utf8>>, from_internal({note, g, 2})),
    %% A
    ?assertEqual(<<"a𝄫"/utf8>>, from_internal({note, a, -2})),
    ?assertEqual(<<"a♭"/utf8>>, from_internal({note, a, -1})),
    ?assertEqual(<<"a"/utf8>>, from_internal({note, a, 0})),
    ?assertEqual(<<"a♯"/utf8>>, from_internal({note, a, 1})),
    ?assertEqual(<<"a𝄪"/utf8>>, from_internal({note, a, 2})),
    %% H and B
    ?assertEqual(<<"b♭"/utf8>>, from_internal({note, h, -2})),
    ?assertEqual(<<"b"/utf8>>, from_internal({note, h, -1})),
    ?assertEqual(<<"h"/utf8>>, from_internal({note, h, 0})),
    ?assertEqual(<<"h♯"/utf8>>, from_internal({note, h, 1})),
    ?assertEqual(<<"h𝄪"/utf8>>, from_internal({note, h, 2})).


round_trip_test() ->
    %% Test round-trip using known working notes from the module
    ?assertEqual(<<"a"/utf8>>, from_internal(to_internal(<<"a"/utf8>>))),
    ?assertEqual(<<"a♭"/utf8>>, from_internal(to_internal(<<"a♭"/utf8>>))),
    ?assertEqual(<<"a♯"/utf8>>, from_internal(to_internal(<<"a♯"/utf8>>))),
    ?assertEqual(<<"b"/utf8>>, from_internal(to_internal(<<"b"/utf8>>))),
    ?assertEqual(<<"c"/utf8>>, from_internal(to_internal(<<"c"/utf8>>))),
    ?assertEqual(<<"d"/utf8>>, from_internal(to_internal(<<"d"/utf8>>))),
    ?assertEqual(<<"e"/utf8>>, from_internal(to_internal(<<"e"/utf8>>))),
    ?assertEqual(<<"f"/utf8>>, from_internal(to_internal(<<"f"/utf8>>))),
    ?assertEqual(<<"g"/utf8>>, from_internal(to_internal(<<"g"/utf8>>))),
    ?assertEqual(<<"h"/utf8>>, from_internal(to_internal(<<"h"/utf8>>))).


to_internal_error_test() ->
    ?assertError(badarg, to_internal(<<"x"/utf8>>)),
    ?assertError(badarg, to_internal(<<"z"/utf8>>)),
    ?assertError(badarg, to_internal(<<""/utf8>>)).


from_internal_error_test() ->
    ?assertError(badarg, from_internal({note, x, 0})),
    ?assertError(badarg, from_internal({note, a, 3})),
    ?assertError(badarg, from_internal({note, a, -3})),
    ?assertError(badarg, from_internal(not_a_note)).


fretboard_chart_from_internal_test() ->
    Input = {chart, [{{mus_string, 1, {note, e, 0}}, [{0, {note, e, 0}}, {1, {note, f, 0}}, {2, {note, f, 1}}]},
                     {{mus_string, 2, {note, a, 0}}, [{0, {note, a, 0}}, {1, {note, a, 1}}, {2, {note, h, -1}}]}]},
    Result = fretboard_chart_from_internal(Input),
    ?assertEqual({chart, [{{mus_string, 1, <<"e"/utf8>>},
                           [{0, <<"e"/utf8>>}, {1, <<"f"/utf8>>}, {2, <<"f♯"/utf8>>}]},
                          {{mus_string, 2, <<"a"/utf8>>},
                           [{0, <<"a"/utf8>>}, {1, <<"a♯"/utf8>>}, {2, <<"b"/utf8>>}]}]},
                 Result).


fretboard_chart_from_internal_error_test() ->
    ?assertError(badarg, fretboard_chart_from_internal({not_chart, []})),
    ?assertError(badarg, fretboard_chart_from_internal([])).
