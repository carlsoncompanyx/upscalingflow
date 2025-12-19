# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base
RUN apt-get update && apt-get install -y git

# install Ultimate SD Upscale custom node
RUN comfy node install ssitu/ComfyUI_UltimateSDUpscale


# download models into comfyui
RUN comfy model download --url https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth --relative-path models/upscale_models --filename RealESRGAN_x4plus.pth

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
