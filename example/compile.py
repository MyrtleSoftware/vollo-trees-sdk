import vollo_trees_compiler as vtc
from pathlib import Path
import argparse


def cli():
    parser = argparse.ArgumentParser(
        prog=__name__,
        description="Compile a .vollo vollo-trees program from an onnx file",
    )

    parser.add_argument("input_onnx", metavar="input", help="input onnx file")
    parser.add_argument(
        "-o", "--program-out", help="Vollo file to export (default: MODEL_NAME.vollo)"
    )
    parser.add_argument("-c", "--config", help="hardware configuration JSON to use")
    parser.add_argument(
        "--print-metrics", help="Print program metrics", action="store_true"
    )

    args = parser.parse_args()

    model_path = Path(args.input_onnx)
    model_name = model_path.stem
    out_path = args.program_out if args.program_out else f"{model_name}.vollo"

    forest = vtc.Forest.from_onnx(model_path)
    if args.print_metrics:
        print(f"Max depth: {forest.max_depth()}")
        print(f"Num input features: {forest.num_input_features()}")
        print(f"Num trees: {forest.num_trees()}")

    config = vtc.Config.from_json(args.config)
    program = forest.to_program_bf16(config)
    program.save(out_path)


if __name__ == "__main__":
    cli()
