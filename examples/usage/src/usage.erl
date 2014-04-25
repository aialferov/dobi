-module(usage).

-export([run/0]).
-export([greeting/0]).

-define(ContentDir, "priv/html").
-define(ConfigFile, "priv/usage.conf").

run() ->
	{ok, Config} = file:consult(?ConfigFile),
	dobi:build(dobi:build_parts(Config, ?ContentDir),
		[{"$text", "This is usage example."}]).

greeting() -> "Hello world!".
