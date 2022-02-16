module freeksd.builtin.termio;

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

import std.stdio;
import std.net.curl;
import std.file;
import std.process;
import std.conv;

// FreeKSD API

import freeksd.api.readline;
import freeksd.api.user;

import core.sys.posix.signal;

extern(C) void handleCtrlC(int)
{
	write("^C");
}

string[] parse_string(string c) {
    int state = 1;
    string[] args;
    string point = "";
    for (int i = 0 ; i < c.length ; ++ i) {
        if (c[i] == ' ' && state == 1) {
            args = args ~ point;
            point = "";
            
            state = 2;
        } else if (c[i] == ' ' && state == 2) {
            args = args ~ point;
            point = "";
        } else if (c[i] == '"' && state == 2) {
            state = 122    ;
            
        } else if (c[i] == '"' && state == 122) {
            state = 2;
            args = args ~ point;
            point = "";
        } else {
            point = point ~ c[i];
        }
    }

    if (point.length != 0) {
        args = args ~ point;
    }
    return args;
}

void loadbinary(string[] bin) {
    auto krnl=spawnProcess(bin);

    if (wait(krnl) != 0) {
        
    }

}

void terminalProcess() {
    writeln("FreeKSD v0.0.1");
    sigaction_t act = { sa_handler: &handleCtrlC };
	int errcode = sigaction(SIGKILL, &act, null);

    while (true) {
        try {
            string input = to!string(readline("> "));
            auto argv = parse_string(input);
            if (argv.length != 0) {
                if (argv[0] == "cd") { try { chdir(argv[1]); } catch(Exception) { error("cd: directory not found."); } } 
                else argv.loadbinary();
            }
        }
        catch (ProcessException) {
            error("Could not find binary");
        } catch (Exception) {
            error("An unknown error occurred!");
            hint_warning("do you have enough memory? did the setup go well? a bug? let us know!");
        }
    }
}