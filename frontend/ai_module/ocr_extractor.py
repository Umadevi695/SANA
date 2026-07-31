from PIL import Image
import pytesseract

from notice_processor import NoticeProcessor


class OCRExtractor:

    @staticmethod
    def extract_text(image_path):

        image = Image.open(image_path)

        text = pytesseract.image_to_string(image)

        return text


if __name__ == "__main__":

    image_path = "test_notices/fee.jpg"

    text = OCRExtractor.extract_text(image_path)

    result = NoticeProcessor.process_notice(text)

    print(result)