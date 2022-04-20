
set -u

current_dir=`dirname "$0"`
root_dir=`cd "${current_dir}/.."; pwd`

. ${root_dir}/bin/functions/color.sh

readarray -t my_array < <(jq -c '.[]' conf/spark-sampled-conf.json)

# iterate through the Bash array
for item in "${my_array[@]}"; do
#  original_name=$(jq '.original_name' <<< "$item")
#  changed_name=$(jq '.changed_name' <<< "$item")

    # Utilize your variables
    python bin/write_spark_conf.py $item



    for benchmark in `cat $root_dir/conf/benchmarks.lst`; do
        if [[ $benchmark == \#* ]]; then
            continue
        fi

        echo -e "${UYellow}${BYellow}Prepare ${Yellow}${UYellow}${benchmark} ${BYellow}...${Color_Off}"
        benchmark="${benchmark/.//}"

        WORKLOAD=$root_dir/bin/workloads/${benchmark}
#        echo -e "${BCyan}Exec script: ${Cyan}${WORKLOAD}/prepare/prepare.sh${Color_Off}"
#        "${WORKLOAD}/prepare/prepare.sh"

        result=$?
        if [ $result -ne 0 ]
        then
        echo "ERROR: ${benchmark} prepare failed!"
            exit $result
        fi
        
        echo -e "${UYellow}${BYellow}Run ${Yellow}${UYellow}${benchmark}/spark${Color_Off}"
        echo -e "${BCyan}Exec script: ${Cyan}$WORKLOAD/spark/run.sh${Color_Off}"
        $WORKLOAD/spark/run.sh

        result=$?
        if [ $result -ne 0 ]
        then
            echo -e "${On_IRed}ERROR: ${benchmark}/spark failed to run successfully.${Color_Off}"
                $result
        fi
    done

    echo "Run all done!"
done