local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('php', {
  s('p=', {
    t '<?= ',
    i(1),
    t '?>',
  }),
  s('php=', {
    t { '<?php', '' },
    t { '' },
    i(1),
    t { '', '?>' },
  }),
  s('phpeach=', {
    t { '<?php foreach (' },
    i(1),
    t { ') { ?>', '' },
    t { '<?php } ?>' },
  }),
  s('phpif=', {
    t { '<?php if (' },
    i(1),
    t { ') { ?>', '' },
    t { '<?php } ?>' },
  }),
})
