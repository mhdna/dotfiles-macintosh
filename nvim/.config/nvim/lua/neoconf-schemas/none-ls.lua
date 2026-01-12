local checkstyle_default_config = "/google_checks.xml"

local pmd_default_dir = "$ROOT"
local pmd_default_rulesets = "category/java/bestpractices.xml"

return {
  defaults = {
    --- Java specific options
    java = {
      --- Checkstyle options
      checkstyle = {
        --- Whether to use file or project wide linting
        file = false,
        --- The file name for the config file XML
        config = checkstyle_default_config,
        --- @type string | nil Additional options for checkstyle
        options = nil,
      },
      --- PMD options
      pmd = {
        --- The run directory for PMD
        dir = pmd_default_dir,
        --- The rulesets for PMD, comma-separated
        rulesets = pmd_default_rulesets,
        --- @type string | nil The cache file path, if used
        cache = nil,
      },
    },
  },
  schema = {
    java = {
      type = "object",
      description = "Java specific options",
      additionalProperties = false,
      properties = {
        checkstyle = {
          type = "object",
          description = "Checkstyle options",
          additionalProperties = false,
          properties = {
            file = {
              type = "boolean",
              description = "Whether to use file or project wide linting",
              default = false,
            },
            config = {
              type = { "string" },
              description = "The file name for the config file XML",
              default = checkstyle_default_config,
            },
            options = {
              type = { "string", "null" },
              description = "Additional options for checkstyle",
            },
          },
        },
        pmd = {
          type = "object",
          description = "PMD options",
          additionalProperties = false,
          properties = {
            dir = {
              type = { "string" },
              description = "The run directory for PMD",
              default = pmd_default_dir,
            },
            rulesets = {
              type = { "string" },
              description = "The rulesets for PMD",
              default = pmd_default_rulesets,
            },
            cache = {
              type = { "string", "null" },
              description = "The cache file path, if used",
            },
          },
        },
      },
    },
  },
}
