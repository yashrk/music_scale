# Music Scale Calculator

Framework for interval, chord and scale calculations. Includes additional functions to calculate fretboard charts.

Opinionated conventions (German notation system — si is H, si flat is B, no pseudo-chords like "Am⁶"). Uses scale degrees and pitch classes, so octaves are not used.

## Build

```bash
$ rebar3 compile
```

## Test

### Unit tests

```bash
$ rebar3 eunit
```

### Integration tests

```bash
$ rebar3 ct
```

### Explore the library interactive

```bash
$ rebar3 shell
```

## Usage

Make given chord from given note:
```erlang
1> music_scale:chord_from(<<"a"/utf8>>, {chord, minor_triad}).
[<<"a">>,<<"c">>,<<"e">>]
```

Make given interval from given note:
```erlang
1> music_scale:interval_from(<<"c"/utf8>>, {interval, third, major}, up).
<<"e">>
```

Calculate notes of a given tonality:
```erlang
1> music_scale:tonality_from(<<"f"/utf8>>, {scale, natural_major}).
[<<"f">>,<<"g">>,<<"a">>,<<"b">>,<<"c">>,<<"d">>,<<"e">>]
```
