#! /usr/bin/env bash
#
# Benchmark script of example Vollo models
set -e

info() {
  >&2 echo -e "\e[33m$1\e[0m"
}

if [ -z "$VOLLO_TREES_SDK" ]; then
  echo "VOLLO_TREES_SDK is not set - have you run 'source setup.sh'?"
  exit 1
fi

info "creating work directory"
mkdir -p work
cd work

if [ ! -d "vollo-venv" ]; then
  info "creating vollo-venv virtual environment"
  python3 -m venv vollo-venv
fi

info "activating vollo-venv virtual environment"
# Directory is created dynamically
# shellcheck disable=SC1091
source vollo-venv/bin/activate

info "installing Vollo Python libraries requirements"
pip3 install --upgrade pip
pip3 install "$VOLLO_TREES_SDK"/python/vollo_trees_compiler-*.whl

info "building example application"
mkdir -p example
cp "$VOLLO_TREES_SDK"/example/{example.c,npy.h,utils.h,Makefile} example/
chmod +w example
( cd example; make vollo-example)

info "Getting hardware config for vollo device"
"$VOLLO_TREES_SDK"/bin/vollo-tool read-hw-config | jq '.[0].hw_config' > hw_config.json

echo "------------------------------------------------------------------"
echo "-- COMPILING AND RUNNING BENCHMARK PROGRAMS ----------------------"
echo "------------------------------------------------------------------"
echo

cmd="example/vollo-example"

for m in "$VOLLO_TREES_SDK/example/onnx-models"/*; do
  info "Compiling program for $m"
  if python3 "$VOLLO_TREES_SDK"/example/compile.py "$m" -c hw_config.json --print-metrics;
  then
    model_name=$(basename "$m" .onnx)
    info "Program compiled for $model_name example, now running inference"
    $cmd "$model_name.vollo"
    echo
  else
    info "Failed to compile model $m, it is not currently supported on this hardware config"
    echo
  fi
done
