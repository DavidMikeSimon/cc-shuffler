local function printUsage()
	print("Usage:")
	print("gcpull <project>")
end

local function fetch_url(url)
  local response = http.get(url)
  if response then
    local sResponse = response.readAll()
    response.close()
    return sResponse
  else
    error("Failed to retrieve " .. url)
  end	
end

local function download_project(project)
  -- Get the root listing
  local root_url = "http://" .. project .. ".googlecode.com/git/"
  print("Retrieving project files from " .. root_url)
  local root_listing = fetch_url(root_url)

  -- Create the project dir, deleting any old one
  if fs.exists(project) then
    fs.delete(project)
  end
  fs.makeDir(project)

  -- Recurse down and retrieve all the files and directories
  pull_listing(root_listing, project .. "/", root_url)
  
  print("Done.")
end

function pull_listing(content, local_path, remote_path)
  for url in content:gmatch("<li><a href=\"(.-)\">") do
    if url ~= "../" then
      full_url = remote_path .. url
      full_local = local_path .. url
      print("Downloading " .. full_local)
      s = fetch_url(full_url)
      if url:match("/$") then
        fs.makeDir(full_local)
        pull_listing(s, full_local, full_url)
      else
        fh = fs.open(full_local, "w")
        fh.write(s)
        fh.close()
      end
    end
  end
end

------
--- EXECUTION BEGINS HERE
------

local tArgs = {...}
if #tArgs ~= 1 then
	printUsage()
  return
end
if not http then
	print("gcpull requires http API")
	print("Set enableAPI_http to 1 in mod_ComputerCraft.cfg")
	return
end
download_project(tArgs[1])
