# Vollo RT Python Example

The Vollo RT Python bindings are provided for convenience, the runtime
performance of this API is not a priority.

<!-- markdown-link-check-disable -->

Here is a minimal way to use the [Vollo RT Python bindings](./api-reference/vollo_rt.html):

<!-- markdown-link-check-enable -->

```python
import vollo_rt
import torch
import os

with vollo_rt.VolloRTContext() as ctx:
    ctx.add_accelerator(0)

    if ctx.accelerator_num_cores(0) == 128:
        ctx.load_program(f"{os.environ['VOLLO_TREES_SDK']}/example/single-decision-u128.vollo")
    else:
        ctx.load_program(f"{os.environ['VOLLO_TREES_SDK']}/example/single-decision-u256.vollo")

    input = torch.rand(*ctx.model_input_shape())
    output = ctx.run(input)

    print(f"Output: {output}")
```
