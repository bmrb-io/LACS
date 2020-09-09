function A = AAtable(tri_A)
if length(tri_A) == 3
    switch tri_A
        case 'ALA',  A = 'A';   case 'CYS',  A = 'C';   case 'ASP',   A = 'D';
        case 'GLU',  A = 'E';   case 'PHE',  A = 'F';   case 'GLY',   A = 'G';
        case 'HIS',  A = 'H';   case 'ILE',  A = 'I';   case 'LYS',   A = 'K';
        case 'LEU',  A = 'L';   case 'MET',  A = 'M';   case 'ASN',   A = 'N';
        case 'PRO',  A = 'P';   case 'GLN',  A = 'Q';   case 'ARG',   A = 'R';
        case 'SER',  A = 'S';   case 'THR',  A = 'T';   case 'VAL',   A = 'V';
        case 'TRP',  A = 'W';   case 'TYR',  A = 'Y';   otherwise,    A = 'X';
    end
else
    switch tri_A
        case 'A',  A = 'ALA';   case 'C',  A = 'CYS';   case 'D',   A = 'ASP';
        case 'E',  A = 'GLU';   case 'F',  A = 'PHE';   case 'G',   A = 'GLY';
        case 'H',  A = 'HIS';   case 'I',  A = 'ILE';   case 'K',   A = 'LYS';
        case 'L',  A = 'LEU';   case 'M',  A = 'MET';   case 'N',   A = 'ASN';
        case 'P',  A = 'PRO';   case 'Q',  A = 'GLN';   case 'R',   A = 'ARG';
        case 'S',  A = 'SER';   case 'T',  A = 'THR';   case 'V',   A = 'VAL';
        case 'W',  A = 'TRP';   case 'Y',  A = 'TYR';   otherwise,    A = 'XXX';
    end
end