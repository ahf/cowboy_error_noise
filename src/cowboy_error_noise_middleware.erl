%%%
%%% Copyright (c) 2014 Alexander Færøy.
%%% All rights reserved.
%%%
%%% Redistribution and use in source and binary forms, with or without
%%% modification, are permitted provided that the following conditions are met:
%%%
%%% * Redistributions of source code must retain the above copyright notice, this
%%%   list of conditions and the following disclaimer.
%%%
%%% * Redistributions in binary form must reproduce the above copyright notice,
%%%   this list of conditions and the following disclaimer in the documentation
%%%   and/or other materials provided with the distribution.
%%%
%%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
%%% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%%% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%%% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
%%% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
%%% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
%%% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
%%% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
%%% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%%% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%
%%% ----------------------------------------------------------------------------
%%% @author     Alexander Færøy <ahf@0x90.dk>
%%% @doc        Cowboy Middleware for adding error noise for your API requests
%%% @end
%%% ----------------------------------------------------------------------------
-module(cowboy_error_noise_middleware).

%% API.
-export([execute/2]).

-spec execute(Request, Environment) -> {ok, Request, Environment}
    when
        Request :: cowboy_req:req(),
        Environment :: cowboy_middleware:env().
execute(Request, Environment) ->
    ErrorCode = proplists:get_value(noise_error_code, Environment, 503),
    ErrorContentType = proplists:get_value(noise_error_content_type, Environment, <<"text/plain; charset=utf-8">>),
    ErrorBody = proplists:get_value(noise_error_body, Environment, <<>>),
    ErrorPercent = proplists:get_value(noise_error_percent, Environment, 1.0),
    case random:uniform() of
        X when X =< ErrorPercent ->
            {ok, Request2} = cowboy_req:reply(ErrorCode, [
                    {<<"content-type">>, ErrorContentType},
                    {<<"retry-after">>, <<"0">>}
                ], ErrorBody, Request),
            {halt, Request2};

        _Otherwise ->
            {ok, Request, Environment}
    end.
