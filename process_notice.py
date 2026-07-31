import sys
import json



from ai_module.notice_processor import NoticeProcessor
from ai_module.ocr_extractor import OCRExtractor
from ai_module.pdf_extractor import PDFExtractor

file_path = sys.argv[1]



if file_path.lower().endswith(".pdf"):
    text = PDFExtractor.extract_text(file_path)
else:
    text = OCRExtractor.extract_text(file_path)




result = NoticeProcessor.process_notice(text)

print(json.dumps(result))