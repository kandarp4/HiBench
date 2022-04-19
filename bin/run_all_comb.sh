readarray -t my_array < <(jq -c '.[]' conf/spark-sampled-conf.json)

# iterate through the Bash array
for item in "${my_array[@]}"; do
#  original_name=$(jq '.original_name' <<< "$item")
#  changed_name=$(jq '.changed_name' <<< "$item")

    # Utilize your variables
    python bin/write_spark_conf.py $item
    break
done