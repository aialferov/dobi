-module(usage).

-export([run/0]).
-export([greeting/0]).

run() -> dobi:document("index", [{"$text", "This is usage example."}]).

greeting() -> "Hello world!".
