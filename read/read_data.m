function [raw_data, n] = read_data(source_file)

    %[raw_data, n] = sload('../2a_gdf/A03T.GDF', 0, 'OWERFLOWDETECTION:OFF');
    [raw_data, n] = sload(['../2a_gdf/', source_file], 0, 'OWERFLOWDETECTION:OFF');
    
    %dlmwrite('./data/temp/tmp.txt', raw_data, ',');
    %raw_data = dlmread(source_file, ',');
end