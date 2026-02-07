# sd-with-wheels

![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Cartesi](https://img.shields.io/badge/Cartesi-000000?style=flat&logo=cartesi&logoColor=white)

Python-based Stable Diffusion inference running inside [Cartesi Rollups](https://docs.cartesi.io/), using HuggingFace Diffusers with pre-built RISC-V Python wheels.

The DApp downloads [Stable Diffusion v1.5](https://huggingface.co/runwayml/stable-diffusion-v1-5) at build time and runs inference inside the Cartesi Machine. Python dependencies (PyTorch, numpy, Pillow, tokenizers, etc.) are installed from custom RISC-V `.whl` packages hosted in the [cartesi-wheels](https://github.com/ryanviana/cartesi-wheels) repo.

## Tech Stack

- **Python 3.10** on `cartesi/python:3.10-slim-jammy` (RISC-V)
- **HuggingFace Diffusers 0.10.2** and **Transformers 4.19.2**
- **PyTorch** (from [rv.kmtea.eu](https://rv.kmtea.eu/simple/) RISC-V index)
- **Pre-built RISC-V wheels**: numpy, Pillow, tokenizers, OpenCV, regex, PyWavelets, and more
- **Cartesi Rollups SDK 0.6.0** (4 GB RAM allocation)

## Project Structure

```
dapp.py              # Cartesi rollup event loop (advance/inspect handlers)
download_model.py    # Downloads SD v1.5 from HuggingFace at build time
Dockerfile           # Full build with wheel installation and model download
SDDockerfile         # Alternative Dockerfile
requirements.txt     # transformers==4.19.2, diffusers==0.10.2
tshirtbase.png       # Base image asset
```

## Setup

### Build the Cartesi DApp

```bash
cartesi build
```

> **Note:** The build downloads ~5 GB of model weights and many Python wheels. Expect a long initial build.

### Run

```bash
cartesi run
```

## Related Projects

- [cartesi-wheels](https://github.com/ryanviana/cartesi-wheels) -- Pre-compiled RISC-V Python wheels used by this project
- [cartesi-stable-diffusion](https://github.com/ryanviana/cartesi-stable-diffusion) -- C++ implementation
- [ctsi-sd-cpp](https://github.com/ryanviana/ctsi-sd-cpp) -- C++ from-source build variant
- [ctsi-rust-sd](https://github.com/ryanviana/ctsi-rust-sd) -- Rust implementation
