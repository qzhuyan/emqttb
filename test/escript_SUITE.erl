%%--------------------------------------------------------------------
%% Copyright (c) 2022-2023 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------
-module(escript_SUITE).


-compile(nowarn_export_all).
-compile(export_all).

-include_lib("snabbkaffe/include/ct_boilerplate.hrl").

suite() ->
  [{timetrap, {seconds, 30}}].

t_no_args(Config) when is_list(Config) ->
  ?assertMatch(0, run("")).

t_basic_scenarios(Config) when is_list(Config) ->
  ?assertMatch(0, run("--loiter 0 @pub -t foo -I 1000 -N 0")).

t_set_group_config(Config) when is_list(Config) ->
  ?assertMatch(0, run("@g -p 9090")),
  ?assertMatch(0, run("@g -g my_group -p 9090")),
  ?assertMatch(1, run("@g -g my_group -p foo")).

run(CMD) ->
  RootDir = string:trim(os:cmd("git rev-parse --show-toplevel")),
  Path = filename:join(RootDir, "_build/default/bin/emqttb"),
  Port = open_port({spawn, Path ++ " " ++ CMD}, [nouse_stdio, exit_status]),
  receive
    {Port, {exit_status, E}} -> E
  end.
