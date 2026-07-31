class PriorityDetector:

    HIGH_PRIORITY = [
        "deadline",
        "last date",
        "submission",
        "exam fee",
        "fee payment"
    ]

    MEDIUM_PRIORITY = [
        "scholarship",
        "placement",
        "recruitment"
    ]

    LOW_PRIORITY = [
        "workshop",
        "seminar",
        "guest lecture"
    ]

    @classmethod
    def detect_priority(cls, text):

        text = text.lower()

        for keyword in cls.HIGH_PRIORITY:
            if keyword in text:
                return "High"

        for keyword in cls.MEDIUM_PRIORITY:
            if keyword in text:
                return "Medium"

        for keyword in cls.LOW_PRIORITY:
            if keyword in text:
                return "Low"

        return "Low"


if __name__ == "__main__":

    notice1 = "Exam fee payment last date is August 25, 2026."
    notice2 = "Scholarship registration opens from September 1."
    notice3 = "AI Workshop will be conducted next week."

    print(PriorityDetector.detect_priority(notice1))
    print(PriorityDetector.detect_priority(notice2))
    print(PriorityDetector.detect_priority(notice3))