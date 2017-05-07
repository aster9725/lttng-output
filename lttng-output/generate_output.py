import os
import sys

# running bash command os.system()

def main(argv) :
    filenum = len(sys.argv)
    if filenum < 2:
        print "usage: ./generate_output.sh [output directory] [analyze tool list]"
        print "example:"
        print "        ./generate_output.sh test irqstats irqfreq"
        sys.exit()

    for x in sys.argv[1:] :
        command = "lttng-irqfreq " + x + "> /home2/sys11/lttng-git/mos_lttng_output/analized-output/" + x + ".irqfreq"
        os.system(command)
        print command

if __name__ == "__main__" :
    main(sys.argv[1:])
