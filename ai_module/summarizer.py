import re


class Summarizer:

    IMPORTANT_KEYWORDS = [
        "exam fee",
        "fee payment",
        "tuition fee",
        "scholarship",
        "assignment",
        "submission",
        "placement",
        "workshop",
        "seminar",
        "deadline",
        "last date",
        "without fine",
        "with fine",
        "important dates"
    ]

    IGNORE_PHRASES = [
        "accredited",
        "approved by",
        "affiliated to",
        "accounts officer",
        "account officer",
        "cheeryal",
        "telangana",
        "ugc",
        "nba",
        "naac",
        "jntuh",
        "contact accounts section"
    ]
    
    
    @classmethod
    def generate_summary(cls, text):

     lines = text.split("\n")

     summary_lines = []

     for line in lines:

        line = line.strip()

        if not line:
            continue

        line_lower = line.lower()

        skip = False

        for phrase in cls.IGNORE_PHRASES:
            if phrase in line_lower:
                skip = True
                break

        if skip:
            continue

        # important keywords
        for keyword in cls.IMPORTANT_KEYWORDS:

            if keyword in line_lower:

                summary_lines.append(line)
                break

        # capture project reviews, exams, schedules etc.
        if (
            "scheduled" in line_lower
            or "review" in line_lower
            or "students must" in line_lower
            or "project" in line_lower
            or line.startswith("•")
        ):
            summary_lines.append(line)

     return " ".join(summary_lines[:5])
    