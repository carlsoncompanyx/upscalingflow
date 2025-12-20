FROM runpod/worker-comfyui:5.5.0-base

RUN apt-get update && apt-get install -y git curl unzip

# 1. Install Ultimate SD Upscale properly with submodules
RUN git clone --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale

# 2. Setup Models - Using exact paths ComfyUI expects
RUN mkdir -p /comfyui/models/upscale_models /comfyui/models/checkpoints

RUN curl -L https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth \
    -o /comfyui/models/upscale_models/RealESRGAN_x4plus.pth

RUN curl -L https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors \
    -o /comfyui/models/checkpoints/sd_xl_base_1.0.safetensors

# 3. Add your workflow
COPY "Image Upscaling (Flow D).json" /comfyui/workflows/upscale_flow.json

# 4. Critical Environment Variables
ENV COMFY_WORKFLOW=upscale_flow.json
# Increase timeout for upscaling jobs
ENV COMFY_POLLING_MAX_RETRIES=2000
