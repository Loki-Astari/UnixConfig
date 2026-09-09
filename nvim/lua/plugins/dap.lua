-- Debugging C++ with nvim-dap
--
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
--
-- DEBUGGER BACKEND
-- ----------------
-- On macOS (arm64) gdb does not work: upstream gdb has no aarch64-Darwin
-- target. ThorMaker already knows this -- `make debugrun.<Test>` shells out to
-- lldb (build/tools/targets/test.mk). So this config picks an adapter at
-- startup, in order of preference:
--
--      codelldb    if installed via :Mason  (nicest, optional)
--      lldb-dap    ships with Xcode / CommandLineTools  (the macOS default)
--      gdb         gdb >= 14 speaks DAP natively        (the Linux default)
--
-- The keymaps and launch configurations are identical whichever is chosen, so
-- the same setup debugs on both Mac and Linux.
--
-- KEYMAPS (all under <leader>d, see which-key)
-- -------
--      <leader>dt      Debug the GTest under the cursor        <-- the main one
--      <leader>dT      Debug tests matching a --gtest_filter you type
--      <leader>da      Debug an application (*.prog) in this directory
--      <leader>dA      Attach to a running process
--
--      <leader>dd      Start / continue          (F5)
--      <leader>db      Toggle breakpoint         (F9)   <-- needed to stop
--      <leader>dB      Breakpoint with condition
--      <leader>dp      Log point (prints, does not stop)
--      <leader>dC      Run to cursor
--      <leader>dn      Step over                 (F10)
--      <leader>di      Step into                 (F11)
--      <leader>do      Step out                  (F12)
--      <leader>dk      Evaluate expression under cursor / selection
--      <leader>de      Evaluate an expression you type
--      <leader>dw      Add an expression to the watch window
--      <leader>dr      Toggle the REPL (raw lldb commands: `:DapRepl`)
--      <leader>du      Toggle the debugger UI
--      <leader>dl      Re-run the last debug session
--      <leader>dx      Terminate the session
--
-- COMMANDS
--      :DapBuildTest   Build the unit test binary without debugging
--      :DapLogLevel    Set THOR_LOG_LEVEL used for the next session

-------------------------------------------------------------------------------
-- Tunables
-------------------------------------------------------------------------------

-- Rebuild the unit test binary before starting a test debug session.
-- Set to false if you would rather build yourself and start instantly.
vim.g.dap_build_before_run = true

-- THOR_LOG_LEVEL exported into the debuggee. ThorMaker's debugrun uses DEBUG.
vim.g.dap_thor_log_level = 'DEBUG'

-- A debug session with no breakpoints just runs to completion and exits, which
-- looks like the debugger opening and instantly closing. When <leader>dt is
-- used and no breakpoints exist anywhere, stop at the first statement of the
-- test being debugged. Set false to run unhindered instead.
vim.g.dap_auto_breakpoint = true

-- ThorsAnvil symlinks src/<Component> -> third/<Repo>/src/<Component>.  The
-- debug info records the *real* third/... path, so a breakpoint set in a buffer
-- opened through the symlink would never bind.  Renaming such buffers to their
-- resolved path keeps breakpoints working from either directory.
vim.g.dap_resolve_symlinks = true

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

local H = {}

local is_mac = vim.uv.os_uname().sysname == 'Darwin'

local function exists(path)
    return path ~= nil and path ~= '' and vim.uv.fs_stat(path) ~= nil
end

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO, { title = 'Debug' })
end

-- The variable the dynamic loader reads for this platform.
H.lib_path_var = is_mac and 'DYLD_LIBRARY_PATH' or 'LD_LIBRARY_PATH'

-- Locate the component directory: the nearest ancestor holding a Makefile,
-- ignoring the build output directories a source file may be sitting in.
--      .../src/Serialize/test/coverage/x.o  ->  .../src/Serialize
function H.component_root(start)
    local skip = { test = true, debug = true, release = true, coverage = true, profile = true }
    local dir = start
    if dir == nil or dir == '' then
        dir = vim.fn.expand('%:p:h')
    end
    if dir == '' then
        dir = vim.fn.getcwd()
    end
    while dir and dir ~= '/' and dir ~= '' do
        if not skip[vim.fn.fnamemodify(dir, ':t')] and exists(dir .. '/Makefile') then
            return dir
        end
        dir = vim.fn.fnamemodify(dir, ':h')
    end
    return vim.fn.getcwd()
