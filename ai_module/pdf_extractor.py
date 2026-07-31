from PyPDF2 import PdfReader


class PDFExtractor:

    @staticmethod
    def extract_text(pdf_path):

        reader = PdfReader(pdf_path)

        text = ""

        for page in reader.pages:
            page_text = page.extract_text()

            if page_text:
                text += page_text + "\n"

        return text


if __name__ == "__main__":

    pdf_path = "test_notices/sample_notices.pdf"

    extracted_text = PDFExtractor.extract_text(pdf_path)

    print(extracted_text)