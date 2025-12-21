FROM runpod/worker-comfyui:5.5.0-base

RUN apt-get update && apt-get install -y git curl unzip

# 1. Install Ultimate SD Upscale (Correct method for Flow D)
RUN git clone --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale

# 2. Download Models into the image (Slow but verified)
RUN mkdir -p /comfyui/models/upscale_models /comfyui/models/checkpoints

# Tiny Upscaler (~67MB)
RUN curl -L https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth \
    -o /comfyui/models/upscale_models/RealESRGAN_x4plus.pth

# The big SDXL model (~6.5GB) - This makes the build slow but ensures Flow D works
RUN curl -L https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors \
    -o /comfyui/models/checkpoints/sd_xl_base_1.0.safetensors

# 3. Copy your JSON from GitHub (Fixed name)
COPY upscale_flow.json /comfyui/workflows/upscale_flow.json

ENV COMFY_WORKFLOW=upscale_flow.json
