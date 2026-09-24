# Benchmarks

This section provides benchmarks for the Vollo Trees accelerator for a variety of decision tree models.

Performance figures are given for a 576-unit configuration for the V80 accelerator card.
If you require a different configuration, please contact us at <vollo@myrtle.ai>.

All these performance numbers can be measured using the `vollo-trees-sdk` with the correct accelerator card
by running the provided [benchmark script](running-the-benchmark.md).

## V80: 576 units

| model                              |   num trees |   max depth |   input features | fully populated   |   mean latency (us) |   99th percentile latency (us) |
|:-----------------------------------|------------:|------------:|-----------------:|:------------------|--------------------:|-------------------------------:|
| single-decision-t1-d1-f32          |           1 |           1 |               32 | No                |                0.91 |                           0.92 |
| example-small-t256-d5-f64          |        256  |           5 |               64 | No                |                0.98 |                           1.00 |
| example-small-t256-d5-f64-full     |        256  |           5 |               64 | Yes               |                1.00 |                           1.01 |
| example-medium-t1024-d8-f128       |        1024 |           8 |              128 | No                |                1.09 |                           1.10 |
| example-medium-t1024-d8-f128-full  |        1024 |           8 |              128 | Yes               |                1.10 |                           1.20 |
| example-large-t4096-d10-f1024      |        4096 |          10 |             1024 | No                |                1.82 |                           1.84 |
