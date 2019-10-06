# batch_process_ICESat_h5data
**Author: Wang Yuzhe**
These scripts are used to obtain the projected shapefiles from the original ICESat .H5 files in a batch process.

1. Run "get_campaign_table.m" in MATLAB. This will produce a .mat file;

2. Run "read_h5_write_csv.m" in MATLAB. This will read the information from .H5 data and save them as csv files;

3. Run "convert_csv2shp.py" in python editor provided by ArcGIS. This  will convert csv files to shape files geocoded in WGS84;

4. Run "project_wgs2utm.py" in python editor provided by ArcGIS. This will project the shape files using UTM coordinates.

Note:
* All processes are run in the current path.

* The projection coordinate can be specified according to your study region. In this example, UTM 47N is used.
