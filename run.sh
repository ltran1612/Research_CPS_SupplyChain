#! /bin/sh

ASP_UPDATE_FOLDER=/Users/longtran/Personal/CPS/Research_CPS_SupplyChain/src/asklab/querypicker/QUERIES/TEST
BASE=/Users/longtran/Personal/CPS/Research_CPS_SupplyChain
cd $ASP_UPDATE_FOLDER
sh generate.sh
cd $BASE
ant build
ant QueryPicker
