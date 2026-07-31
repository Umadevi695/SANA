from datetime import datetime, timedelta


class ReminderGenerator:

    @staticmethod
    def generate_reminders(deadline):

        deadline_date = None

        formats = [
            "%d-%m-%Y",
            "%d/%m/%Y",
            "%d %B %Y"
        ]

        for fmt in formats:

            try:

                deadline_date = datetime.strptime(
                    deadline,
                    fmt
                )

                break

            except ValueError:
                continue

        if deadline_date is None:
            return []

        reminders = [

            (deadline_date - timedelta(days=7)).strftime("%Y-%m-%d"),

            (deadline_date - timedelta(days=3)).strftime("%Y-%m-%d"),

            (deadline_date - timedelta(days=1)).strftime("%Y-%m-%d")
        ]

        return reminders


if __name__ == "__main__":

    print(
        ReminderGenerator.generate_reminders(
            "13-07-2026"
        )
    )

    print(
        ReminderGenerator.generate_reminders(
            "25 August 2026"
        )
    )