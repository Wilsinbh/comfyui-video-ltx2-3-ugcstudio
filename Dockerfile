# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# Instala os custom nodes necessários pro LTX-2.3 (evita depender do Manager em runtime)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Lightricks/ComfyUI-LTXVideo && \
    cd ComfyUI-LTXVideo && \
    pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-KJNodes

# Corrige a incompatibilidade do kornia >= 0.8.3 com o node de pyramid blending do LTXVideo
RUN pip install kornia==0.7.3

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

# user-provided inputs override the auto-generated placeholders above.
RUN wget --progress=dot:giga -O '/comfyui/input/9ePiq_G7InuTT-j4UHGhU_McFpGK6D.png' "https://cool-anteater-319.convex.cloud/api/storage/9b100ae4-a53c-4e2b-a412-75ef910d1094"
