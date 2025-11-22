-- 1. Get client capabilities with nvim-cmp integration
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- 2. Configure the server using the native vim.lsp.config.setup() API
vim.lsp.config.setup({
    server = 'cssls', -- The language server name is passed as the 'server' option
    capabilities = capabilities
    -- Add other settings specific to cssls here, if needed
})
