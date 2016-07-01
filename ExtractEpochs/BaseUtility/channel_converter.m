function [ selectedIdx, selectedDist ] = channel_converter( fromMap, toMap )

fromLocs = zeros(length(fromMap), 3);
toLocs = zeros(length(toMap), 3);

selectedIdx = zeros(length(toMap), 1);
selectedDist = zeros(length(toMap), 1);

for idx = 1:length(fromMap)
    fromLocs(idx, 1) = fromMap(idx).X;
    fromLocs(idx, 2) = fromMap(idx).Y;
    fromLocs(idx, 3) = fromMap(idx).Z;
end
fromMap(1).sph_radius = sqrt(fromMap(1).X^2+fromMap(1).Y^2+fromMap(1).Z^2);
fromLocs = fromLocs*fromMap(1).sph_radius;
for idx = 1:length(toMap)
    toLocs(idx, 1) = toMap(idx).X;
    toLocs(idx, 2) = toMap(idx).Y;
    toLocs(idx, 3) = toMap(idx).Z;
end

% map based on the distance
for idx = 1:length(toMap)
    currLocs = toLocs(idx,:);
    copiedIdx = zeros(length(fromMap), 1);
    for idxFrom = 1:length(fromMap)
        prevLocs = fromLocs(idxFrom, :);
        tmpLocs = currLocs - prevLocs;
        copiedIdx(idxFrom) = tmpLocs * tmpLocs';
    end
    [selectedDist(idx), selectedIdx(idx)] = min(copiedIdx);
end

end

