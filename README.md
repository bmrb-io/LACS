# LACS

Liya Wang's (wangli@cshl.edu) code from 2012-11-30
with a few bits of python added.

Tested on matlab 2011b linux x86_64 (centos 5).

Initial version: 
  run in matlab:
```
>> LACS( 'test_in.txt', 'test_out.txt' );
```
  generates `test_out.txt` and `offset_test_out.txt`.

To build a "standalone" exe at NMRFAM:
```
/opt/MATLAB/R2011b/bin/mcc -m -W main -R '-nojvm,-nodisplay' -I /root/lacs_test/ -d /root/lacs_test/bin/ LACS 
```
 * 2m07_1_A.lacs_in    - input test data.
 * 2m07_1_A.lacs_out   - corresp. output plot

See scripts in the python subdirectory for examples of dealing with LACS input and output files.

## Input matrix
```
'%4.0f      %3.0f      %7.2f      %7.2f      %7.2f      %7.2f     %7.2f     %7.2f  %7.2f'
seq_No      resid      CA         CB         HA         C         H         N      pH
```
`CA`..`N` are CS values for corresp. atoms except for GLY "HA" is (HA2 + HA3)/2. 
Use `-100.0` for missing values.

`resid` is from the lookup table:
```
{ "ALA" : 1,
"CYS" : 2,
"ASP" : 3,
"GLU" : 4,
"PHE" : 5,
"GLY" : 6,
"HIS" : 7,
"ILE" : 8,
"LYS" : 9,
"LEU" : 10,
"MET" : 11,
"ASN" : 12,
"PRO" : 13,
"GLN" : 14,
"ARG" : 15,
"SER" : 16,
"THR" : 17,
"VAL" : 18,
"TRP" : 19,
"TYR" : 20,
"X" : 21 }
```

## Output

```
% lacs codes: 0: outlier, 1: normal, 2: endpoints for line 1, 3: endpoints for line 2
% seq label x_name y_name x_val y_val lacs_code
...
% offsets:
OFFATOMS:     CA    CB    HA     C     H     N
OFFVALUES:  0.25  0.25 -----  0.95 -0.06 -0.62
```

See `example.svg`: rows with `lacs codes` 2 and 3 are used to draw the cyan "midlines",
rows with code 1: to draw the "normal" values in blue, and code 0: the outlier in red. 
Sample drawing code is in `python/lacs2svg_pychart.py`
