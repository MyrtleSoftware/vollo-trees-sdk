# Benchmarks

This section provides benchmarks for the Vollo Trees accelerator for a variety of decision tree models.

Performance figures are given for a 256-unit configuration for the V80 accelerator card.
If you require a different configuration, please contact us at <vollo@myrtle.ai>.

All these performance numbers can be measured using the `vollo-trees-sdk` with the correct accelerator card
by running the provided [benchmark script](running-the-benchmark.md).

## V80: 256 units

### Raw buffer API

This is using buffers allocated with `vollo_rt_get_raw_buffer` which lets the runtime skip IO copy.

| model                              |   num trees |   max depth |   input features | fully populated   |   mean latency (us) |   99th percentile latency (us) |
|:-----------------------------------|------------:|------------:|-----------------:|:------------------|--------------------:|-------------------------------:|
| single-decision-t1-d1-f32          |           1 |           1 |               32 | No                |                0.87 |                           0.89 |
| example-small-t256-d5-f64          |        256  |           5 |               64 | No                |                1.00 |                           1.02 |
| example-small-t256-d5-f64-full     |        256  |           5 |               64 | Yes               |                1.00 |                           1.01 |
| example-medium-t1024-d8-f128       |        1024 |           8 |              128 | No                |                1.12 |                           1.13 |
| example-medium-t1024-d8-f128-full  |        1024 |           8 |              128 | Yes               |                1.12 |                           1.14 |
| example-large-t4096-d10-f1024      |        4096 |          10 |             1024 | No                |                1.82 |                           1.83 |

### User buffers

| model                              |   numtrees |   max depth |   input features | fully populated   |   mean latency (us) |   99th percentile latency (us) |
|:-----------------------------------|-----------:|------------:|-----------------:|:------------------|--------------------:|-------------------------------:|
| single-decision-t1-d1-f32          |          1 |           1 |               32 | No                |                0.88 |                           0.89 |
| example-small-t256-d5-f64          |        256 |           5 |               64 | No                |                1.00 |                           1.01 |
| example-small-t256-d5-f64-full     |        256 |           5 |               64 | Yes               |                1.00 |                           1.01 |
| example-medium-t1024-d8-f128       |       1024 |           8 |              128 | No                |                1.12 |                           1.13 |
| example-medium-t1024-d8-f128-full  |       1024 |           8 |              128 | Yes               |                1.12 |                           1.13 |
| example-large-t4096-d10-f1024      |       4096 |          10 |             1024 | No                |                1.83 |                           1.84 |
