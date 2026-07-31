from ai_module.date_extractor import DateExtractor
from ai_module.category_classifier import CategoryClassifier
from ai_module.priority_detector import PriorityDetector
from ai_module.summarizer import Summarizer
from ai_module.title_extractor import TitleExtractor
from ai_module.deadline_extractor import DeadlineExtractor
from ai_module.reminder_generator import ReminderGenerator

class NoticeProcessor:

    @staticmethod
    def process_notice(text):

        dates = DateExtractor.extract_dates(text)

        category = CategoryClassifier.classify(text)

        priority = PriorityDetector.detect_priority(text)

        summary = Summarizer.generate_summary(text)

        title = TitleExtractor.extract_title(category)

        deadline = DeadlineExtractor.extract_deadline(text)

        reminders=[]
        if deadline:
            reminders=ReminderGenerator.generate_reminders(deadline)

        result = {
            "title": title,
            "category": category,
            "priority": priority,
            "deadline":deadline,
            "reminders":reminders,
            "summary": summary,
            "dates": dates
        }

        return result


if __name__ == "__main__":

    notice = """
    Dear Students,

    The examination fee payment last date is 25 August 2026.

    All students are requested to complete the payment before the deadline.

    Late fee will be charged after the due date.
    """

    result = NoticeProcessor.process_notice(notice)

    print(result)