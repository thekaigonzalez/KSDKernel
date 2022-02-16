module freeksd.runksd;

// Copyright 2022 kaigonzalez
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import freeksd.setup;
import freeksd.api.readline;

import freeksd.builtin.termio;

import std.stdio;
import std.process;
import std.net.curl;
import core.thread;

void kernelprocess() {
    Thread setup = new Thread(&setupKSD);

    setup.start();

    Thread termion = new Thread(&terminalProcess);

    termion.start();

}