end

-- Directories the debuggee needs on its library search path.
--
-- ThorMaker publishes this itself: `make neovimruntime` (build/tools/
-- integrations/neovim.mk) echoes $(RUNTIME_PATHS_USED_TO_LOAD), which is the
-- same value the test targets use. Prefer it -- it also covers
-- $(LDLIBS_EXTERN_PATH), which a search for build/lib alone would miss. Fall
-- back to walking up for build/lib if the target is unavailable.
function H.ask_thormaker(root)
    local ok, result = pcall(function()
        return vim.system({ 'make', 'neovimruntime' }, { cwd = root, text = true }):wait(5000)
    end)
    if not ok or result == nil or result.code ~= 0 then
        return nil
    end
    local found = nil
    for line in (result.stdout or ''):gmatch('[^\r\n]+') do
        if line:sub(1, 1) == '/' then
            found = vim.trim(line)
        end
    end
    return found
end

function H.library_path(root)
    local paths = {}
    local published = H.ask_thormaker(root)
    if published then
        table.insert(paths, published)
    else
        local dir = root
        while dir and dir ~= '/' and dir ~= '' do
            local lib = dir .. '/build/lib'
            if exists(lib) then
                table.insert(paths, vim.fn.resolve(lib))
                break
            end
            dir = vim.fn.fnamemodify(dir, ':h')
        end
    end
    -- The component's own shared libraries, then the system default.
    for _, mode in ipairs({ 'debug', 'release' }) do
        if exists(root .. '/' .. mode) then
            table.insert(paths, root .. '/' .. mode)
        end
    end
    if not published then
        table.insert(paths, exists('/opt/homebrew/lib') and '/opt/homebrew/lib' or '/usr/local/lib')
    end

    local inherited = vim.env[H.lib_path_var]
    if inherited and inherited ~= '' then
        table.insert(paths, inherited)
    end
    return table.concat(paths, ':')
end

function H.environment(root)
    return {
        [H.lib_path_var] = H.library_path(root),
        THOR_LOG_LEVEL = vim.g.dap_thor_log_level or 'DEBUG',
    }
end

-- Each adapter wants the environment in a different shape.
function H.format_env(adapter, env)
    if adapter == 'lldb' then
        -- lldb-dap takes a list of KEY=VALUE strings.
        local list = {}
        for k, v in pairs(env) do
            table.insert(list, k .. '=' .. v)
        end
        table.sort(list)
        return list
    end
    -- codelldb and gdb take a plain dictionary.
    return env
end

-- Work out the --gtest_filter for the test the cursor is sitting in by
-- scanning backwards for the defining macro.
-- Returns the --gtest_filter, and the line the defining macro sits on.
function H.gtest_filter_under_cursor()
    local lnum = vim.fn.line('.')
    for i = lnum, 1, -1 do
        local macro, suite, name =
            vim.fn.getline(i):match('^%s*([%u_]+)%s*%(%s*([%w_]+)%s*,%s*([%w_]+)%s*%)')
        if macro == 'TEST' or macro == 'TEST_F' then
            return suite .. '.' .. name, i
        elseif macro == 'TYPED_TEST' then
            -- Typed tests are registered as Suite/<index>.Name
            return suite .. '/*.' .. name, i
        elseif macro == 'TEST_P' or macro == 'TYPED_TEST_P' then
            -- Parameterised tests are Instantiation/Suite.Name/<index>
            return '*' .. suite .. '.' .. name .. '*', i
        end
    end
    return nil, nil
end

-- Total breakpoints set across every buffer.
function H.breakpoint_count()
    local ok, all = pcall(function() return require('dap.breakpoints').get() end)
    if not ok or all == nil then
        return 0
    end
    local count = 0
    for _, list in pairs(all) do
        count = count + #list
    end
    return count
end

-- First statement inside a test body, skipping the macro line and its brace.
function H.first_body_line(macro_lnum)
    local last = vim.fn.line('$')
    local brace = macro_lnum
    while brace <= last and brace < macro_lnum + 5 do
        if vim.fn.getline(brace):match('{%s*$') then
            break
        end
        brace = brace + 1
    end
    for i = brace + 1, math.min(last, brace + 60) do
        local text = vim.trim(vim.fn.getline(i))
        if text ~= '' and text ~= '{' and not text:match('^//') and not text:match('^/%*')
                and not text:match('^%*') then
            return i
        end
    end
    return math.min(macro_lnum + 2, last)
