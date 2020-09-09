#!/usr/bin/python -u
#
# trying out pychart
#
import sys
import os
from pychart import *

_HERE = os.path.split( __file__ )[0]
sys.path.append( _HERE )
import lacs2db

_DIM = "CA"


def print_svg( outfile, curs, verbose = False ) :

    global _DIM

    dim = _DIM

    theme.default_font_size = 12
    theme.reinitialize()
    xaxis = axis.X()
    xaxis.label = "CA-CB"
    xaxis.tic_label_offset = (0, -10)
    xaxis.format = "%5.1f"
    yaxis = axis.Y()
    yaxis.label = dim
    yaxis.tic_label_offset = (-10, 0)
    yaxis.format = "%5.1f"

    sql = "select min(x_val),max(x_val),min(y_val),max(y_val) from plot where y_dim=?"
    curs.execute( sql, (dim,) )
    row = curs.fetchone()
    xf = (row[1] - row[0]) / 10
    yf = (row[3] - row[2]) / 10

    ar = area.T( size = (640,480), 
                 legend = None, 
                 x_axis = xaxis, 
                 y_axis = yaxis, 
                 x_range = (row[0] - xf,row[1] + xf,),
                 y_range = (row[2] - yf,row[3] + yf,)
    )

    lacs_line = line_style.T()
    lacs_line.color = color.cyan
    lacs_line.dash = None

    sql = "select x_val,y_val from plot where lacs_code=2 and y_dim=?"
    curs.execute( sql, (dim,) )
    endpoints1 = []
    while True :
        row = curs.fetchone()
        if row == None : break
        endpoints1.append( row )

    ar.add_plot( line_plot.T( label = None, data = endpoints1, line_style = lacs_line ) )

    endpoints2 = []
    sql = "select x_val,y_val from plot where lacs_code=3 and y_dim=?"
    curs.execute( sql, (dim,) )
    while True :
        row = curs.fetchone()
        if row == None : break
        endpoints2.append( row )

    ar.add_plot( line_plot.T( label = None, data = endpoints2, line_style = lacs_line ) )

    sql = "select off_val from offsets where y_dim=?"
    curs.execute( sql, (dim,) )
    row = curs.fetchone()

    offset_line = line_style.T()
    offset_line.color = color.red

    ar.add_plot( line_plot.T( label = None, data = [(endpoints1[0][0],row[0]),(endpoints2[1][0],row[0])], line_style = offset_line ) )

    outlier_tick = tick_mark.Circle( size = 5, fill_style = None, line_style = line_style.red )
#    tick_line = line_style.T()
#    tick_line.color = color.chocolate
#    normal_tick = tick_mark.Circle( size = 5, fill_style = None, line_style = tick_line )
    normal_tick = tick_mark.Circle( size = 5, fill_style = None, line_style = line_style.blue )

    sql = "select comp_index_id,comp_id,x_val,y_val,lacs_code from plot where y_dim=? and (lacs_code=0 or lacs_code=1)"
    curs.execute( sql, (dim,) )
    while True :
        row = curs.fetchone()
        if row == None : break
        label = "%s %s %%s" % (row[1],row[0])
        if row[4] == 0 :
            ar.add_plot( line_plot.T( data_label_format = str( label ), data = [(row[2],row[3])], line_style = None, tick_mark = outlier_tick ) )
#            ar.add_plot( line_plot.T( data = [(row[2],row[3])], line_style = None, tick_mark = outlier_tick ) )
        else :
            ar.add_plot( line_plot.T( data = [(row[2],row[3])], line_style = None, tick_mark = normal_tick ) )


    ca = canvas.init( outfile, "svg" )



#    pychart.theme.output_format = "svg"
#    pychart.theme.output_file = "zz.svg"
    ar.draw( ca )
    ca.close()

#
#
if __name__ == "__main__" :

    verbose = False

    conn = lacs2db.main( ":memory:", "zz", verbose = verbose )
    curs = conn.cursor()


    print_svg( sys.stdout, curs, verbose = verbose )

    curs.close()
    conn.close()

#    from optparse import OptionParser
#    usage = "usage: %prog [options]"
#    op = OptionParser( usage = usage )
#    op.add_option( "-v", "--verbose", action = "store_true", dest = "verbose",
#        default = False, help = "print lots of messages to stdout" )
#    op.add_option( "-c", "--config", action = "store", type = "string", dest = "propfile",
#        default = PROPFILE, help = "properties file" )
#    op.add_option( "-d", "--dbfile", action = "store", type = "string", dest = "dbfile",
#        default = DBFILE, help = "dictionary database file" )
#    (options, args) = op.parse_args()
