FROM runpod/worker-comfyui:5.5.0-base

RUN apt-get update && apt-get install -y curl unzip

# Install Ultimate SD Upscale
RUN mkdir -p /comfyui/custom_nodes && \
    curl -L https://github.com/ssitu/ComfyUI_UltimateSDUpscale/archive/refs/heads/main.zip -o /tmp/ultimate.zip && \
    unzip /tmp/ultimate.zip -d /comfyui/custom_nodes && \
    mv /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale-main /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale && \
    rm /tmp/ultimate.zip

# Models
RUN comfy model download \
    --url https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth \
    --relative-path models/upscale_models \
    --filename RealESRGAN_x4plus.pth

RUN mkdir -p /comfyui/models/checkpoints && \
    curl -L https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors \
    -o /comfyui/models/checkpoints/sd_xl_base_1.0.safetensors

# Workflow
COPY upscale_flow.json /comfyui/workflows/upscale_flow.json

# 🔴 THIS WAS MISSING
ENV COMFY_WORKFLOW=upscale_flow.json
