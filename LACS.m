function status = LACS(filename, out_name)
% LACS read chemical shift data in text format and give reference offsets for all backbone
% chemical shifts.
%
% Liya Wang, 11/30/3012

warning off

if nargin < 1
    status = 1;
    error( 'LACS:argChk', 'Input file not specified' );
end

if ~exist( filename, 'file' )
    status = 2;
    error( 'LACS:argChk', 'Input file not found' );
end

status = 0;

if nargin < 2
    out_name = 'stdout';
end

if nargin > 1
    fid = fopen(out_name, 'w');
    fprintf( fid, '%% lacs codes: 0: outlier, 1: normal, 2: endpoints for line 1, 3: endpoints for line 2\n' );
    fprintf( fid, '%% seq label x_name y_name x_val y_val lacs_code\n' );
    fclose( fid );
else
    fprintf( '%% lacs codes: 0: outlier, 1: normal, 2: endpoints for line 1, 3: endpoints for line 2\n' );
    fprintf( '%% seq label x_name y_name x_val y_val lacs_code\n' );
end

ca = ord(filename, 2, out_name);
cb = ord(filename, 3, out_name);
ha = ord(filename, 4, out_name);
co = ord(filename, 5, out_name);

hn = ordN(filename, 6, out_name);
n = ordN(filename, 7, out_name);

if nargin > 1
    fid = fopen( out_name, 'a' );
    fprintf( fid, '%% offsets:\nOFFATOMS:  %5s %5s %5s %5s %5s %5s\n','CA','CB','HA','C','H','N' );
    fprintf( fid, 'OFFVALUES: ' );
    if ca > -100, fprintf(fid, '%5.2f ', ca); else,  fprintf(fid, '----- '); end
    if cb > -100, fprintf(fid, '%5.2f ', cb); else,  fprintf(fid, '----- '); end
    if ha > -100, fprintf(fid, '%5.2f ', ha); else,  fprintf(fid, '----- '); end
    if co > -100, fprintf(fid, '%5.2f ', co); else,  fprintf(fid, '----- '); end
    if hn > -100, fprintf(fid, '%5.2f ', hn); else,  fprintf(fid, '----- '); end
    if n  > -100, fprintf(fid, '%5.2f ',  n); else,  fprintf(fid, '----- '); end
    fprintf( fid, '\n' );
    fclose( fid );
else 
    fprintf( '%% offsets:\nOFFATOMS:  %5s %5s %5s %5s %5s %5s\n','CA','CB','HA','C','H','N' );
    fprintf('OFFVALUES: ');
    if ca > -100, fprintf( '%5.2f ', ca); else,  fprintf( '----- '); end
    if cb > -100, fprintf( '%5.2f ', cb); else,  fprintf( '----- '); end
    if ha > -100, fprintf( '%5.2f ', ha); else,  fprintf( '----- '); end
    if co > -100, fprintf( '%5.2f ', co); else,  fprintf( '----- '); end
    if hn > -100, fprintf( '%5.2f ', hn); else,  fprintf( '----- '); end
    if n  > -100, fprintf( '%5.2f ',  n); else,  fprintf( '----- '); end
    fprintf( '\n' );
end

return;
