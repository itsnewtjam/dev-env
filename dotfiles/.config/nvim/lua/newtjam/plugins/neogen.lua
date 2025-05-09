return {
  "danymat/neogen",
  config = function()
    require("neogen").setup({
      languages = {
        php = {
          parent = {
            type = { "assignment_expression", "property_declaration", "const_declaration", "foreach_statement" },
          },
          data = {
            type = {
              ["assignment_expression|property_declaration|const_declaration|foreach_statement"] = {
                ["0"] = {
                  extract = function(node)
                    local extractors = require("neogen.utilities.extractors")
                    local nodes_utils = require("neogen.utilities.nodes")
                    local i = require("neogen.types.template").item
                    local tree = {
                        { node_type = "property_element", retrieve = "all", extract = true, as = i.Type },
                    }
                    local nodes = nodes_utils:matching_nodes_from(node, tree)
                    local res = extractors:extract_from_matched(nodes)
                    return res
                  end
                }
              }
            }
          },
        }
      }
    })
  end,
  keys = {
    {"<leader>ng", function() require("neogen").generate() end, desc = "neogen"},
  }
}
