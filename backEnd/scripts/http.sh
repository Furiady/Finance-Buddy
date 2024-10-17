#!/bin/bash
project_dir="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" &> /dev/null && pwd )"

api_dir=$project_dir/api
server_cfg_base_dir=$project_dir/files/codegen
server_base_dir=$project_dir/internal/inbound/http

function generate() {
    openapi_file=$1
    domain=$2
    server_cfg_file=$3
    server_dir=$4

    echo "Generating server for ${openapi_file}.."
    mkdir -p $server_dir/$domain
    oapi-codegen \
        -config $server_cfg_file \
        -o $server_dir/$domain/openapi_server.gen.go \
        -package $domain \
        $openapi_file
}

for filename in $api_dir/*; do
    version=$(basename "$filename")

    # Generate golang code
    generate \
        $api_dir/$version/common.yaml \
        "common" \
        $server_cfg_base_dir/$version/server_common.cfg.yaml \
        $server_base_dir/$version

    for filename in $api_dir/$version/*.yaml; do
        filename_without_path=$(basename "$filename")
        domain="${filename_without_path%.*}"    

        if [[ $domain == "common" ]]; then
            continue
        fi

        generate \
            $filename \
            $domain \
            $server_cfg_base_dir/$version/server.cfg.yaml \
            $server_base_dir/$version
    done
done
