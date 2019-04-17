# Filter normal point cloud from nan's and background noise
def filter_pc_normal(pc):
    filtered_pc = []
    filtered_indices = []
 
    for c, i in enumerate(pc):
        if np.isnan(i[0]) or np.isnan(i[1]) or np.isnan(i[2]) or i[2] >= 1:
            filtered_indices.append(c)
            continue
        filtered_pc.append(i[0:3])
 
    return filtered_pc, filtered_indices
 
# Filter point cloud from nan's, background noise and filtered indices from the normal file
def filter_pc(pc, filtered_indices):
    filtered_pc = []
    for c, i in enumerate(pc):
        if np.isnan(i[0]) or np.isnan(i[1]) or np.isnan(i[2]) or i[2] >= 1 or c in filtered_indices:
            filtered_indices.append(c)
            continue
        filtered_pc.append(i)
    return filtered_pc
