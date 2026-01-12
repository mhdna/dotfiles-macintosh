return {
  --- A common error handler for lua functions.
  --- @param error string An error message
  handler = function(error)
    print("An error occurred:", error:gsub("\t", "    "))
  end,
}
