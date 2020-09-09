#!/usr/bin/python -u
#
# reads lacs output into sqlite3 tables.
# because it's easier to massage (e.g. sort) them for output.
#
import sys
import os
import sqlite3

def create_tables( curs, verbose = False ) :
    sql = "create table plot(comp_index_id integer,comp_id text,x_dim text,y_dim text,x_val float,y_val float,lacs_code integer)"
    if verbose : print sql
    curs.execute( sql )
    sql = "create table offsets(y_dim text,off_val float)"
    if verbose : print sql
    curs.execute( sql )

def todb( curs, fin, verbose = False ) :
    offsets = []
    sql = "insert into plot (comp_index_id,comp_id,x_dim,y_dim,x_val,y_val,lacs_code) values (?,?,?,?,?,?,?)"
    for line in fin :
        if len( line.strip() ) < 1 : continue
        if line[0] == "%" : continue
        if verbose : print line

        if line[:8] == "OFFATOMS" :
            fields = line[9:].strip().split()
            for i in fields : offsets.append( [i, None] )
            if verbose : print offsets
            continue

        if line[:9] == "OFFVALUES" :
            fields = line[10:].strip().split()
            for i in range( len( fields ) ) : 
                if verbose : print "%d - %s" % (i, fields[i])
                offsets[i][1] = fields[i]

            if verbose : print offsets
            continue

        fields = line.strip().split()
        if verbose : print (sql.replace( "?", "%s" ) % tuple( fields )),
        curs.execute( sql, tuple( fields ) )
        if verbose : print ":", curs.rowcount

    sql = "update plot set y_dim='C' where y_dim='CO'"
    if verbose : print sql,
    curs.execute( sql )
    if verbose : print ":", curs.rowcount
    sql = "update plot set y_dim='N' where y_dim='NH'"
    if verbose : print sql,
    curs.execute( sql )
    if verbose : print ":", curs.rowcount
    sql = "update plot set y_dim='H' where y_dim='HN'"
    if verbose : print sql,
    curs.execute( sql )
    if verbose : print ":", curs.rowcount

    if len( offsets ) > 0 :
        sql = "insert into offsets(y_dim,off_val) values (?,?)"
        for i in offsets :
            if verbose : print (sql.replace( "?", "%s" ) % tuple( i )),
            curs.execute( sql, tuple( i ) )
            if verbose : print ":", curs.rowcount

    sql = "update offsets set y_dim='C' where y_dim='CO'"
    if verbose : print sql,
    curs.execute( sql )
    if verbose : print ":", curs.rowcount
    sql = "update offsets set y_dim='N' where y_dim='NH'"
    if verbose : print sql,
    curs.execute( sql )
    if verbose : print ":", curs.rowcount
    sql = "update offsets set y_dim='H' where y_dim='HN'"
    if verbose : print sql,
    curs.execute( sql )
    if verbose : print ":", curs.rowcount


def main( dsn, filename, verbose = False ) :

    if not os.path.exists( filename ) :
        raise Exception( "File not found: %s!" % (filename,) )

    conn = sqlite3.connect( dsn )

    try :
        curs = conn.cursor()
        create_tables( curs, verbose = verbose )
        fin = open( filename, "rb" )
        todb( curs, fin, verbose = verbose )
        fin.close()
        conn.commit()
        curs.close()
        return conn

    except :
        conn.rollback()
        raise

#
#
#
if __name__ == "__main__" :

    main( ":memory:", "zz", True )
