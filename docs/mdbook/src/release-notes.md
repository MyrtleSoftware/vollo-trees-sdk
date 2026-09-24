# Release Notes

## 2.0.0

- Add support for multi-process and multi-threaded job starting and polling using vollo-rt
- Starting and polling jobs in vollo-rt is now faster
- Add support for programs containing multiple models
- Support for FP64 output (by compiling a .onnx model with FP64 leaves)
- Jobs might now be started upon calling `vollo_rt_add_job`, instead of being saved up for a call to `vollo_rt_poll`

## 1.0.0

- Add support for the AMD V80 and V80LL accelerator cards
- Include `ami_tool` and the AMI kernel driver for V80 boards
- Trees now use fp32 for inputs, branches and leaves
- Support for increased tree depth

## 0.1.0

- First release of decision tree accelerator
