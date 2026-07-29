# Imagem base limpa do ComfyUI (comfy-cli + comfyui-manager)
FROM runpod/worker-comfyui:5.8.4-base

# ---------- Custom nodes ----------
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Lightricks/ComfyUI-LTXVideo && \
    cd ComfyUI-LTXVideo && \
    pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-KJNodes

# Corrige incompatibilidade do kornia >= 0.8.3 com o LTXVideo
RUN pip install kornia==0.7.3

# ---------- Modelos embutidos direto na imagem (build-time, não runtime) ----------
RUN pip install -U "huggingface_hub[cli]"

# Checkpoint principal bf16 (~43GB)
RUN hf download Lightricks/LTX-2.3 ltx-2.3-22b-dev.safetensors \
    --local-dir /comfyui/models/checkpoints

# Lora distillada 1.1 (~7GB)
RUN hf download Lightricks/LTX-2.3 ltx-2.3-22b-distilled-lora-384-1.1.safetensors \
    --local-dir /comfyui/models/loras

# Gemma 3 12B bf16 - text encoder completo (~23GB)
RUN hf download Comfy-Org/ltx-2 split_files/text_encoders/gemma_3_12B_it.safetensors \
    --local-dir /tmp/dl && \
    mv /tmp/dl/split_files/text_encoders/gemma_3_12B_it.safetensors \
       /comfyui/models/text_encoders/comfy_gemma_3_12B_it.safetensors && \
    rm -rf /tmp/dl

# Projection file (~2.2GB)
RUN hf download Kijai/LTX2.3_comfy text_encoders/ltx-2.3_text_projection_bf16.safetensors \
    --local-dir /tmp/dl && \
    mv /tmp/dl/text_encoders/ltx-2.3_text_projection_bf16.safetensors \
       /comfyui/models/text_encoders/ltx-2.3_text_projection_bf16.safetensors && \
    rm -rf /tmp/dl

# VAE (~23MB)
RUN hf download Kijai/LTX2.3_comfy vae/taeltx2_3.safetensors \
    --local-dir /tmp/dl && \
    mv /tmp/dl/vae/taeltx2_3.safetensors /comfyui/models/vae/taeltx2_3.safetensors && \
    rm -rf /tmp/dl

# Upscaler v1.1 (~950MB)
RUN hf download Lightricks/LTX-2.3 ltx-2.3-spatial-upscaler-x2-1.1.safetensors \
    --local-dir /comfyui/models/latent_upscale_models
