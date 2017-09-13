#!/bin/bash


declare -r GO_VERSION=${GO_VERSION:-1.8.3}
declare -r GO_URL="https://storage.googleapis.com/golang"
declare -r GO_TGZ="go${GO_VERSION}.linux-amd64.tar.gz"

declare -r GLIDE_VERSION=${GLIDE_VERSION:-0.12.3}
declare -r GLIDE_URL="https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}"
declare -r GLIDE_TGZ="glide-v${GLIDE_VERSION}-linux-amd64.tar.gz"


declare -r BUILD_DIR=${BUILD_DIR:-$PWD/.build}
declare -r BUILD_CACHE=${BUILD_CACHE:-$PWD/.cache}



_exit_error() { echo "ERROR: $*" 1>&2; exit 1; }
_log_info() { echo "INFO: $*"; }

_fetch_url() {
    if [[ ! -r ${BUILD_CACHE}/${2} ]]; then
        _log_info "downloading \"${1}/${2}\""
        curl --output ${BUILD_CACHE}/${2} --location --silent ${1}/${2}
    else
        _log_info "\"${2}\" found in ${BUILD_CACHE}"
    fi
}

build_env() {
    local _gp _gr

    _gp="${GOPATH:-$HOME/go}"
    _gr="${BUILD_DIR}/golang-${GO_VERSION}"
    echo "export GOPATH=${_gp}"
    echo "export GOROOT=${BUILD_DIR}/golang-${GO_VERSION}"
    echo "export PATH=${_gr}/bin:${_gp}/bin:$(ls -d ${BUILD_DIR}/*/bin 2>/dev/null | tr '\n' ':')${PATH}"
}


build_setup() {
    eval $(build_env)
    mkdir -p ${BUILD_CACHE} ${BUILD_DIR}

    rm -rf ${GOROOT}
    mkdir -p ${GOROOT}
    _fetch_url ${GO_URL} ${GO_TGZ}
    tar --directory ${GOROOT} --transform 's|^go/|./|' -xf ${BUILD_CACHE}/${GO_TGZ}

    rm -rf ${BUILD_DIR}/glide
    mkdir -p ${BUILD_DIR}/glide/bin
    _fetch_url ${GLIDE_URL} ${GLIDE_TGZ}
    tar --directory ${BUILD_DIR}/glide/bin --strip 1 -xf ${BUILD_CACHE}/${GLIDE_TGZ}

    go get github.com/golang/protobuf/protoc-gen-go
    go get github.com/jstemmer/go-junit-report
    go get github.com/AlekSi/gocoverutil
    go get github.com/mattn/goveralls
    go get github.com/jteeuwen/go-bindata/...
    go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
    go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
}

build_distclean() {

    rm -rf ${BUILD_CACHE} ${BUILD_DIR}
}


case "$1" in
   env)
       build_env;;
   setup)
       build_setup;;
   distclean)
       build_distclean;;
   *)
       echo "Incorrect option"

esac