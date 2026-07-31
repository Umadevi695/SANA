import re


class DeadlineExtractor:

    @staticmethod
    def extract_deadline(text):

        lines = text.split("\n")

        for line in lines:

            line_lower = line.lower()

            if (
    "without fine" in line_lower
    or "last date" in line_lower
    or "deadline" in line_lower
    or "due date" in line_lower
    or "on or before" in line_lower
    or "upto" in line_lower
    or "before" in line_lower
    or "register before" in line_lower
    or "apply before" in line_lower
    or "registration closes" in line_lower
    or "scheduled on" in line_lower
    or "scheduled for" in line_lower
    or "review on" in line_lower
    or "exam on" in line_lower
    or "held on" in line_lower
):

                # Format: 13-07-2026 or 13/07/2026
                numeric_match = re.search(
                    r"\b\d{1,2}[-/]\d{1,2}[-/]\d{4}\b",
                    line
                )

                if numeric_match:
                    return numeric_match.group()

                # Format: 25 August 2026
                month_match = re.search(
                    r"\b\d{1,2}\s+(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4}\b",
                    line,
                    re.IGNORECASE
                )

                if month_match:
                    return month_match.group()

        return None


if __name__ == "__main__":

    sample1 = """
    Without fine upto 13-07-2026
    With Fine 14-07-2026 to 20-07-2026
    """

    sample2 = """
    The examination fee payment last date is 25 August 2026.
    """

    print(DeadlineExtractor.extract_deadline(sample1))
    print(DeadlineExtractor.extract_deadline(sample2))