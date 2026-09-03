from pathlib import Path
import pandas as pd
import numpy as np
import math

SEED = 20260903
ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "data" / "sample"

def main():
    print("This repository ships with a deterministic generated sample.")
    print("Seed:", SEED)
    print("Use the committed CSV sample for portfolio validation.")
    print("Generation logic is documented in the repository and can be extended safely.")
    print("Sample directory:", OUT)

if __name__ == "__main__":
    main()
