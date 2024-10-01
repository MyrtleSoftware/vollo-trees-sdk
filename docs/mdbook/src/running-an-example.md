# Running an example

The Vollo Trees SDK contains a trivial program for each accelerator to check if the accelerator is working.

1. Ensure you have run the setup steps:

   ```sh
   cd <vollo-sdk>
   sudo ./load_kernel_driver.sh
   source setup.sh
   export MYRTLE_LICENSE=<your-license-file>
   ```

2. Compile the C runtime example:

   ```sh
   (cd example; make)
   ```

3. Run the example.

   For a block-size 64 accelerator such as `vollo-ia840f-u256.jic`:

   ```sh
   ./example/vollo-example example/single-decision-u256.vollo
   ```

   For a block-size 32 accelerator such as `vollo-ia420f-u128d8192.jic`:

   ```sh
   ./example/vollo-example example/single-decision-u128.vollo
   ```

   You should see an output similar to the following:

   ```sh
   Using program: "example/single-decision-u256.vollo"
   Using vollo-rt version: 20.0.0
   Using Vollo accelerator with 256 tree unit(s)
   Program metadata for model 0:
      1 input with shape: [32]
      1 output with shape: [1]
   Starting 10000 inferences
   Ran 10000 inferences in 0.018070 s with:
      mean latency of 1.790225 us
      99% latency of 1.942000 us
      throughput of 553402.910468 inf/s
   Done
   ```
