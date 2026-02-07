
-- https://github.com/Olical/conjure

return {
    'Olical/conjure',
    -- NOTE: 'lua' was removed to prevent conjure from loading on init.lua (saves ~10ms startup).
    -- Add back any languages you actively use with conjure.
    ft = { 'clojure', 'fennel', 'scheme', 'lisp', 'racket' },
}
