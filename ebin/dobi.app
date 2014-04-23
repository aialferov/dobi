%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@alferov.me>
%%% @copyright (C) 2014, Anton I Alferov
%%%
%%% Created: 23 Apr 2014 by Anton I Alferov <casper@alferov.me>
%%%-------------------------------------------------------------------

{application, dobi, [
	{id, "dobi"},
	{vsn, "0.0.1"},
	{description, "Document builder"},
	{modules, [
		dobi,
		dobi_app,
		dobi_sup,
		dobi_core,
		dobi_server
	]},
	{registered, [dobi_server]},
	{applications, [kernel, stdlib, sasl, utils]},
	{mod, {dobi_app, []}}
]}.
