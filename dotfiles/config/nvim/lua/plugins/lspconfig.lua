return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        local lsp = require("lspconfig")

        local on_attach = function(client, bufnr)
            -- format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.opt_local.formatexpr = "v:lua.vim.lsp.formatexpr()"

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end

            if client.name == "svelte" then
                vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                    pattern = { "*.js", "*.ts" },
                    callback = function(ctx)
                        client:notify("$/onDidChangeTsOrJsFile", {
                            uri = ctx.match,
                        })
                    end
                })
            end
        end


        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.general = {
            positionEncodings = { "utf-16" }
        }

        lsp.pylsp.setup {
            capabilities = capabilities,
        }

        lsp.cssls.setup {
            capabilities = capabilities,
        }

        lsp.ts_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
        }

        --lsp.metals.setup {
        --    capabilities = capabilities,
        --    on_attach = on_attach,
        --}

        lsp.svelte.setup {
            capabilities = capabilities,
            on_attach = on_attach,
        }

        lsp.rust_analyzer.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        features = { "wickedinsecure" }
                    }
                }
            }
        }

        lsp.lua_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }

        local prettier = {
            formatCommand = 'prettierd "${INPUT}"',
            formatStdin = true,
        }

        lsp.efm.setup({
            init_options = { documentFormatting = true },
            rootMarkers = { '.git/' },
            settings = {
                languages = {
                    typescript = { prettier },
                    typescriptreact = { prettier },
                    javascript = { prettier },
                    javascriptreact = { prettier },
                    svelte = { prettier },
                    vue = { prettier },
                    markdown = { prettier },
                },
            },
            on_attach = on_attach,
            capabilities = capabilities
        })

        lsp.eslint.setup({
            on_attach = on_attach,
            capabilities = capabilities
        })

        --        lsp.harper_ls.setup {
        --            capabilities = capabilities,
        --            on_attach = on_attach,
        --            settings = {
        --                ["harper-ls"] = {
        --                    userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
        --                    linters = {
        --                        Malaysia = true,
        --                        CompoundNouns = true,
        --                        LongSentences = false,
        --                        Upward = true,
        --                        TerminatingConjunctions = true,
        --                        Likewise = true,
        --                        Anywhere = true,
        --                        Thereupon = true,
        --                        Worldwide = true,
        --                        Canada = true,
        --                        However = true,
        --                        Desktop = true,
        --                        Underclock = true,
        --                        Intact = true,
        --                        SpecialAttention = true,
        --                        Insofar = true,
        --                        BoringWords = false,
        --                        KindRegards = true,
        --                        WillContain = true,
        --                        Misunderstand = true,
        --                        ChangeTack = true,
        --                        UnclosedQuotes = true,
        --                        GoingTo = true,
        --                        ExpandTimeShorthands = true,
        --                        Instead = true,
        --                        AnA = true,
        --                        ThatThis = true,
        --                        Henceforth = true,
        --                        OutOfDate = true,
        --                        Spaces = true,
        --                        PluralConjugate = false,
        --                        DespiteOf = true,
        --                        OperativeSystems = true,
        --                        BanTogether = true,
        --                        Middleware = true,
        --                        EllipsisLength = true,
        --                        RepeatedWords = true,
        --                        JetpackNames = true,
        --                        Into = true,
        --                        Multithreading = true,
        --                        LeftRightHand = true,
        --                        Whereas = true,
        --                        AvoidCurses = false,
        --                        GotRidOff = true,
        --                        ByAccident = true,
        --                        FaceFirst = true,
        --                        Australia = true,
        --                        MicrosoftNames = true,
        --                        Somebody = true,
        --                        MutePoint = true,
        --                        PiqueInterest = true,
        --                        WasAloud = true,
        --                        Koreas = true,
        --                        Multimedia = true,
        --                        Whereupon = true,
        --                        Nonetheless = true,
        --                        ThoughtProcess = true,
        --                        ThenThan = true,
        --                        DotInitialisms = true,
        --                        Overclocking = true,
        --                        EnMasse = true,
        --                        InThe = true,
        --                        BadRap = true,
        --                        Misuse = true,
        --                        AppleNames = true,
        --                        NoOxfordComma = false,
        --                        GettingRidOff = true,
        --                        FastPaste = true,
        --                        UseGenitive = false,
        --                        NeedHelp = true,
        --                        IsKnownFor = true,
        --                        AndTheLike = true,
        --                        Widespread = true,
        --                        SentenceCapitalization = true,
        --                        AndIn = true,
        --                        Itself = true,
        --                        SoonerOrLater = true,
        --                        Matcher = true,
        --                        Myself = true,
        --                        LetsConfusion = true,
        --                        OceansAndSeas = true,
        --                        BeckAndCall = true,
        --                        EludedTo = true,
        --                        NotTo = true,
        --                        Anyhow = true,
        --                        BareInMind = true,
        --                        Furthermore = true,
        --                        HyphenateNumberDay = true,
        --                        Misused = true,
        --                        SneakingSuspicion = true,
        --                        Holidays = true,
        --                        ThatWhich = true,
        --                        FatalOutcome = true,
        --                        CorrectNumberSuffix = true,
        --                        Proofread = true,
        --                        Misunderstood = true,
        --                        AvoidAndAlso = true,
        --                        Overall = true,
        --                        Somehow = true,
        --                        MultipleSequentialPronouns = true,
        --                        MergeWords = true,
        --                        Everywhere = true,
        --                        Hereby = true,
        --                        ItCan = true,
        --                        ThatChallenged = true,
        --                        HumanLife = true,
        --                        DayOneNames = true,
        --                        IAm = true,
        --                        Notwithstanding = true,
        --                        MyHouse = true,
        --                        LetAlone = true,
        --                        HopHope = true,
        --                        WrongQuotes = false,
        --                        Backplane = true,
        --                        Somewhere = true,
        --                        LinkingVerbs = false,
        --                        SomewhatSomething = true,
        --                        SpellCheck = true,
        --                        WantBe = true,
        --                        PocketCastsNames = true,
        --                        PossessiveYour = true,
        --                        OxfordComma = true,
        --                        ChineseCommunistParty = true,
        --                        Upset = true,
        --                        GetRidOff = true,
        --                        Americas = true,
        --                        GoogleNames = true,
        --                        CondenseAllThe = true,
        --                        WaveFunction = true,
        --                        AmazonNames = true,
        --                        WordPressDotcom = true,
        --                        TurnItOff = true,
        --                        ChockFull = true,
        --                        UnitedOrganizations = true,
        --                        HadOf = true,
        --                        PronounContraction = true,
        --                        SupposedTo = true,
        --                        Postpone = true,
        --                        OfCourse = true,
        --                        TumblrNames = true,
        --                        CanBeSeen = true,
        --                        SpelledNumbers = false,
        --                        StateOfTheArt = true,
        --                        Multicore = true,
        --                        Regardless = true,
        --                        HungerPang = true,
        --                        NationalCapitals = true,
        --                        Devops = true,
        --                        SameAs = true,
        --                        PointIsMoot = true,
        --                        BeenThere = true,
        --                        AzureNames = true,
        --                        BackInTheDay = true,
        --                        Anybody = true,
        --                        CurrencyPlacement = true,
        --                        GetsRidOff = true,
        --                        Countries = true,
        --                        CapitalizePersonalPronouns = true,
        --                        Therefore = true,
        --                        NumberSuffixCapitalization = true,
        --                        Overnight = true,
        --                        Nobody = true,
        --                        Overload = true,
        --                        ModalOf = true,
        --                        BaitedBreath = true,
        --                        Laptop = true,
        --                        RoadMap = true,
        --                        OperativeSystem = true,
        --                        MetaNames = true,
        --                        BatedBreath = true,
        --                        Nothing = true,
        --                    }
        --                }
        --            },
        --        }
    end,
}
