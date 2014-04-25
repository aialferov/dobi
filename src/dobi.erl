%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@alferov.me>
%%% @copyright (C) 2014, Anton I Alferov
%%%
%%% Created: 23 Apr 2014 by Anton I Alferov <casper@alferov.me>
%%%-------------------------------------------------------------------

-module(dobi).

-export([start/0, stop/0]).

-export([build/2]).
-export([build_parts/2]).

start() -> application:start(?MODULE).
stop() -> application:stop(?MODULE).

build(Parts, Vars) -> lists:foldl(fun(Part, Document) ->
	Document ++ case Part of
		{IncompleteContent, ContentVars} ->
			lists:foldl(fun(Var, Content) ->
				sub(Content, lists:keyfind(Var, 1, Vars))
			end, IncompleteContent, ContentVars);
		Content -> Content
	end
end, [], Parts).

build_parts(Config, ContentDir) -> split_parts(build_joint(Config, ContentDir)).

build_joint(Config, ContentDir) -> lists:foldl(fun
	({ContentFile, Vars}, Document) ->
		{ok, Binary} = file:read_file(filename:join(ContentDir, ContentFile)),
		Sub = fun(Var, Content) -> sub_content(Var, Content, ContentDir) end,
		Document ++ lists:foldl(Sub, binary_to_list(Binary), Vars)
end, [], Config).

sub_content({Var, Value}, Content, ContentDir) ->
	sub(Content, Var, case Value of
		[H|_] when is_tuple(H) -> build_joint(Value, ContentDir);
		{M, F} -> M:F();
		{M, F, A} -> apply(M, F, A);
		Value -> Value
	end);
sub_content(Var, [{Content, Vars}], _) -> [{Content, [Var|Vars]}];
sub_content(Var, Content, _) -> [{Content, [Var]}].

split_parts(Document) -> split_parts(Document, {[], []}).
split_parts([H|T], {Document, Acc}) when is_tuple(H) ->
	split_parts(T, {Document ++ [lists:reverse(Acc)] ++ [H], []});
split_parts([H|T], {Document, Acc}) -> split_parts(T, {Document, [H|Acc]});
split_parts([], {Document, Acc}) -> Document ++ [lists:reverse(Acc)].

sub(Str, {Old, New}) -> sub(Str, Old, New).
sub(Str, Old, New) -> sub(Str, Old, New, length(Old)).
sub(Str, Old, New, Len) -> sub(Str, Old, New, Len, string:str(Str, Old)).
sub(Str, _Old, _New, _Len, 0) -> Str;
sub(Str, Old, New, Len, N) -> string:left(Str, N - 1) ++ New ++
	sub(string:sub_string(Str, N + Len), Old, New, Len).
