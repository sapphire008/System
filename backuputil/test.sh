function array_find() {
    array=$1[@]
    seeking=$2
    a=("${!array}")
    val=-1

    for i in "${!a[@]}" ; do
        if [[ "${a[$i]}" == $seeking ]]; then
          val=$i
          break
        fi
    done
    echo $val
}


LIST=("Assignments" "Books" "EndNote" "PDF" "Pictures")

array_find LIST "Assignments"
