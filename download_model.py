import time
from diffusers import DiffusionPipeline

def download_model(model_name: str, model_save_path: str, max_retries: int = 5):
    retry_count = 0
    while retry_count < max_retries:
        try:
            # Initialize the pipeline (this will download the model)
            pipeline = DiffusionPipeline.from_pretrained(model_name, force_download=True, resume_download=True)
            
            # Save the pipeline (model and tokenizer) locally
            pipeline.save_pretrained(model_save_path)
            print("Model downloaded and saved successfully.")
            return
        except Exception as e:
            retry_count += 1
            print(f"Download failed with error: {e}. Retrying {retry_count}/{max_retries}...")
            time.sleep(10)  # Wait before retrying

    print("Failed to download the model after multiple attempts.")

if __name__ == "__main__":
    model_name = "runwayml/stable-diffusion-v1-5"  # Model name
    model_save_path = "/app/stable_diffusion_v1_5"  # Change this path as needed

    download_model(model_name, model_save_path)
