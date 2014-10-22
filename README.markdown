Cowboy Error Noise
==================

This [Cowboy](https://github.com/ninenines/cowboy) middleware allows you to add
random failure into your API which forces your client's to handle errors better.

Have a look at the example in the [examples/](examples/) directory.

## Configuring

Add `cowboy_error_noise_middleware` to your `middlewares` configuration for cowboy.

### Example Configuration

    {ok, _} = cowboy:start_http(noisy_api_http, 1000, [{port, 10000}], [
        {env, [
            {dispatch, Dispatch},

            %% API Noise.
            {noise_error_percent, 33.333},
            {noise_error_body, <<"Ugh! You should see this message 1/3 of the time.">>},
            {noise_error_content_type, <<"text/plain; charset=utf-8">>}
        ]},

        {middlewares, [cowboy_error_noise_middleware, cowboy_router, cowboy_handler]}
    ]),
