-module(noisy_toppage_handler).

-export([init/2]).

init(Request, Options) ->
    Method = cowboy_req:method(Request),
    {ok, reply(Method, Request), Options}.

reply(<<"GET">>, Request) ->
    cowboy_req:reply(200, [
            {<<"content-type">>, <<"text/plain; charset=utf-8">>}
        ], <<"Hello! This is the actual page :-)">>, Request);
reply(_, Request) ->
    cowboy_req:reply(405, Request).
