#!/usr/bin/python -u
#
# exec wrapper for lacs binary
#
import sys
import os
import subprocess

class Lacs( object ) :

#    LACSROOT = "/var/tmp/MATLAB/MATLAB_Compiler_Runtime"
#    LACS = "%s/LACS" % (LACSROOT,)
#    MCRROOT = "%s/v716" % (LACSROOT,)
    LACS = "/bmrb/linux/LACS/bin/LACS"
    MCRROOT = "/bmrb/linux/mcr_v716"
    MCRJRE = "%s/sys/java/jre/glnxa64/jre/lib/amd64" % (MCRROOT,)

    LACSENV = { "LD_LIBRARY_PATH" : ".:%s/runtime/glnxa64:%s/bin/glnxa64:%s/sys/os/glnxa64:%s/native_threads:%s/server:%s/client:%s"
                                    % (MCRROOT, MCRROOT, MCRROOT, MCRJRE, MCRJRE, MCRJRE, MCRJRE,) }

    _infile = None
    _out = None
    _verbose = False

    def __init__( self ) :
        if not os.path.exists( self.LACS ) :
            raise Exception( "LACS binary not found: %s" % (self.LACS,) )
        self._out = []

    def _get_verbose( self ) :
        """verbose flag"""
        return self._verbose
    def _set_verbose( self, flag ) :
        if (flag == True) or (flag == False) : self._verbose = flag
    verbose = property( _get_verbose, _set_verbose )

    def _get_in( self ) :
        """input filename"""
        return self._infile
    def _set_in( self, filename ) :
        if not os.path.exists( filename ) :
            raise Exception( "File not found: %s" % (filename,) )
        self._infile = filename
    infile = property( _get_in, _set_in )

    def _get_out( self ) :
        """lacs output"""
        return self._out
    result = property( _get_out )

    def run( self ) :
        cmd = [self.LACS, os.path.realpath( self._infile )]
        if self._verbose : print "Running ", cmd
        p = subprocess.Popen( cmd, env = self.LACSENV, stdout = subprocess.PIPE )
        p.wait()
        if p.returncode != 0 : 
            print cmd, "failed:", p.returncode
        self._out = p.stdout.readlines()

#
#
if __name__ == "__main__" :
    l = Lacs()
    l.infile = sys.argv[1]
    l.verbose = True
    l.run()
    for i in l.result : print i.strip()

