-module(usage).

-export([run/0]).
-export([greeting/0]).

-define(ConfigDir, "priv/conf").
-define(ContentDir, "priv/html").

-define(ConfigFile, "index.conf").

run() -> dobi:build(
	dobi:build_parts(filename:join(?ConfigDir, ?ConfigFile), ?ContentDir),
	[{"$text", "This is usage example."}]
).

greeting() -> "Hello world!".
