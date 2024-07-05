if [ -d "$1" ]; then
    ABS_PATH=$(realpath "$1")
    export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:"$ABS_PATH"
    echo "$ABS_PATH added to CPLUS_INCLUDE_PATH"
else
    echo "Directory $1 does not exist"
fi
