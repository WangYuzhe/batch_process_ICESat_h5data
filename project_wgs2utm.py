# Date: 2018-7-2
# Author: Wang Yuzhe
# Email: wangyuzhe@ucas.ac.cn

import arcpy
import os
import glob

shp_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'shp_sample')
in_dir = os.path.join(shp_dir, '*.shp')

out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'utm_sample')
if not os.path.exists(out_dir):
    os.makedirs(out_dir)

shpList = glob.glob(in_dir)

n = len(shpList)
for i in range(n):
    print i
    inFeature = shpList[i]
    outFeature = os.path.join(out_dir, shpList[i][-11:])
    arcpy.Project_management(inFeature, outFeature, 32647)
	
print "Finished!"