end

-- Build the unit test binary, then run `andThen` if it succeeded.
-- Build errors land in the quickfix list.
function H.build_test(root, andThen)
    if not vim.g.dap_build_before_run then
        return andThen()
    end
    notify('Building unit tests in ' .. vim.fn.fnamemodify(root, ':t') .. ' ...')
    vim.system(
        { 'make', 'TARGET_MODE=coverage', 'build_unit_test' },
        { cwd = root, text = true },
        vim.schedule_wrap(function(result)
            if result.code ~= 0 then
                local output = (result.stdout or '') .. (result.stderr or '')
                vim.fn.setqflist({}, ' ', { title = 'Unit test build', lines = vim.split(output, '\n') })
                vim.cmd('copen')
                notify('Build failed -- see the quickfix list.', vim.log.levels.ERROR)
                return
            end
            andThen()
        end)
    )
end

-------------------------------------------------------------------------------
-- Adapter discovery
-------------------------------------------------------------------------------

-- Returns adapterName, command
function H.pick_adapter()
    local mason = vim.fn.stdpath('data') .. '/mason/bin/'

    if exists(mason .. 'codelldb') then
        return 'codelldb', mason .. 'codelldb'
    end

    for _, candidate in ipairs({
        vim.fn.exepath('lldb-dap'),
        mason .. 'lldb-dap',
        '/Library/Developer/CommandLineTools/usr/bin/lldb-dap',
        '/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap',
    }) do
        if exists(candidate) then
            return 'lldb', candidate
        end
    end

    if vim.fn.executable('gdb') == 1 then
        return 'gdb', vim.fn.exepath('gdb')
    end

    return nil, nil
end

-------------------------------------------------------------------------------
-- Launch configurations
-------------------------------------------------------------------------------

-- Debug test/coverage/unittest.prog with the given --gtest_filter.
function H.debug_tests(filter)
    local dap = require('dap')
    local root = H.component_root()
    local program = root .. '/test/coverage/unittest.prog'

    if H.breakpoint_count() == 0 then
        notify('No breakpoints set -- the tests will run to completion and exit.',
            vim.log.levels.WARN)
    end

    H.build_test(root, function()
        if not exists(program) then
            return notify('No test binary at ' .. program, vim.log.levels.ERROR)
        end
        dap.run({
            name = 'GTest: ' .. filter,
            type = H.adapter,
            request = 'launch',
            program = program,
            -- catch_exceptions=0 lets the debugger see a throw rather than
            -- having GoogleTest swallow it and report a failure.
            args = { '--gtest_filter=' .. filter, '--gtest_catch_exceptions=0', '--gtest_color=no' },
            cwd = root,
            env = H.format_env(H.adapter, H.environment(root)),
            stopOnEntry = false,
        })
    end)
end

function H.debug_test_under_cursor()
    local filter, macro_lnum = H.gtest_filter_under_cursor()
    if not filter then
        return notify('No TEST(...) found above the cursor.', vim.log.levels.WARN)
    end
    -- Without this the test runs to completion and the UI closes again
    -- immediately, which reads as the debugger failing to start.
    if vim.g.dap_auto_breakpoint and H.breakpoint_count() == 0 then
        local line = H.first_body_line(macro_lnum)
        require('dap.breakpoints').set({}, vim.api.nvim_get_current_buf(), line)
        notify('No breakpoints were set -- added one at line ' .. line .. ' of ' .. filter .. '.')
    end
    H.debug_tests(filter)
end

function H.debug_test_prompt()
    local default = H.gtest_filter_under_cursor() or '*'
    vim.ui.input({ prompt = 'gtest_filter: ', default = default }, function(filter)
        if filter and filter ~= '' then
            H.debug_tests(filter)
        end
    end)
end

