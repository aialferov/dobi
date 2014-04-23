%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@alferov.me>
%%% @copyright (C) 2014, Anton I Alferov
%%%
%%% Created: 23 Apr 2014 by Anton I Alferov <casper@alferov.me>
%%%-------------------------------------------------------------------

-module(dobi_core).
-export([build/2]).

build(ConfigFile, ContentDir) ->
	{ok, Config} = file:consult(ConfigFile),
	normalize(build_document(Config, ContentDir)).

build_document(Config, ContentDir) -> lists:foldl(fun
	({ContentFile, Vars}, Document) ->
		{ok, Binary} = file:read_file(filename:join(ContentDir, ContentFile)),
		Sub = fun(Var, Content) -> sub(Var, Content, ContentDir) end,
		Document ++ lists:foldl(Sub, binary_to_list(Binary), Vars)
end, [], Config).

sub({Var, Value}, Content, ContentDir) ->
	utils_string:sub(Content, Var, case Value of
		[H|_] when is_tuple(H) -> build_document(Value, ContentDir);
		{M, F} -> M:F();
		{M, F, A} -> apply(M, F, A);
		Value -> Value
	end);
sub(Var, [{Content, Vars}], _) when is_list(Var) -> [{Content, [Var|Vars]}];
sub(Var, Content, _) when is_list(Var) -> [{Content, [Var]}].

normalize(Document) -> normalize(Document, {[], []}).
normalize([H|T], {Document, Acc}) when is_tuple(H) ->
	normalize(T, {Document ++ [lists:reverse(Acc)] ++ [H], []});
normalize([H|T], {Document, Acc}) -> normalize(T, {Document, [H|Acc]});
normalize([], {Document, Acc}) -> Document ++ [lists:reverse(Acc)].
