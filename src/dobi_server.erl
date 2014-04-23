%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@alferov.me>
%%% @copyright (C) 2014, Anton I Alferov
%%%
%%% Created: 23 Apr 2014 by Anton I Alferov <casper@alferov.me>
%%%-------------------------------------------------------------------

-module(dobi_server).
-behaviour(gen_server).

-export([start_link/1]).

-export([reload/0]).

-export([document/1]).

-export([init/1, terminate/2, code_change/3]).
-export([handle_call/3, handle_cast/2, handle_info/2]).

-define(ConfigExt, ".conf").

-record(state, {config_dir, content_dir, documents}).

start_link(_Args) -> gen_server:start_link({local, ?MODULE}, ?MODULE,
	utils_app:get_env([config_dir, content_dir]), []).

init([{config_dir, ConfigDir}, {content_dir, ContentDir}]) -> {ok, #state{
	config_dir = ConfigDir, content_dir = ContentDir,
	documents = load_documents(ConfigDir, ContentDir)
}}.

reload() -> gen_server:call(?MODULE, reload).

document(Name) -> gen_server:call(?MODULE, {document, Name}).

handle_call(reload, _From, S = _State) -> {reply, ok, S#state{
	documents = load_documents(S#state.config_dir, S#state.content_dir)}};

handle_call({document, Name}, _From, S = State) ->
	{reply, utils_lists:keyfind(Name, S#state.documents), State}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

load_documents(ConfigDir, ContentDir) ->
	load_documents(ConfigDir, ContentDir, file:list_dir(ConfigDir)).

load_documents(ConfigDir, ContentDir, {ok, ConfigFiles}) -> [{
	filename:basename(ConfigFile, ?ConfigExt),
	dobi_core:build(filename:join(ConfigDir, ConfigFile), ContentDir)
} || ConfigFile <- ConfigFiles, filename:extension(ConfigFile) == ?ConfigExt].
