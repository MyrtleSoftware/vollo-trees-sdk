# Benchmarks

This section provides benchmarks for the Vollo Trees accelerator for a variety decision tree models.

Performance figures are given for two configurations of the Vollo accelerator.
A 256-unit configuration which is provided for the IA-840F accelerator card
and a 128-unit configuration which is provided for the IA-420F accelerator card.
If you require a different configuration, please contact us at <vollo@myrtle.ai>.

All these performance numbers can be measured using the `vollo-trees-sdk` with the correct accelerator card
by running the provided [benchmark script](running-the-benchmark.md).

## IA-840F: 256 units

### Raw buffer API

This is using buffers allocated with `vollo_rt_get_raw_buffer` which lets the runtime skip IO copy.

| model                       |   num trees |   max depth |   input features | fully populated   |   mean latency (us) |   99th percentile latency (us) |
|:----------------------------|------------:|------------:|-----------------:|:------------------|--------------------:|-------------------------------:|
| single-decision-t1-d1-f32   |           1 |           1 |               32 | No                |                 1.7 |                            1.9 |
| example-t1000-d5-f128       |        1000 |           5 |              128 | No                |                 1.9 |                            2.0 |
| example-t1000-d5-f128-full  |        1000 |           5 |              128 | Yes               |                 1.8 |                            2.0 |
| example-t1000-d8-f128       |        1000 |           8 |              128 | No                |                 1.9 |                            2.1 |
| example-t1000-d8-f128-full  |        1000 |           8 |              128 | Yes               |                 1.9 |                            2.1 |
| example-t512-d8-f512        |         512 |           8 |              512 | No                |                 1.9 |                            2.1 |
| example-t1024-d8-f1024      |        1024 |           8 |             1024 | No                |                 2.0 |                            2.2 |
| example-t4096-d8-f1024-full |        4096 |           8 |             1024 | Yes               |                 2.2 |                            2.3 |

### User buffers

| model                       |   numtrees |   max depth |   input features | fully populated   |   mean latency (us) |   99th percentile latency (us) |
|:----------------------------|-----------:|------------:|-----------------:|:------------------|--------------------:|-------------------------------:|
| single-decision-t1-d1-f32   |          1 |           1 |               32 | No                |                 1.8 |                            2.0 |
| example-t1000-d5-f128       |       1000 |           5 |              128 | No                |                 1.9 |                            2.1 |
| example-t1000-d5-f128-full  |       1000 |           5 |              128 | Yes               |                 1.9 |                            2.1 |
| example-t1000-d8-f128       |       1000 |           8 |              128 | No                |                 2.0 |                            2.2 |
| example-t1000-d8-f128-full  |       1000 |           8 |              128 | Yes               |                 2.0 |                            2.1 |
| example-t512-d8-f512        |        512 |           8 |              512 | No                |                 2.1 |                            2.3 |
| example-t1024-d8-f1024      |       1024 |           8 |             1024 | No                |                 2.3 |                            2.5 |
| example-t4096-d8-f1024-full |       4096 |           8 |             1024 | Yes               |                 2.5 |                            2.7 |

<!-- markdownlint-disable MD024 -->
## IA-420F

### Raw buffer API

| model                       |   num trees |   max depth |   input features | fully populated   |   mean latency (us) |   99th percentile latency (us) |
|:----------------------------|------------:|------------:|-----------------:|:------------------|--------------------:|-------------------------------:|
| single-decision-t1-d1-f32   |           1 |           1 |               32 | No                |                 1.7 |                            1.9 |
| example-t1000-d5-f128       |        1000 |           5 |              128 | No                |                 1.9 |                            2.1 |
| example-t1000-d5-f128-full  |        1000 |           5 |              128 | Yes               |                 1.9 |                            2.1 |
| example-t1000-d8-f128       |        1000 |           8 |              128 | No                |                 1.9 |                            2.1 |
| example-t1000-d8-f128-full  |        1000 |           8 |              128 | Yes               |                 1.9 |                            2.1 |
| example-t512-d8-f512        |         512 |           8 |              512 | No                |                 1.9 |                            2.1 |
| example-t1024-d8-f1024      |        1024 |           8 |             1024 | No                |                 2.0 |                            2.2 |
| example-t4096-d8-f1024-full |        4096 |           8 |             1024 | Yes               |                 2.5 |                            2.6 |

### User buffers

| model                       |   numtrees |   max depth |   input features | fully populated   |   mean latency (us) |   99th percentile latency (us) |
|:----------------------------|-----------:|------------:|-----------------:|:------------------|--------------------:|-------------------------------:|
| single-decision-t1-d1-f32   |          1 |           1 |               32 | No                |                 1.8 |                            1.9 |
| example-t1000-d5-f128       |       1000 |           5 |              128 | No                |                 2.0 |                            2.2 |
| example-t1000-d5-f128-full  |       1000 |           5 |              128 | Yes               |                 2.0 |                            2.1 |
| example-t1000-d8-f128       |       1000 |           8 |              128 | No                |                 2.1 |                            2.2 |
| example-t1000-d8-f128-full  |       1000 |           8 |              128 | Yes               |                 2.0 |                            2.2 |
| example-t512-d8-f512        |        512 |           8 |              512 | No                |                 2.1 |                            2.3 |
| example-t1024-d8-f1024      |       1024 |           8 |             1024 | No                |                 2.3 |                            2.5 |
| example-t4096-d8-f1024-full |       4096 |           8 |             1024 | Yes               |                 2.8 |                            3.0 |

<!-- markdownlint-enable MD024 -->
