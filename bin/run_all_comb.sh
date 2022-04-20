
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

        for framework in `cat $root_dir/conf/frameworks.lst`; do
        if [[ $framework == \#* ]]; then
            continue
        fi

        if [ $benchmark == "micro/dfsioe" ] && [ $framework == "spark" ]; then
            continue
        fi
        if [ $benchmark == "micro/repartition" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "websearch/nutchindexing" ] && [ $framework == "spark" ]; then
            continue
        fi
        if [ $benchmark == "graph/nweight" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "graph/pagerank" ] && [ $framework == "hadoop" ]; then
          continue
        fi
        if [ $benchmark == "ml/lr" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/als" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/svm" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/pca" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/gbt" ] && [ $framework == "hadoop" ]; then
             continue
        fi
        if [ $benchmark == "ml/rf" ] && [ $framework == "hadoop" ]; then
              continue
        fi
        if [ $benchmark == "ml/svd" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/linear" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/lda" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/gmm" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/correlation" ] && [ $framework == "hadoop" ]; then
            continue
        fi
        if [ $benchmark == "ml/summarizer" ] && [ $framework == "hadoop" ]; then
             continue
        fi

        echo -e "${UYellow}${BYellow}Run ${Yellow}${UYellow}${benchmark}/${framework}${Color_Off}"
        echo -e "${BCyan}Exec script: ${Cyan}$WORKLOAD/${framework}/run.sh${Color_Off}"
        $WORKLOAD/${framework}/run.sh

        result=$?
        if [ $result -ne 0 ]
        then
            echo -e "${On_IRed}ERROR: ${benchmark}/${framework} failed to run successfully.${Color_Off}"
                $result
        fi
        done
    done

    echo "Run all done!"
done