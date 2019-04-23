function substruct = get_specific_pcd_data(ind)

% get richt index in string format
index_string = string(ind-1);
if (ind < 11)
    index_string = "0"+index_string;
end

% get files
pcd = readPcd("./Data/data/00000000"+index_string+".pcd");
pcd_normals = readPcd("./Data/data/00000000"+index_string+"_normal.pcd");

% disregard 4th dimension
pcd = pcd(:, 1:3)';
pcd_normals = pcd_normals(:, 1:3)';

% filter out nan values
pcd(isnan(pcd)) = 0;
pcd_normals(isnan(pcd)) = 0;

% put ins truct
substruct = struct();
substruct.pcd = pcd;
substruct.normals = pcd_normals;

end