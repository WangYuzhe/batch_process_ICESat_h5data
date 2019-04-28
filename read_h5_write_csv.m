% Date: 2018-6-25
% Author: Wang Yuzhe
% Email: wangyuzhe@ucas.ac.cn

% Note:
% ICESat uses the TOPEX/Poseidon ellipsoid

% d_lat:
% latitude

% d_lon:
% longitude

% d_elev:
% Surface elevation with respect to the ellipsoid at the spot location
% determined by the land specific range after instrument corrections,
% atmospheric delays and tides have been applied.
% The saturation elevation correction (d_satElevCorr) has not been
% applied and needs to be added to this elevation.

% i_rec_ndx:
% Unique index that relates this record to the corresponding record(s)
% in each GLAS data product

% i_shot_count:
% Identifies each laser shot within a record index. A combination of
% i_rec_ndx and i_shot_count can be used to uniquely identify each GLAS laser shot

% d_satElevCorr:
% Correction to elevation for saturated waveforms.
% This correction has NOT been applied to the data.
% To apply it, SUBTRACT the correction from the range estimate.
% To apply the correction to the elevations it must be ADDED to the elevation estimates.

% d_gdHt:
% The height of the geoid above the ellipsoid.
% EGM2008 geoid height above the reference ellipsoid.
% d_gdHt = h_EGM2008 - h_TP

% d_deltaEllip:
% Surface elevation (T/P ellipsoid) minus surface elevation (WGS84 ellipsoid).
% d_deltaEllip = h_TP - h_wgs84

% d_elev1:
% Surface elevation with respect to the WGS84 ellipsoid and the EGM2000
% geoid.

% d_elev2:
% Surface elevation corrected for saturated waveforms.
%--------------------------------------------------------------------------
clear, clc

% directory of h5 data
h5_indir = '.\h5_sample\';

% make a directory for csv files
mkdir('csv_sample');

h5_files = dir([h5_indir, '*.H5']);
n = length(h5_files);

load campaign_table.mat
unique_campaign = unique(campaign_table);

n1 = length(unique_campaign);
fields = {'d_lat', 'd_lon', 'd_elev', 'i_rec_ndx', 'i_shot_count', ...
    'd_satElevCorr', 'd_gdHt', 'd_deltaEllip', 'd_elev1', 'd_elev2'};

for i = 1:n1
    index1 = find(ismember(campaign_table, unique_campaign{i,1}));
    n2 = length(index1);
    
    varname = strcat('data_', unique_campaign{i,1});
    
    data_i = [];
    for j = 1:n2
        filename_j = fullfile(h5_indir, h5_files(index1(j)).name);
        
        % read the original data
        d_lat = h5read(filename_j, '/Data_40HZ/Geolocation/d_lat');
        d_lon = h5read(filename_j, '/Data_40HZ/Geolocation/d_lon');
        d_elev = h5read(filename_j, '/Data_40HZ/Elevation_Surfaces/d_elev');
        i_rec_ndx = h5read(filename_j, '/Data_40HZ/Time/i_rec_ndx');
        i_shot_count = h5read(filename_j, '/Data_40HZ/Time/i_shot_count');
        d_satElevCorr = h5read(filename_j, '/Data_40HZ/Elevation_Corrections/d_satElevCorr');
        d_gdHt = h5read(filename_j, '/Data_40HZ/Geophysical/d_gdHt');
        d_deltaEllip = h5read(filename_j, '/Data_40HZ/Geophysical/d_deltaEllip');
        
        ind1 = d_satElevCorr < 100;
        d_satElevCorr1 = d_satElevCorr.*ind1;
        
        % elevation above the geoid and in the WGS84 ellipsoid
        d_elev1 = d_elev - d_gdHt - d_deltaEllip;
        d_elev2 = d_elev - d_gdHt - d_deltaEllip + d_satElevCorr1;
        
        index2 = find(d_lat <= 90);
        
        data_temp = [d_lat(index2), d_lon(index2), d_elev(index2), double(i_rec_ndx(index2)),...
            double(i_shot_count(index2)), d_satElevCorr1(index2), d_gdHt(index2),...
            d_deltaEllip(index2), d_elev1(index2), d_elev2(index2)];
        
        data_i = [data_i; data_temp];
    end
    eval([varname ' = data_i' ';'])

    % export to csv file
    csv_outfile = fullfile('.\csv_sample', strcat(varname, '.csv'));    
    csvwrite(csv_outfile, data_i)
end
