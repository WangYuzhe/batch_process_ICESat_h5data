# Date: 2018-6-30
# Author: Wang Yuzhe
# Email: wangyuzhe@ucas.ac.cn

import arcpy
import csv
import os

# creat a directory "shp_sample" in current path
shp_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'shp_sample')
if not os.path.exists(shp_dir):
    os.makedirs(shp_dir)

# set the workspace for arcgis environment
arcpy.env.workspace = shp_dir

# set the csv path, list the csv files
csv_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'csv_sample')
dir_list = os.listdir(csv_dir)

n = len(dir_list)
for i in range(n):
    print i

    shpName = dir_list[i][0:7] + ".shp"
    # creat a feature class
    arcpy.CreateFeatureclass_management(arcpy.env.workspace, shpName, "Point", [], "Disabled", "Disabled", 4326)
	
	# add fields to feature class (note: length of the field name should not be greater than 9
    arcpy.AddField_management(shpName, "elev", field_type="FLOAT", field_precision=9, field_scale=4)
    arcpy.AddField_management(shpName, "rec_ndx", field_type="FLOAT", field_precision=0)
    arcpy.AddField_management(shpName, "shotCount", field_type="FLOAT", field_precision=0)
    arcpy.AddField_management(shpName, "satCorr", field_type="FLOAT", field_precision=9, field_scale=4)
    arcpy.AddField_management(shpName, "gdHt", field_type="FLOAT", field_precision=9, field_scale=4)
    arcpy.AddField_management(shpName, "dEllip", field_type="FLOAT", field_precision=9, field_scale=4)
    arcpy.AddField_management(shpName, "elev1", field_type="FLOAT", field_precision=9, field_scale=4)
    arcpy.AddField_management(shpName, "elev2", field_type="FLOAT", field_precision=9, field_scale=4)
    
    cursor = arcpy.da.InsertCursor(shpName, ["elev", "rec_ndx", "shotCount", "satCorr", "gdHt", "dEllip", "elev1", "elev2", "SHAPE@XY"])

	# open csv file
    csvFileName = os.path.join(csv_dir, dir_list[i])
    csvFile = open(csvFileName, "r")
    csvReader = csv.reader(csvFile)
	
    for row in csvReader:
        cursor.insertRow((float(row[2]), float(row[3]), float(row[4]), float(row[5]), float(row[6]), float(row[7]), float(row[8]), float(row[9]), (float(row[1]), float(row[0]))))
		
del cursor

print "Finished!"