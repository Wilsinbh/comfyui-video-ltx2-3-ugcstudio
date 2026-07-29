# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

# user-provided inputs override the auto-generated placeholders above.
RUN wget --progress=dot:giga -O '/comfyui/input/9ePiq_G7InuTT-j4UHGhU_McFpGK6D.png' "https://cool-anteater-319.convex.cloud/api/storage/9b100ae4-a53c-4e2b-a412-75ef910d1094"
