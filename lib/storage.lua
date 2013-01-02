local P = {}
storage = P

local type = type
local string = string
local error = error
local loadstring = loadstring

setfenv(1, P)

function serialize(fh, o)
  if type(o) == "number" then
    fh.write(o)
  elseif type(o) == "nil" or type(o) == "boolean" then
    fh.write(tostring(o))
  elseif type(o) == "string" then
    fh.write(string.format("%q", o))
  elseif type(o) == "table" then
    fh.write("{\n")
    for k,v in pairs(o) do
      fh.write("  ", k, " = ")
      serialize(v)
      fh.write(",\n")
    end
    fh.write("}\n")
  else
    error("cannot serialize a " .. type(o))
  end
end

function deserialize(s)
  return loadstring("return " .. s)()
end
