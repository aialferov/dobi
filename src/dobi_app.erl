%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@alferov.me>
%%% @copyright (C) 2014, Anton I Alferov
%%%
%%% Created: 23 Apr 2014 by Anton I Alferov <casper@alferov.me>
%%%-------------------------------------------------------------------

-module(dobi_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, StartArgs) -> dobi_sup:start_link(StartArgs).
stop(_State) -> ok.
