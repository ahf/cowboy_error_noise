-module(noisy_api_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [
                {"/", noisy_toppage_handler, []}
              ]}
    ]),

    {ok, _} = cowboy:start_http(noisy_api_http, 1000, [{port, 10000}], [
        {env, [
            {dispatch, Dispatch},

            %% API Noise.
            {noise_error_percent, 33.333},
            {noise_error_body, <<"Ugh! You should see this message 1/3 of the time.">>}
        ]},

        {middlewares, [cowboy_error_noise_middleware, cowboy_router, cowboy_handler]}
    ]),

    noisy_api_sup:start_link().

stop(_State) ->
    ok.
