import sys
import re #Regular Expression

# file open func -open
# sting - slice

def main(argv) :
    filenum = len(sys.argv)
    list_filename = sys.argv

    print 'number of file ', filenum

    for x in list_filename[1:]:
        print 'make csv file for ', x
        makecsv(x)
        print 'outputfile : ', str(x.rsplit('.',1)[0]+".csv")

def makecsv(filename):
    file_in  = open(filename, "r")
    file_out = open(str(filename.rsplit('.',1)[0]+".csv"), "w+")
    pattern_irqfreq = re.compile(r'([0-9]*.[0-9]*)(\s+[#]*\s+)(\d)')
    for string in file_in:
        str_parse = pattern_irqfreq.search(string)
        if str_parse is not None:
            tmp = re.findall(r'<.*>',str_parse.string)
            if len(tmp) is 1:
                file_out.write(tmp[0]+'\n')
#                print tmp[0]
            else:
                tmp = re.sub(r'#',' ',str_parse.string)
                tmp = re.sub(r'\s+',',',tmp)
                if tmp[0] is ',':
                    tmp = tmp[1:]
                file_out.write(tmp+'\n')
#                print tmp

    file_in.close()
    file_out.close()

if __name__ == "__main__":
    main(sys.argv[1:])
