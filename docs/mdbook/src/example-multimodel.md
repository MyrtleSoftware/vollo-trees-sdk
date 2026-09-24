# Multi-model Example

A Vollo program can contain more than one model. The accelerator holds all the
models of a program at the same time, and each inference selects a model by its
index. This lets one accelerator serve several models without a program reload.

This example compiles two scikit-learn models into one program. The models can
have different numbers of trees, depths and input features.

```python
import numpy as np
import vollo_trees_compiler as vtc
from sklearn.ensemble import RandomForestRegressor
from skl2onnx.common.data_types import FloatTensorType
from skl2onnx import convert_sklearn

def train_and_export(name, n_estimators, max_depth, n_features):
    X = np.random.rand(2**max_depth, n_features)
    y = np.random.rand(2**max_depth)
    random_forest = RandomForestRegressor(
        n_estimators=n_estimators, max_depth=max_depth
    )
    random_forest.fit(X, y)

    initial_type = [("input", FloatTensorType([1, n_features]))]
    onnx_model = convert_sklearn(
        random_forest,
        initial_types=initial_type,
        target_opset=12
    )
    with open(f"{name}.onnx", "wb") as f:
        f.write(onnx_model.SerializeToString())

train_and_export("model_a", n_estimators=128, max_depth=8, n_features=64)
train_and_export("model_b", n_estimators=256, max_depth=6, n_features=256)
```

Lower each ONNX model to a `vollo_trees_compiler.Forest`, as in the
[single-model example](example-compiler.md).

```python
forest_a = vtc.Forest.from_onnx("model_a.onnx")
forest_b = vtc.Forest.from_onnx("model_b.onnx")
```

All the models in one program must give their outputs in the same precision.
The precision of a model is set by the leaf type in its ONNX file (see
[Supported Models](supported-models.md)), and `Forest.output_precision`
reports it.

```python
assert forest_a.output_precision() == forest_b.output_precision()
```

Compile the list of forests into one program with
`vollo_trees_compiler.Forest.forests_to_program_f32`. The position of a forest
in the list is its model index in the program.

```python
config = vtc.Config.amd_v80_u256()
program = vtc.Forest.forests_to_program_f32([forest_a, forest_b], config)
program.save("multimodel.vollo")
```

## Simulation

Evaluation and cycle estimates take a `model_ix` argument, which defaults to
model `0`. The input must have the number of features of the selected model.

```python
input_a = np.random.rand(forest_a.num_input_features())
input_b = np.random.rand(forest_b.num_input_features())

print(f"Model 0 output: {program.eval(input_a, model_ix=0)}")
print(f"Model 1 output: {program.eval(input_b, model_ix=1)}")

print(f"Model 0 pessimistic cycle estimate: {program.pessimistic_cycle_estimate(model_ix=0)}")
print(f"Model 1 pessimistic cycle estimate: {program.pessimistic_cycle_estimate(model_ix=1)}")
```

The models in a program share the tree units of the accelerator. The cycle
estimate of a model in a multi-model program can therefore differ from the
estimate of the same model compiled on its own.

## Inference

The [Vollo runtime](vollo-runtime.md) loads a multi-model program in the same
way as a single-model program. The model index given to `vollo_rt_add_job`
selects the model to run. This snippet extends the [C example](vollo-rt-example.md)
to run one inference on model `1`:

```c
// The program holds both models
assert(vollo_rt_num_models(ctx) == 2);

// Model 1 is the second forest in the list given to the compiler
size_t model_index = 1;
assert(vollo_rt_model_input_num_elements(ctx, model_index, 0) == 256);

float input_tensor[256] = {0};
float output_tensor[1];

const void* inputs[1] = {input_tensor};
void* outputs[1] = {output_tensor};
const number_format input_formats[1] = {number_format_fp32};
const number_format output_formats[1] = {number_format_fp32};

EXIT_ON_ERROR(vollo_rt_add_job(
  ctx,
  model_index,
  0,  // user_ctx
  input_formats,
  (const void* const*)inputs,
  output_formats,
  (void* const*)outputs));

// Poll for completion as in the C example
```

Jobs for one model complete in order, but jobs for different models do not.
Use the `user_ctx` argument to tell the completions apart when several models
run at the same time.
