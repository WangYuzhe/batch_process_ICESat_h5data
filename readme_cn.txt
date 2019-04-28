0. 在matlab中运行get_campaign_table.m, 会生成并保存一个.mat文件.
1. 在matlab中运行read_h5_write_csv.m, 从.H5数据中读取有用信息, 并保存为csv文件.
2. 在ArcGIS自带的python中运行convert_csv2shp.py, 会将csv文件转化为shp文件, 这时ICESat点的地理坐标系统为WGS84.
3. 在ArcGIS自带的python中运行project_wgs2utm.py, 会将shp文件进行投影, 投影坐标为UTM.
4. 至此, 以上程序将.H5原始数据转化为具有投影坐标的shp数据.

注意:
* 所有的操作在当前路径下完成.
* 投影坐标系需要根据读者的研究区具体设定 (可google搜索), 例子中给出的是UTM 47N.
