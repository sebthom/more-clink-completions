-- Run after haxe build.hxml: clink lua tests/arduino-cli.lua
-- Exercises the generated Lua with real Arduino CLI help and a recording matcher.
local roots = {}
local function matcher()
    local m = {_args={}, _priority=999, flags={}, commands={}}
    function m:setdelayinit(fn) self.init=fn; return self end
    function m:addarg(args)
        for _, arg in ipairs(args) do
            if type(arg)=='table' and arg.name then self.commands[arg.name]=arg.parser end
        end
        return self
    end
    function m:addflags(flags)
        for _,flag in ipairs(flags) do
            if type(flag)=='table' then self.flags[flag.name]=flag.parser
            else self.flags[flag]=true end
        end
        return self
    end
    function m:nofiles() self.no_files=true; return self end
    return setmetatable(m, {__concat=function(name, parser) return {name=name, parser=parser} end})
end
clink.argmatcher = function(_,name)
    local m=matcher()
    if name then roots[name]=m end
    return m
end
clink.getargmatcher = function(name) return roots[name] end
clink.filematches = function() return {} end
clink.dirmatches = function() return {} end
dofile('target/more-clink-completions.lua')
local root=assert(roots['arduino-cli'])
root.init(root, 'arduino-cli')
assert(root.commands.compile and root.commands.core and root.commands.lib)
assert(root.flags['--config-file'] and root.flags['--json'])
assert(type(root.flags['--json'])=='boolean')
assert(type(root.flags['--config-file'])=='table', 'config-file type: '..type(root.flags['--config-file']))
local core=root.commands.core
core.init(core, 'core')
assert(core.commands.install and core.commands.list and core.commands['update-index'])
local compile=root.commands.compile
compile.init(compile, 'compile')
assert(compile.flags['--fqbn'] and compile.flags['-b'])
assert(type(compile.flags['--fqbn'])=='table')
assert(type(compile.flags['--clean'])=='boolean')
assert(compile.flags['--build-path'] and compile.flags['--config-file'])
assert(not compile.no_files)
assert(root.no_files and core.no_files)
local lib=root.commands.lib
lib.init(lib, 'lib')
assert(lib.commands.install and lib.commands.search and lib.commands.upgrade)
print('PASS Arduino CLI root, nested commands, value/boolean flags, aliases and leaf filenames')
