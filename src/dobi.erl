%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@alferov.me>
%%% @copyright (C) 2014, Anton I Alferov
%%%
%%% Created: 23 Apr 2014 by Anton I Alferov <casper@alferov.me>
%%%-------------------------------------------------------------------

-module(dobi).

-export([start/0, stop/0]).
-export([reload/0]).

-export([document/1, document/2]).

start() -> application:start(?MODULE).
stop() -> application:stop(?MODULE).

reload() -> dobi_server:reload().

document(Name)  -> document(Name, []).
document(Name, Vars) -> case dobi_server:document(Name) of
	{ok, DocumentParts} -> {ok, build(DocumentParts, Vars)}; Error -> Error end.

build(DocumentParts, Vars) -> lists:foldl(fun(Part, Document) ->
	Document ++ case Part of
		{IncompleteContent, ContentVars} ->
			lists:foldl(fun(Var, Content) ->
				utils_string:sub(Content, Var, utils_lists:value(Var, Vars))
			end, IncompleteContent, ContentVars);
		Content -> Content
	end
end, [], DocumentParts).
