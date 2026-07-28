# Example

The Vollo Trees compiler expects an ONNX model with a `TreeEnsembleRegressor` node as input.

```python
!import numpy as np
import vollo_trees_compiler as vtc
from sklearn.ensemble import RandomForestRegressor
from skl2onnx.common.data_types import FloatTensorType
from skl2onnx import convert_sklearn

n_estimators = 256
max_depth = 8
n_features = 256
!n_samples = 2**max_depth
!X = np.random.rand(n_samples, n_features)
!y = np.random.rand(n_samples)

random_forest = RandomForestRegressor(
    n_estimators=n_estimators, max_depth=max_depth
)

# Fit some given data X, y
random_forest.fit(X, y)

# Convert the model to ONNX
initial_type = [("input", FloatTensorType([n_features]))]
onnx_model = convert_sklearn(
    random_forest,
    initial_types=initial_type,
    target_opset=12
)

with open("sklearn_model.onnx", "wb") as f:
  f.write(onnx_model.SerializeToString())
```

The first stage of compiling a model is to lower it to a `vollo_trees_compiler.Forest`.
This is the Vollo Trees compiler's intermediate representation for representing decision tree ensembles.

```python
import numpy as np
!import vollo_trees_compiler as vtc
!from sklearn.ensemble import RandomForestRegressor
!from skl2onnx.common.data_types import FloatTensorType
!from skl2onnx import convert_sklearn

!n_estimators = 256
!max_depth = 8
!n_features = 256
!n_samples = 2**max_depth
!X = np.random.rand(n_samples, n_features)
!y = np.random.rand(n_samples)
!
!random_forest = RandomForestRegressor(
!    n_estimators=n_estimators, max_depth=max_depth
!)
!
!# Fit some given data X, y
!random_forest.fit(X, y)
!
!# Convert the model to ONNX
!initial_type = [("input", FloatTensorType([1, n_features]))]
!onnx_model = convert_sklearn(
!    random_forest,
!    initial_types=initial_type,
!    target_opset=12
!)
!
!with open("example_model.onnx", "wb") as f:
!  f.write(onnx_model.SerializeToString())
!
!model_path = "example_model.onnx"
import vollo_trees_compiler as vtc

forest = vtc.Forest.from_onnx(model_path)
```

The `Forest` can be compiled to a Vollo program given a `vollo_trees_compiler.Config` accelerator configuration.

```python
config = vtc.Config.amd_v80_u256()
program_f32 = forest.to_program_f32(config)
```

Save the program to a file so that it can be used for inference by the [Vollo
runtime](vollo-runtime.md).

```python
program_f32.save('example.vollo')
```

## Simulation

The Vollo Trees compiler can be used to evaluate a program on a given input which can be used to

- Estimate the performance of a model. Optionally, a cycle count can be returned with the evaluation output.
- Verify the correctness of the compilation stages, including the effect of quantisation.

```python
program_f32 = forest.to_program_f32(config)
# Note that even though the ONNX model expects a multi-dimensional input,
# Program evaluation (and the vollo-runtime) expects a flattened input
input = np.random.rand(n_features)

out_value, est_cycle_count = program_f32.eval_with_cycle_estimate(input)

print(f"f32 Program output: {out_value}")
print(f"Estimated cycle count: {est_cycle_count}")
```

You can also obtain a pessimistic cycle estimate which assumes that the maximum depth branch is
taken in each tree.

```python
pessimistic_estimate = program_f32.pessimistic_cycle_estimate()
print(f"Pessimistic cycle estimate: {pessimistic_estimate}")
```

Note there will be some discrepancy between the estimated cycle count and the true
cycle count.
Also note that this estimate does not model the latency of the communication between
the host and the Vollo accelerator. The [`single-decision-t1-d1-f32` benchmark](benchmark.md) measures the
round-trip latency for the smallest possible program. This can be added to the cycle count estimate
(accounting for the FPGA clock rate of 400mhz) to give an estimate for the overall latency of the model.
