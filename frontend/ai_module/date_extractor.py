import re
from datetime import datetime


class DateExtractor:

    @staticmethod
    def extract_dates(text):
        import re
from datetime import datetime


class DateExtractor:

    @staticmethod
    def extract_dates(text):

        results = []
        seen = set()

        patterns = [
            r"\b\d{1,2}[-/]\d{1,2}[-/]\d{4}\b",
            r"\b\d{1,2}\s+(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4}\b"
        ]

        for pattern in patterns:

            matches = re.findall(pattern, text, re.IGNORECASE)

            if pattern.startswith(r"\b\d{1,2}\s+"):

                matches = re.finditer(pattern, text, re.IGNORECASE)

                for match in matches:

                    date_text = match.group()

                    try:
                        date_obj = datetime.strptime(
                            date_text,
                            "%d %B %Y"
                        )

                        formatted = date_obj.strftime("%Y-%m-%d")

                        if formatted not in seen:

                            results.append({
                                "text": date_text,
                                "date": formatted
                            })

                            seen.add(formatted)

                    except:
                        pass

            else:

                for date_text in matches:

                    try:

                        date_obj = datetime.strptime(
                            date_text.replace("/", "-"),
                            "%d-%m-%Y"
                        )

                        formatted = date_obj.strftime("%Y-%m-%d")

                        if formatted not in seen:

                            results.append({
                                "text": date_text,
                                "date": formatted
                            })

                            seen.add(formatted)

                    except:
                        pass

        return results

        


if __name__ == "__main__":

    sample = """
    Without fine upto 13-07-2026
    With Fine 14-07-2026 to 20-07-2026
    """

    print(DateExtractor.extract_dates(sample))