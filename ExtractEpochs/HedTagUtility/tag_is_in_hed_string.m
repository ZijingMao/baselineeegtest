function itExist = tag_is_in_hed_string(tag, hedString)

tag = strrep(lower(tag), '\', '/');
hedString = strrep(lower(hedString), '\', '/');
itExist = logical(strfind(tag, hedString));

end