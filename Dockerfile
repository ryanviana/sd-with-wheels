# syntax=docker.io/docker/dockerfile:1
FROM --platform=linux/riscv64 cartesi/python:3.10-slim-jammy

ARG MACHINE_EMULATOR_TOOLS_VERSION=0.14.1
ADD https://github.com/cartesi/machine-emulator-tools/releases/download/v${MACHINE_EMULATOR_TOOLS_VERSION}/machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb /
RUN dpkg -i /machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb \
  && rm /machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb

LABEL io.cartesi.rollups.sdk_version=0.6.0
LABEL io.cartesi.rollups.ram_size=4000Mi

ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN set -e \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  busybox-static=1:1.30.1-7ubuntu3 \
  libjpeg8-dev \
  build-essential \
  cmake \
  libprotobuf-dev \
  protobuf-compiler \
  libprotoc-dev \
  pkg-config \
  liblzma-dev \
  libbz2-dev \
  libffi-dev \
  libssl-dev \
  zlib1g-dev \
  libreadline-dev \
  libsqlite3-dev \
  curl \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libgdbm-dev \
  libc6-dev \
  libnss3-dev \
  libedit-dev \
  libopencv-dev \
  python3-opencv \
  git \
  wget \
  autoconf \
  automake \
  libtool \
  libjpeg-dev \
  libpng-dev \
  libopenblas-dev \
  && curl https://sh.rustup.rs -sSf | sh -s -- -y \
  && . "$HOME/.cargo/env" \
  && rustup update \
  && rm -rf /var/lib/apt/lists/* /var/log/* /var/cache/*

# Set RUSTFLAGS to avoid the invalid_reference_casting error
ENV RUSTFLAGS="-A invalid_reference_casting"

ENV PATH="/root/.cargo/bin:${PATH}"

RUN useradd --create-home --user-group dapp

ENV PATH="/opt/cartesi/bin:${PATH}"

WORKDIR /opt/cartesi/dapp

# Ensure cache directories exist and are writable
RUN mkdir -p /root/.cache/huggingface/transformers \
  && chmod -R 777 /root/.cache/huggingface/transformers

# Download the available wheels from GitHub
RUN wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/sympy-1.12-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/mpmath-1.3.0-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/numpy-1.26.4-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/packaging-24.0-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/filelock-3.14.0-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/typing_extensions-4.8.0-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/networkx-3.2.1-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/Jinja2-3.1.2-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/MarkupSafe-2.1.5-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/fsspec-2024.5.0-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/pillow-10.3.0-cp310-cp310-linux_riscv64.whl 

# Install dependencies using wheels
RUN pip install --no-index --find-links=/wheels mpmath sympy numpy packaging filelock typing_extensions networkx markupsafe jinja2 fsspec pillow 

# Install PyTorch and its dependencies from the custom repository
RUN pip install --index-url https://rv.kmtea.eu/simple/ --only-binary :all: cmake numpy torch

# Download the available wheels from GitHub
RUN wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/invisible_watermark-0.2.0-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/requests-2.32.2-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/opencv_python-4.9.0.80-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/PyWavelets-1.4.1-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/idna-3.7-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/certifi-2024.2.2-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/charset_normalizer-3.3.2-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/urllib3-2.2.1-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/PyYAML-6.0.1-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/tqdm-4.66.4-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/regex-2024.5.15-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/huggingface_hub-0.23.1-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/diffusers-0.10.2-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/importlib_metadata-7.1.0-py3-none-any.whl \ 
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/numpy-1.26.4-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/pillow-10.3.0-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/regex-2024.5.15-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/tokenizers-0.12.1-cp310-cp310-linux_riscv64.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/typing_extensions-4.12.0-py3-none-any.whl \
  && wget -P /wheels https://github.com/ryanviana/cartesi-wheels/raw/main/zipp-3.18.2-py3-none-any.whl 



# Install dependencies using wheels
RUN pip install --no-index --find-links=/wheels invisible_watermark requests opencv_python PyWavelets idna certifi charset_normalizer urllib3 PyYAML tqdm regex huggingface_hub diffusers importlib_metadata numpy pillow regex tokenizers typing_extensions zipp

# Install Stable Diffusion requirements
COPY ./requirements.txt .
RUN pip install -r requirements.txt --prefer-binary \
  && pip check \
  && find /usr/local/lib/python3.10/site-packages/ -name '__pycache__' -type d -exec rm -rf {} +

# Download and set up Stable Diffusion model
COPY download_model.py ./download_model.py
RUN python download_model.py

# Copy necessary files
COPY ./dapp.py .
COPY ./tshirtbase.png .

ENV ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:5004"
ENV TRANSFORMERS_CACHE=/opt/cartesi/dapp/model/stable_diffusion_v1_5
ENV HF_HOME=/opt/cartesi/dapp/model/stable_diffusion_v1_5

ENTRYPOINT ["rollup-init"]
CMD ["python3", "dapp.py"]