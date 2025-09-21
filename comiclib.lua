local Archiver = require("ffi/archiver")
local XmlObject = require("comicxml")

local ComicInfo = {}

function ComicInfo:new(archive_path)
    local arc = Archiver.Reader:new()

    local xml_content = nil

    if arc:open(archive_path) then
        for entry in arc:iterate() do
            if entry.mode == "file" and entry.path == "ComicInfo.xml" then
                xml_content = arc:extractToMemory(entry.index)

                break
            end
        end

        arc:close()
    end

    if not xml_content or #xml_content == 0 then
        return nil, false
    end

    local parser = XmlObject:new()
    local root = parser:parse(xml_content)
    local comic_metadata = parser:toTable(root)

    local o = {
        archive_path = archive_path,
        metadata = comic_metadata,
    }

    setmetatable(o, self)
    self.__index = self

    return o, true
end

return { ComicInfo = ComicInfo }
