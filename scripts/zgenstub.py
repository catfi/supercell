#!/usr/bin/python

import os,sys, subprocess
from zipfile import ZipFile
from tarfile import TarFile
from zxml   import ZxmlFile

TMP_WORK_DIR = "/tmp/"+os.getenv("USER")+"_tmp_1234/"
if not os.path.isdir( TMP_WORK_DIR):
    os.mkdir( TMP_WORK_DIR )

ZILLIANS_HOME = os.getenv("ZILLIANS_HOME")
if not ZILLIANS_HOME:
    ZILLIANS_HOME = "/opt/zillians"

ENABLED_APIS=[ 
#    os.getenv("ZILLIANS_HOME") + "/inc/ADTApi.zs",
    ZILLIANS_HOME+"/inc/DebugApi.zs" ,
    ZILLIANS_HOME+"/inc/EventApi.zs" ,
    ZILLIANS_HOME+"/inc/MathApi.zs" , 
    ZILLIANS_HOME+"/inc/SpaceApi.zs" ,
    ]

def main():
    from optparse import OptionParser
    usage = "zar [--zar (stdin)] [--stub (stdout)]"

    opt_parser = OptionParser(usage=usage)
    opt_parser.add_option('', '--zar', dest="zar", help="default read it in stdin", default="stdin" )
    opt_parser.add_option('', '--stub', dest="stub", help="default print it out in stdout", default="stdout" )

    (options, restArgs) = opt_parser.parse_args()

    if options.zar == "stdin":
        tt = open(TMP_WORK_DIR+"/"+"tmp_input.zip","w")
        tt . write( sys.stdin.read() )
        tt . close()
        options.zar = TMP_WORK_DIR+"/"+"tmp_input.zip"
        print options.zar
    print options.zar
    zar = ZipFile(options.zar, "r")
#    out = TarFile(options.stub, "w")
    
    compile_command = ZILLIANS_HOME+"/bin/zcc --client-stub "+str(TMP_WORK_DIR) + " "

    for zs_file in zar.namelist():
        if zs_file.endswith('.zs') or  zs_file.endswith('.zxml'):
#            compile_command += str(TMP_WORK_DIR)+"/"+str(zs_file)+ " "
            zar.extract( zs_file, TMP_WORK_DIR )


    def_zxml_file = ZxmlFile( str(TMP_WORK_DIR)+"/default.zxml" )
    for zs in def_zxml_file.zscript:
        compile_command += " "+str(TMP_WORK_DIR)+"/"+zs+" "

    compile_command += ZILLIANS_HOME+"/inc/DebugApi.zs "
    compile_command += ZILLIANS_HOME+"/inc/EventApi.zs "
    compile_command += ZILLIANS_HOME+"/inc/MathApi.zs "
    compile_command += ZILLIANS_HOME+"/inc/SpaceApi.zs " 
    
    subprocess.call(compile_command, shell=True) 

    os.chdir( TMP_WORK_DIR )
    tar_command = "cd "+ TMP_WORK_DIR+"&&"+"tar zcf "+options.stub+" "
    for root, dirs, files in os.walk( TMP_WORK_DIR ):
        for f in files:
            if f.endswith(".h") or f.endswith(".cpp") :
                print "compressing " +f 
                tar_command += f+" "
    #            out.write( root+"/"+f,f ) 
    print tar_command
    subprocess.call(tar_command, shell=True)

    #out.close()

if __name__ == "__main__":
    main()
