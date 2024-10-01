# Vollo-Trees SDK

The Vollo-Trees SDK is designed for low latency streaming inference of decision tree
models on FPGA platforms.

> [!NOTE]
> This is the Vollo product for accelerating decision trees, the parent product 
> for accelerating neural networks can be found at https://github.com/MyrtleSoftware/vollo-sdk

## Installation

The latest SDK is available for download from <https://github.com/MyrtleSoftware/vollo-trees-sdk/releases>.

Download the `vollo-trees-sdk-<version>.run` self-extractable archive and execute it
to extract the Vollo Trees SDK [contents](#release-file-structure) to the current
directory:

```sh
chmod +x vollo-trees-sdk-<version>.run
./vollo-sdk-<version>.run
```

## User guide

The user guide is available online at <https://vollo-trees.myrtle.ai/>.

It is also included locally as markdown at [docs/mdbook/src](docs/mdbook/src) or in the release as html:

```bash
open docs/html/index.html
```

## Overview

The product architecture is shown in the diagram below:

![System Architecture](docs/mdbook/src/assets/system-architecture.svg)

Vollo Trees provides a C API to the user, running on the system host CPU.
Vollo Trees targets FPGAs to provide low latency inference.
The FPGA images (bitstreams) are prebuilt and included in the product.

Vollo Trees consists of the following elements:

- Vollo Accelerator Bitstream. Programming file for the FPGA on the PCIe
  accelerator card. See the [Accelerator
  Setup](https://vollo.myrtle.ai/latest/accelerator-setup.html) section for
  instructions on programming your FPGA with the bitstream.

- [Vollo Trees Compiler](https://vollo-trees.myrtle.ai/latest/vollo-trees-compiler.html).
  Compiles decision tree models defined in ONNX to Vollo programs.

- [Vollo Runtime](https://vollo-trees.myrtle.ai/latest/vollo-runtime.html). The
  runtime library for Vollo. It sets up the the Vollo Trees accelerator with a program and provides an asynchronous inference interface for handling input
  and output for the accelerated model.

## Vollo Trees Compiler

The Vollo Trees compiler is available to use without an accelerator card or license.
Along with compiling decision tree models for the Vollo Trees accelerator,
it also provides a method for estimating the performance of a model.

Refer to the [Vollo Trees Compiler](https://vollo-trees.myrtle.ai/latest/vollo-trees-compiler.html)
section in the user guide and its example walkthrough to get started with the
compiler.
