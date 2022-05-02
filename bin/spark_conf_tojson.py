
import json
import sys
import re
import os

def log(*s):
    if len(s) == 1:
        s = s[0]
    else:
        s = " ".join([str(x) for x in s])
    sys.stderr.write(str(s) + '\n')


def main(filename):
    log("conf_filename",filename)
    spark_conf = dict()
    with open(filename[0]) as f:
        for line in f.readlines():
            line = line.strip()
            if not line:
                continue  # skip empty lines
            try:
                key, value = re.split("\s", line, 1)
            except ValueError:
                key = line.strip()
                value = ""
            spark_conf[key] = value

    print(str(spark_conf).replace(" ", ""))

if __name__ == "__main__":
    main(sys.argv[1:])
    sys.exit(0)
