# Vollo Runtime

The Vollo runtime provides a low latency asynchronous inference API for timing
critical inference requests on the Vollo accelerator.

A couple of example C programs that use the Vollo runtime API have been included in the
installation in the `example/` directory.

In order to use the Vollo runtime you need to have [an accelerator set up](./accelerator-setup.md):

- A programmed [Intel Agilex](./programming-the-agilex.md) or [AMD V80](./programming-the-v80.md) FPGA
- [A loaded kernel driver and an installed license](./licensing.md)
- Environment set up with `source setup.sh`

## Python API

The Vollo Trees SDK includes Python bindings for the Vollo runtime. These can be more
convenient than the C API for e.g. testing Vollo against PyTorch models.

For documentation, see:

<!-- markdown-link-check-disable -->
- [The Python bindings API](./api-reference/vollo_rt.html)
<!-- markdown-link-check-enable -->
- [A small example of using the Python bindings](./vollo-rt-python-example.md)
