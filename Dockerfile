FROM runpod/worker-comfyui:latest-base

# install curl + unzip (safe, deterministic)
RUN apt-get update && apt-get install -y curl unzip

# install Ultimate SD Upscale via ZIP (NO git)
RUN mkdir -p /comfyui/custom_nodes && \
    curl -L https://github.com/ssitu/ComfyUI_UltimateSDUpscale/archive/refs/heads/main.zip -o /tmp/ultimate.zip && \
    unzip /tmp/ultimate.zip -d /comfyui/custom_nodes && \
    mv /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale-main /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale && \
    rm /tmp/ultimate.zip

# download models into comfyui
RUN comfy model download --url https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth --relative-path models/upscale_models --filename RealESRGAN_x4plus.pth

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
