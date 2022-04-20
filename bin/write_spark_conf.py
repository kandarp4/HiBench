
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


def main(conf):
    # load values from conf files
    filename = "conf/spark_default.conf"
    spark_conf = json.loads(conf[0])
    log("Parsing conf: %s" % filename)

    spark_default_conf = dict()
    with open(filename) as f:
        for line in f.readlines():
            line = line.strip()
            if not line:
                continue  # skip empty lines
            if line[0] == '#':
                continue  # skip comments
            try:
                key, value = re.split("\s", line, 1)
            except ValueError:
                key = line.strip()
                value = ""
            spark_default_conf[key] = value
    with open('conf/spark.conf', 'w') as file:
        for d_key, d_value in spark_default_conf.items():
            file.write(d_key+"\t"+str(d_value)+os.linesep)
        for key, value in spark_conf.items():
            if key == "spark.executor.instances":
                file.write("hibench.yarn.executor.num\t"+str(value)+os.linesep)
                file.write(key+"\t"+str(value)+os.linesep)
                continue
            elif key == "spark.executor.cores":
                file.write("hibench.yarn.executor.cores\t"+str(value)+os.linesep)
                file.write(key + "\t" + str(value) + os.linesep)
                continue
            file.write(key+"\t"+str(value)+os.linesep)


if __name__ == "__main__":
    main(sys.argv[1:])
