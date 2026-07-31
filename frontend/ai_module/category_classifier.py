class CategoryClassifier:

    CATEGORY_KEYWORDS = {
        "Exam": [
            "exam",
            "examination",
            "hall ticket",
            "internal exam",
            "semester"
        ],

        "Assignment": [
            "assignment",
            "submission",
            "project submission",
            "record submission"
        ],

        "Scholarship": [
            "scholarship",
            "financial aid",
            "grant"
        ],

        "Placement": [
            "placement",
            "recruitment",
            "interview",
            "campus drive"
        ],

        "Fee Payment": [
            "fee",
            "payment",
            "tuition fee",
            "exam fee"
        ],

        "Workshop": [
            "workshop",
            "training program"
        ],

        "Seminar": [
            "seminar",
            "guest lecture"
        ]
    }

    @classmethod
    def classify(cls, text):

        text = text.lower()

        if "exam fee" in text:
            return "Fee Payment"

        if "fee payment" in text:
            return "Fee Payment"

        if "tuition fee" in text:
            return "Fee Payment"

        for category, keywords in cls.CATEGORY_KEYWORDS.items():

            for keyword in keywords:

                if keyword in text:
                    return category

        return "General Notice"


if __name__ == "__main__":

    notice1 = """
    Exam fee payment last date is August 25, 2026.
    """

    notice2 = """
    Scholarship registration closes on September 10.
    """

    notice3 = """
    AI Workshop will be conducted on July 15.
    """

    notice4 = """
    Semester examination schedule has been released.
    """

    print(CategoryClassifier.classify(notice1))
    print(CategoryClassifier.classify(notice2))
    print(CategoryClassifier.classify(notice3))
    print(CategoryClassifier.classify(notice4))
