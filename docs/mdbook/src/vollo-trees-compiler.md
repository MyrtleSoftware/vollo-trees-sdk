# Vollo Compiler

The `vollo-trees-compiler` Python library can compile an ONNX `TreeEnsembleRegressor` model
to a Vollo program (`.vollo` file). It also provides functionality to estimate the performance of
the Vollo program.

The [Vollo Runtime](vollo-runtime.md) section describes how to run a Vollo
program on a Vollo accelerator.

## API Reference

This chapter walks through examples of how to use the Vollo compiler that
should cover the most commonly used parts of the API.

<!-- markdown-link-check-disable -->

A more complete API reference can be found [here](./api-reference).

<!-- markdown-link-check-enable -->

## Installation

Set up Vollo environment variables by [sourcing
`setup.sh`](accelerator-setup.md#environment-variable-setup) in `bash`.

Install the wheel file for the Vollo Trees compiler library. It's recommended that
you install this into a [virtual
environment](https://docs.python.org/3/library/venv.html).

Note: the packaged wheel only supports python 3.7 or greater

```sh
python3 -m venv vollo-venv
source vollo-venv/bin/activate
pip install --upgrade pip
pip install "$VOLLO_SDK"/python/*.whl
```
