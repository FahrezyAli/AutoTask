// DiaryParser.swift
import Foundation
import NaturalLanguage

struct DiaryParser {
    static func extractDate(from text: String) -> Date? {
        let types: NSTextCheckingResult.CheckingType = [.date]
        if let detector = try? NSDataDetector(types: types.rawValue) {
            let matches = detector.matches(
                in: text,
                options: [],
                range: NSRange(text.startIndex..., in: text)
            )
            if let date = matches.first(where: { $0.date != nil })?.date {
                return date
            }
        }

        // Manual fallback
        let lowered = text.lowercased()
        let now = Date()
        var components = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: now
        )

        if lowered.contains("tomorrow") {
            components.day! += 1
        } else if lowered.contains("today") {
            // Keep today
        } else {
            return nil
        }

        // Extract time like "at 1 PM"
        let timeRegex = try! NSRegularExpression(
            pattern: #"at (\d{1,2})(:\d{2})?\s?(AM|PM)?"#,
            options: .caseInsensitive
        )
        if let match = timeRegex.firstMatch(
            in: text,
            options: [],
            range: NSRange(text.startIndex..., in: text)
        ) {
            let hourRange = match.range(at: 1)
            let ampmRange = match.range(at: 3)

            if let hour = Int((text as NSString).substring(with: hourRange)) {
                var hourValue = hour
                if ampmRange.location != NSNotFound {
                    let ampm = (text as NSString).substring(with: ampmRange)
                        .lowercased()
                    if ampm == "pm" && hour != 12 {
                        hourValue += 12
                    } else if ampm == "am" && hour == 12 {
                        hourValue = 0
                    }
                }
                components.hour = hourValue
                components.minute = 0
                return Calendar.current.date(from: components)
            }
        }

        return Calendar.current.date(from: components)  // Return date with no time if time missing
    }

    static func extractSmartDate(from text: String) -> Date {
        if let detectedDate = extractDate(from: text) {
            return detectedDate
        }

        let lowercased = text.lowercased()
        let calendar = Calendar.current
        let now = Date()

        if lowercased.contains("tomorrow") {
            return calendar.date(byAdding: .day, value: 1, to: now) ?? now
        } else if lowercased.contains("today") {
            return now
        }

        return now
    }

    static func extractNouns(from text: String) -> [String] {
        var results: [String] = []
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text

        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .lexicalClass,
            options: [.omitPunctuation, .omitWhitespace]
        ) { tag, range in
            if tag == .noun {
                results.append(String(text[range]))
            }
            return true
        }

        return results
    }

    static func extractActivityAndGoal(from text: String) -> (
        activity: String?, goal: String?
    ) {
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text

        var nouns: [String] = []
        var verbs: [String] = []

        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .lexicalClass,
            options: [.omitPunctuation, .omitWhitespace]
        ) { tag, range in
            guard let tag = tag else { return true }
            let word = String(text[range]).lowercased()
            switch tag {
            case .verb:
                verbs.append(word)
            case .noun:
                nouns.append(word)
            default:
                break
            }
            return true
        }

        // Try to find meaningful activity verb or noun
        let commonActivities = [
            "run", "train", "meditate", "study", "walk", "yoga", "cycle",
            "swim", "workout", "exercise", "read", "write", "code",
        ]

        let activityVerb = verbs.first(where: { commonActivities.contains($0) })
        let activityNoun = nouns.first(where: { commonActivities.contains($0) })

        let activity = activityVerb ?? activityNoun

        // Goal detection still works
        let goal = nouns.first(where: {
            text.contains("for my \($0)")
                || text.contains("to improve my \($0)")
        })

        return (activity?.capitalized, goal?.capitalized)
    }

    static func extractDetails(from text: String) -> (
        activity: String?, date: Date, goal: String?
    ) {
        let date = extractSmartDate(from: text)
        let (activity, goal) = extractActivityAndGoal(from: text)
        return (activity, date, goal)
    }
}
