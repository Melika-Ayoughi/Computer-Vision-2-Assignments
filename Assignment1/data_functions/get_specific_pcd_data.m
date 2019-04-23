function substruct = get_specific_pcd_data(ind)

% get richt index in string format
index_string = string(ind-1);
if (ind < 11)
    index_string = "0"+index_string;
end

% get files
pcd = readPcd("./Data/data/data/00000000"+index_string+".pcd");
pcd_normals = readPcd("./Data/data/data/00000000"+index_string+"_normal.pcd");

% disregard 4th dimension
pcd = pcd(:, 1:3)';
pcd_normals = pcd_normals(:, 1:3)';

% filter out 3th dimension is larger than 1
indices = find(pcd(3, :)<1);
pcd = pcd(:, indices);
pcd_normals = pcd_normals(:, indices);

% filter out nan values
indices = find(sum(isnan(pcd_normals), 1)<1);
pcd = pcd(:, indices);
pcd_normals = pcd_normals(:, indices);

% put ins truct
substruct = struct();
substruct.pcd = pcd;
substruct.normals = pcd_normals;

end