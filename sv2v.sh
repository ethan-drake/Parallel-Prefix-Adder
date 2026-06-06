    #!/bin/bash
    printf "Starting script\n\n"
    WORKAREA="/c/Users/eduar/Downloads/design/Parallel-Prefix-Adder"
    SRC_AREA="${WORKAREA}/src"

    OUTPUT_DIR="${WORKAREA}/convert_to_v/"

    FILES=""
    FILES="$FILES ${SRC_AREA}/ppa.sv"

    printf "Variables set\n\n"
    printf "WORKAREA: $WORKAREA \n"

    printf "OUTPUT_DIR: $OUTPUT_DIR \n"
    printf "SRC_AREA: $SRC_AREA \n"
    printf "FILES: $FILES \n"
    printf "\n\n"

    mkdir -p "$OUTPUT_DIR"

    ~/Downloads/sv2v-Windows/sv2v-Windows/sv2v.exe $FILES -w=$OUTPUT_DIR