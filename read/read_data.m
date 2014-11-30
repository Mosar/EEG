function [raw_data, n] = read_data(source_file)
    [raw_data, n] = sload(['../2a_gdf/', source_file], 0, 'OWERFLOWDETECTION:OFF');
end