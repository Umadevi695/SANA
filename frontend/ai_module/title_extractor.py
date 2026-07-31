class TitleExtractor:

    CATEGORY_TITLES = {
        "Fee Payment": "Exam Fee Payment",
        "Scholarship": "Scholarship Notice",
        "Placement": "Placement Drive",
        "Assignment": "Assignment Submission",
        "Workshop": "Workshop Announcement",
        "Seminar": "Seminar Notice",
        "Exam": "Examination Notice",
        "General Notice": "General Notice"
    }

    @classmethod
    def extract_title(cls, category):

        return cls.CATEGORY_TITLES.get(
            category,
            "General Notice"
        )


if __name__ == "__main__":

    print(
        TitleExtractor.extract_title("Fee Payment")
    )

    print(
        TitleExtractor.extract_title("Scholarship")
    )

    print(
        TitleExtractor.extract_title("Workshop")
    )