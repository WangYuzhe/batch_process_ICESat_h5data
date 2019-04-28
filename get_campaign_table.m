% Date: 2018-6-25
% Author: Wang Yuzhe
% Email: wangyuzhe@ucas.ac.cn

clear, clc

indir = '.\h5_sample\';
files = dir([indir, '*.H5']);
n = length(files);

campaign_table = cell(n, 1);
for i = 1:n
    filename = files(i).name;
    
    full_filename = fullfile(indir, filename);
    info_ancillary = h5info(full_filename, '/ANCILLARY_DATA');
    campaign_table{i} = info_ancillary.Attributes(1).Value;
end

save campaign_table campaign_table