-- Debug an application built in this component (debug/*.prog, release/*.prog).
function H.debug_app()
    local dap = require('dap')
    local root = H.component_root()

    local programs = {}
    for _, mode in ipairs({ 'debug', 'release' }) do
        for _, prog in ipairs(vim.fn.glob(root .. '/' .. mode .. '/*.prog', false, true)) do
            table.insert(programs, prog)
        end
    end
    -- Anything executable sitting directly in the component directory.
    for _, prog in ipairs(vim.fn.glob(root .. '/*.prog', false, true)) do
        table.insert(programs, prog)
    end

    if #programs == 0 then
        return notify('No *.prog found under ' .. root .. ' -- run `make` first.', vim.log.levels.WARN)
    end

    local function launch(program)
        if H.breakpoint_count() == 0 then
            notify('No breakpoints set -- the program will run to completion and exit.',
                vim.log.levels.WARN)
        end
        vim.ui.input({ prompt = 'Arguments: ' }, function(argstr)
            if argstr == nil then
                return
            end
            dap.run({
                name = vim.fn.fnamemodify(program, ':t'),
                type = H.adapter,
                request = 'launch',
                program = program,
                args = vim.split(vim.trim(argstr), '%s+', { trimempty = true }),
                cwd = root,
                env = H.format_env(H.adapter, H.environment(root)),
                stopOnEntry = false,
            })
        end)
    end

    if #programs == 1 then
        return launch(programs[1])
    end
    vim.ui.select(programs, {
        prompt = 'Debug which application?',
        format_item = function(item)
            return vim.fn.fnamemodify(item, ':.'):gsub('^' .. vim.pesc(root) .. '/', '')
        end,
    }, function(choice)
        if choice then
            launch(choice)
        end
    end)
end

function H.attach()
    local dap = require('dap')
    dap.run({
        name = 'Attach to process',
        type = H.adapter,
        request = 'attach',
        pid = require('dap.utils').pick_process,
        cwd = H.component_root(),
    })
end

-------------------------------------------------------------------------------
-- Plugin specification
-------------------------------------------------------------------------------

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio', -- required by nvim-dap-ui
        'theHamsta/nvim-dap-virtual-text', -- inline variable values
    },

    keys = {
        { '<leader>dt', function() H.debug_test_under_cursor() end, desc = 'Debug test under cursor' },
        { '<leader>dT', function() H.debug_test_prompt() end,       desc = 'Debug tests (gtest_filter)' },
        { '<leader>da', function() H.debug_app() end,               desc = 'Debug application' },
        { '<leader>dA', function() H.attach() end,                  desc = 'Attach to process' },

        { '<leader>dd', function() require('dap').continue() end,           desc = 'Start / continue' },
        { '<F5>',       function() require('dap').continue() end,           desc = 'Debug: start / continue' },
        { '<leader>db', function() require('dap').toggle_breakpoint() end,  desc = 'Toggle breakpoint' },
        { '<F9>',       function() require('dap').toggle_breakpoint() end,  desc = 'Debug: toggle breakpoint' },
        { '<leader>dn', function() require('dap').step_over() end,          desc = 'Step over' },
        { '<F10>',      function() require('dap').step_over() end,          desc = 'Debug: step over' },
        { '<leader>di', function() require('dap').step_into() end,          desc = 'Step into' },
        { '<F11>',      function() require('dap').step_into() end,          desc = 'Debug: step into' },
        { '<leader>do', function() require('dap').step_out() end,           desc = 'Step out' },
        { '<F12>',      function() require('dap').step_out() end,           desc = 'Debug: step out' },
        { '<leader>dC', function() require('dap').run_to_cursor() end,      desc = 'Run to cursor' },
        { '<leader>dl', function() require('dap').run_last() end,           desc = 'Re-run last session' },
        { '<leader>dr', function() require('dap').repl.toggle() end,        desc = 'Toggle REPL' },
        { '<leader>dx', function() require('dap').terminate() end,          desc = 'Terminate session' },

        {
            '<leader>dB',
            function()
                vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(cond)
                    if cond and cond ~= '' then
                        require('dap').set_breakpoint(cond)
                    end
                end)
            end,
            desc = 'Conditional breakpoint',
        },
        {
            '<leader>dp',
            function()
                vim.ui.input({ prompt = 'Log point message: ' }, function(msg)
                    if msg and msg ~= '' then
                        require('dap').set_breakpoint(nil, nil, msg)
                    end
                end)
            end,
            desc = 'Log point',
        },

        { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle debugger UI' },

        -- The 'watch' context is deliberate. lldb-dap answers a 'hover' request
        -- with a plain variable-path lookup only -- `stream.str()` fails there
        -- but evaluates correctly under 'watch'.
        {
            '<leader>dk',
            function() require('dapui').eval(nil, { context = 'watch' }) end,
            mode = { 'n', 'v' },
            desc = 'Evaluate under cursor / selection',
        },
        {
            '<leader>de',
            function()
                vim.ui.input({ prompt = 'Expression: ' }, function(expr)
                    if expr and expr ~= '' then
                        require('dapui').eval(expr, { context = 'watch', enter = true })
                    end
                end)
            end,
            desc = 'Evaluate expression',
        },
        {
            '<leader>dw',
            function()
                vim.ui.input({ prompt = 'Watch expression: ' }, function(expr)
                    if expr and expr ~= '' then
                        require('dapui').elements.watches.add(expr)
                    end
                end)
            end,
            desc = 'Add watch expression',
        },
    },

    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        ---------------------------------------------------------------------
        -- Adapter
        ---------------------------------------------------------------------
        local adapter, command = H.pick_adapter()
        if not adapter then
            return notify(
                'No debug adapter found.\n'
                    .. 'macOS: install the Xcode command line tools (`xcode-select --install`)\n'
                    .. '       or run `:MasonInstall codelldb`.\n'
                    .. 'Linux: install gdb 14+, or `:MasonInstall codelldb`.',
                vim.log.levels.ERROR
            )
        end
        H.adapter = adapter

        if adapter == 'codelldb' then
            dap.adapters.codelldb = {
                type = 'server',
                port = '${port}',
                executable = { command = command, args = { '--port', '${port}' } },
            }
        elseif adapter == 'lldb' then
            dap.adapters.lldb = { type = 'executable', command = command, name = 'lldb' }
        else
            dap.adapters.gdb = {
                type = 'executable',
                command = command,
                args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
            }
        end

        ---------------------------------------------------------------------
        -- Configurations offered by <leader>dd when nothing is running
        ---------------------------------------------------------------------
        local configurations = {
            {
                name = 'Unit tests: test under the cursor',
                type = adapter,
                request = 'launch',
                program = function()
                    return H.component_root() .. '/test/coverage/unittest.prog'
                end,
                args = function()
                    local filter = H.gtest_filter_under_cursor() or '*'
                    return { '--gtest_filter=' .. filter, '--gtest_catch_exceptions=0', '--gtest_color=no' }
                end,
                cwd = function() return H.component_root() end,
                env = function()
                    return H.format_env(adapter, H.environment(H.component_root()))
                end,
                stopOnEntry = false,
            },
            {
                name = 'Unit tests: all',
                type = adapter,
                request = 'launch',
                program = function()
                    return H.component_root() .. '/test/coverage/unittest.prog'
                end,
                args = { '--gtest_catch_exceptions=0', '--gtest_color=no' },
                cwd = function() return H.component_root() end,
                env = function()
                    return H.format_env(adapter, H.environment(H.component_root()))
                end,
                stopOnEntry = false,
            },
            {
                name = 'Application: pick an executable',
                type = adapter,
                request = 'launch',
                program = function()
                    local root = H.component_root()
                    return vim.fn.input('Executable: ', root .. '/debug/', 'file')
                end,
                args = function()
                    return vim.split(vim.trim(vim.fn.input('Arguments: ')), '%s+', { trimempty = true })
                end,
                cwd = function() return H.component_root() end,
                env = function()
                    return H.format_env(adapter, H.environment(H.component_root()))
                end,
                stopOnEntry = false,
            },
        }

        dap.configurations.cpp = configurations
        dap.configurations.c = configurations
        dap.configurations.objcpp = configurations

        ---------------------------------------------------------------------
        -- UI
        ---------------------------------------------------------------------
        dapui.setup({
            layouts = {
                {
                    position = 'left',
                    size = 45,
                    elements = {
                        { id = 'scopes',      size = 0.35 },
                        { id = 'watches',     size = 0.20 },
                        { id = 'breakpoints', size = 0.20 },
                        { id = 'stacks',      size = 0.25 },
                    },
                },
                {
                    position = 'bottom',
                    size = 12,
                    elements = {
                        { id = 'repl',    size = 0.5 },
                        { id = 'console', size = 0.5 },
                    },
                },
            },
        })

        require('nvim-dap-virtual-text').setup({ commented = true })

        -- Open the UI when a session starts, close it when it ends.
        dap.listeners.before.attach.dapui = function() dapui.open() end
        dap.listeners.before.launch.dapui = function() dapui.open() end
        dap.listeners.before.event_terminated.dapui = function() dapui.close() end
        dap.listeners.before.event_exited.dapui = function() dapui.close() end

        -- Closing the UI on exit is silent, so say what happened. Otherwise a
        -- run that stopped at nothing looks like a debugger that failed.
        dap.listeners.before.event_exited.report = function(_, body)
            local code = body and body.exitCode
            notify('Debug session ended' .. (code and (' -- exit code ' .. code) or '') .. '.')
        end

        ---------------------------------------------------------------------
        -- Signs
        ---------------------------------------------------------------------
        -- The text is spelled as UTF-8 byte escapes on purpose. A sign defined
        -- with empty text is accepted, and sign_place even returns an id, but
        -- the sign is never retained -- and nvim-dap reads its breakpoints back
        -- out of the sign list, so every breakpoint silently disappears and the
        -- debugger is sent none. Keeping these pure ASCII in the file makes that
        -- failure impossible to reintroduce by mangling the glyphs.
        local signs = {
            DapBreakpoint          = { text = '\226\151\143', texthl = 'DiagnosticError' },              -- U+25CF filled circle
            DapBreakpointCondition = { text = '\226\151\134', texthl = 'DiagnosticWarn' },               -- U+25C6 filled diamond
            DapLogPoint            = { text = '\226\151\136', texthl = 'DiagnosticInfo' },               -- U+25C8 diamond in diamond
            DapBreakpointRejected  = { text = '\226\151\139', texthl = 'DiagnosticHint' },               -- U+25CB hollow circle
            DapStopped             = { text = '\226\150\182', texthl = 'DiagnosticOk', linehl = 'Visual' }, -- U+25B6 right triangle
        }
        for name, opts in pairs(signs) do
            vim.fn.sign_define(name, opts)
            local defined = vim.fn.sign_getdefined(name)[1]
            if not defined or not defined.text or vim.trim(defined.text) == '' then
                vim.fn.sign_define(name, vim.tbl_extend('force', opts, { text = '>>' }))
                notify(name .. ' had no sign text; fell back to ASCII so breakpoints still register.',
                    vim.log.levels.WARN)
            end
        end

        ---------------------------------------------------------------------
        -- Commands
        ---------------------------------------------------------------------
        vim.api.nvim_create_user_command('DapBuildTest', function()
            local root = H.component_root()
            local saved = vim.g.dap_build_before_run
            vim.g.dap_build_before_run = true
            H.build_test(root, function() notify('Unit tests built.') end)
            vim.g.dap_build_before_run = saved
        end, { desc = 'Build the unit test binary' })

        vim.api.nvim_create_user_command('DapLogLevel', function(args)
            vim.g.dap_thor_log_level = args.args
            notify('THOR_LOG_LEVEL = ' .. args.args)
        end, {
            nargs = 1,
            complete = function()
                return { 'FATAL', 'ERROR', 'WARNING', 'INFO', 'DEBUG', 'ALL', '0' }
            end,
            desc = 'THOR_LOG_LEVEL for the next debug session',
        })

        notify('Debugger ready: ' .. adapter .. ' (' .. command .. ')')
    end,

    init = function()
        -- See vim.g.dap_resolve_symlinks above. Done in init() so it applies to
        -- files opened before the debugger is first used.
        if not vim.g.dap_resolve_symlinks then
            return
        end
        vim.api.nvim_create_autocmd('BufReadPost', {
            group = vim.api.nvim_create_augroup('dap-resolve-symlinks', { clear = true }),
            callback = function(event)
                local name = vim.api.nvim_buf_get_name(event.buf)
                if name == '' or vim.bo[event.buf].buftype ~= '' then
                    return
                end
                local real = vim.fn.resolve(name)
                -- Only rename when nothing else already owns the resolved name,
                -- otherwise :file raises E95.
                if real ~= '' and real ~= name and vim.fn.bufexists(real) == 0 then
                    vim.api.nvim_buf_set_name(event.buf, real)
                end
            end,
        })
    end,

    whichkey = function(wk)
        wk.add({
            { '<leader>d', group = 'Debug' },
        })
    end,
}
