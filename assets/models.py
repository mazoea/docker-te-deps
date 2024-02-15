from transformers import TrOCRProcessor, VisionEncoderDecoderModel

processor = TrOCRProcessor.from_pretrained(
    "microsoft/trocr-large-handwritten",
)
model = VisionEncoderDecoderModel.from_pretrained(
    "microsoft/trocr-large-handwritten",
    pad_token_id=processor.tokenizer.eos_token_id,
)
